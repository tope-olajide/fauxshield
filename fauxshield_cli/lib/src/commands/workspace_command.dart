import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield workspace ...`
class WorkspaceCommand extends Command<int> {
  WorkspaceCommand() {
    addSubcommand(WorkspaceShowCommand());
    addSubcommand(WorkspaceUpdateCommand());
    addSubcommand(WorkspaceCreateCommand());
  }

  @override
  String get name => 'workspace';

  @override
  String get description => 'Read and change the workspace settings.';

  @override
  String get invocation => 'fauxshield workspace <show|update|create>';
}

/// Shows the workspace the credential resolves to.
class WorkspaceShowCommand extends CliCommand {
  WorkspaceShowCommand() {
    argParser.addFlag(
      'public',
      negatable: false,
      help: 'Only print what is public: name, slug, and branding.',
    );
  }

  @override
  String get name => 'show';

  @override
  String get description => 'Show workspace settings and branding.';

  @override
  Future<int> run() async {
    final publicOnly = argResults?['public'] as bool? ?? false;
    final context = connect(requireAuth: !publicOnly);

    WorkspaceBootstrap? bootstrap;
    Workspace? workspace;
    try {
      bootstrap = await context.client.workspace.bootstrap();
      workspace = bootstrap?.workspace;
    } catch (error) {
      throw CliException(
        'Could not read the workspace: ${describeError(error)}',
      );
    }

    if (workspace == null) {
      throw CliException(
        context.isApiKey
            ? 'That key carries no workspace hint. Pass a workspace id, or use '
                  'a key created in the workspace you want.'
            : 'That account is not a member of any workspace. Create one with '
                  '`fauxshield workspace create --name <name>`.',
      );
    }

    if (context.json) {
      printJson(<String, dynamic>{
        'workspace': workspace.toJson(),
        if (bootstrap != null) 'role': bootstrap.role.name,
        if (bootstrap != null) 'isDemo': bootstrap.isDemo,
        if (bootstrap != null) 'permissions': bootstrap.permissions,
      });
      return 0;
    }

    printWorkspace(workspace);
    if (bootstrap != null) {
      stdout.writeln('  role:       ${bootstrap.role.name}');
      stdout.writeln('  demo mode:  ${yesNo(bootstrap.isDemo)}');
    }
    return 0;
  }
}

/// Changes workspace settings.
class WorkspaceUpdateCommand extends CliCommand {
  WorkspaceUpdateCommand() {
    argParser
      ..addOption('name', abbr: 'n', help: 'Workspace name.')
      ..addOption(
        'message',
        abbr: 'm',
        help: 'Message shown to shoppers on an authentic scan.',
      )
      ..addOption(
        'countries',
        help:
            'Comma separated ISO country codes where the products may be '
            'sold. Scans from elsewhere raise a signal.',
      )
      ..addOption(
        'branding',
        help:
            'Branding as JSON: displayName, logoUrl, themeColor, tagline. '
            '`workspace show --json` prints the current values.',
      )
      ..addOption(
        'policy',
        help:
            'Fraud policy as JSON: velocityWindowMinutes, velocityThreshold, '
            'pinAttackThreshold, batchDuplicationThreshold, cloneWindowMinutes, '
            'cloneDistanceThresholdKm, geoIpTimeoutMs, evaluationBudgetMs, '
            'autoLockOnFraud, alertOnHigh.',
      );
  }

  @override
  String get name => 'update';

  @override
  String get description => 'Update workspace settings.';

  @override
  Future<int> run() async {
    final rawCountries = optionalOption('countries');
    final rawBranding = optionalOption('branding');
    final rawPolicy = optionalOption('policy');
    if (rawCountries == null &&
        rawBranding == null &&
        rawPolicy == null &&
        optionalOption('name') == null &&
        optionalOption('message') == null) {
      throw CliException.usage(
        'Nothing to change. Pass --name, --message, --countries, --branding, '
        'or --policy.',
      );
    }

    final context = connect();
    final Workspace updated;
    try {
      updated = await context.client.workspace.update(
        name: optionalOption('name'),
        authenticMessage: optionalOption('message'),
        restrictedCountries: rawCountries == null
            ? null
            : splitList(rawCountries, '--countries'),
        branding: rawBranding == null
            ? null
            : Branding.fromJson(_parseObject(rawBranding, '--branding')),
        fraudPolicy: rawPolicy == null
            ? null
            : FraudPolicy.fromJson(_parseObject(rawPolicy, '--policy')),
      );
    } catch (error) {
      throw CliException(
        'Could not update the workspace: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(updated.toJson());
      return 0;
    }

    stdout.writeln('Updated ${updated.name}');
    printWorkspace(updated);
    return 0;
  }

  /// Parses a JSON object flag, naming the flag rather than the parser.
  static Map<String, dynamic> _parseObject(String raw, String label) {
    Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException catch (error) {
      throw CliException.usage('$label is not JSON: ${error.message}');
    }
    if (decoded is! Map<String, dynamic>) {
      throw CliException.usage('$label must be a JSON object.');
    }
    return decoded;
  }
}

/// Creates a workspace owned by the signed-in account.
class WorkspaceCreateCommand extends CliCommand {
  WorkspaceCreateCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Workspace name, for example a brand.',
      )
      ..addOption('email', abbr: 'e', help: 'Contact email for the workspace.')
      ..addOption(
        'message',
        help: 'Message shown to shoppers on an authentic scan.',
      );
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Create a workspace you own.';

  @override
  Future<int> run() async {
    final name = requiredOption('name');
    final context = connect();
    final WorkspaceBootstrap created;
    try {
      created = await context.client.workspace.create(
        name,
        email: optionalOption('email'),
        authenticMessage: optionalOption('message'),
      );
    } catch (error) {
      throw CliException(
        'Could not create the workspace: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(<String, dynamic>{
        'workspace': created.workspace.toJson(),
        'role': created.role.name,
        'permissions': created.permissions,
      });
      return 0;
    }

    stdout.writeln('Created ${created.workspace.name}');
    printWorkspace(created.workspace);
    stdout.writeln('  role:       ${created.role.name}');
    stdout.writeln(
      '\nNext: `fauxshield products create --name <product>` and '
      '`fauxshield keys create --label ci`.',
    );
    return 0;
  }
}

/// Prints the fields a workspace record carries.
void printWorkspace(Workspace workspace) {
  stdout.writeln('  id:       ${workspace.id?.uuid}');
  stdout.writeln('  slug:     ${workspace.slug}');
  stdout.writeln('  created:  ${formatTime(workspace.createdAt)}');
  if (workspace.authenticMessage != null) {
    stdout.writeln('  message:  ${workspace.authenticMessage}');
  }
  if (workspace.restrictedCountries != null &&
      workspace.restrictedCountries!.isNotEmpty) {
    stdout.writeln(
      '  countries: ${workspace.restrictedCountries!.join(', ')}',
    );
  }
  final branding = workspace.branding;
  if (branding != null) {
    stdout.writeln(
      '  branding: ${branding.displayName ?? workspace.name}'
      '${branding.themeColor == null ? '' : ' (${branding.themeColor})'}',
    );
  }
  final policy = workspace.fraudPolicy;
  if (policy != null) {
    stdout.writeln('  fraud policy:');
    stdout.writeln(
      '    velocity:     ${policy.velocityThreshold} scans per '
      '${policy.velocityWindowMinutes} min',
    );
    stdout.writeln('    PIN attempts: ${policy.pinAttackThreshold}');
    stdout.writeln('    duplication:  ${policy.batchDuplicationThreshold}');
    stdout.writeln(
      '    auto-lock:    ${yesNo(policy.autoLockOnFraud)}',
    );
  }
}
