import 'dart:convert';
import 'dart:io';

import 'package:fauxshield_mcp/fauxshield_mcp.dart';
import 'package:test/test.dart';

/// A config file that does not exist, so the CLI session never leaks into a
/// test that is asserting an error.
final String _missingFile = '${Directory.systemTemp.path}/fauxshield-none.json';

void main() {
  group('Given McpConfig', () {
    test('prefers environment variables over the stored session', () {
      final config = McpConfig.fromEnvironment(
        environment: <String, String>{
          'FAUXSHIELD_URL': 'https://api.example.test',
          'FAUXSHIELD_API_KEY': 'fs_live_abc',
          'FAUXSHIELD_WORKSPACE_ID': 'ws-1',
        },
        configFile: _missingFile,
      );

      expect(config.serverUrl, 'https://api.example.test');
      expect(config.usesApiKey, isTrue);
      expect(config.workspaceId, 'ws-1');
      expect(config.readOnly, isFalse);
    });

    test('accepts a session token instead of an API key', () {
      final config = McpConfig.fromEnvironment(
        environment: <String, String>{'FAUXSHIELD_TOKEN': 'jwt-token'},
        configFile: _missingFile,
      );

      expect(config.usesApiKey, isFalse);
      expect(config.token, 'jwt-token');
      expect(config.serverUrl, McpConfig.defaultServerUrl);
    });

    test('falls back to the file the CLI writes', () {
      final file =
          File(
            '${Directory.systemTemp.createTempSync('fauxshield-mcp').path}'
            '/config.json',
          )..writeAsStringSync(
            jsonEncode(<String, String>{
              'url': 'https://stored.example.test',
              'token': 'fs_live_stored',
            }),
          );

      final config = McpConfig.fromEnvironment(
        environment: const <String, String>{},
        configFile: file.path,
      );

      expect(config.serverUrl, 'https://stored.example.test');
      expect(config.usesApiKey, isTrue);
    });

    test('fails with an actionable message when nothing is configured', () {
      expect(
        () => McpConfig.fromEnvironment(
          environment: const <String, String>{},
          configFile: _missingFile,
        ),
        throwsA(
          isA<McpConfigError>().having(
            (error) => error.message,
            'message',
            allOf(contains('FAUXSHIELD_API_KEY'), contains('auth login')),
          ),
        ),
      );
    });

    test('rejects a URL that is not http', () {
      expect(
        () => McpConfig.fromEnvironment(
          environment: <String, String>{
            'FAUXSHIELD_URL': 'ftp://example.test',
            'FAUXSHIELD_API_KEY': 'fs_live_abc',
          },
          configFile: _missingFile,
        ),
        throwsA(isA<McpConfigError>()),
      );
    });

    test('reads the read-only switch from common truthy spellings', () {
      for (final value in <String>['1', 'true', 'TRUE', 'yes']) {
        final config = McpConfig.fromEnvironment(
          environment: <String, String>{
            'FAUXSHIELD_API_KEY': 'fs_live_abc',
            'FAUXSHIELD_READ_ONLY': value,
          },
          configFile: _missingFile,
        );
        expect(config.readOnly, isTrue, reason: 'for "$value"');
      }
      final off = McpConfig.fromEnvironment(
        environment: const <String, String>{
          'FAUXSHIELD_API_KEY': 'fs_live_abc',
          'FAUXSHIELD_READ_ONLY': 'false',
        },
        configFile: _missingFile,
      );
      expect(off.readOnly, isFalse);
    });

    test('never prints a whole key in the connection summary', () {
      final config = McpConfig.fromEnvironment(
        environment: const <String, String>{
          'FAUXSHIELD_API_KEY': 'fs_live_0123456789abcdef0123456789abcdef',
        },
        configFile: _missingFile,
      );

      expect(config.credentialSummary, contains('fs_live_0123'));
      expect(
        config.credentialSummary,
        isNot(contains('abcdef0123456789abcdef')),
      );
    });
  });
}
