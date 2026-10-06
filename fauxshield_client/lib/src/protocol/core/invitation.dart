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
import '../enums/invitation_status.dart' as _imshd44a;
import '../enums/membership_role.dart' as _icl0wo19;

/// An invitation for a new teammate. The invite code is shared out of band and
/// redeemed inside the app after signing in.
abstract class Invitation
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Invitation._({
    this.id,
    required this.workspaceId,
    required this.email,
    _icl0wo19.MembershipRole? role,
    required this.codePrefix,
    _imshd44a.InvitationStatus? status,
    required this.invitedBy,
    required this.expiresAt,
    this.acceptedAt,
    this.acceptedBy,
    DateTime? createdAt,
  }) : role = role ?? _icl0wo19.MembershipRole.member,
       status = status ?? _imshd44a.InvitationStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory Invitation({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String email,
    _icl0wo19.MembershipRole? role,
    required String codePrefix,
    _imshd44a.InvitationStatus? status,
    required String invitedBy,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    String? acceptedBy,
    DateTime? createdAt,
  }) = _InvitationImpl;

  factory Invitation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Invitation(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      email: jsonSerialization['email'] as String,
      role: jsonSerialization['role'] == null
          ? null
          : _icl0wo19.MembershipRole.fromJson(
              (jsonSerialization['role'] as String),
            ),
      codePrefix: jsonSerialization['codePrefix'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _imshd44a.InvitationStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      invitedBy: jsonSerialization['invitedBy'] as String,
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['acceptedAt'],
            ),
      acceptedBy: jsonSerialization['acceptedBy'] as String?,
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

  String email;

  _icl0wo19.MembershipRole role;

  String codePrefix;

  _imshd44a.InvitationStatus status;

  String invitedBy;

  DateTime expiresAt;

  DateTime? acceptedAt;

  String? acceptedBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [Invitation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Invitation copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    String? email,
    _icl0wo19.MembershipRole? role,
    String? codePrefix,
    _imshd44a.InvitationStatus? status,
    String? invitedBy,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    String? acceptedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Invitation',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'email': email,
      'role': role.toJson(),
      'codePrefix': codePrefix,
      'status': status.toJson(),
      'invitedBy': invitedBy,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (acceptedBy != null) 'acceptedBy': acceptedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Invitation',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'email': email,
      'role': role.toJson(),
      'codePrefix': codePrefix,
      'status': status.toJson(),
      'invitedBy': invitedBy,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (acceptedBy != null) 'acceptedBy': acceptedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InvitationImpl extends Invitation {
  _InvitationImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String email,
    _icl0wo19.MembershipRole? role,
    required String codePrefix,
    _imshd44a.InvitationStatus? status,
    required String invitedBy,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    String? acceptedBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         email: email,
         role: role,
         codePrefix: codePrefix,
         status: status,
         invitedBy: invitedBy,
         expiresAt: expiresAt,
         acceptedAt: acceptedAt,
         acceptedBy: acceptedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Invitation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Invitation copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    String? email,
    _icl0wo19.MembershipRole? role,
    String? codePrefix,
    _imshd44a.InvitationStatus? status,
    String? invitedBy,
    DateTime? expiresAt,
    Object? acceptedAt = _Undefined,
    Object? acceptedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return Invitation(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      email: email ?? this.email,
      role: role ?? this.role,
      codePrefix: codePrefix ?? this.codePrefix,
      status: status ?? this.status,
      invitedBy: invitedBy ?? this.invitedBy,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
      acceptedBy: acceptedBy is String? ? acceptedBy : this.acceptedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
