import 'dart:io';

import 'package:fauxshield_cli/fauxshield_cli.dart';
import 'package:test/test.dart';

/// Finds this package's pubspec.yaml, however the test was started.
File _pubspec() {
  var directory = Directory.current.absolute;
  for (var depth = 0; depth < 6; depth++) {
    final candidate = File(
      '${directory.path}${Platform.pathSeparator}pubspec.yaml',
    );
    if (candidate.existsSync() &&
        candidate.readAsStringSync().contains('name: fauxshield_cli')) {
      return candidate;
    }
    final parent = directory.parent;
    if (parent.path == directory.path) break;
    directory = parent;
  }
  throw StateError('Could not find the fauxshield_cli pubspec.yaml.');
}

void main() {
  test('cliVersion matches the version in pubspec.yaml', () {
    final version = _pubspec()
        .readAsLinesSync()
        .map((line) => line.trim())
        .firstWhere((line) => line.startsWith('version: '))
        .substring('version: '.length)
        .trim();

    expect(cliVersion, version);
  });

  test('--version succeeds without touching the network', () async {
    expect(await runCli(<String>['--version']), 0);
  });
}
