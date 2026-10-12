import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import 'commands/alerts_command.dart';
import 'commands/analytics_command.dart';
import 'commands/audit_command.dart';
import 'commands/auth_command.dart';
import 'commands/batches_command.dart';
import 'commands/demo_command.dart';
import 'commands/identities_command.dart';
import 'commands/keys_command.dart';
import 'commands/notifications_command.dart';
import 'commands/offline_command.dart';
import 'commands/products_command.dart';
import 'commands/recalls_command.dart';
import 'commands/simulations_command.dart';
import 'commands/team_command.dart';
import 'commands/verifications_command.dart';
import 'commands/verify_command.dart';
import 'commands/webhooks_command.dart';
import 'commands/workspace_command.dart';
import 'config.dart';

/// The version reported by `fauxshield --version`.
///
/// Kept in step with the `version` field in `pubspec.yaml` by a check in
/// `test/version_test.dart`.
const String cliVersion = '1.0.0';

/// The FauxShield command line client.
class FauxShieldRunner extends CommandRunner<int> {
  /// Builds the full command tree.
  FauxShieldRunner()
    : super(
        'fauxshield',
        'Manage products, batches, serialized units, and fraud alerts on a '
            'FauxShield server.',
      ) {
    // Registered at the top level as well so that global flags work on either
    // side of the command name: `fauxshield --json alerts list` and
    // `fauxshield alerts list --json` both do what you expect.
    argParser
      ..addFlag(
        'json',
        abbr: 'j',
        negatable: false,
        help: 'Print machine readable JSON.',
      )
      ..addOption(
        'url',
        help: 'Server URL, overriding the stored value.',
        valueHelp: 'http://localhost:8080',
      )
      ..addOption(
        'token',
        help: 'JWT to authenticate with, overriding the stored value.',
      )
      ..addOption(
        'api-key',
        help:
            'API key to authenticate with, overriding the stored value. '
            'Falls back to FAUXSHIELD_API_KEY.',
      )
      ..addFlag(
        'version',
        abbr: 'v',
        negatable: false,
        help: 'Print the CLI version.',
      );

    addCommand(AuthCommand());
    addCommand(ProductsCommand());
    addCommand(BatchesCommand());
    addCommand(IdentitiesCommand());
    addCommand(AlertsCommand());
    addCommand(VerificationsCommand());
    addCommand(RecallsCommand());
    addCommand(SimulationsCommand());
    addCommand(AnalyticsCommand());
    addCommand(AuditCommand());
    addCommand(TeamCommand());
    addCommand(KeysCommand());
    addCommand(WebhooksCommand());
    addCommand(NotificationsCommand());
    addCommand(OfflineCommand());
    addCommand(WorkspaceCommand());
    addCommand(DemoCommand());
    addCommand(VerifyCommand());
  }

  @override
  String? get usageFooter =>
      '\nConfiguration: ${CliConfig.path}\n'
      'Server URL and credential can also come from the FAUXSHIELD_URL, '
      'FAUXSHIELD_TOKEN, and FAUXSHIELD_API_KEY environment variables.';
}

/// True when the invocation is asking for the version rather than work.
bool _wantsVersion(List<String> args) =>
    args.contains('--version') || args.contains('-v');

/// Parses and runs [args], returning the process exit code.
///
/// Expected failures are reported as a single readable line. Anything that
/// looks like a bug is left to throw, so a stack trace still surfaces.
Future<int> runCli(List<String> args) async {
  if (_wantsVersion(args)) {
    stdout.writeln('fauxshield $cliVersion');
    return 0;
  }

  final runner = FauxShieldRunner();
  try {
    return await runner.run(args) ?? 0;
  } on UsageException catch (error) {
    stderr.writeln(error.message);
    stderr.writeln();
    stderr.writeln(error.usage);
    return exitUsage;
  } on CliException catch (error) {
    stderr.writeln('error: ${error.message}');
    return error.exitCode;
  } on ServerpodClientException catch (error) {
    stderr.writeln('error: ${describeError(error)}');
    return exitFailure;
  } on Exception catch (error) {
    stderr.writeln('error: ${describeError(error)}');
    return exitFailure;
  }
}
