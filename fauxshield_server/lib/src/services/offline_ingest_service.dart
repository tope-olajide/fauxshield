import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../core/geo_dataset.dart';
import '../generated/protocol.dart';
import 'fraud_rules.dart';
import 'live_events.dart';
import 'verification_service.dart';

/// Converts field scans captured without connectivity into authoritative
/// verification sessions.
///
/// Two paths funnel through one converter:
///
/// * **Direct upload** — the inspector app posts its queued scans as soon as
///   connectivity returns and receives one verdict per scan.
/// * **Offline sync** — Serverpod's offline sync mirrors `offline_scan_record`
///   rows to the server, and a recurring task converts pending rows. The
///   verdict is written back to the synced row, so the inspector device sees
///   the authoritative result even if it never called the upload endpoint.
///
/// Both paths run the same fraud evaluation, alerting, and live event pipeline
/// as an online scan, so fraud intelligence never loses field activity.
class OfflineIngestService {
  OfflineIngestService({VerificationService? verificationService})
    : _verification = verificationService ?? VerificationService();

  final VerificationService _verification;

  /// Ingests a batch of queued scans and returns one verdict per scan.
  ///
  /// Verdicts preserve input order. A scan that cannot be resolved still gets
  /// a verdict with a human readable message, so the device can show it and
  /// stop retrying.
  Future<List<OfflineScanVerdict>> ingest(
    Session session, {
    required UuidValue workspaceId,
    required String deviceId,
    required List<OfflineScanInput> scans,
  }) async {
    if (scans.isEmpty) return const <OfflineScanVerdict>[];
    if (scans.length > FauxShieldLimits.maxOfflineBatchSize) {
      throw ValidationException(
        message:
            'Send at most ${FauxShieldLimits.maxOfflineBatchSize} scans per upload.',
        field: 'scans',
      );
    }

    final verdicts = <OfflineScanVerdict>[];
    for (final scan in scans) {
      final record = await _findMirror(session, deviceId: deviceId, scan: scan);
      if (record != null && record.processed) {
        final replay = _replayVerdict(record, scan.localId);
        if (replay != null) {
          verdicts.add(replay);
          continue;
        }
      }

      final claimed = record == null ? null : await _claim(session, record.id!);
      final verdict = await _process(
        session,
        localId: scan.localId,
        deviceId: deviceId,
        deviceFingerprint: scan.deviceFingerprint,
        qrToken: scan.qrToken,
        scannedAt: scan.scannedAt,
        latitude: scan.latitude,
        longitude: scan.longitude,
        country: scan.country,
        city: scan.city,
        workspaceId: workspaceId,
        offlineScanId: claimed?.id,
      );

      if (claimed != null) {
        await _saveVerdict(session, claimed, verdict);
      }
      verdicts.add(verdict);
    }
    return verdicts;
  }

  /// Converts pending synced rows into verification sessions.
  ///
  /// Called by a recurring task. Each row is claimed with a row lock before
  /// processing, so a direct upload racing the task cannot double-process a
  /// scan. Returns the number of converted scans.
  Future<int> convertPending(Session session, {int batchSize = 25}) async {
    final pending = await OfflineScanRecord.db.find(
      session,
      where: (t) => t.processed.equals(false),
      orderBy: (t) => t.scannedAt,
      limit: batchSize,
    );

    var converted = 0;
    for (final candidate in pending) {
      final claimed = await _claim(session, candidate.id!);
      if (claimed == null) continue;
      final verdict = await _process(
        session,
        localId: claimed.id!.uuid,
        deviceId: claimed.deviceId,
        deviceFingerprint: claimed.deviceFingerprint,
        qrToken: claimed.qrToken,
        scannedAt: claimed.scannedAt,
        latitude: claimed.latitude,
        longitude: claimed.longitude,
        country: claimed.country,
        city: claimed.city,
        workspaceId: claimed.workspaceId,
        offlineScanId: claimed.id,
      );
      await _saveVerdict(session, claimed, verdict);
      converted++;
    }
    return converted;
  }

