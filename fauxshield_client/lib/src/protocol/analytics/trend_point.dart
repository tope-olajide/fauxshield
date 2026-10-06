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

abstract class TrendPoint
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TrendPoint._({
    required this.date,
    required this.verifications,
    required this.fraud,
  });

  factory TrendPoint({
    required DateTime date,
    required int verifications,
    required int fraud,
  }) = _TrendPointImpl;

  factory TrendPoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return TrendPoint(
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      verifications: jsonSerialization['verifications'] as int,
      fraud: jsonSerialization['fraud'] as int,
    );
  }

  DateTime date;

  int verifications;

  int fraud;

  /// Returns a shallow copy of this [TrendPoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TrendPoint copyWith({
    DateTime? date,
    int? verifications,
    int? fraud,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TrendPoint',
      'date': date.toJson(),
      'verifications': verifications,
      'fraud': fraud,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TrendPoint',
      'date': date.toJson(),
      'verifications': verifications,
      'fraud': fraud,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TrendPointImpl extends TrendPoint {
  _TrendPointImpl({
    required DateTime date,
    required int verifications,
    required int fraud,
  }) : super._(
         date: date,
         verifications: verifications,
         fraud: fraud,
       );

  /// Returns a shallow copy of this [TrendPoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TrendPoint copyWith({
    DateTime? date,
    int? verifications,
    int? fraud,
  }) {
    return TrendPoint(
      date: date ?? this.date,
      verifications: verifications ?? this.verifications,
      fraud: fraud ?? this.fraud,
    );
  }
}
