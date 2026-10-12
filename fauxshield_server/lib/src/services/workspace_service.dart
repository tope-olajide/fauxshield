import 'package:serverpod/serverpod.dart';

import '../core/identity_crypto.dart';
import '../generated/protocol.dart';
import 'api_key_auth.dart';
import 'api_key_service.dart';
import 'audit_service.dart';
import 'rbac.dart';

/// Resolves workspaces by id.
abstract final class WorkspaceResolver {
  /// Loads a workspace or throws a typed not-found failure.
  static Future<Workspace> resolve(
    Session session,
    UuidValue workspaceId,
  ) async {
    final workspace = await Workspace.db.findById(session, workspaceId);
    if (workspace == null) {
      throw NotFoundException(
        message: 'Workspace not found.',
        resource: 'workspace',
      );
    }
    return workspace;
  }

  /// Loads a workspace by its URL slug.
  static Future<Workspace?> bySlug(Session session, String slug) {
    return Workspace.db.findFirstRow(
      session,
      where: (t) => t.slug.equals(slug.trim().toLowerCase()),
    );
  }
}

/// The authenticated caller's identity inside one workspace.
///
/// A caller is either an operator with a membership record, or a machine key
/// bound to the workspace. Both resolve to the same kind of context so every
/// endpoint keeps one authorization gate; only the source of [permissions]
/// differs (role matrix versus key scopes).
class WorkspaceContext {
  const WorkspaceContext({
    required this.workspace,
    required this.permissions,
    this.member,
    this.apiKey,
  });

  final Workspace workspace;

  /// Everything the caller may do in [workspace].
  final Set<Permission> permissions;

  /// The membership this context came from. Null for a machine key.
  final WorkspaceMember? member;

  /// The key that authenticated this request. Null for a signed-in operator.
  final ApiKey? apiKey;

  UuidValue get workspaceId => workspace.id!;

  /// The identity recorded in audit records and `createdBy` columns.
  String get userIdentifier => apiKey != null
      ? apiKeyIdentifier(apiKey!.id!)
      : member!.userIdentifier;

  /// The role for an operator, null for a machine key.
  MembershipRole? get role => member?.role;

  /// Whether the caller is a machine key rather than a person.
  bool get isMachine => apiKey != null;

  bool can(Permission permission) => permissions.contains(permission);
}

/// Builds the app bootstrap payload for a workspace and member.
WorkspaceBootstrap bootstrapFor(Workspace workspace, WorkspaceMember member) {
  final permissions = rolePermissions[member.role] ?? const <Permission>{};
  return WorkspaceBootstrap(
    workspace: workspace,
    member: member,
    role: member.role,
    permissions: permissions
        .map((permission) => permission.name)
        .toList(growable: false),
    isDemo: workspace.demoMode,
  );
}

/// Workspace lifecycle, team management, and the authorization gate used by
/// every operator endpoint.
///
/// Authorization is always derived server side from the authenticated user's
/// membership record. A client supplied workspace id is verified against that
/// membership, never trusted on its own.
abstract final class WorkspaceService {
  /// Resolves the workspace the caller belongs to.
  ///
  /// When [workspaceId] is supplied it must match a membership for the
  /// authenticated user, or the key's own workspace. Otherwise the operator's
  /// first workspace is used.
  static Future<WorkspaceContext> contextFor(
    Session session, {
    UuidValue? workspaceId,
  }) async {
    final userIdentifier = session.authenticated?.userIdentifier;
    if (userIdentifier == null) {
      throw AuthenticationException(
        message: 'Sign in to continue.',
        reason: 'notAuthenticated',
      );
    }
    if (isApiKeyIdentifier(userIdentifier)) {
      return _apiKeyContext(session, userIdentifier, workspaceId: workspaceId);
    }

    WorkspaceMember? member;
    if (workspaceId != null) {
      member = await WorkspaceMember.db.findFirstRow(
        session,
        where: (t) =>
            t.workspaceId.equals(workspaceId) &
            t.userIdentifier.equals(userIdentifier),
      );
      if (member == null) {
        throw AuthenticationException(
          message: 'You do not have access to this workspace.',
          reason: 'forbidden',
        );
      }
    } else {
      member = await WorkspaceMember.db.findFirstRow(
        session,
        where: (t) => t.userIdentifier.equals(userIdentifier),
        orderBy: (t) => t.createdAt,
      );
      if (member == null) {
        throw AuthenticationException(
          message: 'No workspace membership found for this account.',
          reason: 'forbidden',
        );
      }
    }

    final workspace = await WorkspaceResolver.resolve(
      session,
      member.workspaceId,
    );
    return WorkspaceContext(
      workspace: workspace,
      member: member,
      permissions: rolePermissions[member.role] ?? const <Permission>{},
    );
  }

