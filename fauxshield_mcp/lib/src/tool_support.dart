import 'dart:convert';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:mcp_dart/mcp_dart.dart';

/// A problem with a tool call that the agent can fix by changing its arguments.
class ToolError implements Exception {
  ToolError(this.message, {this.hint});

  final String message;

  /// What to try instead, when there is an obvious answer.
  final String? hint;

  String get description => hint == null ? message : '$message\n$hint';
}

/// Typed access to the arguments of one tool call.
class ToolArgs {
  ToolArgs(this.raw);

  final Map<String, dynamic> raw;

  /// Reads a required string.
  String requiredString(String key) {
    final value = optionalString(key);
    if (value == null) {
      throw ToolError('Missing required argument "$key".');
    }
    return value;
  }

  /// Reads an optional string, treating blanks as absent.
  String? optionalString(String key) {
    final value = raw[key];
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    throw ToolError('Argument "$key" must be a string.');
  }

  /// Reads a required uuid, accepting the canonical string form.
  UuidValue requiredUuid(String key) {
    final value = optionalUuid(key);
    if (value == null) {
      throw ToolError('Missing required uuid argument "$key".');
    }
    return value;
  }

  /// Reads an optional uuid.
  UuidValue? optionalUuid(String key) {
    final value = optionalString(key);
    if (value == null) return null;
    final parsed = parseUuid(value);
    if (parsed == null) {
      throw ToolError(
        'Argument "$key" must be a uuid, got "$value".',
        hint: 'Ids are returned by the list tools, for example list_products.',
      );
    }
    return parsed;
  }

  /// Reads an optional integer, accepting numeric strings from loose hosts.
  int? optionalInt(String key) {
    final value = raw[key];
    if (value == null) return null;
    if (value is int) return value;
    if (value is double && value == value.roundToDouble()) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    throw ToolError('Argument "$key" must be a whole number.');
  }

  /// Reads a required integer within [min] and [max].
  int requiredInt(String key, {int? min, int? max}) {
    final value = optionalInt(key);
    if (value == null) {
      throw ToolError('Missing required whole number argument "$key".');
    }
    if (min != null && value < min) {
      throw ToolError('Argument "$key" must be at least $min, got $value.');
    }
    if (max != null && value > max) {
      throw ToolError('Argument "$key" must be at most $max, got $value.');
    }
    return value;
  }

  /// Reads an optional boolean.
  bool optionalBool(String key, {bool fallback = false}) {
    final value = raw[key];
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    throw ToolError('Argument "$key" must be true or false.');
  }

  /// Reads a list of strings.
  List<String>? optionalStringList(String key) {
    final value = raw[key];
    if (value == null) return null;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return null;
      return <String>[trimmed];
    }
    if (value is List) {
      return value.map((item) => item.toString()).toList(growable: false);
    }
    throw ToolError('Argument "$key" must be a list of strings.');
  }

  /// Reads a timestamp, accepting ISO 8601.
  DateTime? optionalDate(String key) {
    final value = optionalString(key);
    if (value == null) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw ToolError(
        'Argument "$key" must be an ISO 8601 timestamp, got "$value".',
      );
    }
    return parsed.toUtc();
  }

  /// Reads a required timestamp, defaulting to now when absent.
  DateTime requiredDateOrNow(String key) => optionalDate(key) ?? _now();

  static DateTime _now() => DateTime.now().toUtc();

  /// Reads an enum value by name, matching case insensitively.
  T? optionalEnum<T extends Enum>(
    String key,
    List<T> values, {
    String? label,
  }) {
    final raw = optionalString(key);
    if (raw == null) return null;
    final normalized = raw
        .toLowerCase()
        .replaceAll('-', '')
        .replaceAll('_', '');
    for (final candidate in values) {
      if (candidate.name.toLowerCase() == normalized) return candidate;
    }
    final allowed = values.map((value) => value.name).join(', ');
    throw ToolError(
      'Unknown ${label ?? key} "$raw". Expected one of: $allowed.',
    );
  }

  /// Reads a required enum value by name.
  T requiredEnum<T extends Enum>(
    String key,
    List<T> values, {
    String? label,
  }) {
    final value = optionalEnum<T>(key, values, label: label);
    if (value == null) {
      throw ToolError(
        'Missing required argument "$key". Expected one of: '
        '${values.map((value) => value.name).join(', ')}.',
      );
    }
    return value;
  }

  /// One-based page arguments, as agents expect, converted to the zero-based
  /// paging the API uses.
  ({int page, int pageSize}) paging({int defaultPageSize = 25, int max = 200}) {
    final page = optionalInt('page') ?? 1;
    final pageSize = optionalInt('page_size') ?? defaultPageSize;
    if (page < 1) throw ToolError('Argument "page" starts at 1, got $page.');
    if (pageSize < 1 || pageSize > max) {
      throw ToolError('Argument "page_size" must be between 1 and $max.');
    }
    return (page: page - 1, pageSize: pageSize);
  }
}

