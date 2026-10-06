import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../generated/protocol.dart';
import '../services/alert_service.dart';
import '../services/analytics_service.dart';
import '../services/audit_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Fraud alert queue, evidence assembly, and consumer report triage.
class AlertEndpoint extends Endpoint {
  /// Lists alerts, newest first.
  Future<List<FraudAlert>> list(
    Session session, {
    UuidValue? workspaceId,
    AlertStatus? status,
    AlertSeverity? severity,
    int page = 0,
    int pageSize = 25,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudRead);
    final size = pageSize.clamp(1, FauxShieldLimits.maxPageSize);
    final offset = (page < 0 ? 0 : page) * size;
    return FraudAlert.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        if (status != null) {
          expression = expression & t.status.equals(status);
        }
        if (severity != null) {
          expression = expression & t.severity.equals(severity);
        }
        return expression;
      },
      orderBy: (t) => t.createdAt.desc(),
      limit: size,
      offset: offset,
    );
  }

  /// Loads one alert.
  Future<FraudAlert> get(Session session, UuidValue alertId) async {
    final alert = await FraudAlert.db.findById(session, alertId);
    if (alert == null) {
      throw NotFoundException(message: 'Alert not found.', resource: 'alert');
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: alert.workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudRead);
    return alert;
  }

  /// Assembles everything needed to investigate one alert in a single call.
  Future<AlertEvidence> evidence(
    Session session,
    UuidValue alertId,
  ) async {
    final alert = await FraudAlert.db.findById(session, alertId);
    if (alert == null) {
      throw NotFoundException(message: 'Alert not found.', resource: 'alert');
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: alert.workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudRead);
    return AnalyticsService.evidence(
      session,
      workspaceId: context.workspaceId,
      alertId: alertId,
    );
  }

  /// Moves an alert through its workflow.
  Future<FraudAlert> updateStatus(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue alertId,
    required AlertStatus status,
    String? note,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudWrite);
    return AlertService.updateStatus(
      session,
      workspaceId: context.workspaceId,
      alertId: alertId,
      status: status,
      actorIdentifier: context.userIdentifier,
      note: note,
    );
  }

  /// Assigns an alert to an investigator.
  Future<FraudAlert> assign(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue alertId,
    String? assignee,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudWrite);
    final alert = await FraudAlert.db.findById(session, alertId);
    if (alert == null || alert.workspaceId != context.workspaceId) {
      throw NotFoundException(message: 'Alert not found.', resource: 'alert');
    }
    final updated = await FraudAlert.db.updateRow(
      session,
      alert.copyWith(
        assignee: assignee,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'alert.assigned',
      targetType: 'fraud_alert',
      targetId: alertId,
      metadata: <String, dynamic>{'assignee': assignee},
    );
    return updated;
  }

  /// Lists raw fraud signals for the intelligence feed.
  Future<List<FraudSignalRecord>> signals(
    Session session, {
    UuidValue? workspaceId,
    UuidValue? batchId,
    SignalType? type,
    int page = 0,
    int pageSize = 25,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudRead);
    final size = pageSize.clamp(1, FauxShieldLimits.maxPageSize);
    final offset = (page < 0 ? 0 : page) * size;
    return FraudSignalRecord.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        if (batchId != null) {
          expression = expression & t.batchId.equals(batchId);
        }
        if (type != null) {
          expression = expression & t.type.equals(type);
        }
        return expression;
      },
      orderBy: (t) => t.detectedAt.desc(),
      limit: size,
      offset: offset,
    );
  }

  /// Lists consumer reports for triage.
  Future<List<FakeReport>> reports(
    Session session, {
    UuidValue? workspaceId,
    FakeReportStatus? status,
    int page = 0,
    int pageSize = 25,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudRead);
    final size = pageSize.clamp(1, FauxShieldLimits.maxPageSize);
    final offset = (page < 0 ? 0 : page) * size;
    return FakeReport.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        if (status != null) {
          expression = expression & t.status.equals(status);
        }
        return expression;
      },
      orderBy: (t) => t.createdAt.desc(),
      limit: size,
      offset: offset,
    );
  }

  /// Triages a consumer report.
  Future<FakeReport> triageReport(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue reportId,
    required FakeReportStatus status,
    String? note,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudWrite);
    final report = await FakeReport.db.findById(session, reportId);
    if (report == null || report.workspaceId != context.workspaceId) {
      throw NotFoundException(
        message: 'Report not found.',
        resource: 'fake_report',
      );
    }
    final updated = await FakeReport.db.updateRow(
      session,
      report.copyWith(
        status: status,
        triagedAt: DateTime.now().toUtc(),
        triagedBy: context.userIdentifier,
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'fake_report.triaged',
      targetType: 'fake_report',
      targetId: reportId,
      metadata: <String, dynamic>{'status': status.name, 'note': note},
    );
    return updated;
  }
}
