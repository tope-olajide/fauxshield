@Timeout(Duration(minutes: 3))
library;

import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

/// Absolute path to the entry point this test starts.
String get _binPath =>
    '${Directory.current.path}${Platform.pathSeparator}bin'
    '${Platform.pathSeparator}fauxshield_mcp.dart';

/// Environment that never picks up the developer's own CLI session.
Map<String, String> _environment({Map<String, String> extra = const {}}) =>
    <String, String>{
      'FAUXSHIELD_CONFIG':
          '${Directory.systemTemp.path}${Platform.pathSeparator}'
          'fauxshield-mcp-stdio-missing.json',
      ...extra,
    };

void main() {
  test('the binary speaks MCP over stdio and advertises its tools', () async {
    final process = await Process.start(
      Platform.resolvedExecutable,
      <String>['run', _binPath],
      environment: _environment(
        extra: <String, String>{
          'FAUXSHIELD_URL': 'http://127.0.0.1:1',
          'FAUXSHIELD_API_KEY': 'fs_live_0000000000000000000000000000test',
        },
      ),
    );
    addTearDown(() => process.kill());

    final lines = process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .asBroadcastStream();

    process.stdin.writeln(
      jsonEncode(<String, dynamic>{
        'jsonrpc': '2.0',
        'id': 1,
        'method': 'initialize',
        'params': <String, dynamic>{
          'protocolVersion': '2025-06-18',
          'capabilities': <String, dynamic>{},
          'clientInfo': <String, dynamic>{
            'name': 'stdio-test',
            'version': '1.0.0',
          },
        },
      }),
    );

    final initialize = await _readResponse(lines, 1);
    expect(initialize['result'], isNotNull);
    expect(
      (initialize['result']! as Map<String, dynamic>)['serverInfo'],
      containsPair('name', 'fauxshield'),
    );

    process.stdin
      ..writeln(
        jsonEncode(<String, dynamic>{
          'jsonrpc': '2.0',
          'method': 'notifications/initialized',
        }),
      )
      ..writeln(
        jsonEncode(<String, dynamic>{
          'jsonrpc': '2.0',
          'id': 2,
          'method': 'tools/list',
        }),
      );

    final listed = await _readResponse(lines, 2);
    final tools =
        ((listed['result']! as Map<String, dynamic>)['tools']! as List<dynamic>)
            .cast<Map<String, dynamic>>();
    expect(tools.length, greaterThanOrEqualTo(35));
    expect(
      tools.map((tool) => tool['name']),
      containsAll(<String>['list_alerts', 'investigate_alert', 'verify_unit']),
    );
    // Every tool carries a description, which is how a model decides to use it.
    for (final tool in tools) {
      expect(tool['description'], isNotEmpty, reason: '${tool['name']}');
    }
  });

  test(
    'the binary exits with a readable error when it is misconfigured',
    () async {
      final process = await Process.start(
        Platform.resolvedExecutable,
        <String>['run', _binPath],
        environment: _environment(),
      );

      final stderrText = await process.stderr.transform(utf8.decoder).join();
      final code = await process.exitCode;

      expect(code, 78, reason: stderrText);
      expect(stderrText, contains('No FauxShield credentials found'));
    },
  );

  test('--version prints the version without needing credentials', () async {
    final process = await Process.start(
      Platform.resolvedExecutable,
      <String>['run', _binPath, '--version'],
      environment: _environment(),
    );

    final output = await process.stdout.transform(utf8.decoder).join();
    expect(await process.exitCode, 0);
    expect(output, contains('fauxshield-mcp'));
  });
}

/// Reads stdout until the response with [id] arrives.
Future<Map<String, dynamic>> _readResponse(
  Stream<String> lines,
  int id,
) async {
  await for (final line in lines) {
    if (line.trim().isEmpty) continue;
    final decoded = jsonDecode(line);
    if (decoded is Map<String, dynamic> && decoded['id'] == id) {
      return decoded;
    }
  }
  fail('The server closed stdout before answering request $id.');
}
