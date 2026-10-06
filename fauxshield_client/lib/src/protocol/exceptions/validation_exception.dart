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

abstract class ValidationException extends _iv35mfmj.ApiException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  ValidationException._({
    required super.message,
    super.code,
    this.field,
  });

  factory ValidationException({
    required String message,
    String? code,
    String? field,
  }) = _ValidationExceptionImpl;

  factory ValidationException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ValidationException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String?,
      field: jsonSerialization['field'] as String?,
    );
  }

  String? field;

  /// Returns a shallow copy of this [ValidationException]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  ValidationException copyWith({
    String? message,
    String? code,
    String? field,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ValidationException',
      'message': message,
      'code': code,
      if (field != null) 'field': field,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ValidationException',
      'message': message,
      'code': code,
      if (field != null) 'field': field,
    };
  }

  @override
  String toString() {
    return 'ValidationException(message: $message, code: $code, field: $field)';
  }
}

class _ValidationExceptionImpl extends ValidationException {
  _ValidationExceptionImpl({
    required String message,
    String? code,
    String? field,
  }) : super._(
         message: message,
         code: code,
         field: field,
       );

  /// Returns a shallow copy of this [ValidationException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ValidationException copyWith({
    String? message,
    String? code,
    Object? field = _Undefined,
  }) {
    return ValidationException(
      message: message ?? this.message,
      code: code ?? this.code,
      field: field is String? ? field : this.field,
    );
  }
}
