import 'dart:io';

import 'package:fauxshield_contract/fauxshield_contract.dart';

/// Writes the API contract from the generated Dart client.
///
/// ```
/// dart run fauxshield_contract:extract          # rewrite the checked-in file
/// dart run fauxshield_contract:extract --check  # fail when it is out of date
/// ```
///
/// `--check` is what CI runs: regenerating the client without refreshing the
/// contract leaves the Node.js and Python SDKs describing an API that no longer
/// exists, and this turns that into a red build instead of a slow drift.
Future<void> main(List<String> arguments) async {
  final checkOnly = arguments.contains('--check');
  final unknown = arguments
      .where((argument) => argument != '--check')
      .toList(growable: false);
  if (unknown.isNotEmpty) {
    stderr.writeln('Unknown argument(s): ${unknown.join(' ')}');
    stderr.writeln('Usage: dart run fauxshield_contract:extract [--check]');
    exitCode = 64;
    return;
  }

  final root = findWorkspaceRoot();
  final extractor = ContractExtractor(
    clientRoot: Directory('${root.path}/fauxshield_client'),
  );
  final contract = extractor.extract();
  final file = File('${root.path}/$contractPath');
  final methods = contract.methodNames.length;

  stdout.writeln(
    '${contract.endpoints.length} endpoints, $methods methods, '
    '${contract.models.length} models, ${contract.enums.length} enums, '
    '${contract.exceptions.length} exceptions '
    '(client ${contract.sourceHash})',
  );

  if (!checkOnly) {
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(contract.encode());
    stdout.writeln('Wrote ${file.path}');
    return;
  }

  if (!file.existsSync()) {
    stderr.writeln('Missing $contractPath; run the extractor.');
    exitCode = 1;
    return;
  }
  if (file.readAsStringSync() != contract.encode()) {
    stderr.writeln(
      'The API contract is out of date with $contractPath.\n'
      'Run: dart run fauxshield_contract:extract',
    );
    exitCode = 1;
    return;
  }
  stdout.writeln('The API contract matches the generated client.');
}
