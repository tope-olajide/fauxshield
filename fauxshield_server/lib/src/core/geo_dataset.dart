import 'dart:math';

/// A coarse location resolved from an IP address. Never precise consumer
/// coordinates: city level at most, matching the platform's privacy stance.
class GeoResult {
  const GeoResult({
    required this.country,
    required this.countryCode,
    required this.city,
    this.latitude,
    this.longitude,
  });

  final String country;
  final String countryCode;
  final String city;
  final double? latitude;
  final double? longitude;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'country': country,
    'countryCode': countryCode,
    'city': city,
    'latitude': latitude,
    'longitude': longitude,
  };
}

/// City level locations used by the deterministic demo resolver and the attack
/// simulation. Coordinates are approximate city centers.
const List<GeoResult> demoCities = <GeoResult>[
  GeoResult(
    country: 'Nigeria',
    countryCode: 'NG',
    city: 'Lagos',
    latitude: 6.5244,
    longitude: 3.3792,
  ),
  GeoResult(
    country: 'Nigeria',
    countryCode: 'NG',
    city: 'Kano',
    latitude: 12.0022,
    longitude: 8.5920,
  ),
  GeoResult(
    country: 'Nigeria',
    countryCode: 'NG',
    city: 'Abuja',
    latitude: 9.0765,
    longitude: 7.3986,
  ),
  GeoResult(
    country: 'Kenya',
    countryCode: 'KE',
    city: 'Nairobi',
    latitude: -1.2921,
    longitude: 36.8219,
  ),
  GeoResult(
    country: 'Ghana',
    countryCode: 'GH',
    city: 'Accra',
    latitude: 5.6037,
    longitude: -0.1870,
  ),
  GeoResult(
    country: 'South Africa',
    countryCode: 'ZA',
    city: 'Johannesburg',
    latitude: -26.2041,
    longitude: 28.0473,
  ),
  GeoResult(
    country: 'Egypt',
    countryCode: 'EG',
    city: 'Cairo',
    latitude: 30.0444,
    longitude: 31.2357,
  ),
  GeoResult(
    country: 'Morocco',
    countryCode: 'MA',
    city: 'Casablanca',
    latitude: 33.5731,
    longitude: -7.5898,
  ),
  GeoResult(
    country: 'India',
    countryCode: 'IN',
    city: 'Mumbai',
    latitude: 19.0760,
    longitude: 72.8777,
  ),
  GeoResult(
    country: 'India',
    countryCode: 'IN',
    city: 'Delhi',
    latitude: 28.6139,
    longitude: 77.2090,
  ),
  GeoResult(
    country: 'China',
    countryCode: 'CN',
    city: 'Guangzhou',
    latitude: 23.1291,
    longitude: 113.2644,
  ),
  GeoResult(
    country: 'China',
    countryCode: 'CN',
    city: 'Shanghai',
    latitude: 31.2304,
    longitude: 121.4737,
  ),
  GeoResult(
    country: 'United Arab Emirates',
    countryCode: 'AE',
    city: 'Dubai',
    latitude: 25.2048,
    longitude: 55.2708,
  ),
  GeoResult(
    country: 'Turkey',
    countryCode: 'TR',
    city: 'Istanbul',
    latitude: 41.0082,
    longitude: 28.9784,
  ),
  GeoResult(
    country: 'United Kingdom',
    countryCode: 'GB',
    city: 'London',
    latitude: 51.5074,
    longitude: -0.1278,
  ),
  GeoResult(
    country: 'Germany',
    countryCode: 'DE',
    city: 'Berlin',
    latitude: 52.5200,
    longitude: 13.4050,
  ),
  GeoResult(
    country: 'France',
    countryCode: 'FR',
    city: 'Paris',
    latitude: 48.8566,
    longitude: 2.3522,
  ),
  GeoResult(
    country: 'Netherlands',
    countryCode: 'NL',
    city: 'Amsterdam',
    latitude: 52.3676,
    longitude: 4.9041,
  ),
  GeoResult(
    country: 'Spain',
    countryCode: 'ES',
    city: 'Madrid',
    latitude: 40.4168,
    longitude: -3.7038,
  ),
  GeoResult(
    country: 'Italy',
    countryCode: 'IT',
    city: 'Milan',
    latitude: 45.4642,
    longitude: 9.1900,
  ),
  GeoResult(
    country: 'Sweden',
    countryCode: 'SE',
    city: 'Stockholm',
    latitude: 59.3293,
    longitude: 18.0686,
  ),
  GeoResult(
    country: 'Poland',
    countryCode: 'PL',
    city: 'Warsaw',
    latitude: 52.2297,
    longitude: 21.0122,
  ),
  GeoResult(
    country: 'United States',
    countryCode: 'US',
    city: 'New York',
    latitude: 40.7128,
    longitude: -74.0060,
  ),
  GeoResult(
    country: 'United States',
    countryCode: 'US',
    city: 'Chicago',
    latitude: 41.8781,
    longitude: -87.6298,
  ),
  GeoResult(
    country: 'United States',
    countryCode: 'US',
    city: 'Mountain View',
    latitude: 37.3861,
    longitude: -122.0839,
  ),
  GeoResult(
    country: 'United States',
    countryCode: 'US',
    city: 'Miami',
    latitude: 25.7617,
    longitude: -80.1918,
  ),
  GeoResult(
    country: 'Canada',
    countryCode: 'CA',
    city: 'Toronto',
    latitude: 43.6532,
    longitude: -79.3832,
  ),
  GeoResult(
    country: 'Mexico',
    countryCode: 'MX',
    city: 'Mexico City',
    latitude: 19.4326,
    longitude: -99.1332,
  ),
  GeoResult(
    country: 'Brazil',
    countryCode: 'BR',
    city: 'Sao Paulo',
    latitude: -23.5505,
    longitude: -46.6333,
  ),
  GeoResult(
    country: 'Argentina',
    countryCode: 'AR',
    city: 'Buenos Aires',
    latitude: -34.6037,
    longitude: -58.3816,
  ),
  GeoResult(
    country: 'Chile',
    countryCode: 'CL',
    city: 'Santiago',
    latitude: -33.4489,
    longitude: -70.6693,
  ),
  GeoResult(
    country: 'Indonesia',
    countryCode: 'ID',
    city: 'Jakarta',
    latitude: -6.2088,
    longitude: 106.8456,
  ),
  GeoResult(
    country: 'Singapore',
    countryCode: 'SG',
    city: 'Singapore',
    latitude: 1.3521,
    longitude: 103.8198,
  ),
  GeoResult(
    country: 'Japan',
    countryCode: 'JP',
    city: 'Tokyo',
    latitude: 35.6762,
    longitude: 139.6503,
  ),
  GeoResult(
    country: 'South Korea',
    countryCode: 'KR',
    city: 'Seoul',
    latitude: 37.5665,
    longitude: 126.9780,
  ),
  GeoResult(
    country: 'Australia',
    countryCode: 'AU',
    city: 'Sydney',
    latitude: -33.8688,
    longitude: 151.2093,
  ),
  GeoResult(
    country: 'Pakistan',
    countryCode: 'PK',
    city: 'Karachi',
    latitude: 24.8607,
    longitude: 67.0011,
  ),
  GeoResult(
    country: 'Bangladesh',
    countryCode: 'BD',
    city: 'Dhaka',
    latitude: 23.8103,
    longitude: 90.4125,
  ),
  GeoResult(
    country: 'Vietnam',
    countryCode: 'VN',
    city: 'Ho Chi Minh City',
    latitude: 10.8231,
    longitude: 106.6297,
  ),
  GeoResult(
    country: 'Thailand',
    countryCode: 'TH',
    city: 'Bangkok',
    latitude: 13.7563,
    longitude: 100.5018,
  ),
  GeoResult(
    country: 'Philippines',
    countryCode: 'PH',
    city: 'Manila',
    latitude: 14.5995,
    longitude: 120.9842,
  ),
  GeoResult(
    country: 'Saudi Arabia',
    countryCode: 'SA',
    city: 'Riyadh',
    latitude: 24.7136,
    longitude: 46.6753,
  ),
  GeoResult(
    country: 'Ethiopia',
    countryCode: 'ET',
    city: 'Addis Ababa',
    latitude: 9.0300,
    longitude: 38.7400,
  ),
  GeoResult(
    country: 'Tanzania',
    countryCode: 'TZ',
    city: 'Dar es Salaam',
    latitude: -6.7924,
    longitude: 39.2083,
  ),
  GeoResult(
    country: 'Uganda',
    countryCode: 'UG',
    city: 'Kampala',
    latitude: 0.3476,
    longitude: 32.5825,
  ),
  GeoResult(
    country: 'Senegal',
    countryCode: 'SN',
    city: 'Dakar',
    latitude: 14.7167,
    longitude: -17.4677,
  ),
  GeoResult(
    country: 'Ivory Coast',
    countryCode: 'CI',
    city: 'Abidjan',
    latitude: 5.3600,
    longitude: -4.0083,
  ),
];

