/// Command line client for the FauxShield anti-counterfeit platform.
///
/// Talks to a FauxShield server over the same JSON-RPC API the Flutter
/// operator app and any Dart or Flutter integration use, so it is a thin
/// wrapper over the generated client rather than a second implementation.
///
/// Install it with `dart pub global activate fauxshield_cli` and run
/// `fauxshield`, or run it from a checkout with
/// `dart run fauxshield_cli:fauxshield`.
library;

export 'src/commands/alerts_command.dart';
export 'src/commands/analytics_command.dart';
export 'src/commands/audit_command.dart';
export 'src/commands/auth_command.dart';
export 'src/commands/batches_command.dart';
export 'src/commands/demo_command.dart';
export 'src/commands/identities_command.dart';
export 'src/commands/keys_command.dart';
export 'src/commands/notifications_command.dart';
export 'src/commands/offline_command.dart';
export 'src/commands/products_command.dart';
export 'src/commands/recalls_command.dart';
export 'src/commands/simulations_command.dart';
export 'src/commands/team_command.dart';
export 'src/commands/verifications_command.dart';
export 'src/commands/verify_command.dart';
export 'src/commands/webhooks_command.dart';
export 'src/commands/workspace_command.dart';
export 'src/config.dart';
export 'src/output.dart';
export 'src/runner.dart';
