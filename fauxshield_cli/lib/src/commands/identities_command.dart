import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield identities ...`
class IdentitiesCommand extends Command<int> {
  IdentitiesCommand() {
    addSubcommand(IdentitiesListCommand());
    addSubcommand(IdentitiesGenerateCommand());
    addSubcommand(IdentitiesRevealPinCommand());
  }

  @override
  String get name => 'identities';

  @override
  String get description => 'Inspect serialized units and mint new ones.';

  @override
  String get invocation => 'fauxshield identities <list|generate|reveal-pin>';
}

/// Lists serialized units.
class IdentitiesListCommand extends CliCommand {
  IdentitiesListCommand() {
    argParser
      ..addOption(
        'batch',
        abbr: 'b',
        help: 'Only units in this batch.',
        valueHelp: '<uuid>',
      )
      ..addOption(
        'status',
        abbr: 's',
        help:
            'Filter by status: active, locked, recalled, regenerated, deleted.',
      )
      ..addFlag(
        'flagged',
        abbr: 'f',
        negatable: false,
        help: 'Only units that carry fraud signals.',
      )
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '20');
  }

  @override
  String get name => 'list';

  @override
  String get description => 'List serialized units.';

  @override
  Future<int> run() async {
    final context = connect();

    final page = int.tryParse((argResults?['page'] as String).trim()) ?? 1;
    final pageSize =
        int.tryParse((argResults?['page-size'] as String).trim()) ?? 20;
    final rawStatus = (argResults?['status'] as String?)?.trim();
    final batchId = (argResults?['batch'] as String?)?.trim();

    final List<ProductIdentity> identities;
    try {
      identities = await context.client.identity.list(
        batchId: batchId == null || batchId.isEmpty
            ? null
            : parseUuid(batchId, '--batch'),
        status: rawStatus == null || rawStatus.isEmpty
            ? null
            : parseEnum(rawStatus, IdentityStatus.values, '--status'),
        onlyFlagged: argResults?['flagged'] as bool? ?? false,
        // `--page` is 1 based for a human; the API counts from zero.
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 20 : pageSize,
      );
    } catch (error) {
      throw CliException('Could not list units: ${describeError(error)}');
    }

    if (context.json) {
      printJson(identities.map((identity) => identity.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['TOKEN', 'STATUS', 'FIRST', 'SCANS', 'FAILED PINS', 'ID'],
      identities
          .map(
            (identity) => <String>[
              shorten(maskToken(identity.qrToken), max: 22),
              identity.status.name,
              yesNo(identity.firstVerified),
              identity.verificationCount.toString(),
              identity.failedPinAttempts.toString(),
              identity.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln(
      '\n${identities.length} unit(s) on page $page. '
      'Tokens are masked; use --json for the full values.',
    );
    return 0;
  }

  /// Shows only the leading edge of a token so a terminal log stays safe.
  static String maskToken(String token) {
    if (token.length <= 12) return token;
    return '${token.substring(0, 8)}…${token.substring(token.length - 4)}';
  }
}

/// Mints identities for a batch.
class IdentitiesGenerateCommand extends CliCommand {
  IdentitiesGenerateCommand() {
    argParser
      ..addOption(
        'batch',
        abbr: 'b',
        help: 'Batch to serialize.',
        valueHelp: '<uuid>',
      )
      ..addOption(
        'quantity',
        abbr: 'q',
        help: 'How many units to mint.',
      )
      ..addOption(
        'idempotency-key',
        help: 'Replays this exact request instead of minting twice.',
      );
  }

  @override
  String get name => 'generate';

  @override
  String get description => 'Mint signed QR tokens and PINs for a batch.';

  @override
  Future<int> run() async {
    final quantity = int.tryParse(requiredOption('quantity'));
    if (quantity == null || quantity <= 0) {
      throw CliException.usage('--quantity must be a positive whole number.');
    }
    final batchId = parseUuid(requiredOption('batch'), '--batch');
    final context = connect();

    final key =
        (argResults?['idempotency-key'] as String?)?.trim().isNotEmpty == true
        ? (argResults!['idempotency-key'] as String).trim()
        : 'cli-${DateTime.now().toUtc().millisecondsSinceEpoch}';

    final IdentityGenerationResult result;
    try {
      result = await context.client.batch.generateIdentities(
        batchId: batchId,
        quantity: quantity,
        idempotencyKey: key,
      );
    } catch (error) {
      throw CliException('Could not generate units: ${describeError(error)}');
    }

    if (context.json) {
      printJson(result.toJson());
      return 0;
    }

    stdout.writeln(
      'Generated ${result.created} of ${result.requested} unit(s) for batch '
      '${result.batchId.uuid}.',
    );
    stdout.writeln('Idempotency key: $key');
    return 0;
  }
}

/// Reveals the packaging PIN for one unit. Audited server side.
class IdentitiesRevealPinCommand extends CliCommand {
  IdentitiesRevealPinCommand() {
    argParser.addOption(
      'identity',
      abbr: 'i',
      help: 'Unit id.',
      mandatory: true,
      valueHelp: '<uuid>',
    );
  }

  @override
  String get name => 'reveal-pin';

  @override
  String get description =>
      'Reveal the packaging PIN. Requires the reveal permission.';

  @override
  Future<int> run() async {
    final identityId = parseUuid(requiredOption('identity'), '--identity');
    final context = connect();
    final RevealedPin revealed;
    try {
      revealed = await context.client.identity.revealPin(
        identityId: identityId,
      );
    } catch (error) {
      throw CliException('Could not reveal the PIN: ${describeError(error)}');
    }

    if (context.json) {
      printJson(revealed.toJson());
      return 0;
    }

    stdout.writeln('PIN for ${revealed.identityId.uuid}: ${revealed.pin}');
    stdout.writeln('Revealed at ${formatTime(revealed.revealedAt)}.');
    return 0;
  }
}
