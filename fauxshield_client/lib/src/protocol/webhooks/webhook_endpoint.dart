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
import 'package:fauxshield_client/src/protocol/protocol.dart' as _iuzkm0gn;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../enums/webhook_event_type.dart' as _ih562tcf;

/// A webhook receiver registered by the brand. Payloads are signed with an
/// HMAC-SHA256 secret that is stored encrypted with AES-256-GCM and bound to
/// the workspace and endpoint.
abstract class WebhookEndpoint
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WebhookEndpoint._({
    this.id,
    required this.workspaceId,
    required this.url,
    this.description,
    required this.subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    this.secretRotatedAt,
    this.deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : enabled = enabled ?? true,
       consecutiveFailures = consecutiveFailures ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory WebhookEndpoint({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String url,
    String? description,
    required List<_ih562tcf.WebhookEventType> subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    DateTime? secretRotatedAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WebhookEndpointImpl;

  factory WebhookEndpoint.fromJson(Map<String, dynamic> jsonSerialization) {
    return WebhookEndpoint(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      url: jsonSerialization['url'] as String,
      description: jsonSerialization['description'] as String?,
      subscribedEvents: _iuzkm0gn.Protocol()
          .deserialize<List<_ih562tcf.WebhookEventType>>(
            jsonSerialization['subscribedEvents'],
          ),
      enabled: jsonSerialization['enabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      consecutiveFailures: jsonSerialization['consecutiveFailures'] as int?,
      secretRotatedAt: jsonSerialization['secretRotatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['secretRotatedAt'],
            ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  String url;

  String? description;

  List<_ih562tcf.WebhookEventType> subscribedEvents;

  bool enabled;

  int consecutiveFailures;

  DateTime? secretRotatedAt;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [WebhookEndpoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WebhookEndpoint copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    String? url,
    String? description,
    List<_ih562tcf.WebhookEventType>? subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    DateTime? secretRotatedAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WebhookEndpoint',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'url': url,
      if (description != null) 'description': description,
      'subscribedEvents': subscribedEvents.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'enabled': enabled,
      'consecutiveFailures': consecutiveFailures,
      if (secretRotatedAt != null) 'secretRotatedAt': secretRotatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WebhookEndpoint',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'url': url,
      if (description != null) 'description': description,
      'subscribedEvents': subscribedEvents.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'enabled': enabled,
      'consecutiveFailures': consecutiveFailures,
      if (secretRotatedAt != null) 'secretRotatedAt': secretRotatedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WebhookEndpointImpl extends WebhookEndpoint {
  _WebhookEndpointImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String url,
    String? description,
    required List<_ih562tcf.WebhookEventType> subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    DateTime? secretRotatedAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         url: url,
         description: description,
         subscribedEvents: subscribedEvents,
         enabled: enabled,
         consecutiveFailures: consecutiveFailures,
         secretRotatedAt: secretRotatedAt,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [WebhookEndpoint]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WebhookEndpoint copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    String? url,
    Object? description = _Undefined,
    List<_ih562tcf.WebhookEventType>? subscribedEvents,
    bool? enabled,
    int? consecutiveFailures,
    Object? secretRotatedAt = _Undefined,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WebhookEndpoint(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      url: url ?? this.url,
      description: description is String? ? description : this.description,
      subscribedEvents:
          subscribedEvents ?? this.subscribedEvents.map((e0) => e0).toList(),
      enabled: enabled ?? this.enabled,
      consecutiveFailures: consecutiveFailures ?? this.consecutiveFailures,
      secretRotatedAt: secretRotatedAt is DateTime?
          ? secretRotatedAt
          : this.secretRotatedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
