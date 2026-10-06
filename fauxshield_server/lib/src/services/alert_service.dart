import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'audit_service.dart';
import 'fraud_rules.dart';
import 'live_events.dart';
import 'notification_service.dart';
import 'webhook_service.dart';

/// Creates and manages fraud alerts, the platform's response layer.
///
/// When fraud is suspected the platform can lock the identity so future
/// verifications return fraud suspected, create an alert for investigators,
/// notify the team, fire webhooks, and record the whole chain in the audit log.
abstract final class AlertService {
  /// Creates an alert for a fraud assessment when the policy warrants it.
  ///
  /// Returns null when the risk score does not cross the alert threshold or an
  /// identical alert already exists inside the deduplication bucket.
  static Future<FraudAlert?> createFromAssessment(
    Session session, {
    required Workspace workspace,
    required FraudEvaluationLike assessment,
    ProductIdentity? identity,
    Batch? batch,
    VerificationSession? verificationSession,
    UuidValue? simulationId,
    String? sourceLabel,
  }) async {
    final policy = workspace.fraudPolicy ?? FraudPolicy();
    final risk = assessment.riskScore;
    if (!shouldAlert(risk, policy) || assessment.signals.isEmpty) {
      return null;
    }

    final severity = alertSeverityFor(risk);
    final primary = assessment.signals.first;
    final identityId = identity?.id;
    final batchId = batch?.id ?? identity?.batchId;
    final bucket = _dedupeBucket();
    final dedupeKey = [
      workspace.id!.uuid,
      primary.type.name,
      identityId?.uuid ?? batchId?.uuid ?? 'workspace',
      bucket,
    ].join(':');

    final existing = await FraudAlert.db.findFirstRow(
      session,
      where: (t) => t.dedupeKey.equals(dedupeKey),
    );
    if (existing != null) {
      final escalated =
          _severityRank(severity) > _severityRank(existing.severity);
      if (escalated) {
        final updated = await FraudAlert.db.updateRow(
          session,
          existing.copyWith(
            severity: severity,
            description: _describe(assessment, identity, sourceLabel),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
        await _publishAlert(session, workspace, updated, created: false);
        return updated;
      }
      return existing;
    }

    final now = DateTime.now().toUtc();
    final signalTypes = assessment.signals
        .map((signal) => signal.type)
        .toList();
    final lock = shouldLockIdentity(risk, policy) && identity != null;

    var alert = FraudAlert(
      workspaceId: workspace.id!,
      identityId: identityId,
      batchId: batchId,
      sessionId: verificationSession?.id,
      severity: severity,
      status: AlertStatus.open,
      title: _title(primary, identity),
      description: _describe(assessment, identity, sourceLabel),
      recommendedAction: signalRecommendedAction(primary.type),
      signalTypes: signalTypes,
      dedupeKey: dedupeKey,
      autoLocked: lock,
      simulationId: simulationId,
      createdAt: now,
      updatedAt: now,
    );
    alert = await FraudAlert.db.insertRow(session, alert);

    if (lock) {
      final locked = identity.copyWith(status: IdentityStatus.locked);
      await ProductIdentity.db.updateRow(session, locked);
      await AuditService.record(
        session,
        workspaceId: workspace.id!,
        action: 'identity.auto_locked',
        targetType: 'identity',
        targetId: identityId,
        actorType: ActorType.system,
        metadata: <String, dynamic>{
          'alert_id': alert.id!.uuid,
          'risk_score': risk.name,
        },
      );
      await LiveEvents.publish(
        session,
        workspaceId: workspace.id!,
        type: LiveEventType.identityStatusChanged,
        title: 'Identity locked automatically',
        subtitle:
            '${identity.batchId.uuid.substring(0, 8)}… locked after '
            '${signalLabel(primary.type).toLowerCase()}',
        identityId: identityId,
        alertId: alert.id,
        batchId: batchId,
        severity: severity,
      );
    }

    await _publishAlert(session, workspace, alert, created: true);

    await AuditService.record(
      session,
      workspaceId: workspace.id!,
      action: 'fraud.alert_created',
      targetType: 'fraud_alert',
      targetId: alert.id,
      actorType: ActorType.system,
      metadata: <String, dynamic>{
        'severity': severity.name,
        'risk_score': risk.name,
        'signals': signalTypes.map((type) => type.name).toList(),
        'auto_locked': lock,
      },
    );

    await NotificationService.notifyWorkspace(
      session,
      workspaceId: workspace.id!,
      type: NotificationType.fraudAlert,
      title: alert.title,
      body: alert.description,
      targetType: 'fraud_alert',
      targetId: alert.id,
      minSeverity: severity,
    );

    return alert;
  }

  /// Updates the workflow status of an alert.
  static Future<FraudAlert> updateStatus(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue alertId,
    required AlertStatus status,
    required String actorIdentifier,
    String? note,
  }) async {
    final alert = await FraudAlert.db.findById(session, alertId);
    if (alert == null || alert.workspaceId != workspaceId) {
      throw NotFoundException(message: 'Alert not found.', resource: 'alert');
    }
    final now = DateTime.now().toUtc();
    final updated = alert.copyWith(
      status: status,
      updatedAt: now,
      acknowledgedAt:
          alert.acknowledgedAt ??
          (status == AlertStatus.investigating ? now : alert.acknowledgedAt),
      resolvedAt:
          status == AlertStatus.resolved || status == AlertStatus.dismissed
          ? now
          : alert.resolvedAt,
      resolvedBy:
          status == AlertStatus.resolved || status == AlertStatus.dismissed
          ? actorIdentifier
          : alert.resolvedBy,
      resolutionNote: note ?? alert.resolutionNote,
    );
    final saved = await FraudAlert.db.updateRow(session, updated);

    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'fraud.alert_${status.name}',
      targetType: 'fraud_alert',
      targetId: alertId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{'note': note},
    );

    await LiveEvents.publish(
      session,
      workspaceId: workspaceId,
      type: LiveEventType.fraudAlertUpdated,
      title: 'Alert ${status.name}',
      subtitle: alert.title,
      severity: saved.severity,
      alertId: saved.id,
      identityId: saved.identityId,
      batchId: saved.batchId,
    );

    await WebhookService.enqueue(
      session,
      workspaceId: workspaceId,
      eventType: WebhookEventType.fraudAlertUpdated,
      payload: <String, dynamic>{
        'alert_id': alertId.uuid,
        'status': status.name,
        'note': note,
      },
    );

    return saved;
  }