/// Well known IP mappings used to make local development and demos
/// deterministic. A production deployment configures a real provider instead.
const Map<String, int> _knownIpIndex = <String, int>{
  '8.8.8.8': 24, // Mountain View
  '1.1.1.1': 35, // Sydney
  '41.': 3, // Nairobi
  '102.': 0, // Lagos
  '105.': 0, // Lagos
  '197.': 0, // Lagos
  '154.': 6, // Cairo
  '196.': 3, // Nairobi
  '185.': 14, // London
  '193.': 15, // Berlin
  '78.': 13, // Istanbul
  '103.': 9, // Delhi
  '113.': 10, // Guangzhou
  '200.': 28, // Sao Paulo
  '201.': 28, // Sao Paulo
  '187.': 27, // Mexico City
  '73.': 23, // Chicago
  '86.': 11, // Shanghai
};

/// True when [ip] is a loopback, private, link-local, or otherwise
/// non-routable address. These can never be geolocated: the address identifies
/// a machine or network segment, not a place, so fabricating a city for them
/// would be dishonest. Local scans report "Unknown" or a device timezone
/// hint instead.
bool isPrivateOrLocalIp(String ip) {
  final value = ip.trim().toLowerCase();
  if (value.isEmpty) return true;
  if (value == '::1' || value == '::') return true;
  if (value.startsWith('fe80:') ||
      value.startsWith('fc') ||
      value.startsWith('fd')) {
    // IPv6 link-local (fe80::/10) and unique local (fc00::/7).
    return true;
  }
  if (value.startsWith('::ffff:')) {
    // IPv4-mapped IPv6, for example ::ffff:127.0.0.1.
    return isPrivateOrLocalIp(value.substring(7));
  }
  final parts = value.split('.');
  if (parts.length != 4) return false;
  final a = int.tryParse(parts[0]);
  final b = int.tryParse(parts[1]);
  if (a == null || b == null) return false;
  if (a == 127) return true; // Loopback, 127.0.0.0/8.
  if (a == 10) return true; // Private, 10.0.0.0/8.
  if (a == 0) return true; // "This network".
  if (a == 169 && b == 254) return true; // Link-local.
  if (a == 172 && b >= 16 && b <= 31) return true; // Private, 172.16.0.0/12.
  if (a == 192 && b == 168) return true; // Private, 192.168.0.0/16.
  if (a == 100 && b >= 64 && b <= 127) return true; // CGNAT, 100.64.0.0/10.
  return false;
}

