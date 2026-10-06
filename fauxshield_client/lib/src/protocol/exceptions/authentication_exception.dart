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

abstract class AuthenticationException extends _iv35mfmj.ApiException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  AuthenticationException._({
    required super.message,
    super.code,
    required this.reason,
  });

  factory AuthenticationException({
    required String message,
    String? code,
    required String reason,
  }) = _AuthenticationExceptionImpl;

  factory AuthenticationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AuthenticationException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String?,
      reason: jsonSerialization['reason'] as String,
    );
  }

  /// Either notAuthenticated or forbidden.
  String reason;

  /// Returns a shallow copy of this [AuthenticationException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  AuthenticationException copyWith({
    String? message,
    String? code,
    String? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthenticationException',
      'message': message,
      'code': code,
      'reason': reason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthenticationException',
      'message': message,
      'code': code,
      'reason': reason,
    };
  }

  @override
  String toString() {
    return 'AuthenticationException(message: $message, code: $code, reason: $reason)';
  }
}

class _AuthenticationExceptionImpl extends AuthenticationException {
  _AuthenticationExceptionImpl({
    required String message,
    String? code,
    required String reason,
  }) : super._(
         message: message,
         code: code,
         reason: reason,
       );

  /// Returns a shallow copy of this [AuthenticationException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AuthenticationException copyWith({
    String? message,
    String? code,
    String? reason,
  }) {
    return AuthenticationException(
      message: message ?? this.message,
      code: code ?? this.code,
      reason: reason ?? this.reason,
    );
  }
}
