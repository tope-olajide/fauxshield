import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield recalls ...`
class RecallsCommand extends Command<int> {
  RecallsCommand() {
    addSubcommand(RecallsListCommand());
    addSubcommand(RecallsIssueCommand());
    addSubcommand(RecallsLiftCommand());
  }

  @override
  String get name => 'recalls';

  @override
  String get description => 'Issue and lift product recalls.';

  @override
  String get invocation => 'fauxshield recalls <list|issue|lift>';
}

/// Lists recall records.
class RecallsListCommand extends CliCommand {
  RecallsListCommand() {
    argParser.addFlag(
      'lifted',
      negatable: false,
      help: 'Include recalls that have been lifted.',
    );
  }

  @override
  String get name => 'list';

  @override
  String get description => 'List recalls, newest first.';

  @override
  Future<int> run() async {
    final context = connect();
    final List<RecallRecord> recalls;
    try {
      recalls = await context.client.recall.list(
        includeLifted: argResults?['lifted'] as bool? ?? false,
      );
    } catch (error) {
      throw CliException('Could not list recalls: ${describeError(error)}');
    }

    if (context.json) {
      printJson(recalls.map((recall) => recall.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['SCOPE', 'REASON', 'TARGET', 'ISSUED', 'LIFTED', 'ID'],
      recalls
          .map(
            (recall) => <String>[
              recall.scope.name,
              shorten(recall.reason, max: 26),
              shorten(
                recall.identityId?.uuid ?? recall.batchId.uuid,
                max: 36,
              ),
              formatTime(recall.issuedAt),
              recall.lifted ? formatTime(recall.liftedAt) : 'no',
              recall.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${recalls.length} recall(s).');
    return 0;
  }
}

/// Recalls a batch or a single serialized unit.
class RecallsIssueCommand extends CliCommand {
  RecallsIssueCommand() {
    argParser
      ..addOption('batch', abbr: 'b', help: 'Recall this batch.')
      ..addOption('identity', abbr: 'i', help: 'Recall this single unit.')
      ..addOption(
        'reason',
        abbr: 'r',
        help: 'Why the products are being recalled. Shown to shoppers.',
      )
      ..addOption('notes', help: 'Internal notes for the team.');
  }

  @override
  String get name => 'issue';

  @override
  String get description => 'Recall a batch or a single serialized unit.';

  @override
  Future<int> run() async {
    final rawBatch = optionalOption('batch');
    final rawIdentity = optionalOption('identity');
    if (rawBatch == null && rawIdentity == null) {
      throw CliException.usage(
        'Pass the target with --batch <uuid> or --identity <uuid>.',
      );
    }
    if (rawBatch != null && rawIdentity != null) {
      throw CliException.usage(
        'Pass either --batch or --identity, not both.',
      );
    }

    final reason = requiredOption('reason');
    final context = connect();

    final RecallResult result;
    try {
      result = rawBatch != null
          ? await context.client.recall.recallBatch(
              batchId: parseUuid(rawBatch, '--batch'),
              reason: reason,
              notes: optionalOption('notes'),
            )
          : await context.client.recall.recallIdentity(
              identityId: parseUuid(rawIdentity!, '--identity'),
              reason: reason,
              notes: optionalOption('notes'),
            );
    } catch (error) {
      throw CliException('Could not issue the recall: ${describeError(error)}');
    }

    if (context.json) {
      printJson(result.toJson());
      return 0;
    }

    stdout.writeln(
      'Recalled ${result.affected} serialized unit(s) '
      '(${result.recall.scope.name} ${result.recall.id?.uuid}).',
    );
    stdout.writeln(
      'Shoppers who scan those codes now see the recall reason instead of a '
      'clean result.',
    );
    return 0;
  }
}

/// Marks a recall as over.
class RecallsLiftCommand extends CliCommand {
  RecallsLiftCommand() {
    argParser
      ..addOption('recall', abbr: 'r', help: 'Recall id.')
      ..addOption('note', abbr: 'n', help: 'Why the recall is being lifted.');
  }

  @override
  String get name => 'lift';

  @override
  String get description => 'Lift a recall once the problem is resolved.';

  @override
  Future<int> run() async {
    final recallId = parseUuid(requiredOption('recall'), '--recall');
    final context = connect();
    final RecallResult result;
    try {
      result = await context.client.recall.lift(
        recallId: recallId,
        note: optionalOption('note'),
      );
    } catch (error) {
      throw CliException('Could not lift the recall: ${describeError(error)}');
    }

    if (context.json) {
      printJson(result.toJson());
      return 0;
    }
    stdout.writeln(
      'Lifted recall $recallId; ${result.affected} unit(s) verify normally '
      'again.',
    );
    return 0;
  }
}
