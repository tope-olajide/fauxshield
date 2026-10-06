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

abstract class ConflictException extends _iv35mfmj.ApiException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  ConflictException._({
    required super.message,
    super.code,
    required this.resource,
  });

  factory ConflictException({
    required String message,
    String? code,
    required String resource,
  }) = _ConflictExceptionImpl;

  factory ConflictException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConflictException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String?,
      resource: jsonSerialization['resource'] as String,
    );
  }

  String resource;

  /// Returns a shallow copy of this [ConflictException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  ConflictException copyWith({
    String? message,
    String? code,
    String? resource,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConflictException',
      'message': message,
      'code': code,
      'resource': resource,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConflictException',
      'message': message,
      'code': code,
      'resource': resource,
    };
  }

  @override
  String toString() {
    return 'ConflictException(message: $message, code: $code, resource: $resource)';
  }
}

class _ConflictExceptionImpl extends ConflictException {
  _ConflictExceptionImpl({
    required String message,
    String? code,
    required String resource,
  }) : super._(
         message: message,
         code: code,
         resource: resource,
       );

  /// Returns a shallow copy of this [ConflictException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ConflictException copyWith({
    String? message,
    String? code,
    String? resource,
  }) {
    return ConflictException(
      message: message ?? this.message,
      code: code ?? this.code,
      resource: resource ?? this.resource,
    );
  }
}
