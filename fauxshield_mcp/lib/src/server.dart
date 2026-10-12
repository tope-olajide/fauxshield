import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';

import 'config.dart';
import 'gateway.dart';
import 'tool_support.dart';
import 'tools/catalog_tools.dart';
import 'tools/fraud_tools.dart';
import 'tools/operations_tools.dart';
import 'tools/platform_tools.dart';

/// Server name and version advertised to MCP clients.
const String mcpServerName = 'fauxshield';
const String mcpServerVersion = '1.0.0';

/// Builds the MCP server with every tool registered against [gateway].
///
/// Registration is deliberately flat: each tool is one API call, so the tool
/// list an agent sees matches the API's own capabilities instead of hiding them
/// behind a do-everything command.
McpServer buildFauxShieldServer(FauxShieldGateway gateway) {
  final server = McpServer(
    const Implementation(name: mcpServerName, version: mcpServerVersion),
    options: McpServerOptions(
      capabilities: const ServerCapabilities(
        tools: ServerCapabilitiesTools(),
      ),
      instructions: _instructions(gateway),
    ),
  );

  final registry = ToolRegistry(
    server: server,
    executor: ToolExecutor(readOnly: gateway.readOnly),
  );
  registerCatalogTools(registry, gateway);
  registerFraudTools(registry, gateway);
  registerOperationsTools(registry, gateway);
  registerPlatformTools(registry, gateway);
  return server;
}

/// The startup note MCP clients show to the model.
String _instructions(FauxShieldGateway gateway) {
  final buffer = StringBuffer()
    ..writeln(
      'FauxShield is an anti-counterfeit platform: brands serialize products '
      'with signed QR codes and packaging PINs, consumers verify them, and '
      'operators work a live fraud queue.',
    )
    ..writeln(gateway.summary)
    ..writeln(
      'Investigation flow: list_alerts, then alert_evidence or '
      'investigate_alert, then act with update_alert_status, lock_unit, '
      'recall_batch, or lift_recall. Reads are always safe; mutations are '
      'audited against this credential.',
    );
  if (gateway.readOnly) {
    buffer.writeln(
      'This server is read-only: mutating tools refuse to run.',
    );
  }
  return buffer.toString();
}

/// Runs the MCP server over stdio using the environment configuration.
///
/// Everything the protocol needs goes to stdout, so all diagnostics go to
/// stderr: a stray print on stdout corrupts the session.
Future<void> runFauxShieldMcp() async {
  final config = McpConfig.fromEnvironment();
  final gateway = FauxShieldGateway.fromConfig(config);
  final server = buildFauxShieldServer(gateway);
  stderr.writeln('fauxshield-mcp $mcpServerVersion: ${gateway.summary}');
  await server.connect(StdioServerTransport());
}
