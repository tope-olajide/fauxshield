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
  }

  @override
  String get name => 'alerts';

  @override
  String get description => 'Read the fraud queue and an alert\'s evidence.';

  @override
  String get invocation => 'fauxshield alerts <list|show>';
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
  /// `reasons`. Anything unexpected is ignored rather than crashing the report.
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
