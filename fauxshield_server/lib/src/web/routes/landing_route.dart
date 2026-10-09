import 'package:serverpod/serverpod.dart';

import '../../cache_busting.dart';
import '../../generated/protocol.dart';
import '../../services/identity_service.dart';
import '../widgets/landing_page.dart';

/// The FauxShield landing page.
///
/// Reads live counters from the database so the landing page always matches
/// the state of the deployment, and links to a real demo product code that
/// visitors can verify end to end.
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

      String? demoToken;
      String? demoProductName;
      String? demoBrandName;
      String? demoPin;
      final demoWorkspace = await Workspace.db.findFirstRow(
        session,
        where: (t) => t.demoMode.equals(true),
        orderBy: (t) => t.createdAt,
      );
      if (demoWorkspace != null) {
        demoBrandName =
            demoWorkspace.branding?.displayName ?? demoWorkspace.name;

        // A visitor's first click should land on a clean verification, so
        // units whose batch is already under an open alert are skipped. The
        // seeded investigations stay in the operator's fraud queue, which is
        // where they are actually put on show.
        final flaggedBatches = <UuidValue>{};
        final openAlerts = await FraudAlert.db.find(
          session,
          where: (t) =>
              t.workspaceId.equals(demoWorkspace.id!) &
              t.status.equals(AlertStatus.open) &
              t.batchId.notEquals(null),
          limit: 200,
        );
        for (final alert in openAlerts) {
          final batchId = alert.batchId;
          if (batchId != null) flaggedBatches.add(batchId);
        }

        Future<ProductIdentity?> pick({
          required bool unverifiedOnly,
          required bool avoidFlagged,
        }) {
          return ProductIdentity.db.findFirstRow(
            session,
            where: (t) {
              var expression =
                  t.workspaceId.equals(demoWorkspace.id!) &
                  t.deletedAt.equals(null) &
                  t.status.equals(IdentityStatus.active);
              if (unverifiedOnly) {
                expression = expression & t.firstVerified.equals(false);
              }
              if (avoidFlagged && flaggedBatches.isNotEmpty) {
                expression = expression & t.batchId.notInSet(flaggedBatches);
              }
              return expression;
            },
            orderBy: (t) => t.createdAt,
          );
        }

        // An untouched unit gives a first-time visitor the authentic outcome.
        // A batch the engine has nothing bad to say about is even better, so it
        // is tried first, but never at the cost of the untouched unit.
        final demoIdentity =
            await pick(unverifiedOnly: true, avoidFlagged: true) ??
            await pick(unverifiedOnly: true, avoidFlagged: false) ??
            await pick(unverifiedOnly: false, avoidFlagged: false);
        if (demoIdentity != null) {
          demoToken = demoIdentity.qrToken;
          final batch = await Batch.db.findById(session, demoIdentity.batchId);
          if (batch != null) {
            final product = await Product.db.findById(session, batch.productId);
            demoProductName = product?.name;
          }
          // Demo workspaces are explicitly disposable, so the landing page may
          // show the packaging PIN next to the demo code and let visitors walk
          // the full verification flow without operator access.
          try {
            final revealed = await IdentityService().revealPin(
              session,
              workspaceId: demoWorkspace.id!,
              identityId: demoIdentity.id!,
              actorIdentifier: 'landing-demo',
            );
            demoPin = revealed.pin;
          } catch (error) {
            session.log(
              'demo pin reveal failed: $error',
              level: LogLevel.warning,
            );
          }
        }
      }

      return LandingPageWidget.withStats(
        workspaces: workspaces,
        products: products,
        identities: identities,
        verifications: verifications,
        alerts: alerts,
        demoToken: demoToken,
        demoProductName: demoProductName,
        demoBrandName: demoBrandName,
        demoPin: demoPin,
      );
    } catch (error) {
      session.log('landing page failed: $error', level: LogLevel.warning);
      return LandingPageWidget.unavailable();
    }
  }
}