  /// Locks an identity through an authorized operator action.
  static Future<ProductIdentity> lockIdentity(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue identityId,
    required String actorIdentifier,
    String? reason,
  }) async {
    final identity = await ProductIdentity.db.findById(session, identityId);
    if (identity == null || identity.workspaceId != workspaceId) {
      throw NotFoundException(
        message: 'Identity not found.',
        resource: 'identity',
      );
    }
    final updated = await ProductIdentity.db.updateRow(
      session,
      identity.copyWith(status: IdentityStatus.locked),
    );
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'identity.locked',
      targetType: 'identity',
      targetId: identityId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{'reason': reason},
    );
    await LiveEvents.publish(
      session,
      workspaceId: workspaceId,
      type: LiveEventType.identityStatusChanged,
      title: 'Identity locked',
      subtitle: reason,
      identityId: identityId,
      batchId: identity.batchId,
    );
    return updated;
  }

  /// Unlocks an identity after investigation.
  static Future<ProductIdentity> unlockIdentity(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue identityId,
    required String actorIdentifier,
    String? note,
  }) async {
    final identity = await ProductIdentity.db.findById(session, identityId);
    if (identity == null || identity.workspaceId != workspaceId) {
      throw NotFoundException(
        message: 'Identity not found.',
        resource: 'identity',
      );
    }
    final targetStatus = identity.recalledAt != null
        ? IdentityStatus.recalled
        : IdentityStatus.active;
    final updated = await ProductIdentity.db.updateRow(
      session,
      identity.copyWith(
        status: targetStatus,
        failedPinAttempts: 0,
        lockedUntil: null,
      ),
    );
    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'identity.unlocked',
      targetType: 'identity',
      targetId: identityId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{'note': note},
    );
    await LiveEvents.publish(
      session,
      workspaceId: workspaceId,
      type: LiveEventType.identityStatusChanged,
      title: 'Identity unlocked',
      subtitle: note,
      identityId: identityId,
      batchId: identity.batchId,
    );
    return updated;
  }

  static Future<void> _publishAlert(
    Session session,
    Workspace workspace,
    FraudAlert alert, {
    required bool created,
  }) {
    return LiveEvents.publish(
      session,
      workspaceId: workspace.id!,
      type: created
          ? LiveEventType.fraudAlertCreated
          : LiveEventType.fraudAlertUpdated,
      title: alert.title,
      subtitle: alert.description,
      severity: alert.severity,
      alertId: alert.id,
      identityId: alert.identityId,
      batchId: alert.batchId,
      sessionId: alert.sessionId,
      payload: <String, dynamic>{
        'status': alert.status.name,
        'signal_types': alert.signalTypes?.map((type) => type.name).toList(),
      },
    );
  }

  static String _title(SignalAssessment primary, ProductIdentity? identity) {
    final suffix = identity == null
        ? ''
        : ' · ${identity.qrToken.substring(0, 4)}…${identity.qrToken.substring(identity.qrToken.length - 4)}';
    return '${signalLabel(primary.type)}$suffix';
  }

  static String _describe(
    FraudEvaluationLike assessment,
    ProductIdentity? identity,
    String? sourceLabel,
  ) {
    final buffer = StringBuffer();
    buffer.write('Risk ${assessment.riskScore.name.toUpperCase()}');
    if (sourceLabel != null && sourceLabel.isNotEmpty) {
      buffer.write(' · $sourceLabel');
    }
    buffer.write('\n');
    for (final signal in assessment.signals) {
      buffer.write(
        '• ${signalLabel(signal.type)}: ${signal.reasons.join('; ')}\n',
      );
    }
    return buffer.toString().trimRight();
  }

  static String _dedupeBucket() {
    final now = DateTime.now().toUtc();
    final bucket = DateTime.utc(
      now.year,
      now.month,
      now.day,
      now.hour ~/ 6 * 6,
    );
    return '${bucket.year}${bucket.month.toString().padLeft(2, '0')}'
        '${bucket.day.toString().padLeft(2, '0')}T${bucket.hour.toString().padLeft(2, '0')}';
  }

  static int _severityRank(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.low:
        return 0;
      case AlertSeverity.medium:
        return 1;
      case AlertSeverity.high:
        return 2;
      case AlertSeverity.critical:
        return 3;
    }
  }
}

/// Structural type accepted by [AlertService.createFromAssessment], letting
/// the fraud engine result and test doubles feed the same code path.
abstract interface class FraudEvaluationLike {
  RiskScore get riskScore;
  List<SignalAssessment> get signals;
}
