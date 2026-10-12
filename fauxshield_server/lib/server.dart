import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';

import 'src/cache_busting.dart';
import 'src/core/constants.dart';
import 'src/services/api_key_auth.dart';
import 'src/generated/serverpod.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/docs_routes.dart';
import 'src/web/routes/landing_route.dart';
import 'src/web/routes/marketing_routes.dart';
import 'src/web/routes/verify_route.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(args);

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      // The default setup works with Serverpod Cloud without configuration. In
      // development the verification codes are logged to the console, and in
      // staging and production they are sent through the Serverpod Cloud email
      // service. If you want to use a custom provider for sending emails, use
      // `EmailIdpConfigFromPasswords`.
      ServerpodCloudEmailIdpConfig(
        appDisplayName: 'fauxshield',
      ),
    ],
  );

  // Machine access. Keys issued from the workspace's API keys screen are
  // prefixed, so they are tried before the JWT handler and everything else is
  // handed straight to it. Scope checks and the per-key rate limit happen in
  // WorkspaceService, where every endpoint already passes.
  pod.authenticationHandler = withApiKeyAuthentication(
    pod.authenticationHandler,
  );

  // Landing page with live platform stats.
  pod.webServer.addRoute(LandingRoute(), '/');
  pod.webServer.addRoute(LandingRoute(), '/index.html');

  // Consumer verification page. QR codes printed on packaging point here as
  // /verify?t=<token>, and the same page handles PIN entry and product reports.
  pod.webServer.addRoute(VerifyRoute(), '/verify');

  // Public marketing pages. They share the nav, footer, and design system
  // rendered by SiteChrome, and are served by the same Serverpod process.
  pod.webServer.addRoute(FeaturesRoute(), '/features');
  pod.webServer.addRoute(PricingRoute(), '/pricing');
  pod.webServer.addRoute(AboutRoute(), '/about');

  // The developer documentation portal. One route serves every page under
  // /docs, the search index the pages fetch, and a helpful page for a slug that
  // does not exist — so a page in the sidebar is always a page that answers.
  pod.webServer.addRoute(DocsRoute(), '/docs');
  pod.webServer.addRoute(DocsRoute(), '/docs/**');

  // Serve all files in the web/static relative directory under /web.
  // These are used by the default web page.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        appDir,
        // If building the Flutter app with WASM, set the below parameter to
        // true and add the --wasm flag to the flutter build command.
        enableWasmHeaders: false,
      ),
      '/app',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    final defaultRoute = StaticRoute.file(
      File(
        Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
      ),
    );

    pod.webServer.addRoute(
      defaultRoute,
      '/app/**',
    );
  }

  // Configure cloud storage.
  // This setup works with Serverpod Cloud without extra configuration.
  // If you want to use a custom provider for cloud storage, replace these
  // with your preferred provider.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  // Start the server.
  await pod.start();

  // Register the recurring platform tasks. Cancelling by identifier first
  // keeps a restart from stacking duplicate schedules.
  await _scheduleRecurringTasks(pod);
}

/// Schedules the always-on background work of the platform.
///
/// * `webhook-drain` attempts due webhook deliveries with retry backoff.
/// * `offline-scan-converter` turns synced field scans into sessions.
/// * `daily-rollup` materializes analytics rollups for every workspace.
/// * `maintenance-sweep` prunes expired idempotency keys and stale runs.
///
/// Future calls require a database and can be disabled for a deployment
/// (`futureCall.enabled`, or the `SERVERPOD_FUTURE_CALL_*` variables a host may
/// set). Serverpod Cloud runs its app podlets that way and executes scheduled
/// work in a separate role, where this same boot sequence schedules the
/// recurring calls. Without the guard the dispatcher below is uninitialized
/// and its throw leaves the podlet permanently unready.
Future<void> _scheduleRecurringTasks(Serverpod pod) async {
  final futureCallsEnabled =
      pod.config.database != null && pod.config.futureCall.enabled;
  if (!futureCallsEnabled) {
    pod.logVerbose(
      'Future calls are disabled; skipping recurring task scheduling.',
    );
    return;
  }

  await pod.futureCalls.cancel('webhook-drain');
  await pod.futureCalls
      .callRecurring(identifier: 'webhook-drain')
      .every(FauxShieldLimits.webhookDrainInterval)
      .webhookDrain
      .drain();

  await pod.futureCalls.cancel('offline-scan-converter');
  await pod.futureCalls
      .callRecurring(identifier: 'offline-scan-converter')
      .every(FauxShieldLimits.offlineScanProcessInterval)
      .offlineScanConverter
      .convert();

  await pod.futureCalls.cancel('daily-rollup');
  await pod.futureCalls
      .callRecurring(identifier: 'daily-rollup')
      .every(const Duration(minutes: 15))
      .dailyRollup
      .rollup();

  await pod.futureCalls.cancel('maintenance-sweep');
  await pod.futureCalls
      .callRecurring(identifier: 'maintenance-sweep')
      .every(const Duration(minutes: 30))
      .maintenanceSweep
      .sweep();
}
