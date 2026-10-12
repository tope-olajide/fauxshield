import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield alerts ...`
class AlertsCommand extends Command<int> {
  AlertsCommand() {
    addSubcommand(AlertsListCommand());
    addSubcommand(AlertsShowCommand());
    addSubcommand(AlertsStatusCommand());
    addSubcommand(AlertsAssignCommand());
    addSubcommand(AlertsSignalsCommand());
    addSubcommand(AlertsReportsCommand());
    addSubcommand(AlertsTriageCommand());
  }

  @override
  String get name => 'alerts';

  @override
  String get description => 'Read the fraud queue and an alert\'s evidence.';

  @override
  String get invocation =>
      'fauxshield alerts <list|show|status|assign|signals|reports|triage>';
}

/// Lists fraud alerts.
class AlertsListCommand extends CliCommand {
  AlertsListCommand() {
    argParser
      ..addOption(
        'status',
        abbr: 's',
        help: 'Filter by status: open, investigating, resolved, dismissed.',
      )
      ..addOption(
        'severity',
        abbr: 'S',
        help: 'Filter by severity: low, medium, high, critical.',
      )
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '20');
  }

  @override
  String get name => 'list';

  @override
  String get description => 'List fraud alerts.';

  @override
  Future<int> run() async {
    final context = connect();

    final rawStatus = (argResults?['status'] as String?)?.trim();
    final rawSeverity = (argResults?['severity'] as String?)?.trim();
    final page = int.tryParse((argResults?['page'] as String).trim()) ?? 1;
    final pageSize =
        int.tryParse((argResults?['page-size'] as String).trim()) ?? 20;

    final List<FraudAlert> alerts;
    try {
      alerts = await context.client.alert.list(
        status: rawStatus == null || rawStatus.isEmpty
            ? null
            : parseEnum(rawStatus, AlertStatus.values, '--status'),
        severity: rawSeverity == null || rawSeverity.isEmpty
            ? null
            : parseEnum(rawSeverity, AlertSeverity.values, '--severity'),
        // `--page` is 1 based for a human; the API counts from zero.
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 20 : pageSize,
      );
    } catch (error) {
      throw CliException('Could not list alerts: ${describeError(error)}');
    }

    if (context.json) {
      printJson(alerts.map((alert) => alert.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['SEVERITY', 'STATUS', 'TITLE', 'SIGNALS', 'CREATED', 'ID'],
      alerts
          .map(
            (alert) => <String>[
              alert.severity.name,
              alert.status.name,
              shorten(alert.title, max: 34),
              alert.signalTypes == null
                  ? '-'
                  : alert.signalTypes!.map((type) => type.name).join(','),
              formatTime(alert.createdAt),
              alert.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${alerts.length} alert(s) on page $page.');
    return 0;
  }
}

/// Shows one alert with its contributing signals.
class AlertsShowCommand extends CliCommand {
  AlertsShowCommand() {
    argParser.addOption(
      'alert',
      abbr: 'a',
      help: 'Alert id.',
      valueHelp: '<uuid>',
    );
  }

  @override
  String get name => 'show';

  @override
  String get description => 'Show an alert and the evidence behind it.';

  @override
  Future<int> run() async {
    final alertId = parseUuid(requiredOption('alert'), '--alert');
    final context = connect();
    final AlertEvidence evidence;
    try {
      evidence = await context.client.alert.evidence(alertId);
    } catch (error) {
      throw CliException('Could not read the alert: ${describeError(error)}');
    }

    if (context.json) {
      printJson(evidence.toJson());
      return 0;
    }

    final alert = evidence.alert;
    stdout.writeln(alert.title);
    stdout.writeln('  severity:   ${alert.severity.name}');
    stdout.writeln('  status:     ${alert.status.name}');
    stdout.writeln('  created:    ${formatTime(alert.createdAt)}');
    stdout.writeln('  autoLocked: ${yesNo(alert.autoLocked)}');
    stdout.writeln();
    stdout.writeln(alert.description);
    if (alert.recommendedAction != null) {
      stdout.writeln('\nRecommended: ${alert.recommendedAction}');
    }

    if (evidence.product != null) {
      stdout.writeln('\nProduct:  ${evidence.product!.name}');
    }
    if (evidence.batch != null) {
      stdout.writeln(
        'Batch:    ${evidence.batch!.reference} '
        '(${evidence.batch!.distributionRegion})',
      );
    }
    if (evidence.signals.isNotEmpty) {
      stdout.writeln('\nSignals:');
      for (final signal in evidence.signals) {
        stdout.writeln('  - ${signal.type.name} (${signal.severity.name})');
        for (final reason in _readReasons(signal.dataJson)) {
          stdout.writeln('      $reason');
        }
      }
    }
    stdout.writeln('\n${evidence.sessions.length} session(s) in evidence.');
    return 0;
  }

  /// Signal details are stored as a JSON blob, with the reasons under
  /// `reasons`. Anything unexpected is ignored rather than crashing the
  /// report.
  static List<String> _readReasons(String dataJson) {
    try {
      final decoded = jsonDecode(dataJson);
      if (decoded is Map<String, dynamic>) {
        final reasons = decoded['reasons'];
        if (reasons is List) {
          return reasons.map((reason) => reason.toString()).toList();
        }
      }
    } on FormatException {
      return const <String>[];
    }
    return const <String>[];
  }
}

/// Moves an alert through the triage queue.
class AlertsStatusCommand extends CliCommand {
  AlertsStatusCommand() {
    argParser
      ..addOption('alert', abbr: 'a', help: 'Alert id.')
      ..addOption(
        'status',
        abbr: 's',
        help: 'New status: open, investigating, resolved, dismissed.',
      )
      ..addOption('note', abbr: 'n', help: 'Note kept with the change.');
  }

  @override
  String get name => 'status';

  @override
  String get description => 'Change an alert status.';

  @override
  Future<int> run() async {
    final alertId = parseUuid(requiredOption('alert'), '--alert');
    final status = parseEnum(
      requiredOption('status'),
      AlertStatus.values,
      '--status',
    );
    final context = connect();
    final FraudAlert alert;
    try {
      alert = await context.client.alert.updateStatus(
        alertId: alertId,
        status: status,
        note: optionalOption('note'),
      );
    } catch (error) {
      throw CliException(
        'Could not update the alert: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(alert.toJson());
      return 0;
    }
    stdout.writeln('${alert.title} is now ${alert.status.name}.');
    return 0;
  }
}

/// Hands an alert to a person.
class AlertsAssignCommand extends CliCommand {
  AlertsAssignCommand() {
    argParser
      ..addOption('alert', abbr: 'a', help: 'Alert id.')
      ..addOption(
        'assignee',
        help: 'Email or name of the operator taking the alert.',
      )
      ..addFlag(
        'clear',
        negatable: false,
        help: 'Unassign instead of assigning.',
      );
  }

  @override
  String get name => 'assign';

  @override
  String get description => 'Assign or unassign an alert.';

  @override
  Future<int> run() async {
    final alertId = parseUuid(requiredOption('alert'), '--alert');
    final assignee = optionalOption('assignee');
    final clear = argResults?['clear'] as bool? ?? false;
    if (assignee == null && !clear) {
      throw CliException.usage(
        'Pass --assignee <email>, or --clear to take the alert off its owner.',
      );
    }

    final context = connect();
    final FraudAlert alert;
    try {
      alert = await context.client.alert.assign(
        alertId: alertId,
        assignee: clear ? null : assignee,
      );
    } catch (error) {
      throw CliException(
        'Could not assign the alert: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(alert.toJson());
      return 0;
    }
    stdout.writeln(
      clear
          ? 'Cleared the assignee on ${alert.title}.'
          : 'Assigned ${alert.title} to ${alert.assignee ?? assignee}.',
    );
    return 0;
  }
}

/// Reads the raw fraud signals behind the alerts.
class AlertsSignalsCommand extends CliCommand {
  AlertsSignalsCommand() {
    argParser
      ..addOption('batch', abbr: 'b', help: 'Only signals for this batch.')
      ..addOption(
        'type',
        abbr: 't',
        help: 'Filter by signal type, for example impossibleTravel.',
      )
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '25');
  }

  @override
  String get name => 'signals';

  @override
  String get description => 'List the fraud signals the engine raised.';

  @override
  Future<int> run() async {
    final rawBatch = optionalOption('batch');
    final rawType = optionalOption('type');
    final page = int.tryParse(argResults?['page'] as String? ?? '1') ?? 1;
    final pageSize =
        int.tryParse(argResults?['page-size'] as String? ?? '25') ?? 25;
    final context = connect();

    final List<FraudSignalRecord> signals;
    try {
      signals = await context.client.alert.signals(
        batchId: rawBatch == null ? null : parseUuid(rawBatch, '--batch'),
        type: rawType == null || rawType.isEmpty
            ? null
            : parseEnum(rawType, SignalType.values, '--type'),
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 25 : pageSize,
      );
    } catch (error) {
      throw CliException(
        'Could not list signals: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(signals.map((signal) => signal.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['TYPE', 'RISK', 'IDENTITY', 'BATCH', 'DETECTED'],
      signals
          .map(
            (signal) => <String>[
              signal.type.name,
              signal.severity.name,
              signal.identityId.uuid,
              signal.batchId.uuid,
              formatTime(signal.detectedAt),
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${signals.length} signal(s) on page $page.');
    return 0;
  }
}

/// Reads what shoppers reported as fake.
class AlertsReportsCommand extends CliCommand {
  AlertsReportsCommand() {
    argParser
      ..addOption(
        'status',
        abbr: 's',
        help: 'Filter by status: open, triaged, rejected.',
      )
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '25');
  }

  @override
  String get name => 'reports';

  @override
  String get description => 'List shopper fake-product reports.';

  @override
  Future<int> run() async {
    final rawStatus = optionalOption('status');
    final page = int.tryParse(argResults?['page'] as String? ?? '1') ?? 1;
    final pageSize =
        int.tryParse(argResults?['page-size'] as String? ?? '25') ?? 25;
    final context = connect();

    final List<FakeReport> reports;
    try {
      reports = await context.client.alert.reports(
        status: rawStatus == null || rawStatus.isEmpty
            ? null
            : parseEnum(rawStatus, FakeReportStatus.values, '--status'),
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 25 : pageSize,
      );
    } catch (error) {
      throw CliException(
        'Could not list reports: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(reports.map((report) => report.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['STATUS', 'REASON', 'IDENTITY', 'PLACE', 'CREATED'],
      reports
          .map(
            (report) => <String>[
              report.status.name,
              shorten(report.reason, max: 26),
              report.identityId.uuid,
              shorten(
                <String?>[
                  report.city,
                  report.country,
                ].whereType<String>().join(', '),
                max: 18,
              ),
              formatTime(report.createdAt),
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${reports.length} report(s) on page $page.');
    return 0;
  }
}

/// Closes or rejects a shopper report.
class AlertsTriageCommand extends CliCommand {
  AlertsTriageCommand() {
    argParser
      ..addOption('report', abbr: 'r', help: 'Report id.')
      ..addOption(
        'status',
        abbr: 's',
        help: 'New status: triaged or rejected.',
      )
      ..addOption('note', abbr: 'n', help: 'Note kept with the decision.');
  }

  @override
  String get name => 'triage';

  @override
  String get description => 'Triage a shopper fake-product report.';

  @override
  Future<int> run() async {
    final reportId = parseUuid(requiredOption('report'), '--report');
    final status = parseEnum(
      requiredOption('status'),
      FakeReportStatus.values,
      '--status',
    );
    final context = connect();
    final FakeReport report;
    try {
      report = await context.client.alert.triageReport(
        reportId: reportId,
        status: status,
        note: optionalOption('note'),
      );
    } catch (error) {
      throw CliException(
        'Could not triage the report: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(report.toJson());
      return 0;
    }
    stdout.writeln('Report ${report.id?.uuid} is now ${report.status.name}.');
    return 0;
  }
}
