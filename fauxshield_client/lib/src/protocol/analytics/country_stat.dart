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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class CountryStat
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CountryStat._({
    required this.country,
    this.countryCode,
    required this.verifications,
    required this.fraud,
  });

  factory CountryStat({
    required String country,
    String? countryCode,
    required int verifications,
    required int fraud,
  }) = _CountryStatImpl;

  factory CountryStat.fromJson(Map<String, dynamic> jsonSerialization) {
    return CountryStat(
      country: jsonSerialization['country'] as String,
      countryCode: jsonSerialization['countryCode'] as String?,
      verifications: jsonSerialization['verifications'] as int,
      fraud: jsonSerialization['fraud'] as int,
    );
  }

  String country;

  String? countryCode;

  int verifications;

  int fraud;

  /// Returns a shallow copy of this [CountryStat]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CountryStat copyWith({
    String? country,
    String? countryCode,
    int? verifications,
    int? fraud,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CountryStat',
      'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      'verifications': verifications,
      'fraud': fraud,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CountryStat',
      'country': country,
      if (countryCode != null) 'countryCode': countryCode,
      'verifications': verifications,
      'fraud': fraud,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CountryStatImpl extends CountryStat {
  _CountryStatImpl({
    required String country,
    String? countryCode,
    required int verifications,
    required int fraud,
  }) : super._(
         country: country,
         countryCode: countryCode,
         verifications: verifications,
         fraud: fraud,
       );

  /// Returns a shallow copy of this [CountryStat]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CountryStat copyWith({
    String? country,
    Object? countryCode = _Undefined,
    int? verifications,
    int? fraud,
  }) {
    return CountryStat(
      country: country ?? this.country,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      verifications: verifications ?? this.verifications,
      fraud: fraud ?? this.fraud,
    );
  }
}
