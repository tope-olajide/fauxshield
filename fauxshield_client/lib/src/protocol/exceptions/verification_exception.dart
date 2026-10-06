/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'api_exception.dart';

/// A typed failure in the consumer verification flow. Carries a reason the app
/// can react to without parsing error strings.
abstract class VerificationException extends _iv35mfmj.ApiException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  VerificationException._({
    required super.message,
    super.code,
    required this.reason,
  });

  factory VerificationException({
    required String message,
    String? code,
    required _i9xcs559.VerificationErrorReason reason,
  }) = _VerificationExceptionImpl;

  factory VerificationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VerificationException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String?,
      reason: _i9xcs559.VerificationErrorReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _i9xcs559.VerificationErrorReason reason;

  /// Returns a shallow copy of this [VerificationException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  VerificationException copyWith({
    String? message,
    String? code,
    _i9xcs559.VerificationErrorReason? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VerificationException',
      'message': message,
      'code': code,
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VerificationException',
      'message': message,
      'code': code,
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'VerificationException(message: $message, code: $code, reason: $reason)';
  }
}

class _VerificationExceptionImpl extends VerificationException {
  _VerificationExceptionImpl({
    required String message,
    String? code,
    required _i9xcs559.VerificationErrorReason reason,
  }) : super._(
         message: message,
         code: code,
         reason: reason,
       );

  /// Returns a shallow copy of this [VerificationException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  VerificationException copyWith({
    String? message,
    String? code,
    _i9xcs559.VerificationErrorReason? reason,
  }) {
    return VerificationException(
      message: message ?? this.message,
      code: code ?? this.code,
      reason: reason ?? this.reason,
    );
  }
}