/// Deterministic city for a *public* IP address. Stable for the same IP so
/// demos are reproducible. Used by the demo geo provider and the attack
/// simulation. Private and loopback addresses are refused: they carry no
/// location, and guessing one (as an earlier version did, inventing
/// "Guangzhou" for 127.0.0.1) misleads operators investigating real scans.
GeoResult? demoLocationForIp(String ip) {
  final trimmed = ip.trim();
  if (isPrivateOrLocalIp(trimmed)) return null;
  for (final entry in _knownIpIndex.entries) {
    if (trimmed.startsWith(entry.key)) {
      return demoCities[entry.value];
    }
  }
  var hash = 0;
  for (final code in trimmed.codeUnits) {
    hash = (hash * 31 + code) & 0x7fffffff;
  }
  return demoCities[hash % demoCities.length];
}

/// Resolves an IANA timezone label, for example `Africa/Lagos`, to the
/// nearest bundled city. Scans from localhost carry a loopback address, so the
/// consumer page sends the browser's timezone as a coarse, opt-in hint: it
/// names a real region the device is configured for instead of a fabricated
/// IP guess. Returns null when the timezone names no city we know.
GeoResult? locationForTimezone(String timezone) {
  final label = timezone.trim();
  if (label.isEmpty || !label.contains('/')) return null;
  // "Africa/Lagos" -> "Lagos"; "America/Argentina/Buenos_Aires" -> last part.
  final city = label.split('/').last.replaceAll('_', ' ').trim();
  if (city.isEmpty) return null;
  for (final candidate in demoCities) {
    if (candidate.city.toLowerCase() == city.toLowerCase()) return candidate;
  }
  return null;
}

/// Deterministic full city list entry for simulation scenarios.
GeoResult demoCity(String countryCode, String city) {
  for (final candidate in demoCities) {
    if (candidate.countryCode == countryCode && candidate.city == city) {
      return candidate;
    }
  }
  return demoCities.first;
}

/// Great circle distance between two coordinates in kilometers.
double haversineDistanceKm(double lat1, double lon1, double lat2, double lon2) {
  const earthRadiusKm = 6371.0;
  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadiusKm * c;
}

double _toRadians(double degrees) => degrees * pi / 180.0;

/// A stable positive hash for strings, used for deterministic choices.
int stableHash(String value) {
  var hash = 0;
  for (final code in value.codeUnits) {
    hash = (hash * 31 + code) & 0x7fffffff;
  }
  return hash;
}
