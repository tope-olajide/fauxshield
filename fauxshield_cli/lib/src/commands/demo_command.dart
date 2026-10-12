import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield demo ...`
class DemoCommand extends Command<int> {
  DemoCommand() {
    addSubcommand(DemoStatusCommand());
    addSubcommand(DemoResetCommand());
    addSubcommand(DemoJoinCommand());
  }

  @override
  String get name => 'demo';

  @override
  String get description =>
      'Inspect and rebuild the disposable demo workspace.';

  @override
  String get invocation => 'fauxshield demo <status|reset|join>';
}

/// Reports whether the demo workspace exists.
class DemoStatusCommand extends CliCommand {
  DemoStatusCommand() {
    argParser.addFlag(
      'public',
      negatable: false,
      help: 'Only ask whether the demo workspace exists; no sign in needed.',
    );
  }

  @override
  String get name => 'status';

  @override
  String get description => 'Show whether the demo workspace is seeded.';

  @override
  Future<int> run() async {
    final publicOnly = argResults?['public'] as bool? ?? false;
    final context = connect(requireAuth: !publicOnly);

    final bool seeded;
    WorkspaceBootstrap? bootstrap;
    try {
      seeded = await context.client.demo.isSeeded();
      if (!publicOnly) bootstrap = await context.client.workspace.bootstrap();
    } catch (error) {
      throw CliException(
        'Could not read the demo state: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(<String, dynamic>{
        'url': context.url,
        'seeded': seeded,
        if (!publicOnly) 'workspaceId': bootstrap?.workspace.id?.uuid,
        if (!publicOnly) 'workspace': bootstrap?.workspace.name,
        if (!publicOnly) 'role': bootstrap?.role.name,
        if (!publicOnly) 'isDemo': bootstrap?.isDemo,
      });
      return 0;
    }

    stdout.writeln('Server:  ${context.url}');
    stdout.writeln('Seeded:  ${yesNo(seeded)}');
    if (bootstrap != null) {
      stdout.writeln('You are in: ${bootstrap.workspace.name}');
      stdout.writeln('Role:       ${bootstrap.role.name}');
      stdout.writeln('Demo mode:  ${yesNo(bootstrap.isDemo)}');
    }
    return 0;
  }
}

/// Rebuilds the demo workspace from scratch.
class DemoResetCommand extends CliCommand {
  DemoResetCommand() {
    argParser
      ..addOption('secret', abbr: 's', help: 'Demo seed secret.')
      ..addOption('email', abbr: 'e', help: 'Account to seed the demo for.')
      ..addOption('name', help: 'Display name for that account.')
      ..addFlag(
        'yes',
        abbr: 'y',
        negatable: false,
        help: 'Skip the confirmation prompt.',
      );
  }

  @override
  String get name => 'reset';

  @override
  String get description =>
      'Rebuild the demo workspace. Every demo change made so far is lost.';

  @override
  Future<int> run() async {
    final secret =
        optionalOption('secret') ??
        Platform.environment['FAUXSHIELD_DEMO_SECRET']?.trim();
    if (secret == null || secret.isEmpty) {
      throw CliException.usage(
        'Pass the seed secret with --secret, or set FAUXSHIELD_DEMO_SECRET.',
      );
    }
    final context = connect();

    if (!confirmDestructive(
      argResults?['yes'] as bool? ?? false,
      'Rebuild the demo workspace on ${context.url}? Anything added to it by '
      'hand is deleted and the seeded data is recreated.',
    )) {
      stdout.writeln('Cancelled.');
      return 0;
    }

    final WorkspaceBootstrap bootstrap;
    try {
      bootstrap = await context.client.demo.seed(
        email: optionalOption('email'),
        displayName: optionalOption('name'),
        secret: secret,
      );
    } catch (error) {
      throw CliException('Could not seed the demo: ${describeError(error)}');
    }

    if (context.json) {
      printJson(<String, dynamic>{
        'workspaceId': bootstrap.workspace.id?.uuid,
        'workspace': bootstrap.workspace.name,
        'role': bootstrap.role.name,
        'isDemo': bootstrap.isDemo,
      });
      return 0;
    }

    stdout.writeln('Seeded ${bootstrap.workspace.name}');
    stdout.writeln('  you are: ${bootstrap.role.name}');
    stdout.writeln(
      'Demo mode is on: scans, alerts, and recalls are marked so they can be '
      'cleared again.',
    );
    return 0;
  }
}

/// Joins the shared demo workspace as a guest.
class DemoJoinCommand extends CliCommand {
  DemoJoinCommand() {
    argParser
      ..addOption('email', abbr: 'e', help: 'Email to show on the team list.')
      ..addOption('name', help: 'Display name.');
  }

  @override
  String get name => 'join';

  @override
  String get description => 'Join the demo workspace as a guest operator.';

  @override
  Future<int> run() async {
    final context = connect();
    final WorkspaceBootstrap bootstrap;
    try {
      bootstrap = await context.client.workspace.joinDemo(
        email: optionalOption('email'),
        displayName: optionalOption('name'),
      );
    } catch (error) {
      throw CliException('Could not join the demo: ${describeError(error)}');
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
