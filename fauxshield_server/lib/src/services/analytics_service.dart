import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'recall_service.dart';

/// Dashboard analytics.
///
/// * Daily rollups are materialized by a recurring scheduled task, so the
///   command center stays fast even with large verification volumes.
/// * Until the current day is rolled up, the summary reads raw sessions for
///   that day so the dashboard is never stale.
/// * Alert evidence assembles everything an investigator needs in one call:
///   the alert, the identity, batch and product, every related session,
///   detected signals, consumer reports, and recall history.
abstract final class AnalyticsService {
  /// Builds the operator dashboard payload for the last [windowDays] days.
  static Future<DashboardSummary> dashboard(
    Session session, {
    required UuidValue workspaceId,
    int windowDays = 14,
  }) async {
    final days = windowDays.clamp(1, 90);
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final windowStart = today.subtract(Duration(days: days - 1));

    final rollups = await DailyWorkspaceStat.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          (t.date >= windowStart) &
          (t.date <= today),
      orderBy: (t) => t.date,
    );

    var verifications = 0;
    var authentic = 0;
    var alreadyVerified = 0;
    var invalidPin = 0;
    var fraudSuspected = 0;
    var highRisk = 0;
    var recalled = 0;
    final trend = <TrendPoint>[];
    final countryTotals = <String, CountryStat>{};
    var rolledUpThrough = windowStart.subtract(const Duration(days: 1));

    for (final rollup in rollups) {
      verifications += rollup.verifications;
      authentic += rollup.authentic;
      alreadyVerified += rollup.alreadyVerified;
      invalidPin += rollup.invalidPin;
      fraudSuspected += rollup.fraudSuspected;
      highRisk += rollup.highRisk;
      recalled += rollup.recalled;
      if (rollup.date.isAfter(rolledUpThrough)) {
        rolledUpThrough = rollup.date;
      }
      trend.add(
        TrendPoint(
          date: rollup.date,
          verifications: rollup.verifications,
          fraud: rollup.fraudSuspected + rollup.highRisk,
        ),
      );
      final countriesJson = rollup.topCountriesJson;
      if (countriesJson != null) {
        _mergeCountries(countryTotals, countriesJson);
      }
    }

    // Today (and any gap after the last rollup) is read live so the dashboard
    // always reflects the latest scans.
    final liveFrom = rolledUpThrough.add(const Duration(days: 1));
    if (!liveFrom.isAfter(today)) {
      final live = await _liveWindow(session, workspaceId, liveFrom, today);
      verifications += live.verifications;
      authentic += live.authentic;
      alreadyVerified += live.alreadyVerified;
      invalidPin += live.invalidPin;
      fraudSuspected += live.fraudSuspected;
      highRisk += live.highRisk;
      recalled += live.recalled;
      for (final point in live.trend) {
        trend.add(point);
      }
      for (final entry in live.countries.entries) {
        _mergeCountry(countryTotals, entry.value);
      }
    }

    trend.sort((a, b) => a.date.compareTo(b.date));

    final openAlerts = await FraudAlert.db.count(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          (t.status.equals(AlertStatus.open) |
              t.status.equals(AlertStatus.investigating)),
    );
    final criticalAlerts = await FraudAlert.db.count(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.severity.equals(AlertSeverity.critical) &
          (t.status.equals(AlertStatus.open) |
              t.status.equals(AlertStatus.investigating)),
    );

