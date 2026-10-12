import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Workspace lifecycle and team management.
///
/// Every operator call resolves the workspace server side from the
/// authenticated user's membership; a client supplied workspace id is only
/// ever used as a hint and is verified against that membership.
class WorkspaceEndpoint extends Endpoint {
  /// Resolves the signed-in operator's workspace.
  ///
  /// Returns null when the user has not joined or created a workspace yet, so
  /// the app can show onboarding instead of an error.
  Future<WorkspaceBootstrap?> bootstrap(
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

    WorkspaceMember? member;
    if (workspaceId != null) {
      member = await WorkspaceMember.db.findFirstRow(
        session,
        where: (t) =>
            t.workspaceId.equals(workspaceId) &
            t.userIdentifier.equals(userIdentifier),
      );
    } else {
      member = await WorkspaceMember.db.findFirstRow(
        session,
        where: (t) => t.userIdentifier.equals(userIdentifier),
        orderBy: (t) => t.createdAt,
      );
    }
    if (member == null) return null;

    final workspace = await WorkspaceResolver.resolve(
      session,
      member.workspaceId,
    );
    return _bootstrap(workspace, member);
  }

  /// Creates a workspace owned by the signed-in operator.
  Future<WorkspaceBootstrap> create(
    Session session,
    String name, {
    String? email,
    String? authenticMessage,
    Branding? branding,
  }) async {
    final context = await WorkspaceService.create(
      session,
      name: name,
      email: email,
      branding: branding,
      authenticMessage: authenticMessage,
    );
    // Machine keys are rejected by `WorkspaceService.create`, so a caller that
    // creates a workspace always brings a membership with it.
    return _bootstrap(context.workspace, context.member!);
  }

  /// Joins the public demo workspace.
  ///
  /// Demo workspaces are explicitly marked `demoMode` and can be reset at any
  /// time, which is what makes them safe to open up. Joining grants the owner
  /// role so every feature is testable.
  Future<WorkspaceBootstrap> joinDemo(
    Session session, {
    String? email,
    String? displayName,
  }) async {
    final userIdentifier = session.authenticated?.userIdentifier;
    if (userIdentifier == null) {
      throw AuthenticationException(
        message: 'Sign in to join the demo.',
        reason: 'notAuthenticated',
      );
    }

    final workspace = await Workspace.db.findFirstRow(
      session,
      where: (t) => t.demoMode.equals(true),
      orderBy: (t) => t.createdAt,
    );
    if (workspace == null) {
      throw NotFoundException(
        message: 'The demo workspace is not available yet.',
        resource: 'workspace',
      );
    }

    var member = await WorkspaceMember.db.findFirstRow(
      session,
      where: (t) =>
          t.workspaceId.equals(workspace.id!) &
          t.userIdentifier.equals(userIdentifier),
    );
    member ??= await WorkspaceMember.db.insertRow(
      session,
      WorkspaceMember(
        workspaceId: workspace.id!,
        userIdentifier: userIdentifier,
        email:
            email?.trim().toLowerCase() ??
            '$userIdentifier@demo.fauxshield.local',
        displayName: displayName,
        role: MembershipRole.owner,
      ),
    );
    return _bootstrap(workspace, member);
  }

  /// Updates workspace settings. Requires the `workspaceWrite` permission.
  Future<Workspace> update(
    Session session, {
    UuidValue? workspaceId,
    String? name,
    Branding? branding,
    String? authenticMessage,
    List<String>? restrictedCountries,
    FraudPolicy? fraudPolicy,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    return WorkspaceService.update(
      session,
      context: context,
      name: name,
      branding: branding,
      authenticMessage: authenticMessage,
      restrictedCountries: restrictedCountries,
      fraudPolicy: fraudPolicy,
    );
  }

  /// Lists workspace members.
  Future<List<WorkspaceMember>> members(
    Session session, {
    UuidValue? workspaceId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    return WorkspaceService.members(session, context);
  }

  /// Lists pending invitations.
  Future<List<Invitation>> invitations(
    Session session, {
    UuidValue? workspaceId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.teamRead);
    return Invitation.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(context.workspaceId) &
          t.status.equals(InvitationStatus.pending),
      orderBy: (t) => t.createdAt.desc(),
      limit: 100,
    );
  }

  /// Invites a teammate. The code is returned once and stored hashed.
  Future<InvitationCreated> invite(
    Session session, {
    UuidValue? workspaceId,
    required String email,
    MembershipRole role = MembershipRole.member,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    final result = await WorkspaceService.invite(
      session,
      context: context,
      email: email,
      role: role,
    );
    return InvitationCreated(
      invitation: result.invitation,
      code: result.code,
      warning: 'Share this code once. Only its hash is stored.',
    );
  }

  /// Redeems an invite code and joins the workspace.
  Future<WorkspaceBootstrap> acceptInvitation(
    Session session,
    String code, {
    String? displayName,
  }) async {
    final context = await WorkspaceService.acceptInvitation(
      session,
      code: code,
      displayName: displayName,
    );
    // As above: accepting an invitation always creates a membership, and API
    // keys cannot accept one.
    return _bootstrap(context.workspace, context.member!);
  }

  /// Changes a member's role. Requires the `teamWrite` permission.
  Future<WorkspaceMember> changeRole(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue memberId,
    required MembershipRole role,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    return WorkspaceService.changeRole(
      session,
      context: context,
      memberId: memberId,
      role: role,
    );
  }

  /// Removes a member. Owners must transfer ownership first.
  Future<void> removeMember(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue memberId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    await WorkspaceService.removeMember(
      session,
      context: context,
      memberId: memberId,
    );
  }

  WorkspaceBootstrap _bootstrap(Workspace workspace, WorkspaceMember member) =>
      bootstrapFor(workspace, member);
}
