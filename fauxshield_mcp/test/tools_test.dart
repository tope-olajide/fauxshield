import 'dart:async';

import 'package:fauxshield_mcp/fauxshield_mcp.dart';
import 'package:mcp_dart/mcp_dart.dart';
import 'package:test/test.dart';

/// A configuration file that does not exist, so the developer's own CLI session
/// never leaks into a test.
const String _missingConfig = 'fauxshield-mcp-test-missing-config.json';

/// A gateway pointed at a port nothing listens on: any tool that reaches the
/// network fails predictably, which is exactly what the error path tests want.
FauxShieldGateway offlineGateway({bool readOnly = false}) {
  return FauxShieldGateway.fromConfig(
    McpConfig.fromEnvironment(
      environment: <String, String>{
        'FAUXSHIELD_URL': 'http://127.0.0.1:1',
        'FAUXSHIELD_API_KEY': 'fs_live_0000000000000000000000000000test',
        if (readOnly) 'FAUXSHIELD_READ_ONLY': 'true',
      },
      configFile: _missingConfig,
    ),
  );
}

/// A connected server/client pair talking over in-memory streams.
class McpPair {
  McpPair(this.server, this.client, this._close);

  final McpServer server;
  final McpClient client;
  final Future<void> Function() _close;

  /// Connects a server built by [build] to a fresh client.
  static Future<McpPair> connect(McpServer server) async {
    final toServer = StreamController<List<int>>();
    final toClient = StreamController<List<int>>();
    final serverTransport = IOStreamTransport(
      stream: toServer.stream,
      sink: toClient.sink,
    );
    final clientTransport = IOStreamTransport(
      stream: toClient.stream,
      sink: toServer.sink,
    );
    final client = McpClient(
      const Implementation(name: 'fauxshield-test', version: '1.0.0'),
    );
    await server.connect(serverTransport);
    await client.connect(clientTransport);
    return McpPair(server, client, () async {
      await client.close();
      await server.close();
      await toServer.close();
      await toClient.close();
    });
  }

  Future<void> close() => _close();
}

void main() {
  group('Given the FauxShield MCP server', () {
    late McpPair pair;

    setUp(() async {
      pair = await McpPair.connect(buildFauxShieldServer(offlineGateway()));
    });

    tearDown(() => pair.close());

    test('advertises the platform tool surface', () async {
      final result = await pair.client.listTools();
      final names = result.tools.map((tool) => tool.name).toSet();

      expect(
        names,
        containsAll(<String>[
          'list_products',
          'get_product',
          'create_product',
          'list_batches',
          'create_batch',
          'generate_units',
          'list_units',
          'export_units',
          'lock_unit',
          'list_alerts',
          'alert_evidence',
          'investigate_alert',
          'update_alert_status',
          'recall_batch',
          'lift_recall',
          'search_audit_events',
          'dashboard_summary',
          'list_webhooks',
          'test_webhook',
          'list_workspace_members',
          'list_api_keys',
          'verify_unit',
        ]),
      );
      // The dangerous operator-only paths stay out of an agent's reach.
      expect(names, isNot(contains('reveal_pin')));
      expect(result.tools.length, greaterThanOrEqualTo(35));
    });

    test('marks every tool as read-only or mutating, never both', () async {
      final result = await pair.client.listTools();
      for (final tool in result.tools) {
        final annotations = tool.annotations;
        expect(annotations, isNotNull, reason: tool.name);
        if (annotations!.readOnlyHint) {
          expect(annotations.destructiveHint, isFalse, reason: tool.name);
        }
      }
    });

    test('reports a bad argument without calling the API', () async {
      final result = await pair.client.callTool(
        CallToolRequest(
          name: 'list_units',
          arguments: <String, dynamic>{'page': 0},
        ),
      );

      expect(result.isError, isTrue);
      expect(_text(result), contains('starts at 1'));
      expect(_text(result), isNot(contains('Could not reach')));
    });

    test('names the missing argument it needs', () async {
      final result = await pair.client.callTool(
        const CallToolRequest(name: 'get_batch'),
      );

      expect(result.isError, isTrue);
      expect(_text(result), contains('batch_id'));
    });

    test('reports an unreachable API as a tool error, not a crash', () async {
      final result = await pair.client.callTool(
        const CallToolRequest(name: 'list_products'),
      );

      expect(result.isError, isTrue);
      expect(_text(result), contains('Could not reach the FauxShield API'));
    });
  });

  group('Given a read-only MCP server', () {
    late McpPair pair;

    setUp(() async {
      pair = await McpPair.connect(
        buildFauxShieldServer(offlineGateway(readOnly: true)),
      );
    });

    tearDown(() => pair.close());

    test(
      'still advertises the tools, so the client can explain the refusal',
      () async {
        final names = (await pair.client.listTools()).tools
            .map((tool) => tool.name)
            .toSet();
        expect(names, containsAll(<String>['create_product', 'recall_batch']));
      },
    );

    test('refuses a mutating call before it reaches the API', () async {
      final result = await pair.client.callTool(
        const CallToolRequest(
          name: 'create_product',
          arguments: <String, dynamic>{'name': 'Should not exist'},
        ),
      );

      expect(result.isError, isTrue);
      expect(_text(result), contains('read-only'));
      expect(_text(result), contains('FAUXSHIELD_READ_ONLY'));
    });

    test('allows reads', () async {
      final result = await pair.client.callTool(
        const CallToolRequest(name: 'list_products'),
      );
      // The API is unreachable, so this fails on the network rather than on the
      // read-only guard: proof that reads are not blocked.
      expect(_text(result), contains('Could not reach the FauxShield API'));
    });
  });

  group('Given the FauxShield gateway', () {
    test('rejects a workspace id that is not a uuid', () {
      expect(
        () => FauxShieldGateway.fromConfig(
          McpConfig.fromEnvironment(
            environment: const <String, String>{
              'FAUXSHIELD_API_KEY': 'fs_live_abc',
              'FAUXSHIELD_WORKSPACE_ID': 'not-a-uuid',
            },
            configFile: _missingConfig,
          ),
        ),
        throwsA(isA<McpConfigError>()),
      );
    });

    test('keeps a supplied idempotency key and mints one otherwise', () {
      final gateway = offlineGateway();

      expect(gateway.idempotencyKey('generate_units', 'abc'), 'abc');
      final first = gateway.idempotencyKey('generate_units');
      final second = gateway.idempotencyKey('generate_units');
      expect(first, startsWith('generate_units-'));
      expect(second, isNot(first));
    });

    test('sends the token as a bearer header', () async {
      final provider = BearerTokenProvider('fs_live_abc');
      expect(await provider.authHeaderValue, 'Bearer fs_live_abc');
    });
  });
}

/// The text of a tool result.
String _text(CallToolResult result) => result.content
    .whereType<TextContent>()
    .map((content) => content.text)
    .join('\n');
