import 'dart:convert';
import 'dart:io';

/// Where the MCP server finds the server URL and the credentials it runs with.
///
/// Everything is environment first, so a host can configure the server without
/// touching the disk. When nothing is set, the same `~/.fauxshield/config.json`
/// the CLI writes on `auth login` is used, which means an agent can inherit a
/// developer's session without a second sign in.
class McpConfig {
  McpConfig({
    required this.serverUrl,
    required this.token,
    required this.workspaceId,
    required this.readOnly,
  });

  /// Base URL of the FauxShield API.
  final String serverUrl;

  /// API key (`fs_live_...`) or session JWT, sent as a bearer token.
  final String token;

  /// Workspace to act on. Null lets the server resolve the caller's workspace,
  /// which is the right default for both a key and a single-workspace user.
  final String? workspaceId;

  /// When true, mutating tools are not registered at all.
  final bool readOnly;

  /// Whether the token is an API key rather than a session JWT.
  bool get usesApiKey => token.startsWith('fs_live_');

  /// The API the server talks to when `FAUXSHIELD_URL` is not set: the hosted
  /// deployment, so an agent configured with nothing but a key works. A local
  /// or staging server is opt-in through `FAUXSHIELD_URL`.
  static const String defaultServerUrl =
      'https://fauxshield.api.serverpod.space';

  /// The file the CLI writes, or wherever `FAUXSHIELD_CONFIG` points.
  static String get configFilePath => resolveConfigPath(Platform.environment);

  /// The session file for a given environment.
  static String resolveConfigPath(Map<String, String> environment) {
    final override = environment['FAUXSHIELD_CONFIG'];
    if (override != null && override.trim().isNotEmpty) return override;
    final home =
        environment['HOME'] ??
        environment['USERPROFILE'] ??
        Directory.current.path;
    return '$home${Platform.pathSeparator}.fauxshield'
        '${Platform.pathSeparator}config.json';
  }

  /// Reads the environment, falling back to the CLI's stored session.
  ///
  /// Throws [McpConfigError] with an actionable message when no credentials
  /// exist, so the failure shows up in the client's MCP logs instead of inside
  /// the first tool call.
  factory McpConfig.fromEnvironment({
    Map<String, String>? environment,
    String? configFile,
  }) {
    final env = environment ?? Platform.environment;
    final stored = _readStoredConfig(
      configFile ?? resolveConfigPath(env),
    );

    String? firstNonEmpty(List<String?> values) {
      for (final value in values) {
        if (value != null && value.trim().isNotEmpty) return value.trim();
      }
      return null;
    }

    final url =
        firstNonEmpty(<String?>[
          env['FAUXSHIELD_URL'],
          stored?['url'] as String?,
        ]) ??
        defaultServerUrl;
    final token = firstNonEmpty(<String?>[
      env['FAUXSHIELD_API_KEY'],
      env['FAUXSHIELD_TOKEN'],
      stored?['token'] as String?,
    ]);
    if (token == null) {
      throw McpConfigError(
        'No FauxShield credentials found. Set FAUXSHIELD_API_KEY (create one '
        'in the operator app under Settings -> API keys) or FAUXSHIELD_TOKEN, '
        'or run `fauxshield auth login` to store a session in '
        '${configFile ?? resolveConfigPath(env)}.',
      );
    }
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      throw McpConfigError(
        'FAUXSHIELD_URL must start with http:// or https://, got "$url".',
      );
    }

    final workspaceId = firstNonEmpty(<String?>[
      env['FAUXSHIELD_WORKSPACE_ID'],
    ]);
    final readOnly = _isTruthy(env['FAUXSHIELD_READ_ONLY']);

    return McpConfig(
      serverUrl: url,
      token: token,
      workspaceId: workspaceId,
      readOnly: readOnly,
    );
  }

  static bool _isTruthy(String? value) {
    final normalized = value?.trim().toLowerCase();
    return normalized == '1' || normalized == 'true' || normalized == 'yes';
  }

  /// Returns the stored CLI config, or null when there is none to read.
  static Map<String, dynamic>? _readStoredConfig(String path) {
    final file = File(path);
    if (!file.existsSync()) return null;
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    } on FileSystemException {
      return null;
    }
  }

  /// A one line description of where credentials came from, for the server
  /// instructions an agent sees at startup. Never includes the token itself.
  String get credentialSummary => usesApiKey
      ? 'API key ${token.substring(0, 12)}... against $serverUrl'
      : 'session token against $serverUrl';
}

/// A configuration problem the operator can fix, reported without a stack trace.
class McpConfigError implements Exception {
  McpConfigError(this.message);

  final String message;

  @override
  String toString() => message;
}
