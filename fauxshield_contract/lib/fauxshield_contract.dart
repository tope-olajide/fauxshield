/// A language-neutral description of the FauxShield API, extracted from the
/// generated Dart client.
///
/// The Node.js and Python SDKs are built against the contract this package
/// writes, so they cannot describe a method, parameter, or field the API does
/// not have. `dart run fauxshield_contract:extract` rewrites the checked-in
/// file; `--check` fails instead of writing, which is how CI notices a client
/// that was regenerated without the contract following it.
library;

import 'dart:io';

export 'src/contract.dart';
export 'src/extractor.dart';

/// The checked-in contract, relative to the workspace root.
const String contractPath = 'fauxshield_contract/contract/api_contract.json';

/// Finds the workspace root by walking up from [from] until a directory holds
/// both this package and the generated client.
///
/// Tests run with the package as the working directory while a developer at the
/// terminal runs from the repository root, so neither can assume the other's
/// starting point.
Directory findWorkspaceRoot({Directory? from}) {
  var directory = (from ?? Directory.current).absolute;
  while (true) {
    final hasClient = Directory(
      '${directory.path}/fauxshield_client',
    ).existsSync();
    final hasThis = Directory(
      '${directory.path}/fauxshield_contract',
    ).existsSync();
    if (hasClient && hasThis) return directory;

    final parent = directory.parent;
    if (parent.path == directory.path) {
      throw StateError(
        'Could not find the workspace root above ${(from ?? Directory.current).path}.',
      );
    }
    directory = parent;
  }
}
