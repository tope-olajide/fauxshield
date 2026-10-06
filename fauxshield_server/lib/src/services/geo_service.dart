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
///   local development, tests, and demos are reproducible.
/// * `http`: a configurable lookup URL template such as
///   `https://ipwho.is/{ip}` returning JSON with country/city fields. Failures
///   fall back to the demo table so verification never blocks on geo.
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

  static final Map<String, GeoResult?> _cache = <String, GeoResult?>{};
  static const int _cacheLimit = 512;

  Future<GeoResult?> resolveLocation(Session session, String? ipAddress) async {
    if (ipAddress == null || ipAddress.isEmpty) return null;

    final provider =
        (providerOverride ??
                PlatformKeys.optional(
                  session,
                  PlatformSecretNames.geoProvider,
                ) ??
                'demo')
            .toLowerCase();
    if (provider == 'disabled') return null;

    if (_cache.containsKey(ipAddress)) {
      return _cache[ipAddress];
    }

    GeoResult? result;
    switch (provider) {
      case 'http':
        result = await _resolveHttp(session, ipAddress);
        break;
      case 'demo':
      default:
        result = demoLocationForIp(ipAddress);
        break;
    }

    if (_cache.length >= _cacheLimit) {
      _cache.remove(_cache.keys.first);
    }
    _cache[ipAddress] = result;
    return result;
  }

  Future<GeoResult?> _resolveHttp(Session session, String ipAddress) async {
    final template =
        urlTemplateOverride ??
        PlatformKeys.optional(
          session,
          PlatformSecretNames.geoLookupUrlTemplate,
        );
    if (template == null || !template.contains('{ip}')) {
      return demoLocationForIp(ipAddress);
    }
    final url = template.replaceAll('{ip}', Uri.encodeComponent(ipAddress));
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(FauxShieldLimits.geoLookupTimeout);
      if (response.statusCode != 200) return demoLocationForIp(ipAddress);
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return demoLocationForIp(ipAddress);

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
        return demoLocationForIp(ipAddress);
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
      return demoLocationForIp(ipAddress);
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