  /// Builds the context for a request authenticated with an API key.
  ///
  /// The key carries its own workspace and scope list, so there is no
  /// membership to consult. The key is re-read here: revocation, scope edits,
  /// and the per-key rate limit must all take effect on the next request, not
  /// on the next sign-in.
  static Future<WorkspaceContext> _apiKeyContext(
    Session session,
    String userIdentifier, {
    UuidValue? workspaceId,
  }) async {
    final apiKeyId = apiKeyIdFromIdentifier(userIdentifier);
    final apiKey = apiKeyId == null
        ? null
        : await ApiKey.db.findById(session, apiKeyId);
    if (apiKey == null || apiKey.revoked) {
      throw AuthenticationException(
        message: 'This API key is no longer valid.',
        reason: 'notAuthenticated',
      );
    }
    if (workspaceId != null && apiKey.workspaceId != workspaceId) {
      throw AuthenticationException(
        message: 'You do not have access to this workspace.',
        reason: 'forbidden',
      );
    }
    ApiKeyService.enforceRateLimit(apiKey);
    final workspace = await WorkspaceResolver.resolve(
      session,
      apiKey.workspaceId,
    );
    return WorkspaceContext(
      workspace: workspace,
      apiKey: apiKey,
      permissions: apiKeyPermissions(apiKey.scopes),
    );
  }

  /// Resolves the context and enforces one permission.
  static Future<WorkspaceContext> requirePermission(
    Session session,
    Permission permission, {
    UuidValue? workspaceId,
  }) async {
    final context = await contextFor(session, workspaceId: workspaceId);
    require(context, permission);
    return context;
  }

  /// Enforces one permission on an existing context.
  ///
  /// A machine key is told which scope it is missing, because that is what the
  /// person holding the key can act on.
  static void require(WorkspaceContext context, Permission permission) {
    if (context.can(permission)) return;
    final apiKey = context.apiKey;
    if (apiKey != null) {
      final scope = scopeForPermission(permission);
      throw AuthenticationException(
        message: scope == null
            ? 'This action is reserved for signed in operators, not API keys.'
            : 'The key "${apiKey.label}" is missing the ${scope.name} scope.',
        reason: 'forbidden',
      );
    }
    throw AuthenticationException(
      message:
          'Your role (${roleLabel(context.role!)}) cannot perform this action.',
      reason: 'forbidden',
    );
  }

  /// Creates a workspace and makes the creator its owner.
  static Future<WorkspaceContext> create(
    Session session, {
    required String name,
    String? email,
    Branding? branding,
    String? authenticMessage,
  }) async {
    final userIdentifier = session.authenticated?.userIdentifier;
    if (userIdentifier == null) {
      throw AuthenticationException(
        message: 'Sign in to continue.',
        reason: 'notAuthenticated',
      );
    }
    if (isApiKeyIdentifier(userIdentifier)) {
      throw AuthenticationException(
        message: 'API keys cannot create workspaces.',
        reason: 'forbidden',
      );
    }
    final trimmed = name.trim();
    if (trimmed.length < 2) {
      throw ValidationException(
        message: 'Workspace name must be at least 2 characters.',
        field: 'name',
      );
    }

    final memberEmail =
        email?.trim().toLowerCase() ?? '$userIdentifier@fauxshield.local';
    final now = DateTime.now().toUtc();
    var workspace = Workspace(
      name: trimmed,
      slug: await _uniqueSlug(session, trimmed),
      branding: branding,
      authenticMessage: authenticMessage,
      demoMode: false,
      createdAt: now,
      updatedAt: now,
    );
    workspace = await Workspace.db.insertRow(session, workspace);

    var member = WorkspaceMember(
      workspaceId: workspace.id!,
      userIdentifier: userIdentifier,
      email: memberEmail,
      role: MembershipRole.owner,
      createdAt: now,
    );
    member = await WorkspaceMember.db.insertRow(session, member);

    await AuditService.recordForUser(
      session,
      workspaceId: workspace.id!,
      action: 'workspace.created',
      targetType: 'workspace',
      targetId: workspace.id,
      metadata: <String, dynamic>{
        'name': workspace.name,
        'slug': workspace.slug,
      },
    );

    return WorkspaceContext(
      workspace: workspace,
      member: member,
      permissions:
          rolePermissions[MembershipRole.owner] ?? const <Permission>{},
    );
  }