/// A canonical uuid, checked before it reaches the API.
///
/// `UuidValue.fromString` accepts almost anything, so a typo like `batch_id:
/// "my-batch"` would only fail later with an opaque transport error. Validating
/// the shape here turns it into a message the agent can act on.
final RegExp _uuidPattern = RegExp(
  r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-'
  r'[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
);

/// Parses a canonical uuid, or null when [value] is not one.
UuidValue? parseUuid(String value) {
  final trimmed = value.trim();
  if (!_uuidPattern.hasMatch(trimmed)) return null;
  try {
    return UuidValue.fromString(trimmed);
  } catch (_) {
    return null;
  }
}

/// Registers tool definitions with consistent schemas, annotations, and error
/// handling, so each tool body stays a short call into the SDK.
class ToolRegistry {
  ToolRegistry({required this.server, required this.executor});

  /// The MCP server tools are registered on.
  final McpServer server;

  /// Runs tool bodies and shapes their results and failures.
  final ToolExecutor executor;

  /// Registers a read-only tool.
  void read(
    String name, {
    required String description,
    Map<String, JsonSchema> properties = const <String, JsonSchema>{},
    List<String> required = const <String>[],
    required ToolBody body,
  }) {
    _register(
      name,
      description: description,
      properties: properties,
      required: required,
      annotations: const ToolAnnotations(
        readOnlyHint: true,
        destructiveHint: false,
        idempotentHint: true,
        openWorldHint: false,
      ),
      body: body,
      mutating: false,
    );
  }

  /// Registers a tool that changes data.
  ///
  /// When the server is configured read-only, the tool is registered anyway so
  /// the caller gets a clear refusal instead of "unknown tool", but the body is
  /// never executed.
  void write(
    String name, {
    required String description,
    Map<String, JsonSchema> properties = const <String, JsonSchema>{},
    List<String> required = const <String>[],
    bool destructive = false,
    bool idempotent = false,
    required ToolBody body,
  }) {
    _register(
      name,
      description: description,
      properties: properties,
      required: required,
      annotations: ToolAnnotations(
        readOnlyHint: false,
        destructiveHint: destructive,
        idempotentHint: idempotent,
        openWorldHint: false,
      ),
      body: body,
      mutating: true,
    );
  }

  void _register(
    String name, {
    required String description,
    required Map<String, JsonSchema> properties,
    required List<String> required,
    required ToolAnnotations annotations,
    required ToolBody body,
    required bool mutating,
  }) {
    server.registerTool(
      name,
      title: name,
      description: description,
      inputSchema: JsonSchema.object(
        properties: properties,
        required: required,
      ),
      annotations: annotations,
      callback: (args, _) => executor.run(name, args, body, mutating: mutating),
    );
  }
}

/// The body of one tool: receives typed arguments and returns either a model
/// (an object), a list of models, or a short string.
typedef ToolBody = Future<Object?> Function(ToolArgs args, ToolCallContext ctx);

/// Runs tool bodies and turns their results and failures into MCP responses.
class ToolExecutor {
  ToolExecutor({required this.readOnly});

  /// When true, mutating tools refuse to run.
  final bool readOnly;

