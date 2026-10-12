import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// Every scope name, for help text and validation messages.
final List<String> _scopeNames = ApiScope.values
    .map((scope) => scope.name)
    .toList(growable: false);

/// `fauxshield keys ...`
class KeysCommand extends Command<int> {
  KeysCommand() {
    addSubcommand(KeysListCommand());
    addSubcommand(KeysCreateCommand());
    addSubcommand(KeysRevokeCommand());
  }

  @override
  String get name => 'keys';

  @override
  String get description => 'Manage API keys for machines and CI.';

  @override
  String get invocation => 'fauxshield keys <list|create|revoke>';
}

/// Lists the workspace API keys.
class KeysListCommand extends CliCommand {
  @override
  String get name => 'list';

  @override
  String get description => 'List API keys without their secrets.';

  @override
  Future<int> run() async {
    final context = connect();
    final List<ApiKey> keys;
    try {
      keys = await context.client.apiKey.list();
    } catch (error) {
      throw CliException('Could not list API keys: ${describeError(error)}');
    }

    if (context.json) {
      printJson(keys.map((key) => key.toJson()).toList());
      return 0;
    }

    printTable(
      <String>[
        'LABEL',
        'PREFIX',
        'SCOPES',
        'LIMIT',
        'LAST USED',
        'STATE',
        'ID',
      ],
      keys
          .map(
            (key) => <String>[
              shorten(key.label, max: 22),
              key.keyPrefix,
              key.scopes.length.toString(),
              '${key.rateLimitPerMinute}/min',
              formatTime(key.lastUsedAt),
              key.revoked ? 'revoked' : 'active',
              key.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${keys.length} key(s).');
    return 0;
  }
}

/// Creates a key and prints its secret once.
class KeysCreateCommand extends CliCommand {
  KeysCreateCommand() {
    argParser
      ..addOption('label', abbr: 'l', help: 'What the key is for.')
      ..addOption(
        'scopes',
        abbr: 's',
        help: 'Comma separated scopes: ${_scopeNames.join(', ')}.',
        defaultsTo:
            'productsRead,batchesRead,identitiesRead,verificationsRead,'
            'fraudRead,analyticsRead',
      )
      ..addFlag(
        'all-scopes',
        negatable: false,
        help: 'Grant every scope, including the write scopes.',
      )
      ..addOption(
        'rate-limit',
        abbr: 'r',
        help: 'Requests per minute allowed for this key.',
        defaultsTo: '120',
      );
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Create an API key. The secret is shown once.';

  @override
  Future<int> run() async {
    final label = requiredOption('label');
    final allScopes = argResults?['all-scopes'] as bool? ?? false;
    final rawScopes = argResults?['scopes'] as String? ?? '';
    final scopes = allScopes
        ? ApiScope.values.toList()
        : parseEnumList(rawScopes, ApiScope.values, '--scopes');
    final rateLimit = int.tryParse(
      argResults?['rate-limit'] as String? ?? '120',
    );

    final context = connect();
    final ApiKeySecret created;
    try {
      created = await context.client.apiKey.create(
        label: label,
        scopes: scopes,
        rateLimitPerMinute: rateLimit ?? 120,
      );
    } catch (error) {
      throw CliException('Could not create the key: ${describeError(error)}');
    }

    if (context.json) {
      // The secret is part of the answer, and JSON output is what automation
      // reads, so it is included here on purpose.
      printJson(created.toJson());
      return 0;
    }

    stdout.writeln('Created ${created.apiKey.label}');
    stdout.writeln('  key:    ${created.secret}');
    stdout.writeln(
      '  scopes: ${created.apiKey.scopes.map((s) => s.name).join(', ')}',
    );
    stdout.writeln('  limit:  ${created.apiKey.rateLimitPerMinute}/min');
    stdout.writeln('\n${created.warning}');
    stdout.writeln(
      'Export it as FAUXSHIELD_API_KEY, or store it with '
      '`fauxshield auth login --api-key <key>`.',
    );
    return 0;
  }
}

/// Revokes a key immediately.
class KeysRevokeCommand extends CliCommand {
  KeysRevokeCommand() {
    argParser
      ..addOption('key', abbr: 'k', help: 'API key id.')
      ..addFlag(
        'yes',
        abbr: 'y',
        negatable: false,
        help: 'Skip the confirmation prompt.',
      );
  }

  @override
  String get name => 'revoke';

  @override
  String get description =>
      'Revoke an API key. Requests using it fail at once.';

  @override
  Future<int> run() async {
    final keyId = parseUuid(requiredOption('key'), '--key');
    final context = connect();

    if (!confirmDestructive(
      argResults?['yes'] as bool? ?? false,
      'Revoke API key $keyId? Anything using it stops working immediately.',
    )) {
      stdout.writeln('Cancelled.');
      return 0;
    }

    final ApiKey revoked;
    try {
      revoked = await context.client.apiKey.revoke(apiKeyId: keyId);
    } catch (error) {
      throw CliException('Could not revoke the key: ${describeError(error)}');
    }

    if (context.json) {
      printJson(revoked.toJson());
      return 0;
    }
    stdout.writeln('Revoked ${revoked.label} (${revoked.keyPrefix}…).');
    return 0;
  }
}
