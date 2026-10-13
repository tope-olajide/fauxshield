import 'package:serverpod/serverpod.dart';

import '../../cache_busting.dart';
import '../../generated/protocol.dart';
import '../widgets/landing_page.dart';

/// The FauxShield landing page.
///
/// Reads live counters from the database so the landing page always matches the
/// state of the deployment.
class LandingRoute extends WidgetRoute {
  LandingRoute()
    : super(
        methods: const <Method>{Method.get},
        cacheBustingConfig: cacheBustingConfig,
      );

  @override
  Future<WebWidget> build(Session session, Request request) async {
    try {
      final workspaces = await Workspace.db.count(session);
      final products = await Product.db.count(session);
      final identities = await ProductIdentity.db.count(session);
      final verifications = await VerificationSession.db.count(session);
      final alerts = await FraudAlert.db.count(session);

      return LandingPageWidget.withStats(
        workspaces: workspaces,
        products: products,
        identities: identities,
        verifications: verifications,
        alerts: alerts,
      );
    } catch (error) {
      session.log('landing page failed: $error', level: LogLevel.warning);
      return LandingPageWidget.unavailable();
    }
  }
}
