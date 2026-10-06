/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// Coarse IP-derived location for a verification. The platform never uses
/// browser GPS and never stores precise consumer coordinates.
abstract class GeoSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  GeoSummary._({
    this.country,
    this.countryCode,
    this.city,
    this.latitude,
    this.longitude,
  });

  factory GeoSummary({
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
  }) = _GeoSummaryImpl;

  factory GeoSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return GeoSummary(
      country: jsonSerialization['country'] as String?,
      countryCode: jsonSerialization['countryCode'] as String?,
      city: jsonSerialization['city'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
    );
  }

  String? country;

  String? countryCode;

  String? city;

  double? latitude;

  double? longitude;

  /// Returns a shallow copy of this [GeoSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  GeoSummary copyWith({
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GeoSummary',
      if (country != null) 'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GeoSummary',
      if (country != null) 'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      if (city != null) 'city': city,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GeoSummaryImpl extends GeoSummary {
  _GeoSummaryImpl({
    String? country,
    String? countryCode,
    String? city,
    double? latitude,
    double? longitude,
  }) : super._(
         country: country,
         countryCode: countryCode,
         city: city,
         latitude: latitude,
         longitude: longitude,
       );

  /// Returns a shallow copy of this [GeoSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  GeoSummary copyWith({
    Object? country = _Undefined,
    Object? countryCode = _Undefined,
    Object? city = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
  }) {
    return GeoSummary(
      country: country is String? ? country : this.country,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      city: city is String? ? city : this.city,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
    );
  }
}
