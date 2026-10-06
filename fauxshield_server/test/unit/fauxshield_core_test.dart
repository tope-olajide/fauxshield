import 'package:fauxshield_server/src/core/identity_crypto.dart';
import 'package:fauxshield_server/src/core/webhook_signing.dart';
import 'package:fauxshield_server/src/services/fraud_rules.dart';
import 'package:fauxshield_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  group('Given IdentityCrypto', () {
    test('generates 128 bit hex QR tokens', () {
      final token = IdentityCrypto.generateQrToken();
      expect(token.length, 32);
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(token), isTrue);
    });

    test('generates six digit PINs', () {
      final pin = IdentityCrypto.generateSecurePin();
      expect(pin.length, 6);
      expect(int.tryParse(pin), isNotNull);
    });

    test(
      'signs and verifies a token binding workspace, product and identity',
      () {
        const secret = 'test-secret';
        const token = 'aabbccdd';
        final signature = IdentityCrypto.signToken(
          secret: secret,
          workspaceId: 'ws-1',
          productId: 'prod-1',
          identityId: 'id-1',
          token: token,
        );
        expect(
          IdentityCrypto.verifyTokenSignature(
            secret: secret,
            workspaceId: 'ws-1',
            productId: 'prod-1',
            identityId: 'id-1',
            token: token,
            signature: signature,
          ),
          isTrue,
        );
        // Moving the token to another product must fail.
        expect(
          IdentityCrypto.verifyTokenSignature(
            secret: secret,
            workspaceId: 'ws-1',
            productId: 'prod-2',
            identityId: 'id-1',
            token: token,
            signature: signature,
          ),
          isFalse,
        );
      },
    );

    test('hashes and verifies PINs with PBKDF2', () async {
      final hash = await IdentityCrypto.hashPin('123456', iterations: 1000);
      expect(await IdentityCrypto.verifyPin('123456', hash), isTrue);
      expect(await IdentityCrypto.verifyPin('654321', hash), isFalse);
    });

    test(
      'encrypts and decrypts values with AES-256-GCM bound to AAD',
      () async {
        const key =
            '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';
        final ciphertext = await IdentityCrypto.encryptValue(
          plaintext: 'super-secret',
          keyHex: key,
          aad: 'workspace:identity',
        );
        expect(
          await IdentityCrypto.decryptValue(
            ciphertext: ciphertext,
            keyHex: key,
            aad: 'workspace:identity',
          ),
          'super-secret',
        );
        // A different AAD must fail to decrypt.
        expect(
          await IdentityCrypto.decryptValue(
            ciphertext: ciphertext,
            keyHex: key,
            aad: 'workspace:other',
          ),
          isNull,
        );
      },
    );

    test('masks tokens for display', () {
      final masked = IdentityCrypto.maskToken(
        'abcdef0123456789abcdef0123456789',
      );
      expect(masked.contains('abcdef0123456789abcdef0123456789'), isFalse);
      expect(masked, contains('...'));
    });
  });

  group('Given WebhookSigner', () {
    test('signs and verifies payloads', () {
      final timestamp = DateTime.utc(2026, 1, 1, 12);
      final header = WebhookSigner.sign(
        secret: 'whsec',
        body: '{"event":"verification_completed"}',
        timestamp: timestamp,
      );
      expect(header, startsWith('t='));
      expect(
        WebhookSigner.verify(
          secret: 'whsec',
          body: '{"event":"verification_completed"}',
          header: header,
          tolerance: const Duration(minutes: 5),
          now: timestamp,
        ),
        isTrue,
      );
      // Tampered body fails.
      expect(
        WebhookSigner.verify(
          secret: 'whsec',
          body: '{"event":"fraud_alert_created"}',
          header: header,
          tolerance: const Duration(minutes: 5),
          now: timestamp,
        ),
        isFalse,
      );
      // Stale timestamps fail outside the tolerance window.
      expect(
        WebhookSigner.verify(
          secret: 'whsec',
          body: '{"event":"verification_completed"}',
          header: header,
          tolerance: const Duration(minutes: 5),
          now: timestamp.add(const Duration(hours: 1)),
        ),
        isFalse,
      );
    });
  });

  group('Given the fraud rules', () {
    test('scores low with no signals', () {
      expect(calculateRiskScore(<SignalAssessment>[]), RiskScore.low);
    });

    test('escalates a high signal combined with another signal', () {
      final signals = <SignalAssessment>[
        const SignalAssessment(
          type: SignalType.cloneDetection,
          severity: RiskScore.high,
          reasons: <String>['far apart'],
        ),
        const SignalAssessment(
          type: SignalType.velocityAnomaly,
          severity: RiskScore.medium,
          reasons: <String>['too many scans'],
        ),
      ];
      expect(calculateRiskScore(signals), RiskScore.fraudSuspected);
    });

    test('keeps a lone high signal at high', () {
      final signals = <SignalAssessment>[
        const SignalAssessment(
          type: SignalType.cloneDetection,
          severity: RiskScore.high,
          reasons: <String>['far apart'],
        ),
      ];
      expect(calculateRiskScore(signals), RiskScore.high);
    });
  });
}