  /// Updates workspace settings.
  static Future<Workspace> update(
    Session session, {
    required WorkspaceContext context,
    String? name,
    Branding? branding,
    String? authenticMessage,
    List<String>? restrictedCountries,
    FraudPolicy? fraudPolicy,
  }) async {
    require(context, Permission.workspaceWrite);
    final updated = await Workspace.db.updateRow(
      session,
      context.workspace.copyWith(
        name: name?.trim() ?? context.workspace.name,
        branding: branding ?? context.workspace.branding,
        authenticMessage:
            authenticMessage ?? context.workspace.authenticMessage,
        restrictedCountries:
            restrictedCountries ?? context.workspace.restrictedCountries,
        fraudPolicy: fraudPolicy ?? context.workspace.fraudPolicy,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'workspace.updated',
      targetType: 'workspace',
      targetId: context.workspaceId,
      metadata: <String, dynamic>{
        'name': name,
        'restricted_countries': restrictedCountries,
      },
    );
    return updated;
  }

  /// Lists members of the workspace.
  static Future<List<WorkspaceMember>> members(
    Session session,
    WorkspaceContext context,
  ) {
    require(context, Permission.teamRead);
    return WorkspaceMember.db.find(
      session,
      where: (t) => t.workspaceId.equals(context.workspaceId),
      orderBy: (t) => t.createdAt,
    );
  }

  /// Creates a single use invitation. The plaintext code is returned once.
  static Future<({Invitation invitation, String code})> invite(
    Session session, {
    required WorkspaceContext context,
    required String email,
    MembershipRole role = MembershipRole.member,
    Duration validFor = const Duration(days: 7),
  }) async {
    require(context, Permission.teamWrite);
    final normalizedEmail = email.trim().toLowerCase();
    if (!normalizedEmail.contains('@') || normalizedEmail.length < 5) {
      throw ValidationException(
        message: 'Enter a valid email address.',
        field: 'email',
      );
    }

    final code = IdentityCrypto.generateSecret(byteLength: 16);
    final now = DateTime.now().toUtc();
    var invitation = Invitation(
      workspaceId: context.workspaceId,
      email: normalizedEmail,
      role: role,
      codeHash: IdentityCrypto.sha256Hex(code),
      codePrefix: code.substring(0, 6),
      status: InvitationStatus.pending,
      invitedBy: context.userIdentifier,
      expiresAt: now.add(validFor),
      createdAt: now,
    );
    invitation = await Invitation.db.insertRow(session, invitation);

    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'team.invited',
      targetType: 'invitation',
      targetId: invitation.id,
      metadata: <String, dynamic>{'email': normalizedEmail, 'role': role.name},
    );
    return (invitation: invitation, code: code);
  }