  Future<OfflineScanVerdict> _process(
    Session session, {
    required String localId,
    required String deviceId,
    required String? deviceFingerprint,
    required String qrToken,
    required DateTime scannedAt,
    required double? latitude,
    required double? longitude,
    required String? country,
    required String? city,
    required UuidValue? workspaceId,
    required UuidValue? offlineScanId,
  }) async {
    final now = DateTime.now().toUtc();
    final token = qrToken.trim().toLowerCase();

    final identity = await ProductIdentity.db.findFirstRow(
      session,
      where: (t) => t.qrToken.equals(token) & t.deletedAt.equals(null),
    );
    // A token from another tenant is treated as unknown: inspectors must not
    // be able to probe whether a foreign code exists.
    if (identity == null ||
        (workspaceId != null && identity.workspaceId != workspaceId)) {
      return OfflineScanVerdict(
        localId: localId,
        processedAt: now,
        message: 'This code is not registered by any brand on FauxShield.',
      );
    }

    final fingerprint = (deviceFingerprint?.trim().isNotEmpty ?? false)
        ? deviceFingerprint!.trim()
        : 'offline:$deviceId';

    final delay = now.difference(scannedAt.toUtc());
    final extraSignals = delay > FauxShieldLimits.offlineBackfillThreshold
        ? <SignalAssessment>[
            SignalAssessment(
              type: SignalType.offlineBackfill,
              severity: RiskScore.low,
              reasons: <String>[
                'Scan captured ${_humanize(delay)} before it reached the server.',
              ],
            ),
          ]
        : const <SignalAssessment>[];

    final locationOverride = latitude != null && longitude != null
        ? GeoResult(
            country: country ?? 'Unknown',
            countryCode: '',
            city: city ?? 'Unknown',
            latitude: latitude,
            longitude: longitude,
          )
        : null;

    try {
      var verification = await _verification.resolveToken(
        session,
        token: token,
        deviceFingerprint: fingerprint,
        source: ScanSource.inspectorOffline,
        locationOverride: locationOverride,
        offlineScanId: offlineScanId,
        extraSignals: extraSignals,
      );
      verification = await _verification.finalizeInspectorScan(
        session,
        sessionId: verification.id!,
        deviceFingerprint: fingerprint,
      );

      final verdict = OfflineScanVerdict(
        localId: localId,
        outcome: verification.outcome,
        riskScore: verification.riskScore,
        sessionId: verification.id,
        processedAt: now,
        message: _verdictMessage(verification, delay),
      );

      await LiveEvents.publish(
        session,
        workspaceId: identity.workspaceId,
        type: LiveEventType.offlineScanIngested,
        title: 'Offline scan processed',
        subtitle: verdict.message,
        outcome: verdict.outcome,
        riskScore: verdict.riskScore,
        country: verification.country,
        countryCode: verification.countryCode,
        city: verification.city,
        identityId: identity.id,
        sessionId: verification.id,
        batchId: identity.batchId,
        payload: <String, dynamic>{
          'device_id': deviceId,
          'backfill_seconds': delay.inSeconds,
        },
      );
      return verdict;
    } on VerificationException catch (error) {
      return OfflineScanVerdict(
        localId: localId,
        processedAt: now,
        message: error.message,
      );
    }
  }

  /// Finds the synced mirror row for an uploaded scan.
  Future<OfflineScanRecord?> _findMirror(
    Session session, {
    required String deviceId,
    required OfflineScanInput scan,
  }) {
    final token = scan.qrToken.trim().toLowerCase();
    return OfflineScanRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.deviceId.equals(deviceId) &
          t.qrToken.equals(token) &
          t.scannedAt.equals(scan.scannedAt.toUtc()),
    );
  }

  /// Atomically marks a row as being processed and returns it.
  ///
  /// The row lock makes this the single point of truth: whichever process
  /// claims the row first owns the conversion.
  Future<OfflineScanRecord?> _claim(Session session, UuidValue recordId) {
    final now = DateTime.now().toUtc();
    return session.db.transaction((tx) async {
      final record = await OfflineScanRecord.db.findById(
        session,
        recordId,
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (record == null || record.processed) return null;
      return OfflineScanRecord.db.updateRow(
        session,
        record.copyWith(processed: true, processedAt: now),
        transaction: tx,
      );
    });
  }

  Future<void> _saveVerdict(
    Session session,
    OfflineScanRecord record,
    OfflineScanVerdict verdict,
  ) async {
    await OfflineScanRecord.db.updateRow(
      session,
      record.copyWith(
        verdictJson: jsonEncode(verdict.toJson()),
        processedAt: DateTime.now().toUtc(),
      ),
    );
  }

  OfflineScanVerdict? _replayVerdict(
    OfflineScanRecord record,
    String localId,
  ) {
    final stored = record.verdictJson;
    if (stored == null) return null;
    try {
      final decoded = jsonDecode(stored);
      if (decoded is! Map<String, dynamic>) return null;
      final verdict = OfflineScanVerdict.fromJson(decoded);
      return verdict.copyWith(localId: localId);
    } catch (_) {
      return null;
    }
  }

  static String _verdictMessage(
    VerificationSession verification,
    Duration delay,
  ) {
    final lag = delay.inMinutes > 0 ? ' after ${_humanize(delay)} offline' : '';
    switch (verification.outcome) {
      case VerificationOutcome.authentic:
        return 'Authentic product confirmed$lag.';
      case VerificationOutcome.alreadyVerified:
        return 'This authenticated unit was verified before$lag.';
      case VerificationOutcome.invalidPin:
        return 'Wrong PIN recorded$lag.';
      case VerificationOutcome.highRisk:
        return 'Verified with elevated risk$lag. Review the route.';
      case VerificationOutcome.fraudSuspected:
        return 'Fraud suspected. Unit locked and escalated$lag.';
      case VerificationOutcome.recalled:
        return 'This unit is recalled. Quarantine it$lag.';
      case null:
        return 'Scan recorded$lag.';
    }
  }

  static String _humanize(Duration duration) {
    if (duration.inDays > 0) return '${duration.inDays} day(s)';
    if (duration.inHours > 0) return '${duration.inHours} hour(s)';
    if (duration.inMinutes > 0) return '${duration.inMinutes} minute(s)';
    return '${duration.inSeconds} second(s)';
  }
}
