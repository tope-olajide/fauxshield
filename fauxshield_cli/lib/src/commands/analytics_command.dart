import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield analytics ...`
class AnalyticsCommand extends Command<int> {
  AnalyticsCommand() {
    addSubcommand(AnalyticsDashboardCommand());
    addSubcommand(AnalyticsRollupCommand());
  }

  @override
  String get name => 'analytics';

  @override
  String get description => 'Read the numbers the command center shows.';

  @override
  String get invocation => 'fauxshield analytics <dashboard|rollup>';
}

/// Prints the dashboard summary.
class AnalyticsDashboardCommand extends CliCommand {
  AnalyticsDashboardCommand() {
    argParser.addOption(
      'window',
      abbr: 'w',
      help: 'How many days back to count.',
      defaultsTo: '14',
    );
  }

  @override
  String get name => 'dashboard';

  @override
  String get description => 'Show verification and fraud totals for a window.';

  @override
  Future<int> run() async {
    final window = int.tryParse(argResults?['window'] as String? ?? '14') ?? 14;
    final context = connect();
    final DashboardSummary summary;
    try {
      summary = await context.client.analytics.dashboard(
        windowDays: window < 1 ? 14 : window,
      );
    } catch (error) {
      throw CliException(
        'Could not read the dashboard: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(summary.toJson());
      return 0;
    }

    stdout.writeln('Last ${summary.windowDays} day(s)');
    printTable(
      <String>['METRIC', 'VALUE'],
      <List<String>>[
        <String>['Verifications', summary.totalVerifications.toString()],
        <String>['Authentic', summary.authentic.toString()],
        <String>['Already verified', summary.alreadyVerified.toString()],
        <String>['Invalid PIN', summary.invalidPin.toString()],
        <String>['Fraud suspected', summary.fraudSuspected.toString()],
        <String>['High risk', summary.highRisk.toString()],
        <String>['Recalled scans', summary.recalled.toString()],
        <String>['Open alerts', summary.openAlerts.toString()],
        <String>['Critical alerts', summary.criticalAlerts.toString()],
      ],
    );

    stdout.writeln('\nCatalogue');
    printTable(
      <String>['METRIC', 'VALUE'],
      <List<String>>[
        <String>['Products', summary.productsTotal.toString()],
        <String>['Batches', summary.batchesTotal.toString()],
        <String>['Identities', summary.identitiesTotal.toString()],
        <String>['Locked units', summary.identitiesLocked.toString()],
        <String>['Recalled units', summary.identitiesRecalled.toString()],
      ],
    );

    if (summary.topCountries.isNotEmpty) {
      stdout.writeln('\nTop countries');
      printTable(
        <String>['COUNTRY', 'SCANS', 'FLAGGED'],
        summary.topCountries
            .map(
              (country) => <String>[
                country.countryCode == null
                    ? country.country
                    : '${country.countryCode} ${country.country}',
                country.verifications.toString(),
                country.fraud.toString(),
              ],
            )
            .toList(),
      );
    }

    if (summary.recentAlerts.isNotEmpty) {
      stdout.writeln('\nRecent alerts');
      printTable(
        <String>['SEVERITY', 'STATUS', 'TITLE', 'CREATED'],
        summary.recentAlerts
            .map(
              (alert) => <String>[
                alert.severity.name,
                alert.status.name,
                shorten(alert.title, max: 40),
                formatTime(alert.createdAt),
              ],
            )
            .toList(),
      );
    }
    return 0;
  }
}

/// Recomputes one day of rolled up statistics.
class AnalyticsRollupCommand extends CliCommand {
  AnalyticsRollupCommand() {
    argParser.addOption(
      'day',
      abbr: 'd',
      help: 'Day to recompute, as YYYY-MM-DD. Defaults to today.',
    );
  }

  @override
  String get name => 'rollup';

  @override
  String get description => 'Recompute the daily statistics for one day.';

  @override
  Future<int> run() async {
    final context = connect();
    final DailyWorkspaceStat stat;
    try {
      stat = await context.client.analytics.rollupNow(
        day: optionalDate('day', '--day'),
      );
    } catch (error) {
      throw CliException(
        'Could not roll up the day: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(stat.toJson());
      return 0;
    }

    stdout.writeln('Rolled up ${formatTime(stat.date)}');
    printTable(
      <String>['METRIC', 'VALUE'],
      <List<String>>[
        <String>['Verifications', stat.verifications.toString()],
        <String>['Authentic', stat.authentic.toString()],
        <String>['Already verified', stat.alreadyVerified.toString()],
        <String>['Invalid PIN', stat.invalidPin.toString()],
        <String>['Fraud suspected', stat.fraudSuspected.toString()],
        <String>['High risk', stat.highRisk.toString()],
        <String>['Alerts created', stat.alertsCreated.toString()],
        <String>['Alerts resolved', stat.alertsResolved.toString()],
      ],
    );
    return 0;
  }
}
