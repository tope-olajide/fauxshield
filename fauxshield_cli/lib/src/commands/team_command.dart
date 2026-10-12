import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield team ...`
class TeamCommand extends Command<int> {
  TeamCommand() {
    addSubcommand(TeamMembersCommand());
    addSubcommand(TeamInvitationsCommand());
    addSubcommand(TeamInviteCommand());
    addSubcommand(TeamAcceptCommand());
    addSubcommand(TeamRoleCommand());
    addSubcommand(TeamRemoveCommand());
  }

  @override
  String get name => 'team';

  @override
  String get description => 'Manage who can work in the workspace.';

  @override
  String get invocation =>
      'fauxshield team <members|invitations|invite|accept|role|remove>';
}

/// Lists the people in the workspace.
class TeamMembersCommand extends CliCommand {
  @override
  String get name => 'members';

  @override
  String get description => 'List workspace members and their roles.';

  @override
  Future<int> run() async {
    final context = connect();
    final List<WorkspaceMember> members;
    try {
      members = await context.client.workspace.members();
    } catch (error) {
      throw CliException('Could not list members: ${describeError(error)}');
    }

    if (context.json) {
      printJson(members.map((member) => member.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['EMAIL', 'NAME', 'ROLE', 'JOINED', 'ID'],
      members
          .map(
            (member) => <String>[
              shorten(member.email, max: 30),
              shorten(member.displayName, max: 20),
              member.role.name,
              formatTime(member.createdAt),
              member.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${members.length} member(s).');
    return 0;
  }
}

/// Lists invitations that have not been accepted yet.
class TeamInvitationsCommand extends CliCommand {
  @override
  String get name => 'invitations';

  @override
  String get description => 'List pending invitations.';

  @override
  Future<int> run() async {
    final context = connect();
    final List<Invitation> invitations;
    try {
      invitations = await context.client.workspace.invitations();
    } catch (error) {
      throw CliException('Could not list invitations: ${describeError(error)}');
    }

    if (context.json) {
      printJson(invitations.map((invitation) => invitation.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['EMAIL', 'ROLE', 'STATUS', 'EXPIRES', 'ID'],
      invitations
          .map(
            (invitation) => <String>[
              shorten(invitation.email, max: 30),
              invitation.role.name,
              invitation.status.name,
              formatTime(invitation.expiresAt),
              invitation.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${invitations.length} invitation(s).');
    return 0;
  }
}

/// Invites a teammate and prints the one-time code.
class TeamInviteCommand extends CliCommand {
  TeamInviteCommand() {
    argParser
      ..addOption('email', abbr: 'e', help: 'Teammate email.')
      ..addOption(
        'role',
        abbr: 'r',
        help: 'Role to grant: owner, admin, member, viewer.',
        defaultsTo: 'member',
      );
  }

  @override
  String get name => 'invite';

  @override
  String get description => 'Invite a teammate to the workspace.';

  @override
  Future<int> run() async {
    final email = requiredOption('email');
    final role = parseEnum(
      argResults?['role'] as String? ?? 'member',
      MembershipRole.values,
      '--role',
    );
    final context = connect();
    final InvitationCreated created;
    try {
      created = await context.client.workspace.invite(
        email: email,
        role: role,
      );
    } catch (error) {
      throw CliException('Could not invite $email: ${describeError(error)}');
    }

    if (context.json) {
      printJson(created.toJson());
      return 0;
    }

    stdout.writeln('Invited $email as ${role.name}.');
    stdout.writeln('  code:    ${created.code}');
    stdout.writeln(
      '  expires: ${formatTime(created.invitation.expiresAt)}',
    );
    stdout.writeln(
      '\n${created.warning} They redeem it with '
      '`fauxshield team accept --code <code>`.',
    );
    return 0;
  }
}

/// Redeems an invitation code.
class TeamAcceptCommand extends CliCommand {
  TeamAcceptCommand() {
    argParser
      ..addOption('code', abbr: 'c', help: 'Invitation code.')
      ..addOption(
        'name',
        help: 'Display name to show on the team list.',
      );
  }

  @override
  String get name => 'accept';

  @override
  String get description => 'Join a workspace with an invitation code.';

  @override
  Future<int> run() async {
    final code = requiredOption('code');
    final context = connect();
    final WorkspaceBootstrap bootstrap;
    try {
      bootstrap = await context.client.workspace.acceptInvitation(
        code,
        displayName: optionalOption('name'),
      );
    } catch (error) {
      throw CliException(
        'Could not accept the invite: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(<String, dynamic>{
        'workspaceId': bootstrap.workspace.id?.uuid,
        'workspace': bootstrap.workspace.name,
        'role': bootstrap.role.name,
      });
      return 0;
    }

    stdout.writeln(
      'Joined ${bootstrap.workspace.name} as ${bootstrap.role.name}.',
    );
    return 0;
  }
}

/// Changes a member's role.
class TeamRoleCommand extends CliCommand {
  TeamRoleCommand() {
    argParser
      ..addOption('member', abbr: 'm', help: 'Member id.')
      ..addOption(
        'role',
        abbr: 'r',
        help: 'New role: owner, admin, member, viewer.',
      );
  }

  @override
  String get name => 'role';

  @override
  String get description => 'Change a workspace member role.';

  @override
  Future<int> run() async {
    final memberId = parseUuid(requiredOption('member'), '--member');
    final role = parseEnum(
      requiredOption('role'),
      MembershipRole.values,
      '--role',
    );
    final context = connect();
    final WorkspaceMember member;
    try {
      member = await context.client.workspace.changeRole(
        memberId: memberId,
        role: role,
      );
    } catch (error) {
      throw CliException(
        'Could not change the role: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(member.toJson());
      return 0;
    }
    stdout.writeln('${member.email} is now ${member.role.name}.');
    return 0;
  }
}

/// Removes a member from the workspace.
class TeamRemoveCommand extends CliCommand {
  TeamRemoveCommand() {
    argParser
      ..addOption('member', abbr: 'm', help: 'Member id.')
      ..addFlag(
        'yes',
        abbr: 'y',
        negatable: false,
        help: 'Skip the confirmation prompt.',
      );
  }

  @override
  String get name => 'remove';

  @override
  String get description => 'Remove a member from the workspace.';

  @override
  Future<int> run() async {
    final memberId = parseUuid(requiredOption('member'), '--member');
    final context = connect();

    if (!confirmDestructive(
      argResults?['yes'] as bool? ?? false,
      'Remove member $memberId? They lose access immediately. Ownership must '
      'be transferred first.',
    )) {
      stdout.writeln('Cancelled.');
      return 0;
    }

    try {
      await context.client.workspace.removeMember(memberId: memberId);
    } catch (error) {
      throw CliException(
        'Could not remove the member: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(<String, dynamic>{'removed': memberId.uuid});
    } else {
      stdout.writeln('Removed $memberId from the workspace.');
    }
    return 0;
  }
}
