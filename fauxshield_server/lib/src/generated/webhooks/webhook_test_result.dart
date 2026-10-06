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

/// Result of sending a test delivery to a webhook endpoint.
abstract class WebhookTestResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  WebhookTestResult._({
    required this.success,
    this.statusCode,
    this.responseTimeMs,
    this.error,
    this.deliveryId,
  });

  factory WebhookTestResult({
    required bool success,
    int? statusCode,
    int? responseTimeMs,
    String? error,
    _is.UuidValue? deliveryId,
  }) = _WebhookTestResultImpl;

  factory WebhookTestResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookTestResult(
      success: _is.BoolJsonExtension.fromJson(jsonSerialization['success']),
      statusCode: jsonSerialization['statusCode'] as int?,
      responseTimeMs: jsonSerialization['responseTimeMs'] as int?,
      error: jsonSerialization['error'] as String?,
      deliveryId: jsonSerialization['deliveryId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['deliveryId'],
            ),
    );
  }

  bool success;

  int? statusCode;

  int? responseTimeMs;

  String? error;

  _is.UuidValue? deliveryId;

  /// Returns a shallow copy of this [WebhookTestResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WebhookTestResult copyWith({
    bool? success,
    int? statusCode,
    int? responseTimeMs,
    String? error,
    _is.UuidValue? deliveryId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WebhookTestResult',
      'success': success,
      if (statusCode != null) 'statusCode': statusCode,
      if (responseTimeMs != null) 'responseTimeMs': responseTimeMs,
      if (error != null) 'error': error,
      if (deliveryId != null) 'deliveryId': deliveryId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WebhookTestResult',
      'success': success,
      if (statusCode != null) 'statusCode': statusCode,
      if (responseTimeMs != null) 'responseTimeMs': responseTimeMs,
      if (error != null) 'error': error,
      if (deliveryId != null) 'deliveryId': deliveryId?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WebhookTestResultImpl extends WebhookTestResult {
  _WebhookTestResultImpl({
    required bool success,
    int? statusCode,
    int? responseTimeMs,
    String? error,
    _is.UuidValue? deliveryId,
  }) : super._(
         success: success,
         statusCode: statusCode,
         responseTimeMs: responseTimeMs,
         error: error,
         deliveryId: deliveryId,
       );

  /// Returns a shallow copy of this [WebhookTestResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WebhookTestResult copyWith({
    bool? success,
    Object? statusCode = _Undefined,
    Object? responseTimeMs = _Undefined,
    Object? error = _Undefined,
    Object? deliveryId = _Undefined,
  }) {
    return WebhookTestResult(
      success: success ?? this.success,
      statusCode: statusCode is int? ? statusCode : this.statusCode,
      responseTimeMs: responseTimeMs is int?
          ? responseTimeMs
          : this.responseTimeMs,
      error: error is String? ? error : this.error,
      deliveryId: deliveryId is _is.UuidValue? ? deliveryId : this.deliveryId,
    );
  }
}
