import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../core/geo_dataset.dart';
import 'platform_keys.dart';

/// Resolves coarse IP derived locations for fraud analysis.
///
/// Providers:
/// * `demo` (default): deterministic city lookup from the bundled dataset so
///   local development, tests, and demos are reproducible. It is a table of
///   cities keyed by address prefix and a hash of the address, so for any
///   address it does not know it invents a city. It is not a geolocation
///   service: a real deployment must not present its answer as the consumer's
///   location. A device supplied [timezoneHint] therefore outranks it.
/// * `http`: a configurable lookup URL template such as
///   `https://ipwho.is/{ip}` returning JSON with country/city fields. This is
///   the only provider that answers with real geo data; when it cannot answer
///   the lookup resolves to null rather than to the demo table's invention.
/// * `disabled`: no geo enrichment; geo dependent signals are skipped.
///
/// The service never uses browser GPS and never stores precise coordinates.
class GeoService {
  GeoService({
    this.providerOverride,
    this.urlTemplateOverride,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String? providerOverride;
  final String? urlTemplateOverride;
  final http.Client _client;

  static final Map<String, GeoResult> _cache = <String, GeoResult>{};
  static const int _cacheLimit = 512;

  /// Resolves a coarse location for [ipAddress].
  ///
  /// [timezoneHint] is the consumer device's IANA timezone (for example
  /// `Africa/Lagos`), sent by the verify page. It names a region the device is
  /// really configured for, so it is preferred over the demo table's invented
  /// city — and it is the only signal available for loopback and private
  /// addresses, which describe a machine rather than a place.
  Future<GeoResult?> resolveLocation(
    Session session,
    String? ipAddress, {
    String? timezoneHint,
  }) async {
    GeoResult? hint;
    if (timezoneHint != null && timezoneHint.trim().isNotEmpty) {
      hint = locationForTimezone(timezoneHint);
    }
    if (ipAddress == null || ipAddress.isEmpty) return hint;

    final provider =
        (providerOverride ??
                PlatformKeys.optional(
                  session,
                  PlatformSecretNames.geoProvider,
                ) ??
                'demo')
            .toLowerCase();
    if (provider == 'disabled') return null;

    // A non-routable address cannot be looked up by any provider; the
    // timezone hint is the only honest signal available.
    if (isPrivateOrLocalIp(ipAddress)) return hint;

    // Only what the address itself yields is cached, so one device's timezone
    // hint can never be handed to another device behind the same NAT, and a
    // lookup that could not answer is retried on the next scan instead of
    // being remembered as an answer.
    GeoResult? fromIp;
    if (_cache.containsKey(ipAddress)) {
      fromIp = _cache[ipAddress];
    } else {
      fromIp = provider == 'http'
          ? await _resolveHttp(session, ipAddress)
          : demoLocationForIp(ipAddress);
      if (fromIp != null) {
        if (_cache.length >= _cacheLimit) {
          _cache.remove(_cache.keys.first);
        }
        _cache[ipAddress] = fromIp;
      }
    }

    return preferLocation(
      realProvider: provider == 'http',
      fromIp: fromIp,
      hint: hint,
    );
  }

  /// The precedence rule for a resolved location, kept as a pure function so
  /// the policy can be tested without a session.
  ///
  /// A provider that answers with real geo data wins, and the device hint only
  /// fills in when it could not answer. The demo table invents a city for an
  /// address it does not know, so there the device's own timezone outranks it.
  static GeoResult? preferLocation({
    required bool realProvider,
    GeoResult? fromIp,
    GeoResult? hint,
  }) => realProvider ? (fromIp ?? hint) : (hint ?? fromIp);

  /// Looks [ipAddress] up through the configured template, returning null when
  /// no lookup is configured, the service does not answer, or it answers
  /// without usable fields. It never falls back to the demo table: an invented
  /// city in the operator's feed is worse than no city at all.
  Future<GeoResult?> _resolveHttp(Session session, String ipAddress) async {
    final template =
        urlTemplateOverride ??
        PlatformKeys.optional(
          session,
          PlatformSecretNames.geoLookupUrlTemplate,
        );
    if (template == null || !template.contains('{ip}')) {
      return null;
    }
    final url = template.replaceAll('{ip}', Uri.encodeComponent(ipAddress));
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(FauxShieldLimits.geoLookupTimeout);
      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return null;

      final country = _stringValue(decoded, const ['country', 'country_name']);
      final countryCode = _stringValue(decoded, const [
        'country_code',
        'countryCode',
      ]);
      final city = _stringValue(decoded, const ['city']);
      final latitude = _doubleValue(decoded, const ['latitude', 'lat']);
      final longitude = _doubleValue(decoded, const [
        'longitude',
        'lon',
        'lng',
      ]);

      if (country.isEmpty && countryCode.isEmpty && city.isEmpty) {
        return null;
      }
      return GeoResult(
        country: country.isEmpty
            ? (countryCode.isEmpty ? 'Unknown' : countryCode)
            : country,
        countryCode: countryCode.isEmpty
            ? country.toUpperCase()
            : countryCode.toUpperCase(),
        city: city.isEmpty ? 'Unknown' : city,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (_) {
      // Geo enrichment is best effort: verification must never fail on it.
      return null;
    }
  }

  static String _stringValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }

  static double? _doubleValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) return value.toDouble();
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }
}
