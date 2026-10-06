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
import '../enums/delivery_status.dart' as _ik1evhid;
import '../enums/webhook_event_type.dart' as _ih562tcf;

/// Outbox record for one webhook delivery attempt chain. A recurring scheduled
/// task drains due deliveries and applies the retry schedule.
abstract class WebhookDelivery
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WebhookDelivery._({
    this.id,
    required this.workspaceId,
    required this.endpointId,
    required this.eventType,
    required this.payloadJson,
    _ik1evhid.DeliveryStatus? status,
    int? attemptCount,
    int? maxAttempts,
    this.lastAttemptAt,
    DateTime? nextAttemptAt,
    this.lastHttpStatus,
    this.lastError,
    this.responseTimeMs,
    this.processingStartedAt,
    DateTime? createdAt,
    this.deliveredAt,
  }) : status = status ?? _ik1evhid.DeliveryStatus.pending,
       attemptCount = attemptCount ?? 0,
       maxAttempts = maxAttempts ?? 5,
       nextAttemptAt = nextAttemptAt ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  factory WebhookDelivery({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue endpointId,
    required _ih562tcf.WebhookEventType eventType,
    required String payloadJson,
    _ik1evhid.DeliveryStatus? status,
    int? attemptCount,
    int? maxAttempts,
    DateTime? lastAttemptAt,
    DateTime? nextAttemptAt,
    int? lastHttpStatus,
    String? lastError,
    int? responseTimeMs,
    DateTime? processingStartedAt,
    DateTime? createdAt,
    DateTime? deliveredAt,
  }) = _WebhookDeliveryImpl;

  factory WebhookDelivery.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookDelivery(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      endpointId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['endpointId'],
      ),
      eventType: _ih562tcf.WebhookEventType.fromJson(
        (jsonSerialization['eventType'] as String),
      ),
      payloadJson: jsonSerialization['payloadJson'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _ik1evhid.DeliveryStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      attemptCount: jsonSerialization['attemptCount'] as int?,
      maxAttempts: jsonSerialization['maxAttempts'] as int?,
      lastAttemptAt: jsonSerialization['lastAttemptAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastAttemptAt'],
            ),
      nextAttemptAt: jsonSerialization['nextAttemptAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextAttemptAt'],
            ),
      lastHttpStatus: jsonSerialization['lastHttpStatus'] as int?,
      lastError: jsonSerialization['lastError'] as String?,
      responseTimeMs: jsonSerialization['responseTimeMs'] as int?,
      processingStartedAt: jsonSerialization['processingStartedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['processingStartedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deliveredAt: jsonSerialization['deliveredAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['deliveredAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  _isc.UuidValue endpointId;

  _ih562tcf.WebhookEventType eventType;

  String payloadJson;

  _ik1evhid.DeliveryStatus status;

  int attemptCount;

  int maxAttempts;

  DateTime? lastAttemptAt;

  DateTime nextAttemptAt;

  int? lastHttpStatus;

  String? lastError;

  int? responseTimeMs;

  DateTime? processingStartedAt;

  DateTime createdAt;

  DateTime? deliveredAt;

  /// Returns a shallow copy of this [WebhookDelivery]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WebhookDelivery copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? endpointId,
    _ih562tcf.WebhookEventType? eventType,
    String? payloadJson,
    _ik1evhid.DeliveryStatus? status,
    int? attemptCount,
    int? maxAttempts,
    DateTime? lastAttemptAt,
    DateTime? nextAttemptAt,
    int? lastHttpStatus,
    String? lastError,
    int? responseTimeMs,
    DateTime? processingStartedAt,
    DateTime? createdAt,
    DateTime? deliveredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WebhookDelivery',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'endpointId': endpointId.toJson(),
      'eventType': eventType.toJson(),
      'payloadJson': payloadJson,
      'status': status.toJson(),
      'attemptCount': attemptCount,
      'maxAttempts': maxAttempts,
      if (lastAttemptAt != null) 'lastAttemptAt': lastAttemptAt?.toJson(),
      'nextAttemptAt': nextAttemptAt.toJson(),
      if (lastHttpStatus != null) 'lastHttpStatus': lastHttpStatus,
      if (lastError != null) 'lastError': lastError,
      if (responseTimeMs != null) 'responseTimeMs': responseTimeMs,
      if (processingStartedAt != null)
        'processingStartedAt': processingStartedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WebhookDelivery',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'endpointId': endpointId.toJson(),
      'eventType': eventType.toJson(),
      'payloadJson': payloadJson,
      'status': status.toJson(),
      'attemptCount': attemptCount,
      'maxAttempts': maxAttempts,
      if (lastAttemptAt != null) 'lastAttemptAt': lastAttemptAt?.toJson(),
      'nextAttemptAt': nextAttemptAt.toJson(),
      if (lastHttpStatus != null) 'lastHttpStatus': lastHttpStatus,
      if (lastError != null) 'lastError': lastError,
      if (responseTimeMs != null) 'responseTimeMs': responseTimeMs,
      if (processingStartedAt != null)
        'processingStartedAt': processingStartedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (deliveredAt != null) 'deliveredAt': deliveredAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WebhookDeliveryImpl extends WebhookDelivery {
  _WebhookDeliveryImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required _isc.UuidValue endpointId,
    required _ih562tcf.WebhookEventType eventType,
    required String payloadJson,
    _ik1evhid.DeliveryStatus? status,
    int? attemptCount,
    int? maxAttempts,
    DateTime? lastAttemptAt,
    DateTime? nextAttemptAt,
    int? lastHttpStatus,
    String? lastError,
    int? responseTimeMs,
    DateTime? processingStartedAt,
    DateTime? createdAt,
    DateTime? deliveredAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         endpointId: endpointId,
         eventType: eventType,
         payloadJson: payloadJson,
         status: status,
         attemptCount: attemptCount,
         maxAttempts: maxAttempts,
         lastAttemptAt: lastAttemptAt,
         nextAttemptAt: nextAttemptAt,
         lastHttpStatus: lastHttpStatus,
         lastError: lastError,
         responseTimeMs: responseTimeMs,
         processingStartedAt: processingStartedAt,
         createdAt: createdAt,
         deliveredAt: deliveredAt,
       );

  /// Returns a shallow copy of this [WebhookDelivery]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WebhookDelivery copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? endpointId,
    _ih562tcf.WebhookEventType? eventType,
    String? payloadJson,
    _ik1evhid.DeliveryStatus? status,
    int? attemptCount,
    int? maxAttempts,
    Object? lastAttemptAt = _Undefined,
    DateTime? nextAttemptAt,
    Object? lastHttpStatus = _Undefined,
    Object? lastError = _Undefined,
    Object? responseTimeMs = _Undefined,
    Object? processingStartedAt = _Undefined,
    DateTime? createdAt,
    Object? deliveredAt = _Undefined,
  }) {
    return WebhookDelivery(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      endpointId: endpointId ?? this.endpointId,
      eventType: eventType ?? this.eventType,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      attemptCount: attemptCount ?? this.attemptCount,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      lastAttemptAt: lastAttemptAt is DateTime?
          ? lastAttemptAt
          : this.lastAttemptAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lastHttpStatus: lastHttpStatus is int?
          ? lastHttpStatus
          : this.lastHttpStatus,
      lastError: lastError is String? ? lastError : this.lastError,
      responseTimeMs: responseTimeMs is int?
          ? responseTimeMs
          : this.responseTimeMs,
      processingStartedAt: processingStartedAt is DateTime?
          ? processingStartedAt
          : this.processingStartedAt,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt is DateTime? ? deliveredAt : this.deliveredAt,
    );
  }
}
