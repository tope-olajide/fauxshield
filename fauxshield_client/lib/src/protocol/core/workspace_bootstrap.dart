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
import '../core/workspace.dart' as _iuh1gqpp;
import '../core/workspace_member.dart' as _iheboqfe;
import '../enums/membership_role.dart' as _icl0wo19;

/// Everything the app needs right after sign-in: the resolved workspace, the
/// member record, the role, capability names for UI gating, and whether this
/// is the public demo workspace.
abstract class WorkspaceBootstrap
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WorkspaceBootstrap._({
    required this.workspace,
    required this.member,
    required this.role,
    required this.permissions,
    required this.isDemo,
  });

  factory WorkspaceBootstrap({
    required _iuh1gqpp.Workspace workspace,
    required _iheboqfe.WorkspaceMember member,
    required _icl0wo19.MembershipRole role,
    required List<String> permissions,
    required bool isDemo,
  }) = _WorkspaceBootstrapImpl;

  factory WorkspaceBootstrap.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceBootstrap(
      workspace: _iuzkm0gn.Protocol().deserialize<_iuh1gqpp.Workspace>(
        jsonSerialization['workspace'],
      ),
      member: _iuzkm0gn.Protocol().deserialize<_iheboqfe.WorkspaceMember>(
        jsonSerialization['member'],
      ),
      role: _icl0wo19.MembershipRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      permissions: _iuzkm0gn.Protocol().deserialize<List<String>>(
        jsonSerialization['permissions'],
      ),
      isDemo: _isc.BoolJsonExtension.fromJson(jsonSerialization['isDemo']),
    );
  }

  _iuh1gqpp.Workspace workspace;

  _iheboqfe.WorkspaceMember member;

  _icl0wo19.MembershipRole role;

  /// Permission names the role holds, used to gate UI actions.
  List<String> permissions;

  bool isDemo;

  /// Returns a shallow copy of this [WorkspaceBootstrap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WorkspaceBootstrap copyWith({
    _iuh1gqpp.Workspace? workspace,
    _iheboqfe.WorkspaceMember? member,
    _icl0wo19.MembershipRole? role,
    List<String>? permissions,
    bool? isDemo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkspaceBootstrap',
      'workspace': workspace.toJson(),
      'member': member.toJson(),
      'role': role.toJson(),
      'permissions': permissions.toJson(),
      'isDemo': isDemo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkspaceBootstrap',
      'workspace': workspace.toJsonForProtocol(),
      'member': member.toJsonForProtocol(),
      'role': role.toJson(),
      'permissions': permissions.toJson(),
      'isDemo': isDemo,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _WorkspaceBootstrapImpl extends WorkspaceBootstrap {
  _WorkspaceBootstrapImpl({
    required _iuh1gqpp.Workspace workspace,
    required _iheboqfe.WorkspaceMember member,
    required _icl0wo19.MembershipRole role,
    required List<String> permissions,
    required bool isDemo,
  }) : super._(
         workspace: workspace,
         member: member,
         role: role,
         permissions: permissions,
         isDemo: isDemo,
       );

  /// Returns a shallow copy of this [WorkspaceBootstrap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WorkspaceBootstrap copyWith({
    _iuh1gqpp.Workspace? workspace,
    _iheboqfe.WorkspaceMember? member,
    _icl0wo19.MembershipRole? role,
    List<String>? permissions,
    bool? isDemo,
  }) {
    return WorkspaceBootstrap(
      workspace: workspace ?? this.workspace.copyWith(),
      member: member ?? this.member.copyWith(),
      role: role ?? this.role,
      permissions: permissions ?? this.permissions.map((e0) => e0).toList(),
      isDemo: isDemo ?? this.isDemo,
    );
  }
}