  /// Redeems an invitation for the signed-in user.
  static Future<WorkspaceContext> acceptInvitation(
    Session session, {
    required String code,
    String? displayName,
  }) async {
    final userIdentifier = session.authenticated?.userIdentifier;
    if (userIdentifier == null) {
      throw AuthenticationException(
        message: 'Sign in to accept an invitation.',
        reason: 'notAuthenticated',
      );
    }
    if (isApiKeyIdentifier(userIdentifier)) {
      throw AuthenticationException(
        message: 'API keys cannot accept invitations.',
        reason: 'forbidden',
      );
    }

    final hash = IdentityCrypto.sha256Hex(code.trim());
    final invitation = await Invitation.db.findFirstRow(
      session,
      where: (t) => t.codeHash.equals(hash),
    );
    if (invitation == null) {
      throw NotFoundException(
        message: 'Invitation not found.',
        resource: 'invitation',
      );
    }
    if (invitation.status != InvitationStatus.pending) {
      throw ConflictException(
        message: 'This invitation was already ${invitation.status.name}.',
        resource: 'invitation',
      );
    }
    if (invitation.expiresAt.isBefore(DateTime.now().toUtc())) {
      await Invitation.db.updateRow(
        session,
        invitation.copyWith(status: InvitationStatus.expired),
      );
      throw ConflictException(
        message: 'This invitation expired.',
        resource: 'invitation',
      );
    }

    final existing = await WorkspaceMember.db.findFirstRow(
      session,
      where: (t) =>
          t.workspaceId.equals(invitation.workspaceId) &
          t.userIdentifier.equals(userIdentifier),
    );
    if (existing != null) {
      final workspace = await WorkspaceResolver.resolve(
        session,
        invitation.workspaceId,
      );
      return WorkspaceContext(
        workspace: workspace,
        member: existing,
        permissions:
            rolePermissions[existing.role] ?? const <Permission>{},
      );
    }

    final now = DateTime.now().toUtc();
    var member = WorkspaceMember(
      workspaceId: invitation.workspaceId,
      userIdentifier: userIdentifier,
      email: invitation.email,
      displayName: displayName,
      role: invitation.role,
      createdAt: now,
    );
    member = await WorkspaceMember.db.insertRow(session, member);
    await Invitation.db.updateRow(
      session,
      invitation.copyWith(
        status: InvitationStatus.accepted,
        acceptedAt: now,
        acceptedBy: userIdentifier,
      ),
    );

    final workspace = await WorkspaceResolver.resolve(
      session,
      invitation.workspaceId,
    );
    await AuditService.recordForUser(
      session,
      workspaceId: invitation.workspaceId,
      action: 'team.invitation_accepted',
      targetType: 'workspace_member',
      targetId: member.id,
      metadata: <String, dynamic>{'role': invitation.role.name},
    );
    return WorkspaceContext(
      workspace: workspace,
      member: member,
      permissions: rolePermissions[member.role] ?? const <Permission>{},
    );
  }

  /// Changes a teammate's role. Owners cannot demote themselves.
  static Future<WorkspaceMember> changeRole(
    Session session, {
    required WorkspaceContext context,
    required UuidValue memberId,
    required MembershipRole role,
  }) async {
    require(context, Permission.teamWrite);
    final member = await WorkspaceMember.db.findById(session, memberId);
    if (member == null || member.workspaceId != context.workspaceId) {
      throw NotFoundException(message: 'Member not found.', resource: 'member');
    }
    if (member.userIdentifier == context.userIdentifier &&
        role != MembershipRole.owner) {
      throw ConflictException(
        message: 'You cannot remove your own owner role.',
        resource: 'member',
      );
    }
    final updated = await WorkspaceMember.db.updateRow(
      session,
      member.copyWith(role: role),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'team.role_changed',
      targetType: 'workspace_member',
      targetId: memberId,
      metadata: <String, dynamic>{'role': role.name},
    );
    return updated;
  }

  /// Removes a teammate from the workspace.
  static Future<void> removeMember(
    Session session, {
    required WorkspaceContext context,
    required UuidValue memberId,
  }) async {
    require(context, Permission.teamWrite);
    final member = await WorkspaceMember.db.findById(session, memberId);
    if (member == null || member.workspaceId != context.workspaceId) {
      throw NotFoundException(message: 'Member not found.', resource: 'member');
    }
    if (member.role == MembershipRole.owner) {
      throw ConflictException(
        message: 'Transfer ownership before removing an owner.',
        resource: 'member',
      );
    }
    await WorkspaceMember.db.deleteRow(session, member);
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'team.member_removed',
      targetType: 'workspace_member',
      targetId: memberId,
      metadata: <String, dynamic>{'email': member.email},
    );
  }

  static Future<String> _uniqueSlug(Session session, String name) async {
    final base = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final candidate = base.isEmpty ? 'workspace' : base;
    var slug = candidate;
    var suffix = 1;
    while (await WorkspaceResolver.bySlug(session, slug) != null) {
      suffix++;
      slug = '$candidate-$suffix';
    }
    return slug;
  }
}
