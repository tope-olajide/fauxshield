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
import '../enums/actor_type.dart' as _iau4lzx2;

/// Append-only audit event. Every significant operator, machine, and consumer
/// action is recorded with its actor so changes can be traced back.
abstract class AuditEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AuditEvent._({
    this.id,
    required this.workspaceId,
    _iau4lzx2.ActorType? actorType,
    this.actorIdentifier,
    this.apiKeyId,
    required this.action,
    required this.targetType,
    this.targetId,
    this.metadataJson,
    this.ipAddress,
    DateTime? createdAt,
  }) : actorType = actorType ?? _iau4lzx2.ActorType.system,
       createdAt = createdAt ?? DateTime.now();

  factory AuditEvent({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    _iau4lzx2.ActorType? actorType,
    String? actorIdentifier,
    _isc.UuidValue? apiKeyId,
    required String action,
    required String targetType,
    _isc.UuidValue? targetId,
    String? metadataJson,
    String? ipAddress,
    DateTime? createdAt,
  }) = _AuditEventImpl;

  factory AuditEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditEvent(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      actorType: jsonSerialization['actorType'] == null
          ? null
          : _iau4lzx2.ActorType.fromJson(
              (jsonSerialization['actorType'] as String),
            ),
      actorIdentifier: jsonSerialization['actorIdentifier'] as String?,
      apiKeyId: jsonSerialization['apiKeyId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['apiKeyId']),
      action: jsonSerialization['action'] as String,
      targetType: jsonSerialization['targetType'] as String,
      targetId: jsonSerialization['targetId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['targetId']),
      metadataJson: jsonSerialization['metadataJson'] as String?,
      ipAddress: jsonSerialization['ipAddress'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  _isc.UuidValue workspaceId;

  _iau4lzx2.ActorType actorType;

  /// Auth user identifier, api key id, or system component name.
  String? actorIdentifier;

  _isc.UuidValue? apiKeyId;

  /// Dotted action name such as identity.generated or alert.resolved.
  String action;

  String targetType;

  _isc.UuidValue? targetId;

  /// Structured context serialized as JSON.
  String? metadataJson;

  String? ipAddress;

  DateTime createdAt;

  /// Returns a shallow copy of this [AuditEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AuditEvent copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    _iau4lzx2.ActorType? actorType,
    String? actorIdentifier,
    _isc.UuidValue? apiKeyId,
    String? action,
    String? targetType,
    _isc.UuidValue? targetId,
    String? metadataJson,
    String? ipAddress,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditEvent',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'actorType': actorType.toJson(),
      if (actorIdentifier != null) 'actorIdentifier': actorIdentifier,
      if (apiKeyId != null) 'apiKeyId': apiKeyId?.toJson(),
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId?.toJson(),
      if (metadataJson != null) 'metadataJson': metadataJson,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditEvent',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'actorType': actorType.toJson(),
      if (actorIdentifier != null) 'actorIdentifier': actorIdentifier,
      if (apiKeyId != null) 'apiKeyId': apiKeyId?.toJson(),
      'action': action,
      'targetType': targetType,
      if (targetId != null) 'targetId': targetId?.toJson(),
      if (metadataJson != null) 'metadataJson': metadataJson,
      if (ipAddress != null) 'ipAddress': ipAddress,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditEventImpl extends AuditEvent {
  _AuditEventImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    _iau4lzx2.ActorType? actorType,
    String? actorIdentifier,
    _isc.UuidValue? apiKeyId,
    required String action,
    required String targetType,
    _isc.UuidValue? targetId,
    String? metadataJson,
    String? ipAddress,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         actorType: actorType,
         actorIdentifier: actorIdentifier,
         apiKeyId: apiKeyId,
         action: action,
         targetType: targetType,
         targetId: targetId,
         metadataJson: metadataJson,
         ipAddress: ipAddress,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuditEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AuditEvent copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    _iau4lzx2.ActorType? actorType,
    Object? actorIdentifier = _Undefined,
    Object? apiKeyId = _Undefined,
    String? action,
    String? targetType,
    Object? targetId = _Undefined,
    Object? metadataJson = _Undefined,
    Object? ipAddress = _Undefined,
    DateTime? createdAt,
  }) {
    return AuditEvent(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      actorType: actorType ?? this.actorType,
      actorIdentifier: actorIdentifier is String?
          ? actorIdentifier
          : this.actorIdentifier,
      apiKeyId: apiKeyId is _isc.UuidValue? ? apiKeyId : this.apiKeyId,
      action: action ?? this.action,
      targetType: targetType ?? this.targetType,
      targetId: targetId is _isc.UuidValue? ? targetId : this.targetId,
      metadataJson: metadataJson is String? ? metadataJson : this.metadataJson,
      ipAddress: ipAddress is String? ? ipAddress : this.ipAddress,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
