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

/// Result of an authorized PIN reveal. Every reveal is recorded in the audit
/// log with the acting user.
abstract class RevealedPin
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RevealedPin._({
    required this.identityId,
    required this.pin,
    required this.revealedAt,
  });

  factory RevealedPin({
    required _isc.UuidValue identityId,
    required String pin,
    required DateTime revealedAt,
  }) = _RevealedPinImpl;

  factory RevealedPin.fromJson(Map<String, dynamic> jsonSerialization) {
    return RevealedPin(
      identityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      pin: jsonSerialization['pin'] as String,
      revealedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['revealedAt'],
      ),
    );
  }

  _isc.UuidValue identityId;

  String pin;

  DateTime revealedAt;

  /// Returns a shallow copy of this [RevealedPin]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RevealedPin copyWith({
    _isc.UuidValue? identityId,
    String? pin,
    DateTime? revealedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RevealedPin',
      'identityId': identityId.toJson(),
      'pin': pin,
      'revealedAt': revealedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RevealedPin',
      'identityId': identityId.toJson(),
      'pin': pin,
      'revealedAt': revealedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RevealedPinImpl extends RevealedPin {
  _RevealedPinImpl({
    required _isc.UuidValue identityId,
    required String pin,
    required DateTime revealedAt,
  }) : super._(
         identityId: identityId,
         pin: pin,
         revealedAt: revealedAt,
       );

  /// Returns a shallow copy of this [RevealedPin]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RevealedPin copyWith({
    _isc.UuidValue? identityId,
    String? pin,
    DateTime? revealedAt,
  }) {
    return RevealedPin(
      identityId: identityId ?? this.identityId,
      pin: pin ?? this.pin,
      revealedAt: revealedAt ?? this.revealedAt,
    );
  }
}
