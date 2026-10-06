import '../generated/protocol.dart';

/// Capabilities that can be granted to workspace roles.
enum Permission {
  workspaceRead,
  workspaceWrite,
  teamRead,
  teamWrite,
  productsRead,
  productsWrite,
  batchesRead,
  batchesWrite,
  identitiesRead,
  identitiesGenerate,
  identitiesExport,
  identitiesRevealPin,
  verificationsRead,
  fraudRead,
  fraudWrite,
  simulationsRun,
  auditRead,
  analyticsRead,
  webhooksRead,
  webhooksWrite,
  apiKeysRead,
  apiKeysWrite,
}

const Set<Permission> _readOnly = <Permission>{
  Permission.workspaceRead,
  Permission.teamRead,
  Permission.productsRead,
  Permission.batchesRead,
  Permission.identitiesRead,
  Permission.verificationsRead,
  Permission.fraudRead,
  Permission.auditRead,
  Permission.analyticsRead,
  Permission.webhooksRead,
  Permission.apiKeysRead,
};

const Set<Permission> _member = <Permission>{
  ..._readOnly,
  Permission.productsWrite,
  Permission.batchesWrite,
  Permission.identitiesGenerate,
  Permission.identitiesExport,
  Permission.fraudWrite,
  Permission.simulationsRun,
};

const Set<Permission> _admin = <Permission>{
  ..._member,
  Permission.workspaceWrite,
  Permission.teamWrite,
  Permission.webhooksWrite,
  Permission.apiKeysWrite,
};

/// Role permission matrix.
///
/// * Viewer: read everything, change nothing.
/// * Member: operate products, batches, identities, and fraud response.
/// * Admin: member capabilities plus workspace settings, team, webhooks, keys.
/// * Owner: admin capabilities plus destructive identity operations.
const Map<MembershipRole, Set<Permission>> rolePermissions =
    <MembershipRole, Set<Permission>>{
      MembershipRole.viewer: _readOnly,
      MembershipRole.member: _member,
      MembershipRole.admin: _admin,
      MembershipRole.owner: <Permission>{
        ..._admin,
        Permission.identitiesRevealPin,
      },
    };

bool hasPermission(MembershipRole role, Permission permission) =>
    rolePermissions[role]?.contains(permission) ?? false;

/// Human readable description of a role for the team screen.
String roleLabel(MembershipRole role) {
  switch (role) {
    case MembershipRole.owner:
      return 'Owner';
    case MembershipRole.admin:
      return 'Admin';
    case MembershipRole.member:
      return 'Member';
    case MembershipRole.viewer:
      return 'Viewer';
  }
}
