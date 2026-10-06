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
import '../enums/notification_type.dart' as _izfnm04l;

/// In-app notification delivered to one workspace member. New notifications are
/// also pushed over the live stream for instant display in the app.
abstract class Notification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Notification._({
    this.id,
    required this.workspaceId,
    required this.userIdentifier,
    required this.type,
    required this.title,
    required this.body,
    this.targetType,
    this.targetId,
    bool? read,
    DateTime? createdAt,
  }) : read = read ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory Notification({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String userIdentifier,
    required _izfnm04l.NotificationType type,
    required String title,
    required String body,
    String? targetType,
    _isc.UuidValue? targetId,
    bool? read,
    DateTime? createdAt,
  }) = _NotificationImpl;

  factory Notification.fromJson(Map<String, dynamic> jsonSerialization) {
    return Notification(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      type: _izfnm04l.NotificationType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      targetType: jsonSerialization['targetType'] as String?,
      targetId: jsonSerialization['targetId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['targetId']),
      read: jsonSerialization['read'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['read']),
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

  /// Auth user identifier of the recipient.
  String userIdentifier;

  _izfnm04l.NotificationType type;

  String title;

  String body;

  String? targetType;

  _isc.UuidValue? targetId;

  bool read;

  DateTime createdAt;

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Notification copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    String? userIdentifier,
    _izfnm04l.NotificationType? type,
    String? title,
    String? body,
    String? targetType,
    _isc.UuidValue? targetId,
    bool? read,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Notification',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'type': type.toJson(),
      'title': title,
      'body': body,
      if (targetType != null) 'targetType': targetType,
      if (targetId != null) 'targetId': targetId?.toJson(),
      'read': read,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Notification',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'type': type.toJson(),
      'title': title,
      'body': body,
      if (targetType != null) 'targetType': targetType,
      if (targetId != null) 'targetId': targetId?.toJson(),
      'read': read,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationImpl extends Notification {
  _NotificationImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String userIdentifier,
    required _izfnm04l.NotificationType type,
    required String title,
    required String body,
    String? targetType,
    _isc.UuidValue? targetId,
    bool? read,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         userIdentifier: userIdentifier,
         type: type,
         title: title,
         body: body,
         targetType: targetType,
         targetId: targetId,
         read: read,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Notification copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    String? userIdentifier,
    _izfnm04l.NotificationType? type,
    String? title,
    String? body,
    Object? targetType = _Undefined,
    Object? targetId = _Undefined,
    bool? read,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      targetType: targetType is String? ? targetType : this.targetType,
      targetId: targetId is _isc.UuidValue? ? targetId : this.targetId,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
