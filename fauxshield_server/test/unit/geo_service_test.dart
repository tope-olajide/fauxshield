import 'package:fauxshield_server/src/core/geo_dataset.dart';
import 'package:fauxshield_server/src/services/geo_service.dart';
import 'package:test/test.dart';

/// Live scans once reported "Manila, Philippines" for a consumer in Lagos: the
/// demo provider hashes an address the bundled table does not recognize into
/// whatever city that hash lands on, and the invented city was presented as the
/// scan's location. These tests pin the rule that a real lookup wins, and that
/// the device's own timezone outranks the invention.
void main() {
  group('Given the demo geo table', () {
    test('a public address it does not recognize still gets a city', () {
      // 129.205.0.0/16 is a Nigerian range the table has no prefix for, so
      // the hash decides; the same address always lands on the same city,
      // which is what makes local demos reproducible.
      final first = demoLocationForIp('129.205.124.226');
      final second = demoLocationForIp('129.205.124.226');

      expect(first, isNotNull);
      expect(first!.city, second!.city);
      expect(first.country, second.country);
    });

    test('the address the table does know resolves to its real city', () {
      expect(demoLocationForIp('102.89.23.4')?.city, 'Lagos');
    });

    test('a non-routable address resolves to nothing', () {
      for (final ip in <String>[
        '127.0.0.1',
        '10.0.0.5',
        '192.168.1.10',
        '::1',
        '',
      ]) {
        expect(isPrivateOrLocalIp(ip), isTrue, reason: ip);
        expect(demoLocationForIp(ip), isNull, reason: ip);
      }
    });

    test('the device timezone names a real city, or nothing', () {
      final lagos = locationForTimezone('Africa/Lagos');

      expect(lagos, isNotNull);
      expect(lagos!.city, 'Lagos');
      expect(lagos.country, 'Nigeria');
      expect(
        locationForTimezone('America/Argentina/Buenos_Aires')?.city,
        'Buenos Aires',
      );
      expect(locationForTimezone('Africa/Nowhere'), isNull);
      expect(locationForTimezone(''), isNull);
    });
  });

  group('Given the location precedence rule', () {
    final lagos = locationForTimezone('Africa/Lagos');
    final invented = demoLocationForIp('129.205.124.226');

    test('the device timezone outranks the demo table', () {
      final resolved = GeoService.preferLocation(
        realProvider: false,
        fromIp: invented,
        hint: lagos,
      );

      expect(resolved?.city, 'Lagos');
      expect(resolved?.country, 'Nigeria');
    });

    test('the demo table is used when no timezone is available', () {
      final resolved = GeoService.preferLocation(
        realProvider: false,
        fromIp: invented,
        hint: null,
      );

      expect(resolved, same(invented));
    });

    test('a real lookup outranks the device timezone', () {
      const manila = GeoResult(
        country: 'Philippines',
        countryCode: 'PH',
        city: 'Manila',
      );

      final resolved = GeoService.preferLocation(
        realProvider: true,
        fromIp: manila,
        hint: lagos,
      );

      expect(resolved?.city, 'Manila');
    });

    test('a lookup that could not answer falls back to the timezone', () {
      final resolved = GeoService.preferLocation(
        realProvider: true,
        fromIp: null,
        hint: lagos,
      );

      expect(resolved?.city, 'Lagos');
    });

    test('with no signal at all there is no location to report', () {
      expect(
        GeoService.preferLocation(realProvider: true, fromIp: null, hint: null),
        isNull,
      );
      expect(
        GeoService.preferLocation(
          realProvider: false,
          fromIp: null,
          hint: null,
        ),
        isNull,
      );
    });
  });
}
