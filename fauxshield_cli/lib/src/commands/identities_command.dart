import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield identities ...`
class IdentitiesCommand extends Command<int> {
  IdentitiesCommand() {
    addSubcommand(IdentitiesListCommand());
    addSubcommand(IdentitiesShowCommand());
    addSubcommand(IdentitiesGenerateCommand());
    addSubcommand(IdentitiesExportCommand());
    addSubcommand(IdentitiesRevealPinCommand());
    addSubcommand(IdentitiesLockCommand());
    addSubcommand(IdentitiesUnlockCommand());
    addSubcommand(IdentitiesRegenerateCommand());
    addSubcommand(IdentitiesDeleteCommand());
    addSubcommand(IdentitiesRestoreCommand());
  }

  @override
  String get name => 'identities';

  @override
  String get description => 'Inspect serialized units and mint new ones.';

  @override
  String get invocation =>
      'fauxshield identities '
      '<list|show|generate|export|reveal-pin|lock|unlock|regenerate|delete|'
      'restore>';
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

/// Shows one serialized unit.
class IdentitiesShowCommand extends CliCommand {
  IdentitiesShowCommand() {
    argParser.addOption(
      'identity',
      abbr: 'i',
      help: 'Identity id.',
      valueHelp: '<uuid>',
    );
  }

  @override
  String get name => 'show';

  @override
  String get description => 'Show a serialized unit.';

  @override
  Future<int> run() async {
    final identityId = parseUuid(requiredOption('identity'), '--identity');
    final context = connect();
    final ProductIdentity identity;
    try {
      identity = await context.client.identity.get(identityId);
    } catch (error) {
      throw CliException('Could not read the unit: ${describeError(error)}');
    }

    if (context.json) {
      printJson(identity.toJson());
      return 0;
    }

    printIdentity(identity);
    return 0;
  }
}

/// Writes the identities of a batch as a CSV or TSV sheet.
class IdentitiesExportCommand extends CliCommand {
  IdentitiesExportCommand() {
    argParser
      ..addOption('batch', abbr: 'b', help: 'Batch id.')
      ..addOption(
        'format',
        abbr: 'f',
        help: 'Export format: csv or tsv.',
        defaultsTo: 'csv',
      )
      ..addOption(
        'out',
        abbr: 'o',
        help: 'Write to this file instead of stdout.',
      );
  }

  @override
  String get name => 'export';

  @override
  String get description =>
      'Export the serialized units of a batch as a CSV or TSV sheet.';

  @override
  Future<int> run() async {
    final rawBatch = optionalOption('batch');
    final format = parseEnum(
      argResults?['format'] as String,
      ExportFormat.values,
      '--format',
    );
    final context = connect();
    final ExportFile file;
    try {
      file = await context.client.identity.export(
        batchId: rawBatch == null ? null : parseUuid(rawBatch, '--batch'),
        format: format,
      );
    } catch (error) {
      throw CliException('Could not export the units: ${describeError(error)}');
    }

    final out = optionalOption('out');
    if (out != null) {
      File(out).writeAsStringSync(file.content);
    }

    if (context.json) {
      printJson(<String, dynamic>{
        'filename': file.filename,
        'mimeType': file.mimeType,
        'rowCount': file.rowCount,
        'truncated': file.truncated,
        'path': out,
        if (out == null) 'content': file.content,
      });
      return 0;
    }

    if (out != null) {
      stdout.writeln(
        'Wrote ${file.rowCount} row(s) to $out '
        '(${file.filename}, ${file.mimeType}).',
      );
    } else {
      stdout.write(file.content);
      if (!file.content.endsWith('\n')) stdout.writeln();
    }
    if (file.truncated) {
      stdout.writeln(
        'Warning: the export stopped at the row limit. Filter by batch to get '
        'a complete file.',
      );
    }
    return 0;
  }
}

/// Locks a unit so it can no longer be verified as authentic.
class IdentitiesLockCommand extends CliCommand {
  IdentitiesLockCommand() {
    argParser
      ..addOption('identity', abbr: 'i', help: 'Identity id.')
      ..addOption('reason', abbr: 'r', help: 'Why the unit is locked.');
  }

  @override
  String get name => 'lock';

  @override
  String get description => 'Lock a serialized unit.';

  @override
  Future<int> run() async {
    final identityId = parseUuid(requiredOption('identity'), '--identity');
    final context = connect();
    final ProductIdentity identity;
    try {
      identity = await context.client.identity.lock(
        identityId: identityId,
        reason: optionalOption('reason'),
      );
    } catch (error) {
      throw CliException('Could not lock the unit: ${describeError(error)}');
    }

    if (context.json) {
      printJson(identity.toJson());
      return 0;
    }
    stdout.writeln('Locked ${identity.id?.uuid} (${identity.status.name}).');
    return 0;
  }
}

/// Lifts a lock after a false alarm.
class IdentitiesUnlockCommand extends CliCommand {
  IdentitiesUnlockCommand() {
    argParser
      ..addOption('identity', abbr: 'i', help: 'Identity id.')
      ..addOption('note', abbr: 'n', help: 'Why the lock is being lifted.');
  }

  @override
  String get name => 'unlock';

  @override
  String get description => 'Unlock a serialized unit.';

  @override
  Future<int> run() async {
    final identityId = parseUuid(requiredOption('identity'), '--identity');
    final context = connect();
    final ProductIdentity identity;
    try {
      identity = await context.client.identity.unlock(
        identityId: identityId,
        note: optionalOption('note'),
      );
    } catch (error) {
      throw CliException('Could not unlock the unit: ${describeError(error)}');
    }

    if (context.json) {
      printJson(identity.toJson());
      return 0;
    }
    stdout.writeln('Unlocked ${identity.id?.uuid} (${identity.status.name}).');
    return 0;
  }
}

/// Mints a replacement QR token for a unit that leaked or was reprinted.
class IdentitiesRegenerateCommand extends CliCommand {
  IdentitiesRegenerateCommand() {
    argParser
      ..addOption('identity', abbr: 'i', help: 'Identity id.')
      ..addOption(
        'reason',
        abbr: 'r',
        help: 'Why the token is being replaced.',
      );
  }

  @override
  String get name => 'regenerate';

  @override
  String get description => 'Issue a fresh QR token for a serialized unit.';

  @override
  Future<int> run() async {
    final identityId = parseUuid(requiredOption('identity'), '--identity');
    final context = connect();
    final ProductIdentity identity;
    try {
      identity = await context.client.identity.regenerateToken(
        identityId: identityId,
        reason: optionalOption('reason'),
      );
    } catch (error) {
      throw CliException(
        'Could not regenerate the token: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(identity.toJson());
      return 0;
    }
    stdout.writeln('The old code stops working; print the new one.');
    printIdentity(identity);
    return 0;
  }
}

/// Moves a unit to the recycle bin.
class IdentitiesDeleteCommand extends CliCommand {
  IdentitiesDeleteCommand() {
    argParser
      ..addOption('identity', abbr: 'i', help: 'Identity id.')
      ..addOption('reason', abbr: 'r', help: 'Why the unit is going away.');
  }

  @override
  String get name => 'delete';

  @override
  String get description => 'Delete a serialized unit into the recycle bin.';

  @override
  Future<int> run() async {
    final identityId = parseUuid(requiredOption('identity'), '--identity');
    final context = connect();
    final ProductIdentity identity;
    try {
      identity = await context.client.identity.delete(
        identityId: identityId,
        reason: optionalOption('reason'),
      );
    } catch (error) {
      throw CliException('Could not delete the unit: ${describeError(error)}');
    }

    if (context.json) {
      printJson(identity.toJson());
      return 0;
    }
    stdout.writeln('Deleted ${identity.id?.uuid}.');
    return 0;
  }
}

/// Brings a deleted unit back.
class IdentitiesRestoreCommand extends CliCommand {
  IdentitiesRestoreCommand() {
    argParser.addOption('identity', abbr: 'i', help: 'Identity id.');
  }

  @override
  String get name => 'restore';

  @override
  String get description => 'Restore a deleted serialized unit.';

  @override
  Future<int> run() async {
    final identityId = parseUuid(requiredOption('identity'), '--identity');
    final context = connect();
    final ProductIdentity identity;
    try {
      identity = await context.client.identity.restore(identityId: identityId);
    } catch (error) {
      throw CliException('Could not restore the unit: ${describeError(error)}');
    }

    if (context.json) {
      printJson(identity.toJson());
      return 0;
    }
    stdout.writeln('Restored ${identity.id?.uuid}.');
    return 0;
  }
}

/// Prints the fields a serialized unit carries.
void printIdentity(ProductIdentity identity) {
  stdout.writeln('  id:        ${identity.id?.uuid}');
  stdout.writeln('  batch:     ${identity.batchId.uuid}');
  stdout.writeln('  status:    ${identity.status.name}');
  stdout.writeln('  token:     ${shorten(identity.qrToken, max: 48)}');
  stdout.writeln('  scans:     ${identity.verificationCount}');
  stdout.writeln('  first:     ${formatTime(identity.firstVerifiedAt)}');
  stdout.writeln('  last:      ${formatTime(identity.lastVerifiedAt)}');
  stdout.writeln('  created:   ${formatTime(identity.createdAt)}');
  if (identity.failedPinAttempts > 0) {
    stdout.writeln('  failed PIN attempts: ${identity.failedPinAttempts}');
  }
  if (identity.lockedUntil != null) {
    stdout.writeln('  locked until: ${formatTime(identity.lockedUntil)}');
  }
  if (identity.recallReason != null) {
    stdout.writeln('  recall:    ${identity.recallReason}');
  }
  if (identity.deletedAt != null) {
    stdout.writeln('  deleted:   ${formatTime(identity.deletedAt)}');
  }
}
