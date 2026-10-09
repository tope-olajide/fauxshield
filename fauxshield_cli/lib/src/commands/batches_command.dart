import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield batches ...`
class BatchesCommand extends Command<int> {
  BatchesCommand() {
    addSubcommand(BatchesListCommand());
    addSubcommand(BatchesCreateCommand());
    addSubcommand(BatchesStatsCommand());
  }

  @override
  String get name => 'batches';

  @override
  String get description => 'List, create, and inspect manufacturing batches.';

  @override
  String get invocation => 'fauxshield batches <list|create|stats>';
}

/// Lists batches, optionally for one product.
class BatchesListCommand extends CliCommand {
  BatchesListCommand() {
    argParser.addOption(
      'product',
      abbr: 'p',
      help: 'Only batches for this product id.',
      valueHelp: '<uuid>',
    );
  }

  @override
  String get name => 'list';

  @override
  String get description => 'List batches in the workspace.';

  @override
  Future<int> run() async {
    final context = connect();
    final productId = argResults?['product'] as String?;
    final List<Batch> batches;
    try {
      batches = await context.client.batch.list(
        productId: productId == null || productId.isEmpty
            ? null
            : parseUuid(productId, '--product'),
      );
    } catch (error) {
      throw CliException('Could not list batches: ${describeError(error)}');
    }

    if (context.json) {
      printJson(batches.map((batch) => batch.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['REFERENCE', 'REGION', 'QTY', 'STATUS', 'MANUFACTURED', 'ID'],
      batches
          .map(
            (batch) => <String>[
              shorten(batch.reference, max: 22),
              shorten(batch.distributionRegion, max: 10),
              batch.quantity.toString(),
              batch.status.name,
              formatTime(batch.manufactureDate),
              batch.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${batches.length} batch(es).');
    return 0;
  }
}

/// Creates a batch.
class BatchesCreateCommand extends CliCommand {
  BatchesCreateCommand() {
    argParser
      ..addOption(
        'product',
        abbr: 'p',
        help: 'Product id this batch belongs to.',
        valueHelp: '<uuid>',
      )
      ..addOption(
        'reference',
        abbr: 'r',
        help: 'Batch reference, for example LOT-2026-04.',
      )
      ..addOption(
        'region',
        help: 'Declared distribution region. Drives leakage detection.',
        valueHelp: 'NG',
      )
      ..addOption(
        'quantity',
        abbr: 'q',
        help: 'Planned unit count.',
      )
      ..addOption(
        'manufacture-date',
        help: 'Manufacture date as YYYY-MM-DD. Defaults to today.',
      )
      ..addOption(
        'expiry-date',
        help: 'Optional expiry date as YYYY-MM-DD.',
      );
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Create a batch for a product.';

  @override
  Future<int> run() async {
    final quantity = int.tryParse(requiredOption('quantity'));
    if (quantity == null || quantity <= 0) {
      throw CliException.usage('--quantity must be a positive whole number.');
    }

    final productId = parseUuid(requiredOption('product'), '--product');
    final reference = requiredOption('reference');
    final region = requiredOption('region');
    final manufactureDate = _parseDate(
      argResults?['manufacture-date'] as String?,
      '--manufacture-date',
    );
    final expiryDate = _parseDate(
      argResults?['expiry-date'] as String?,
      '--expiry-date',
    );

    final context = connect();

    final Batch batch;
    try {
      batch = await context.client.batch.create(
        productId: productId,
        reference: reference,
        manufactureDate: manufactureDate ?? DateTime.now().toUtc(),
        expiryDate: expiryDate,
        distributionRegion: region,
        quantity: quantity,
      );
    } catch (error) {
      throw CliException('Could not create the batch: ${describeError(error)}');
    }

    if (context.json) {
      printJson(batch.toJson());
      return 0;
    }

    stdout.writeln('Created batch ${batch.reference}');
    stdout.writeln('  id:     ${batch.id?.uuid}');
    stdout.writeln('  region: ${batch.distributionRegion}');
    stdout.writeln('  qty:    ${batch.quantity}');
    stdout.writeln('\nMint its units with:');
    stdout.writeln(
      '  fauxshield identities generate --batch ${batch.id?.uuid} '
      '--quantity ${batch.quantity}',
    );
    return 0;
  }

  DateTime? _parseDate(String? value, String label) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value.trim());
    if (parsed == null) {
      throw CliException.usage('$label must look like YYYY-MM-DD.');
    }
    return parsed.toUtc();
  }
}

/// Shows the identity breakdown of a batch.
class BatchesStatsCommand extends CliCommand {
  BatchesStatsCommand() {
    argParser.addOption(
      'batch',
      abbr: 'b',
      help: 'Batch id.',
      mandatory: true,
      valueHelp: '<uuid>',
    );
  }

  @override
  String get name => 'stats';

  @override
  String get description => 'Show the identity counts for a batch.';

  @override
  Future<int> run() async {
    final batchId = parseUuid(requiredOption('batch'), '--batch');
    final context = connect();
    final BatchStats stats;
    try {
      stats = await context.client.batch.stats(batchId);
    } catch (error) {
      throw CliException('Could not read batch stats: ${describeError(error)}');
    }

    if (context.json) {
      printJson(stats.toJson());
      return 0;
    }

    printTable(
      <String>['TOTAL', 'ACTIVE', 'VERIFIED', 'LOCKED', 'RECALLED', 'FLAGGED'],
      <List<String>>[
        <String>[
          stats.totalIdentities.toString(),
          stats.active.toString(),
          stats.verified.toString(),
          stats.locked.toString(),
          stats.recalled.toString(),
          stats.flagged.toString(),
        ],
      ],
    );
    return 0;
  }
}
