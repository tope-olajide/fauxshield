import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield verifications ...`
class VerificationsCommand extends Command<int> {
  VerificationsCommand() {
    addSubcommand(VerificationsListCommand());
    addSubcommand(VerificationsShowCommand());
  }

  @override
  String get name => 'verifications';

  @override
  String get description => 'Read what shoppers scanned and what came back.';

  @override
  String get invocation => 'fauxshield verifications <list|show>';
}

/// Lists verification sessions.
class VerificationsListCommand extends CliCommand {
  VerificationsListCommand() {
    argParser
      ..addOption('identity', abbr: 'i', help: 'Only scans of this unit.')
      ..addOption('batch', abbr: 'b', help: 'Only scans in this batch.')
      ..addOption('product', abbr: 'p', help: 'Only scans of this product.')
      ..addOption(
        'state',
        abbr: 's',
        help: 'Filter by state, for example authentic or fraudSuspected.',
      )
      ..addOption('outcome', help: 'Filter by outcome.')
      ..addOption(
        'risk',
        abbr: 'r',
        help: 'Filter by risk score: low, medium, high, critical.',
      )
      ..addOption(
        'source',
        help: 'Filter by scan source, for example consumerWeb.',
      )
      ..addOption(
        'from',
        help: 'Only scans on or after this date (YYYY-MM-DD).',
      )
      ..addOption('to', help: 'Only scans up to this date (YYYY-MM-DD).')
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '25');
  }

  @override
  String get name => 'list';

  @override
  String get description => 'List verification sessions, newest first.';

  @override
  Future<int> run() async {
    final rawIdentity = optionalOption('identity');
    final rawBatch = optionalOption('batch');
    final rawProduct = optionalOption('product');
    final rawState = optionalOption('state');
    final rawOutcome = optionalOption('outcome');
    final rawRisk = optionalOption('risk');
    final rawSource = optionalOption('source');
    final page = int.tryParse(argResults?['page'] as String? ?? '1') ?? 1;
    final pageSize =
        int.tryParse(argResults?['page-size'] as String? ?? '25') ?? 25;
    final context = connect();

    final List<VerificationSession> sessions;
    try {
      sessions = await context.client.verification.list(
        identityId: rawIdentity == null
            ? null
            : parseUuid(rawIdentity, '--identity'),
        batchId: rawBatch == null ? null : parseUuid(rawBatch, '--batch'),
        productId: rawProduct == null
            ? null
            : parseUuid(rawProduct, '--product'),
        state: rawState == null || rawState.isEmpty
            ? null
            : parseEnum(rawState, VerificationState.values, '--state'),
        outcome: rawOutcome == null || rawOutcome.isEmpty
            ? null
            : parseEnum(rawOutcome, VerificationOutcome.values, '--outcome'),
        riskScore: rawRisk == null || rawRisk.isEmpty
            ? null
            : parseEnum(rawRisk, RiskScore.values, '--risk'),
        source: rawSource == null || rawSource.isEmpty
            ? null
            : parseEnum(rawSource, ScanSource.values, '--source'),
        from: optionalDate('from', '--from'),
        to: optionalDate('to', '--to'),
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 25 : pageSize,
      );
    } catch (error) {
      throw CliException('Could not list scans: ${describeError(error)}');
    }

    if (context.json) {
      printJson(sessions.map((session) => session.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['WHEN', 'STATE', 'OUTCOME', 'RISK', 'PLACE', 'SOURCE'],
      sessions
          .map(
            (session) => <String>[
              formatTime(session.createdAt),
              session.state.name,
              session.outcome?.name ?? '-',
              session.riskScore?.name ?? '-',
              shorten(
                <String?>[
                  session.city,
                  session.country,
                ].whereType<String>().join(', '),
                max: 20,
              ),
              session.source.name,
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${sessions.length} scan(s) on page $page.');
    return 0;
  }
}

/// Shows one verification session.
class VerificationsShowCommand extends CliCommand {
  VerificationsShowCommand() {
    argParser.addOption(
      'session',
      abbr: 's',
      help: 'Verification session id.',
      valueHelp: '<uuid>',
    );
  }

  @override
  String get name => 'show';

  @override
  String get description => 'Show one scan with its device and location.';

  @override
  Future<int> run() async {
    final sessionId = parseUuid(requiredOption('session'), '--session');
    final context = connect();
    final VerificationSession session;
    try {
      session = await context.client.verification.get(sessionId);
    } catch (error) {
      throw CliException('Could not read the scan: ${describeError(error)}');
    }

    if (context.json) {
      printJson(session.toJson());
      return 0;
    }

    stdout.writeln('  id:      ${session.id?.uuid}');
    stdout.writeln('  state:   ${session.state.name}');
    stdout.writeln('  outcome: ${session.outcome?.name ?? '-'}');
    stdout.writeln('  risk:    ${session.riskScore?.name ?? '-'}');
    stdout.writeln('  source:  ${session.source.name}');
    stdout.writeln('  when:    ${formatTime(session.createdAt)}');
    stdout.writeln('  identity: ${session.identityId.uuid}');
    stdout.writeln('  country: ${session.country ?? '-'}');
    stdout.writeln('  city:    ${session.city ?? '-'}');
    if (session.latitude != null && session.longitude != null) {
      stdout.writeln(
        '  coords:  ${session.latitude}, ${session.longitude}',
      );
    }
    if (session.offlineScanId != null) {
      stdout.writeln('  offline: ${session.offlineScanId}');
    }
    if (session.simulationId != null) {
      stdout.writeln('  simulated by ${session.simulationId}');
    }
    return 0;
  }
}
