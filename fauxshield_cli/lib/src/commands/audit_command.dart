import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield audit ...`
class AuditCommand extends Command<int> {
  AuditCommand() {
    addSubcommand(AuditListCommand());
  }

  @override
  String get name => 'audit';

  @override
  String get description => 'Read the tamper-evident audit log.';

  @override
  String get invocation => 'fauxshield audit <list>';
}

/// Lists audit events.
class AuditListCommand extends CliCommand {
  AuditListCommand() {
    argParser
      ..addOption(
        'action',
        abbr: 'a',
        help: 'Filter by action, for example identity.locked.',
      )
      ..addOption(
        'actor',
        help: 'Filter by the user or key that acted.',
      )
      ..addOption('target-type', help: 'Filter by target type, such as batch.')
      ..addOption('target', help: 'Filter by target id.')
      ..addOption(
        'from',
        help: 'Only events on or after this date (YYYY-MM-DD).',
      )
      ..addOption('to', help: 'Only events up to this date (YYYY-MM-DD).')
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '50')
      ..addFlag(
        'full',
        negatable: false,
        help: 'Print the whole metadata blob instead of trimming it.',
      );
  }

  @override
  String get name => 'list';

  @override
  String get description => 'List audit events, newest first.';

  @override
  Future<int> run() async {
    final rawTarget = optionalOption('target');
    final page = int.tryParse(argResults?['page'] as String? ?? '1') ?? 1;
    final pageSize =
        int.tryParse(argResults?['page-size'] as String? ?? '50') ?? 50;
    final context = connect();

    final List<AuditEvent> events;
    try {
      events = await context.client.audit.query(
        action: optionalOption('action'),
        actorIdentifier: optionalOption('actor'),
        targetType: optionalOption('target-type'),
        targetId: rawTarget == null ? null : parseUuid(rawTarget, '--target'),
        from: optionalDate('from', '--from'),
        to: optionalDate('to', '--to'),
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 50 : pageSize,
      );
    } catch (error) {
      throw CliException(
        'Could not read the audit log: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(events.map((event) => event.toJson()).toList());
      return 0;
    }

    final full = argResults?['full'] as bool? ?? false;
    printTable(
      <String>['WHEN', 'ACTOR', 'ACTION', 'TARGET', 'DETAILS'],
      events
          .map(
            (event) => <String>[
              formatTime(event.createdAt),
              shorten(event.actorIdentifier ?? event.actorType.name, max: 22),
              shorten(event.action, max: 26),
              shorten(event.targetId?.uuid ?? event.targetType, max: 20),
              full
                  ? shorten(event.metadataJson ?? '', max: 400)
                  : shorten(_summarize(event.metadataJson), max: 40),
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${events.length} event(s) on page $page.');
    return 0;
  }

  /// Renders the metadata blob as `key=value` pairs for a table cell.
  ///
  /// The column is nullable on the wire, and a missing blob renders as empty.
  static String _summarize(String? metadataJson) {
    if (metadataJson == null) return '';
    try {
      final decoded = jsonDecode(metadataJson);
      if (decoded is Map && decoded.isNotEmpty) {
        return decoded.entries
            .map((entry) => '${entry.key}=${entry.value}')
            .join(' ');
      }
    } on FormatException {
      return metadataJson;
    }
    return '';
  }
}