    final identitiesTotal = await ProductIdentity.db.count(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) & t.deletedAt.equals(null),
    );
    final identitiesLocked = await ProductIdentity.db.count(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.deletedAt.equals(null) &
          t.status.equals(IdentityStatus.locked),
    );
    final identitiesRecalled = await ProductIdentity.db.count(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.deletedAt.equals(null) &
          t.status.equals(IdentityStatus.recalled),
    );
    final batchesTotal = await Batch.db.count(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
    final productsTotal = await Product.db.count(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.archivedAt.equals(null) &
          t.deletedAt.equals(null),
    );

    final recentAlerts = await FraudAlert.db.find(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
      orderBy: (t) => t.createdAt.desc(),
      limit: 8,
    );

    final outcomes = <OutcomeBreakdown>[
      OutcomeBreakdown(
        outcome: VerificationOutcome.authentic,
        count: authentic,
      ),
      OutcomeBreakdown(
        outcome: VerificationOutcome.alreadyVerified,
        count: alreadyVerified,
      ),
      OutcomeBreakdown(
        outcome: VerificationOutcome.invalidPin,
        count: invalidPin,
      ),
      OutcomeBreakdown(
        outcome: VerificationOutcome.fraudSuspected,
        count: fraudSuspected,
      ),
      OutcomeBreakdown(outcome: VerificationOutcome.highRisk, count: highRisk),
      OutcomeBreakdown(outcome: VerificationOutcome.recalled, count: recalled),
    ];

    final countries = countryTotals.values.toList()
      ..sort((a, b) => b.verifications.compareTo(a.verifications));

    return DashboardSummary(
      windowDays: days,
      totalVerifications: verifications,
      authentic: authentic,
      alreadyVerified: alreadyVerified,
      invalidPin: invalidPin,
      fraudSuspected: fraudSuspected,
      highRisk: highRisk,
      recalled: recalled,
      openAlerts: openAlerts,
      criticalAlerts: criticalAlerts,
      identitiesTotal: identitiesTotal,
      identitiesLocked: identitiesLocked,
      identitiesRecalled: identitiesRecalled,
      batchesTotal: batchesTotal,
      productsTotal: productsTotal,
      trend: trend,
      topCountries: countries.take(8).toList(),
      outcomes: outcomes,
      recentAlerts: recentAlerts,
      generatedAt: DateTime.now().toUtc(),
    );
  }

  /// Recomputes the rollup for one UTC day and upserts it.
  ///
  /// Returns the stored row. The recurring task calls this for today (and
  /// yesterday, to absorb late writes).
  static Future<DailyWorkspaceStat> rollupDay(
    Session session, {
    required UuidValue workspaceId,
    required DateTime day,
  }) async {
    final start = DateTime.utc(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    final sessions = await VerificationSession.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          (t.createdAt >= start) &
          (t.createdAt < end),
      limit: 200000,
    );

    var authentic = 0;
    var alreadyVerified = 0;
    var invalidPin = 0;
    var fraudSuspected = 0;
    var highRisk = 0;
    var recalled = 0;
    final countries = <String, CountryStat>{};

    for (final item in sessions) {
      switch (item.outcome) {
        case VerificationOutcome.authentic:
          authentic++;
        case VerificationOutcome.alreadyVerified:
          alreadyVerified++;
        case VerificationOutcome.invalidPin:
          invalidPin++;
        case VerificationOutcome.fraudSuspected:
          fraudSuspected++;
        case VerificationOutcome.highRisk:
          highRisk++;
        case VerificationOutcome.recalled:
          recalled++;
        case null:
          break;
      }
      final country = item.country;
      if (country != null && country.isNotEmpty) {
        final key = item.countryCode ?? country.toUpperCase();
        final existing = countries[key];
        final isFraud =
            item.outcome == VerificationOutcome.fraudSuspected ||
            item.outcome == VerificationOutcome.highRisk;
        countries[key] = CountryStat(
          country: existing?.country ?? country,
          countryCode: item.countryCode,
          verifications: (existing?.verifications ?? 0) + 1,
          fraud: (existing?.fraud ?? 0) + (isFraud ? 1 : 0),
        );
      }
    }

    final alertsCreated = await FraudAlert.db.count(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          (t.createdAt >= start) &
          (t.createdAt < end),
    );
    final alertsResolved = await FraudAlert.db.count(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.resolvedAt.notEquals(null) &
          (t.resolvedAt >= start) &
          (t.resolvedAt < end),
    );

    final ranked = countries.values.toList()
      ..sort((a, b) => b.verifications.compareTo(a.verifications));
    final countriesJson = ranked.isEmpty
        ? null
        : jsonEncode(ranked.take(12).map((stat) => stat.toJson()).toList());

    final existing = await DailyWorkspaceStat.db.findFirstRow(
      session,
      where: (t) => t.workspaceId.equals(workspaceId) & t.date.equals(start),
    );

    final row = DailyWorkspaceStat(
      id: existing?.id,
      workspaceId: workspaceId,
      date: start,
      verifications: sessions.length,
      authentic: authentic,
      alreadyVerified: alreadyVerified,
      invalidPin: invalidPin,
      fraudSuspected: fraudSuspected,
      highRisk: highRisk,
      recalled: recalled,
      alertsCreated: alertsCreated,
      alertsResolved: alertsResolved,
      topCountriesJson: countriesJson,
      createdAt: existing?.createdAt ?? DateTime.now().toUtc(),
    );
    if (existing == null) {
      return DailyWorkspaceStat.db.insertRow(session, row);
    }
    return DailyWorkspaceStat.db.updateRow(session, row);
  }

  /// Everything needed to understand one alert in a single call.
  static Future<AlertEvidence> evidence(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue alertId,
  }) async {
    final alert = await FraudAlert.db.findById(session, alertId);
    if (alert == null || alert.workspaceId != workspaceId) {
      throw NotFoundException(message: 'Alert not found.', resource: 'alert');
    }

    ProductIdentity? identity;
    if (alert.identityId != null) {
      identity = await ProductIdentity.db.findById(session, alert.identityId!);
    }
    Batch? batch;
    final batchId = alert.batchId ?? identity?.batchId;
    if (batchId != null) {
      batch = await Batch.db.findById(session, batchId);
    }
    Product? product;
    if (batch != null) {
      product = await Product.db.findById(session, batch.productId);
    }

    final sessions = <VerificationSession>[];
    if (alert.sessionId != null) {
      final sessionRow = await VerificationSession.db.findById(
        session,
        alert.sessionId!,
      );
      if (sessionRow != null) sessions.add(sessionRow);
    }

    var identitySessions = <VerificationSession>[];
    if (alert.identityId != null) {
      identitySessions = await VerificationSession.db.find(
        session,
        where: (t) => t.identityId.equals(alert.identityId!),
        orderBy: (t) => t.createdAt.desc(),
        limit: 50,
      );
    }

    final signals = await FraudSignalRecord.db.find(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
      orderBy: (t) => t.detectedAt.desc(),
      limit: 200,
    );
    final relevantSignals = signals
        .where(
          (signal) =>
              (alert.sessionId != null &&
                  signal.sessionId == alert.sessionId) ||
              (alert.identityId != null &&
                  signal.identityId == alert.identityId),
        )
        .toList();

    var reports = <FakeReport>[];
    if (alert.identityId != null) {
      reports = await FakeReport.db.find(
        session,
        where: (t) =>
            t.workspaceId.equals(workspaceId) &
            t.identityId.equals(alert.identityId!),
        orderBy: (t) => t.createdAt.desc(),
        limit: 25,
      );
    }

    RecallRecord? recall;
    if (alert.identityId != null && batchId != null) {
      recall = await RecallService.activeForIdentity(
        session,
        workspaceId: workspaceId,
        identityId: alert.identityId!,
        batchId: batchId,
      );
    }

    return AlertEvidence(
      alert: alert,
      identity: identity,
      batch: batch,
      product: product,
      sessions: sessions,
      identitySessions: identitySessions,
      signals: relevantSignals,
      reports: reports,
      recall: recall,
      generatedAt: DateTime.now().toUtc(),
    );
  }

  static Future<
    ({
      int verifications,
      int authentic,
      int alreadyVerified,
      int invalidPin,
      int fraudSuspected,
      int highRisk,
      int recalled,
      List<TrendPoint> trend,
      Map<String, CountryStat> countries,
    })
  >
  _liveWindow(
    Session session,
    UuidValue workspaceId,
    DateTime fromDay,
    DateTime throughDay,
  ) async {
    final start = DateTime.utc(fromDay.year, fromDay.month, fromDay.day);
    final end = DateTime.utc(
      throughDay.year,
      throughDay.month,
      throughDay.day,
    ).add(const Duration(days: 1));

    final sessions = await VerificationSession.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          (t.createdAt >= start) &
          (t.createdAt < end),
      limit: 200000,
    );

    var authentic = 0;
    var alreadyVerified = 0;
    var invalidPin = 0;
    var fraudSuspected = 0;
    var highRisk = 0;
    var recalled = 0;
    final perDay = <String, ({int total, int fraud})>{};
    final countries = <String, CountryStat>{};

    for (final item in sessions) {
      switch (item.outcome) {
        case VerificationOutcome.authentic:
          authentic++;
        case VerificationOutcome.alreadyVerified:
          alreadyVerified++;
        case VerificationOutcome.invalidPin:
          invalidPin++;
        case VerificationOutcome.fraudSuspected:
          fraudSuspected++;
        case VerificationOutcome.highRisk:
          highRisk++;
        case VerificationOutcome.recalled:
          recalled++;
        case null:
          break;
      }
      final isFraud =
          item.outcome == VerificationOutcome.fraudSuspected ||
          item.outcome == VerificationOutcome.highRisk;
      final created = item.createdAt.toUtc();
      final key = '${created.year}-${created.month}-${created.day}';
      final current = perDay[key] ?? (total: 0, fraud: 0);
      perDay[key] = (
        total: current.total + 1,
        fraud: current.fraud + (isFraud ? 1 : 0),
      );

      final country = item.country;
      if (country != null && country.isNotEmpty) {
        final countryKey = item.countryCode ?? country.toUpperCase();
        final existing = countries[countryKey];
        countries[countryKey] = CountryStat(
          country: existing?.country ?? country,
          countryCode: item.countryCode,
          verifications: (existing?.verifications ?? 0) + 1,
          fraud: (existing?.fraud ?? 0) + (isFraud ? 1 : 0),
        );
      }
    }

    final trend = perDay.entries.map((entry) {
      final parts = entry.key.split('-');
      return TrendPoint(
        date: DateTime.utc(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        ),
        verifications: entry.value.total,
        fraud: entry.value.fraud,
      );
    }).toList();

    return (
      verifications: sessions.length,
      authentic: authentic,
      alreadyVerified: alreadyVerified,
      invalidPin: invalidPin,
      fraudSuspected: fraudSuspected,
      highRisk: highRisk,
      recalled: recalled,
      trend: trend,
      countries: countries,
    );
  }

  static void _mergeCountries(
    Map<String, CountryStat> totals,
    String countriesJson,
  ) {
    try {
      final decoded = jsonDecode(countriesJson);
      if (decoded is! List) return;
      for (final entry in decoded) {
        if (entry is! Map) continue;
        final stat = CountryStat.fromJson(Map<String, dynamic>.from(entry));
        _mergeCountry(totals, stat);
      }
    } catch (_) {
      // A malformed rollup must never break the dashboard.
    }
  }

  static void _mergeCountry(Map<String, CountryStat> totals, CountryStat stat) {
    final key = stat.countryCode ?? stat.country.toUpperCase();
    final existing = totals[key];
    totals[key] = CountryStat(
      country: existing?.country ?? stat.country,
      countryCode: stat.countryCode ?? existing?.countryCode,
      verifications: (existing?.verifications ?? 0) + stat.verifications,
      fraud: (existing?.fraud ?? 0) + stat.fraud,
    );
  }
}
