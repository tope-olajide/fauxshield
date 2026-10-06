import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/demo_seeder.dart';
import '../services/platform_keys.dart';
import '../services/workspace_service.dart';

/// One click demo access.
///
/// The first caller creates the public demo workspace; everyone after that
/// joins it. Passing the configured `demoSeedSecret` resets the demo data,
/// which keeps review environments clean without letting visitors wipe the
/// workspace they are browsing.
class DemoEndpoint extends Endpoint {
  /// Seeds (when missing) or joins the public demo workspace.
  Future<WorkspaceBootstrap> seed(
    Session session, {
    String? email,
    String? displayName,
    String? secret,
  }) async {
    final userIdentifier = session.authenticated?.userIdentifier;
    if (userIdentifier == null) {
      throw AuthenticationException(
        message: 'Sign in to open the demo workspace.',
        reason: 'notAuthenticated',
      );
    }

    final existing = await Workspace.db.findFirstRow(
      session,
      where: (t) => t.demoMode.equals(true),
      orderBy: (t) => t.createdAt,
    );
    final configuredSecret = PlatformKeys.optional(
      session,
      PlatformSecretNames.demoSeedSecret,
    );
    final seeder = DemoSeeder();

    final Workspace workspace;
    if (existing == null) {
      workspace = await seeder.create(
        session,
        actorIdentifier: userIdentifier,
      );
    } else if (configuredSecret != null &&
        configuredSecret.isNotEmpty &&
        secret == configuredSecret) {
      workspace = await seeder.reset(
        session,
        workspace: existing,
        actorIdentifier: userIdentifier,
      );
    } else {
      workspace = existing;
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
    return bootstrapFor(workspace, member);
  }

  /// Whether a demo workspace already exists.
  Future<bool> isSeeded(Session session) async {
    final existing = await Workspace.db.findFirstRow(
      session,
      where: (t) => t.demoMode.equals(true),
      orderBy: (t) => t.createdAt,
    );
    return existing != null;
  }
}
