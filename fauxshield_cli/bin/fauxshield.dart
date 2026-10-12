import 'dart:io';

import 'package:fauxshield_cli/fauxshield_cli.dart';

Future<void> main(List<String> arguments) async {
  exitCode = await runCli(arguments);
}