  /// Executes [body], converting every failure into a readable tool error.
  ///
  /// A mutating call is refused outright when the server is configured
  /// read-only, before the arguments are even parsed.
  Future<CallToolResult> run(
    String toolName,
    Map<String, dynamic> arguments,
    ToolBody body, {
    required bool mutating,
  }) async {
    if (mutating && readOnly) {
      return error_(
        'This FauxShield MCP server is read-only, so $toolName is disabled.',
        hint:
            'It is running with FAUXSHIELD_READ_ONLY=true. Unset it and restart '
            'the server to allow changes.',
      );
    }
    try {
      return result(await body(ToolArgs(arguments), ToolCallContext()));
    } on ToolError catch (error) {
      return error_(error.message, hint: error.hint);
    } on ApiException catch (error) {
      return error_(describeApiError(error));
    } on ServerpodClientException catch (error) {
      return error_(
        'Could not reach the FauxShield API: ${error.message.trim()}',
        hint:
            'Check FAUXSHIELD_URL and that the server is running. An API key '
            'also has to be sent to the right workspace.',
      );
    } on FormatException catch (error) {
      return error_('Malformed argument: ${error.message}');
    } catch (error) {
      return error_(
        'The $toolName tool failed: ${_describeUnknown(error)}',
      );
    }
  }

  /// The MCP result for a completed tool call.
  ///
  /// Objects become `structuredContent` so agents can read fields directly,
  /// lists are wrapped in a count plus items, and anything else is text.
  CallToolResult result(Object? value) {
    if (value == null) {
      return CallToolResult.fromContent(const <Content>[
        TextContent(text: 'ok'),
      ]);
    }
    if (value is String) {
      return CallToolResult.fromContent(<Content>[TextContent(text: value)]);
    }
    if (value is List) {
      return _object(<String, dynamic>{
        'count': value.length,
        'items': value.map(_toJson).toList(growable: false),
      });
    }
    return _object(_toJson(value));
  }

  CallToolResult error_(String message, {String? hint}) {
    final text = hint == null ? message : '$message\n$hint';
    return CallToolResult(
      content: <Content>[TextContent(text: text)],
      isError: true,
    );
  }

  CallToolResult _object(Object? value) {
    final json = _toJson(value);
    if (json is Map<String, dynamic>) {
      // Structured content carries the fields; `fromStructuredContent` also
      // fills `content` with the same JSON for clients that ignore it.
      return CallToolResult.fromStructuredContent(json);
    }
    return CallToolResult.fromContent(<Content>[
      TextContent(text: const JsonEncoder.withIndent('  ').convert(json)),
    ]);
  }

  static Object? _toJson(Object? value) {
    if (value == null) return null;
    if (value is Map || value is List || value is String || value is num) {
      if (value is Map) {
        return value.map(
          (key, item) => MapEntry(key.toString(), _toJson(item)),
        );
      }
      if (value is List) return value.map(_toJson).toList(growable: false);
      return value;
    }
    // Generated models all serialize themselves.
    try {
      final dynamic model = value;
      return model.toJson();
    } catch (_) {
      return value.toString();
    }
  }

  /// A short, safe description of an unexpected failure.
  static String _describeUnknown(Object error) {
    final text = error.toString();
    if (text.startsWith('Exception: ')) return text.substring(11);
    return text.length > 300 ? '${text.substring(0, 300)}...' : text;
  }

  /// Turns a typed API failure into something an agent can act on.
  static String describeApiError(ApiException error) {
    final message = error.message.trim();
    if (error is AuthenticationException) {
      if (error.reason == 'notAuthenticated') {
        return 'Not authorized: $message Create an API key in the operator app '
            'and set FAUXSHIELD_API_KEY.';
      }
      return 'Not permitted: $message';
    }
    if (error is RateLimitException) {
      return 'Rate limited: $message';
    }
    if (error is NotFoundException) {
      return 'Not found (${error.resource}): $message';
    }
    if (error is ValidationException) {
      final field = error.field;
      return field == null
          ? 'Rejected: $message'
          : 'Rejected ($field): $message';
    }
    if (error is VerificationException) {
      return 'Verification failed: $message';
    }
    return message.isEmpty ? 'The server rejected the call.' : message;
  }
}

/// Per-call context handed to tool bodies.
///
/// A placeholder today: the SDK client is stateless per call, so a tool body
/// only needs the run-time read-only flag through the gateway.
class ToolCallContext {
  const ToolCallContext();
}
