import 'dart:convert';
import 'dart:math';

import 'package:fauxshield_client/fauxshield_client.dart';

import 'config.dart';
import 'tool_support.dart';

/// Hands the configured token to the SDK as a bearer header.
class BearerTokenProvider implements ClientAuthKeyProvider {
  BearerTokenProvider(this.token);

  final String token;

  @override
  Future<String?> get authHeaderValue async =>
      wrapAsBearerAuthHeaderValue(token);
}

/// The single place tools talk to FauxShield from.
///
/// It owns the SDK client, the workspace every call is scoped to, and the
/// read-only switch, so a tool body is only ever the API call it wraps.
class FauxShieldGateway {
  FauxShieldGateway({
    required this.client,
    required this.config,
    required this.workspaceId,
  });

  final Client client;
  final McpConfig config;

  /// The workspace to act on, or null to let the server resolve the caller's.
  final UuidValue? workspaceId;

  /// Whether mutating tools may run.
  bool get readOnly => config.readOnly;

  /// Builds a gateway from configuration, including its SDK client.
  factory FauxShieldGateway.fromConfig(McpConfig config) {
    final client = Client(config.serverUrl)
      ..authKeyProvider = BearerTokenProvider(config.token);
    final rawWorkspaceId = config.workspaceId;
    final workspaceId = rawWorkspaceId == null
        ? null
        : parseUuid(rawWorkspaceId);
    if (rawWorkspaceId != null && workspaceId == null) {
      throw McpConfigError(
        'FAUXSHIELD_WORKSPACE_ID must be a uuid, got "$rawWorkspaceId".',
      );
    }
    return FauxShieldGateway(
      client: client,
      config: config,
      workspaceId: workspaceId,
    );
  }

  /// A random device fingerprint for consumer verification calls, matching the
  /// shape the SDK sends from the browser and the field app.
  static String newFingerprint() => 'mcp-${_hex(8)}';

  static String _hex(int bytes) {
    final random = Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < bytes; i++) {
      buffer.write(random.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  /// Idempotency keys are how the API makes a mutating call safe to retry; an
  /// agent that repeats a call keeps the key it was given the first time.
  String idempotencyKey(String toolName, [String? supplied]) {
    final provided = supplied?.trim();
    if (provided != null && provided.isNotEmpty) return provided;
    // The counter keeps two calls in the same microsecond apart.
    return '$toolName-${DateTime.now().toUtc().microsecondsSinceEpoch}'
        '-${++_keyCounter}';
  }

  static int _keyCounter = 0;

  /// A short line describing the client the agent is working as.
  String get summary =>
      'Connected to ${config.serverUrl} with '
      '${config.credentialSummary}'
      '${workspaceId == null ? '' : ', workspace ${workspaceId!.uuid}'}'
      '${readOnly ? ' (read-only)' : ''}';

  /// Marks the gateway as unusable after a fatal configuration problem.
  static McpConfigError unsupported(String message) => McpConfigError(message);

  /// Pretty JSON, used by tools that return export payloads as text.
  static String prettyJson(Object? value) =>
      const JsonEncoder.withIndent('  ').convert(value);
}
