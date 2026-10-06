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
import '../enums/alert_severity.dart' as _ivfuu0vh;
import '../enums/notification_channel.dart' as _ico4u50j;

/// Per-member preference for one notification channel.
abstract class NotificationPreference
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NotificationPreference._({
    this.id,
    required this.workspaceId,
    required this.userIdentifier,
    required this.channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    this.email,
    DateTime? updatedAt,
  }) : enabled = enabled ?? true,
       minSeverity = minSeverity ?? _ivfuu0vh.AlertSeverity.low,
       updatedAt = updatedAt ?? DateTime.now();

  factory NotificationPreference({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String userIdentifier,
    required _ico4u50j.NotificationChannel channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    String? email,
    DateTime? updatedAt,
  }) = _NotificationPreferenceImpl;

  factory NotificationPreference.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreference(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      channel: _ico4u50j.NotificationChannel.fromJson(
        (jsonSerialization['channel'] as String),
      ),
      enabled: jsonSerialization['enabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['enabled']),
      minSeverity: jsonSerialization['minSeverity'] == null
          ? null
          : _ivfuu0vh.AlertSeverity.fromJson(
              (jsonSerialization['minSeverity'] as String),
            ),
      email: jsonSerialization['email'] as String?,
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

  String userIdentifier;

  _ico4u50j.NotificationChannel channel;

  bool enabled;

  /// Only notify for alerts at or above this severity.
  _ivfuu0vh.AlertSeverity minSeverity;

  String? email;

  DateTime updatedAt;

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NotificationPreference copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    String? userIdentifier,
    _ico4u50j.NotificationChannel? channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    String? email,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreference',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'channel': channel.toJson(),
      'enabled': enabled,
      'minSeverity': minSeverity.toJson(),
      if (email != null) 'email': email,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NotificationPreference',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'channel': channel.toJson(),
      'enabled': enabled,
      'minSeverity': minSeverity.toJson(),
      if (email != null) 'email': email,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationPreferenceImpl extends NotificationPreference {
  _NotificationPreferenceImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String userIdentifier,
    required _ico4u50j.NotificationChannel channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    String? email,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         userIdentifier: userIdentifier,
         channel: channel,
         enabled: enabled,
         minSeverity: minSeverity,
         email: email,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NotificationPreference copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    String? userIdentifier,
    _ico4u50j.NotificationChannel? channel,
    bool? enabled,
    _ivfuu0vh.AlertSeverity? minSeverity,
    Object? email = _Undefined,
    DateTime? updatedAt,
  }) {
    return NotificationPreference(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      channel: channel ?? this.channel,
      enabled: enabled ?? this.enabled,
      minSeverity: minSeverity ?? this.minSeverity,
      email: email is String? ? email : this.email,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
