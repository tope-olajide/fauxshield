import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../generated/protocol.dart';
import 'audit_service.dart';
import 'live_events.dart';

/// Consumer reports about suspicious products.
///
/// Reports are rate limited per device, feed the brand's triage queue, and
/// announce themselves through the live event channel so the command center
/// sees consumer sentiment in real time.
abstract final class FakeReportService {
  static Future<ReportAcknowledgement> create(
    Session session, {
    required VerificationSession verification,
    required String deviceFingerprint,
    required String reason,
    String? comment,
  }) async {
    final trimmedReason = reason.trim();
    if (trimmedReason.length < 3) {
      throw ValidationException(
        message: 'Describe what looks wrong in at least 3 characters.',
        field: 'reason',
      );
    }

    final now = DateTime.now().toUtc();
    final recent = await FakeReport.db.count(
      session,
      where: (t) =>
          t.workspaceId.equals(verification.workspaceId) &
          t.deviceFingerprint.equals(deviceFingerprint) &
          (t.createdAt > now.subtract(const Duration(days: 1))),
    );
    if (recent >= FauxShieldLimits.fakeReportsPerDayPerIdentity) {
      throw RateLimitException(
        message: 'You have already sent the maximum number of reports today.',
        retryAfterSeconds: 86400,
      );
    }

    final report = await FakeReport.db.insertRow(
      session,
      FakeReport(
        workspaceId: verification.workspaceId,
        identityId: verification.identityId,
        sessionId: verification.id,
        reason: trimmedReason,
        comment: comment,
        deviceFingerprint: deviceFingerprint,
        country: verification.country,
        city: verification.city,
        status: FakeReportStatus.open,
        source: verification.source,
        createdAt: now,
      ),
    );

    await AuditService.record(
      session,
      workspaceId: verification.workspaceId,
      action: 'fake_report.created',
      targetType: 'fake_report',
      targetId: report.id,
      actorType: ActorType.consumer,
      metadata: <String, dynamic>{'reason': trimmedReason},
      ipAddress: verification.ipAddress,
    );
    await LiveEvents.publish(
      session,
      workspaceId: verification.workspaceId,
      type: LiveEventType.fakeReportCreated,
      title: 'Consumer reported a suspicious product',
      subtitle: trimmedReason,
      severity: AlertSeverity.medium,
      country: verification.country,
      countryCode: verification.countryCode,
      city: verification.city,
      identityId: verification.identityId,
      sessionId: verification.id,
      payload: <String, dynamic>{'report_id': report.id!.uuid},
    );

    return ReportAcknowledgement(
      reportId: report.id!,
      message:
          'Thank you. Your report reached the brand and will be reviewed by their team.',
      createdAt: now,
    );
  }
}
