import 'package:fauxshield_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the FauxShield verification pipeline', (
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
      'verifies an authentic unit end to end with the packaging PIN',
      () async {
        final identity = fixture.identities.first;
        final revealed = await endpoints.identity.revealPin(
          owner,
          identityId: identity.id!,
        );

        var presentation = await endpoints.verification.start(
          consumer,
          identity.qrToken,
          'device-authentic',
        );
        expect(presentation.state, isNot(VerificationState.resultDetermined));

        presentation = await endpoints.verification.acknowledge(
          consumer,
          presentation.sessionId,
          'device-authentic',
        );
        expect(presentation.state, VerificationState.pinPrompted);

        presentation = await endpoints.verification.submitPin(
          consumer,
          presentation.sessionId,
          'device-authentic',
          revealed.pin,
        );

        expect(presentation.outcome, VerificationOutcome.authentic);
        expect(presentation.firstVerified, isTrue);
        expect(presentation.productName, fixture.product.name);
        expect(presentation.batchReference, fixture.batch.reference);
        expect(presentation.branding?.displayName, isNotNull);
      },
    );

    test(
      'reports already verified when the same unit is scanned again',
      () async {
        final identity = fixture.identities.first;
        final revealed = await endpoints.identity.revealPin(
          owner,
          identityId: identity.id!,
        );

        Future<VerificationPresentation> verify(String device) async {
          var presentation = await endpoints.verification.start(
            consumer,
            identity.qrToken,
            device,
          );
          presentation = await endpoints.verification.acknowledge(
            consumer,
            presentation.sessionId,
            device,
          );
          return endpoints.verification.submitPin(
            consumer,
            presentation.sessionId,
            device,
            revealed.pin,
          );
        }

        expect(
          (await verify('device-first')).outcome,
          VerificationOutcome.authentic,
        );
        expect(
          (await verify('device-second')).outcome,
          VerificationOutcome.alreadyVerified,
        );
      },
    );

    test('returns invalidPin for a wrong PIN', () async {
      final identity = fixture.identities.first;
      final revealed = await endpoints.identity.revealPin(
        owner,
        identityId: identity.id!,
      );

      var presentation = await endpoints.verification.start(
        consumer,
        identity.qrToken,
        'device-wrong',
      );
      presentation = await endpoints.verification.acknowledge(
        consumer,
        presentation.sessionId,
        'device-wrong',
      );
      presentation = await endpoints.verification.submitPin(
        consumer,
        presentation.sessionId,
        'device-wrong',
        wrongPin(revealed.pin),
      );

      expect(presentation.outcome, VerificationOutcome.invalidPin);
    });

    test('temporarily locks the unit after repeated wrong PINs', () async {
      final identity = fixture.identities.first;

      for (var attempt = 0; attempt < 5; attempt++) {
        final device = 'device-brute-$attempt';
        var presentation = await endpoints.verification.start(
          consumer,
          identity.qrToken,
          device,
        );
        if (presentation.state == VerificationState.resultDetermined) break;
        presentation = await endpoints.verification.acknowledge(
          consumer,
          presentation.sessionId,
          device,
        );
        presentation = await endpoints.verification.submitPin(
          consumer,
          presentation.sessionId,
          device,
          '000000',
        );
      }

      final stored = await endpoints.identity.get(owner, identity.id!);
      expect(stored.failedPinAttempts, greaterThanOrEqualTo(5));
      expect(stored.lockedUntil, isNotNull);
    });

    test('keeps identity generation idempotent', () async {
      final first = await endpoints.batch.generateIdentities(
        owner,
        workspaceId: fixture.workspaceId,
        batchId: fixture.batch.id!,
        quantity: 2,
        idempotencyKey: 'idem-key-1',
      );
      final second = await endpoints.batch.generateIdentities(
        owner,
        workspaceId: fixture.workspaceId,
        batchId: fixture.batch.id!,
        quantity: 2,
        idempotencyKey: 'idem-key-1',
      );

      expect(second.created, first.created);
      expect(
        second.startedAt.toIso8601String(),
        first.startedAt.toIso8601String(),
      );
    });

    test('exports identities as CSV without leaking PIN material', () async {
      final export = await endpoints.identity.export(
        owner,
        workspaceId: fixture.workspaceId,
        batchId: fixture.batch.id,
        format: ExportFormat.csv,
      );

      expect(export.rowCount, fixture.identities.length);
      expect(export.content, startsWith('identity_id,'));
      expect(export.truncated, isFalse);
      expect(export.content.contains('pin_hash'), isFalse);
      expect(export.content.contains('pin_ciphertext'), isFalse);
    });

    test('enforces role permissions for viewers', () async {
      final invite = await endpoints.workspace.invite(
        owner,
        workspaceId: fixture.workspaceId,
        email: 'viewer@example.com',
        role: MembershipRole.viewer,
      );
      final viewer = authenticatedAs(sessionBuilder, 'viewer-1');
      final joined = await endpoints.workspace.acceptInvitation(
        viewer,
        invite.code,
      );
      expect(joined.role, MembershipRole.viewer);

      // Creating a product requires productsWrite, which a viewer lacks.
      await expectLater(
        endpoints.product.create(
          viewer,
          workspaceId: fixture.workspaceId,
          name: 'Should not be created',
        ),
        throwsA(isA<AuthenticationException>()),
      );
    });
  });
}
