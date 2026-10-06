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
import '../enums/membership_role.dart' as _icl0wo19;

/// Links an authenticated user to a workspace with a role. Authorization for
/// every operator endpoint is derived from this record.
abstract class WorkspaceMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WorkspaceMember._({
    this.id,
    required this.workspaceId,
    required this.userIdentifier,
    required this.email,
    this.displayName,
    _icl0wo19.MembershipRole? role,
    this.notificationEmail,
    DateTime? createdAt,
  }) : role = role ?? _icl0wo19.MembershipRole.member,
       createdAt = createdAt ?? DateTime.now();

  factory WorkspaceMember({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String userIdentifier,
    required String email,
    String? displayName,
    _icl0wo19.MembershipRole? role,
    String? notificationEmail,
    DateTime? createdAt,
  }) = _WorkspaceMemberImpl;

  factory WorkspaceMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceMember(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      email: jsonSerialization['email'] as String,
      displayName: jsonSerialization['displayName'] as String?,
      role: jsonSerialization['role'] == null
          ? null
          : _icl0wo19.MembershipRole.fromJson(
              (jsonSerialization['role'] as String),
            ),
      notificationEmail: jsonSerialization['notificationEmail'] as String?,
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

  /// The serverpod auth user identifier. Never trust a client supplied value.
  String userIdentifier;

  String email;

  String? displayName;

  _icl0wo19.MembershipRole role;

  /// Optional notification email when it differs from the sign-in email.
  String? notificationEmail;

  DateTime createdAt;

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WorkspaceMember copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    String? userIdentifier,
    String? email,
    String? displayName,
    _icl0wo19.MembershipRole? role,
    String? notificationEmail,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkspaceMember',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'email': email,
      if (displayName != null) 'displayName': displayName,
      'role': role.toJson(),
      if (notificationEmail != null) 'notificationEmail': notificationEmail,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkspaceMember',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'email': email,
      if (displayName != null) 'displayName': displayName,
      'role': role.toJson(),
      if (notificationEmail != null) 'notificationEmail': notificationEmail,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceMemberImpl extends WorkspaceMember {
  _WorkspaceMemberImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String userIdentifier,
    required String email,
    String? displayName,
    _icl0wo19.MembershipRole? role,
    String? notificationEmail,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         userIdentifier: userIdentifier,
         email: email,
         displayName: displayName,
         role: role,
         notificationEmail: notificationEmail,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WorkspaceMember copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    String? userIdentifier,
    String? email,
    Object? displayName = _Undefined,
    _icl0wo19.MembershipRole? role,
    Object? notificationEmail = _Undefined,
    DateTime? createdAt,
  }) {
    return WorkspaceMember(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      email: email ?? this.email,
      displayName: displayName is String? ? displayName : this.displayName,
      role: role ?? this.role,
      notificationEmail: notificationEmail is String?
          ? notificationEmail
          : this.notificationEmail,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
