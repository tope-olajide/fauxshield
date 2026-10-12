import 'dart:io';

import 'package:fauxshield_cli/fauxshield.dart';
import 'package:test/test.dart';

void main() {
  group('Given the CLI base URL', () {
    test('the built-in default is the hosted API, not localhost', () {
      // An installed CLI has to work against a real account with no
      // configuration. A localhost default only works on the machine running a
      // dev server, and silently points every other user at nothing.
      expect(defaultServerUrl, 'https://fauxshield.api.serverpod.space');
      expect(defaultServerUrl, startsWith('https://'));
      expect(defaultServerUrl, isNot(contains('localhost')));
      expect(defaultServerUrl, isNot(contains('127.0.0.1')));
    });

    test('the default is a URL the client can actually parse', () {
      final uri = Uri.parse(defaultServerUrl);

      expect(uri.hasScheme, isTrue);
      expect(uri.host, isNotEmpty);
      expect(uri.path, isEmpty);
    });

    test(
      '--url overrides the default, so local work stays local',
      () async {
        // Run the real binary against a closed port. The failure names the URL
        // it tried, which is the proof the flag beat the hosted default rather
        // than a claim that a failure happened: had the default won, the
        // request would have gone to the hosted API instead.
        final result = await Process.run('dart', <String>[
          'run',
          'bin/fauxshield.dart',
          'products',
          'list',
          '--api-key',
          'fs_live_abcdefghijklmnop',
          '--url',
          'http://127.0.0.1:1',
        ]);
        final output = '${result.stdout}${result.stderr}';

        expect(result.exitCode, isNot(0));
        expect(output, contains('127.0.0.1:1'));
        expect(output, isNot(contains('serverpod.space')));
      },
      // Compiling and running the binary takes seconds on a warm machine and
      // can take a minute on a cold one; the assertion is about the URL the
      // failure names, not about how fast Dart starts.
      timeout: const Timeout(Duration(minutes: 3)),
    );
  });
}
