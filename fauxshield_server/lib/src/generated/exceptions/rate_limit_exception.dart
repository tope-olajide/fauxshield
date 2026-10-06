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

abstract class RateLimitException extends _iv35mfmj.ApiException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  RateLimitException._({
    required super.message,
    super.code,
    required this.retryAfterSeconds,
  });

  factory RateLimitException({
    required String message,
    String? code,
    required int retryAfterSeconds,
  }) = _RateLimitExceptionImpl;

  factory RateLimitException.fromJson(Map<String, dynamic> jsonSerialization) {
    return RateLimitException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String?,
      retryAfterSeconds: jsonSerialization['retryAfterSeconds'] as int,
    );
  }

  int retryAfterSeconds;

  /// Returns a shallow copy of this [RateLimitException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  RateLimitException copyWith({
    String? message,
    String? code,
    int? retryAfterSeconds,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RateLimitException',
      'message': message,
      'code': code,
      'retryAfterSeconds': retryAfterSeconds,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RateLimitException',
      'message': message,
      'code': code,
      'retryAfterSeconds': retryAfterSeconds,
    };
  }

  @override
  String toString() {
    return 'RateLimitException(message: $message, code: $code, retryAfterSeconds: $retryAfterSeconds)';
  }
}

class _RateLimitExceptionImpl extends RateLimitException {
  _RateLimitExceptionImpl({
    required String message,
    String? code,
    required int retryAfterSeconds,
  }) : super._(
         message: message,
         code: code,
         retryAfterSeconds: retryAfterSeconds,
       );

  /// Returns a shallow copy of this [RateLimitException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RateLimitException copyWith({
    String? message,
    String? code,
    int? retryAfterSeconds,
  }) {
    return RateLimitException(
      message: message ?? this.message,
      code: code ?? this.code,
      retryAfterSeconds: retryAfterSeconds ?? this.retryAfterSeconds,
    );
  }
}
