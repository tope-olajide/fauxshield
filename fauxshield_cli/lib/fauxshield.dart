/// Command line client for the FauxShield anti-counterfeit platform.
///
/// Talks to a FauxShield server over the same JSON-RPC API the Flutter
/// operator app and any Dart or Flutter integration use, so it is a thin
/// wrapper over the generated client rather than a second implementation.
///
/// Run it with `dart run fauxshield_cli:fauxshield`, or `fauxshield` once the
/// package is activated with `dart pub global activate --source path .`.
library;

export 'src/commands/alerts_command.dart';
export 'src/commands/auth_command.dart';
export 'src/commands/batches_command.dart';
export 'src/commands/identities_command.dart';
export 'src/commands/products_command.dart';
export 'src/commands/verify_command.dart';
export 'src/config.dart';
export 'src/output.dart';
export 'src/runner.dart';
