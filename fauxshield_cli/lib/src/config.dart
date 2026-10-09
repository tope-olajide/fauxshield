import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

/// Exit code for a bad invocation, matching `EX_USAGE` from sysexits.
const int exitUsage = 64;

/// Exit code for a failure that is nobody's typo, such as a refused connection
/// or a rejected token.
const int exitFailure = 1;

/// A problem the user can fix, reported without a stack trace.
class CliException implements Exception {
  /// A failure that is not the user's mistake, such as a rejected token.
  CliException(this.message) : exitCode = exitFailure;

  /// A mistake in how the command was typed, such as a missing flag.
  CliException.usage(this.message) : exitCode = exitUsage;

  final String message;

  /// The process exit code this failure should produce.
  final int exitCode;

  @override
  String toString() => message;
}

/// Stores the server URL and the JWT between runs.
///
/// The file lives at `~/.fauxshield/config.json`, or wherever
/// `FAUXSHIELD_CONFIG` points. Environment variables and command line flags
/// take precedence over it, so CI never has to write the file at all.
class CliConfig {
  CliConfig({required this.url, this.token});

  final String url;
  final String? token;

  static const String _dirName = '.fauxshield';
  static const String _fileName = 'config.json';

  /// The path of the credentials file for the current user.
  static String get path {
    final override = Platform.environment['FAUXSHIELD_CONFIG'];
    if (override != null && override.trim().isNotEmpty) return override;
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        Directory.current.path;
    return '$home${Platform.pathSeparator}$_dirName'
        '${Platform.pathSeparator}$_fileName';
  }

  /// Reads the stored credentials, or null when nothing is stored yet.
  static CliConfig? load() {
    final file = File(path);
    if (!file.existsSync()) return null;
    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map<String, dynamic>) return null;
      final url = decoded['url'];
      if (url is! String || url.isEmpty) return null;
      final token = decoded['token'];
      return CliConfig(url: url, token: token is String ? token : null);
    } on FormatException {
      return null;
    }
  }

  /// Writes the credentials to disk, creating the directory if needed.
  void save() {
    final file = File(path);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(<String, dynamic>{
        'url': url,
        if (token != null) 'token': token,
      }),
    );
  }

  /// Removes the stored credentials.
  static void clear() {
    final file = File(path);
    if (file.existsSync()) file.deleteSync();
  }
}

/// Hands the stored token to the client as a bearer header.
class BearerTokenProvider implements ClientAuthKeyProvider {
  BearerTokenProvider(this.token);

  final String token;

  @override
  Future<String?> get authHeaderValue async =>
      wrapAsBearerAuthHeaderValue(token);
}

/// Turns a thrown error into a single readable line.
String describeError(Object error) {
  if (error is ServerpodClientHttpException) {
    final message = error.message.trim();
    return message.isEmpty
        ? 'HTTP ${error.statusCode}'
        : 'HTTP ${error.statusCode} $message';
  }
  if (error is ServerpodClientException) return error.message.trim();
  final text = error.toString();
  if (text.startsWith('Exception: ')) return text.substring(11);
  return text;
}

/// Everything a command needs to talk to the server.
class CliContext {
  CliContext({
    required this.client,
    required this.url,
    required this.json,
    this.token,
  });

  final Client client;
  final String url;
  final bool json;
  final String? token;
}

/// The default server used when nothing is configured.
const String defaultServerUrl = 'http://localhost:8080';

/// Base class for every command in this CLI.
///
/// Resolution order for both the URL and the token is: command line flag,
/// environment variable, stored config, default.
abstract class CliCommand extends Command<int> {
  CliCommand() {
    // Registered on every leaf command so that `fauxshield products list --json`
    // works as well as `fauxshield --json products list`.
    argParser
      ..addFlag(
        'json',
        abbr: 'j',
        negatable: false,
        help: 'Print machine readable JSON.',
      )
      ..addOption(
        'url',
        help: 'Server URL, overriding the stored value.',
        valueHelp: 'http://localhost:8080',
      );
    if (acceptsAuthToken) {
      argParser.addOption(
        'token',
        help: 'JWT to authenticate with, overriding the stored value.',
      );
    }
  }

  /// Whether the shared `--token` session override is registered.
  ///
  /// Override with `false` on a command where `--token` means something else,
  /// such as `verify`, where it is the QR token printed on the packaging.
  bool get acceptsAuthToken => true;

  /// Whether `--json` was passed, either before or after the command name.
  bool get jsonOutput =>
      (argResults?['json'] as bool? ?? false) ||
      (globalResults?['json'] as bool? ?? false);

  /// Reads a value from the command first, then the root, then the environment.
  String? _flagOrEnv(String name, String environmentVariable) {
    final local = argResults?[name];
    if (local is String && local.trim().isNotEmpty) return local.trim();
    final global = globalResults?[name];
    if (global is String && global.trim().isNotEmpty) return global.trim();
    final env = Platform.environment[environmentVariable];
    if (env != null && env.trim().isNotEmpty) return env.trim();
    return null;
  }

  /// Resolves the server URL without authenticating.
  String get resolvedUrl =>
      _flagOrEnv('url', 'FAUXSHIELD_URL') ??
      CliConfig.load()?.url ??
      defaultServerUrl;

  /// Resolves the token without touching the network.
  String? get resolvedToken {
    if (!acceptsAuthToken) return null;
    final explicit = _flagOrEnv('token', 'FAUXSHIELD_TOKEN');
    if (explicit != null) return explicit;
    final stored = CliConfig.load()?.token;
    if (stored != null && stored.trim().isNotEmpty) return stored.trim();
    return null;
  }

  /// Reads a required option, naming the flag when it is missing.
  ///
  /// Required options are checked here instead of with `mandatory: true`,
  /// because `args` enforces `mandatory` by throwing an [ArgumentError] from
  /// the getter. That reaches the user as an unhandled crash rather than a
  /// message telling them which flag to add.
  String requiredOption(String name) {
    final value = argResults?[name];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    throw CliException.usage('Missing --$name. Run with --help for the usage.');
  }

  /// Builds a client. Throws when [requireAuth] is set and no token exists.
  CliContext connect({bool requireAuth = true}) {
    final url = resolvedUrl;
    final token = resolvedToken;
    if (requireAuth && token == null) {
      throw CliException(
        'Not signed in. Run `fauxshield auth login --email <email>`, or set '
        'FAUXSHIELD_TOKEN.',
      );
    }
    final client = Client(url);
    if (token != null) client.authKeyProvider = BearerTokenProvider(token);
    return CliContext(
      client: client,
      url: url,
      json: jsonOutput,
      token: token,
    );
  }

  /// Parses a uuid argument, failing with a readable message.
  UuidValue parseUuid(String value, String label) {
    try {
      return UuidValue.fromString(value.trim());
    } catch (_) {
      throw CliException.usage('$label must be a uuid, got "$value".');
    }
  }

  /// Parses an enum argument by name, matching case insensitively.
  T parseEnum<T extends Enum>(String value, List<T> values, String label) {
    final normalized = value.trim().toLowerCase().replaceAll('-', '');
    for (final candidate in values) {
      if (candidate.name.toLowerCase() == normalized) return candidate;
    }
    final allowed = values.map((item) => item.name).join(', ');
    throw CliException.usage(
      'Unknown $label "$value". Expected one of: $allowed.',
    );
  }
}
