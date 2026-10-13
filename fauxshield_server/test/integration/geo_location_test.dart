import 'package:fauxshield_server/src/services/verification_service.dart';
import 'package:test/test.dart';

import 'test_fixture.dart';
import 'test_tools/serverpod_test_tools.dart';

/// A live scan from a Nigerian address was reported to the brand as
/// "Manila, Philippines": under the default `demo` geo provider an address the
/// bundled table does not recognize is hashed into an invented city, and that
/// invention was presented as the scan's location. The verify page sends the
/// device's timezone, which names a region the device is really configured for,
/// so it has to outrank the invention.
void main() {
  withServerpod('Given a consumer scan', (sessionBuilder, endpoints) {
    test('the device timezone outranks the demo table', () async {
      final owner = authenticatedAs(sessionBuilder, 'owner-geo-location');
      final fixture = await setUpBrand(endpoints, owner);
      final session = owner.build();

      final resolved = await VerificationService().resolveToken(
        session,
        token: fixture.identities.first.qrToken,
        deviceFingerprint: 'test-device-geo',
        // A public address the demo table covers only by hashing it.
        ipOverride: '129.205.124.226',
        timezoneHint: 'Africa/Lagos',
      );

      expect(resolved.city, 'Lagos');
      expect(resolved.country, 'Nigeria');
      expect(resolved.countryCode, 'NG');
    });

    test('a scan without a timezone still resolves a location', () async {
      final owner = authenticatedAs(sessionBuilder, 'owner-geo-fallback');
      final fixture = await setUpBrand(endpoints, owner);
      final session = owner.build();

      final resolved = await VerificationService().resolveToken(
        session,
        token: fixture.identities.first.qrToken,
        deviceFingerprint: 'test-device-geo-fallback',
        ipOverride: '129.205.124.227',
      );

      expect(resolved.city, isNotEmpty);
      expect(resolved.country, isNotEmpty);
    });

    test('a local scan carries no invented location', () async {
      final owner = authenticatedAs(sessionBuilder, 'owner-geo-local');
      final fixture = await setUpBrand(endpoints, owner);
      final session = owner.build();

      final resolved = await VerificationService().resolveToken(
        session,
        token: fixture.identities.first.qrToken,
        deviceFingerprint: 'test-device-geo-local',
        ipOverride: '127.0.0.1',
      );

      expect(resolved.city, 'Unknown');
      expect(resolved.country, 'Unknown');
    });
  });
}
