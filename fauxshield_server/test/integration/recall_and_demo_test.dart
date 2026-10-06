import 'package:fauxshield_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the FauxShield recall flow', (
    sessionBuilder,
    endpoints,
  ) {
    late TestSessionBuilder owner;
    late TestSessionBuilder consumer;
    late BrandFixture fixture;

    setUp(() async {
      owner = authenticatedAs(sessionBuilder, 'owner-1');
      consumer = anonymous(sessionBuilder);
      fixture = await setUpBrand(endpoints, owner);
    });

    test(
      'recall flips verification outcomes and lifting restores it',
      () async {
        final recallResult = await endpoints.recall.recallBatch(
          owner,
          workspaceId: fixture.workspaceId,
          batchId: fixture.batch.id!,
          reason: 'Contamination found in retained samples from this lot.',
        );
        expect(recallResult.affected, fixture.identities.length);

        final identity = fixture.identities.first;
        final recalledPresentation = await endpoints.verification.start(
          consumer,
          identity.qrToken,
          'device-recall',
        );
        expect(recalledPresentation.outcome, VerificationOutcome.recalled);
        expect(recalledPresentation.recallReason, isNotNull);

        final listed = await endpoints.recall.list(
          owner,
          workspaceId: fixture.workspaceId,
          includeLifted: true,
        );
        expect(listed, isNotEmpty);
        expect(listed.first.lifted, isFalse);

        await endpoints.recall.lift(
          owner,
          workspaceId: fixture.workspaceId,
          recallId: recallResult.recall.id!,
          note: 'Retested clean.',
        );

        final afterLift = await endpoints.verification.start(
          consumer,
          identity.qrToken,
          'device-after-lift',
        );
        expect(afterLift.outcome, isNot(VerificationOutcome.recalled));
      },
    );

    test('recalling a single identity only affects that unit', () async {
      final target = fixture.identities.first;
      final other = fixture.identities[1];

      await endpoints.recall.recallIdentity(
        owner,
        workspaceId: fixture.workspaceId,
        identityId: target.id!,
        reason: 'Suspected tampering on this unit.',
      );

      final recalled = await endpoints.verification.start(
        consumer,
        target.qrToken,
        'device-single',
      );
      expect(recalled.outcome, VerificationOutcome.recalled);

      final untouched = await endpoints.verification.start(
        consumer,
        other.qrToken,
        'device-single-other',
      );
      expect(untouched.outcome, isNot(VerificationOutcome.recalled));
    });
  });

  withServerpod('Given the demo seeder', (sessionBuilder, endpoints) {
    test(
      'seeds a browsable demo workspace with products, verifications and alerts',
      () async {
        final owner = authenticatedAs(sessionBuilder, 'demo-owner');
        final bootstrap = await endpoints.demo.seed(owner);
        expect(bootstrap.isDemo, isTrue);
        expect(bootstrap.role, MembershipRole.owner);

        final products = await endpoints.product.list(
          owner,
          workspaceId: bootstrap.workspace.id,
          includeArchived: false,
        );
        expect(products.length, greaterThanOrEqualTo(3));

        final dashboard = await endpoints.analytics.dashboard(
          owner,
          workspaceId: bootstrap.workspace.id,
          windowDays: 14,
        );
        expect(dashboard.totalVerifications, greaterThan(0));
        expect(dashboard.identitiesTotal, greaterThan(0));

        final alerts = await endpoints.alert.list(
          owner,
          workspaceId: bootstrap.workspace.id,
          page: 0,
          pageSize: 25,
        );
        expect(alerts, isNotEmpty);

        final recalls = await endpoints.recall.list(
          owner,
          workspaceId: bootstrap.workspace.id,
          includeLifted: true,
        );
        expect(recalls, isNotEmpty);
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );
  });
}
