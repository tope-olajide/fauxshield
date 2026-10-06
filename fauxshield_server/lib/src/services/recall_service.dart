import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'audit_service.dart';
import 'live_events.dart';
import 'notification_service.dart';
import 'webhook_service.dart';

/// Issues and lifts product recalls.
///
/// A recall can cover a whole batch or a single serialized unit. While a
/// recall is active, verification returns the `recalled` outcome and the
/// consumer page shows the reason. Every recall is an immutable
/// [RecallRecord]; lifting a recall flips its `lifted` flag instead of
/// deleting history.
abstract final class RecallService {
  /// Recalls a batch and every active identity inside it.
  ///
  /// Returns the recall record plus how many identities changed status.
  static Future<({RecallRecord record, int affected})> recallBatch(
    Session session, {
    required Workspace workspace,
    required UuidValue batchId,
    required String reason,
    required String actorIdentifier,
    String? notes,
  }) async {
    final trimmedReason = reason.trim();
    if (trimmedReason.length < 3) {
      throw ValidationException(
        message: 'Give a recall reason of at least 3 characters.',
        field: 'reason',
      );
    }

    late RecallRecord record;
    var affected = 0;
    final now = DateTime.now().toUtc();

    await session.db.transaction((tx) async {
      final batch = await Batch.db.findById(
        session,
        batchId,
        transaction: tx,
        lockMode: LockMode.forUpdate,
      );
      if (batch == null || batch.workspaceId != workspace.id) {
        throw NotFoundException(message: 'Batch not found.', resource: 'batch');
      }
      if (batch.status == BatchStatus.recalled) {
        throw ConflictException(
          message: 'This batch is already recalled.',
          resource: 'batch',
        );
      }

      await Batch.db.updateRow(
        session,
        batch.copyWith(
          status: BatchStatus.recalled,
          recallReason: trimmedReason,
          recalledAt: now,
          recalledBy: actorIdentifier,
          updatedAt: now,
        ),
        transaction: tx,
      );

      final identities = await ProductIdentity.db.find(
        session,
        where: (t) =>
            t.batchId.equals(batchId) &
            t.deletedAt.equals(null) &
            t.status.notEquals(IdentityStatus.recalled),
        limit: 50000,
        transaction: tx,
      );
      for (final identity in identities) {
        await ProductIdentity.db.updateRow(
          session,
          identity.copyWith(
            status: IdentityStatus.recalled,
            recallReason: trimmedReason,
            recalledAt: now,
          ),
          transaction: tx,
        );
        affected++;
      }

      record = await RecallRecord.db.insertRow(
        session,
        RecallRecord(
          workspaceId: workspace.id!,
          batchId: batchId,
          scope: RecallScope.batch,
          reason: trimmedReason,
          issuedBy: actorIdentifier,
          issuedAt: now,
          notes: notes,
        ),
        transaction: tx,
      );

      await AuditService.record(
        session,
        workspaceId: workspace.id!,
        action: 'recall.issued',
        targetType: 'batch',
        targetId: batchId,
        actorType: ActorType.user,
        actorIdentifier: actorIdentifier,
        metadata: <String, dynamic>{
          'scope': RecallScope.batch.name,
          'reason': trimmedReason,
          'affected_identities': affected,
        },
        transaction: tx,
      );
    });

    await LiveEvents.publish(
      session,
      workspaceId: workspace.id!,
      type: LiveEventType.batchRecalled,
      title: 'Batch recalled',
      subtitle: trimmedReason,
      batchId: batchId,
      severity: AlertSeverity.critical,
      payload: <String, dynamic>{'affected_identities': affected},
    );

    await NotificationService.notifyWorkspace(
      session,
      workspaceId: workspace.id!,
      type: NotificationType.recall,
      title: 'Batch recalled: $affected units',
      body: trimmedReason,
      targetType: 'batch',
      targetId: batchId,
      minSeverity: AlertSeverity.low,
    );

    await WebhookService.enqueue(
      session,
      workspaceId: workspace.id!,
      eventType: WebhookEventType.recallIssued,
      payload: <String, dynamic>{
        'recall_id': record.id!.uuid,
        'batch_id': batchId.uuid,
        'scope': RecallScope.batch.name,
        'reason': trimmedReason,
        'affected_identities': affected,
        'issued_at': now.toIso8601String(),
      },
    );

    return (record: record, affected: affected);
  }

  /// Recalls one serialized identity.
  static Future<({RecallRecord record, ProductIdentity identity})>
  recallIdentity(
    Session session, {
    required Workspace workspace,
    required UuidValue identityId,
    required String reason,
    required String actorIdentifier,
    String? notes,
  }) async {
    final trimmedReason = reason.trim();
    if (trimmedReason.length < 3) {
      throw ValidationException(
        message: 'Give a recall reason of at least 3 characters.',
        field: 'reason',
      );
    }
    final identity = await ProductIdentity.db.findById(session, identityId);
    if (identity == null ||
        identity.workspaceId != workspace.id ||
        identity.deletedAt != null) {
      throw NotFoundException(
        message: 'Identity not found.',
        resource: 'identity',
      );
    }
    if (identity.status == IdentityStatus.recalled) {
      throw ConflictException(
        message: 'This unit is already recalled.',
        resource: 'identity',
      );
    }

    final now = DateTime.now().toUtc();
    final updated = await ProductIdentity.db.updateRow(
      session,
      identity.copyWith(
        status: IdentityStatus.recalled,
        recallReason: trimmedReason,
        recalledAt: now,
      ),
    );
    final record = await RecallRecord.db.insertRow(
      session,
      RecallRecord(
        workspaceId: workspace.id!,
        batchId: identity.batchId,
        identityId: identityId,
        scope: RecallScope.instance,
        reason: trimmedReason,
        issuedBy: actorIdentifier,
        issuedAt: now,
        notes: notes,
      ),
    );

    await AuditService.record(
      session,
      workspaceId: workspace.id!,
      action: 'recall.issued',
      targetType: 'identity',
      targetId: identityId,
      actorType: ActorType.user,
      actorIdentifier: actorIdentifier,
      metadata: <String, dynamic>{
        'scope': RecallScope.instance.name,
        'reason': trimmedReason,
      },
    );
    await LiveEvents.publish(
      session,
      workspaceId: workspace.id!,
      type: LiveEventType.identityStatusChanged,
      title: 'Unit recalled',
      subtitle: trimmedReason,
      identityId: identityId,
      batchId: identity.batchId,
      severity: AlertSeverity.high,
    );
    await WebhookService.enqueue(
      session,
      workspaceId: workspace.id!,
      eventType: WebhookEventType.recallIssued,
      payload: <String, dynamic>{
        'recall_id': record.id!.uuid,
        'identity_id': identityId.uuid,
        'batch_id': identity.batchId.uuid,
        'scope': RecallScope.instance.name,
        'reason': trimmedReason,
        'issued_at': now.toIso8601String(),
      },
    );

    return (record: record, identity: updated);
  }

  /// Lifts a recall. Units return to active unless they were locked or
  /// deleted for another reason.
  static Future<({RecallRecord record, int affected})> lift(
    Session session, {
    required Workspace workspace,
    required UuidValue recallId,
    required String actorIdentifier,
    String? note,
  }) async {
    final record = await RecallRecord.db.findById(session, recallId);
    if (record == null || record.workspaceId != workspace.id) {
      throw NotFoundException(message: 'Recall not found.', resource: 'recall');
    }
    if (record.lifted) {
      throw ConflictException(
        message: 'This recall was already lifted.',
        resource: 'recall',
      );
    }

    final now = DateTime.now().toUtc();
    var affected = 0;
    late RecallRecord updated;

    await session.db.transaction((tx) async {
      if (record.scope == RecallScope.batch) {
        final batch = await Batch.db.findById(
          session,
          record.batchId,
          transaction: tx,
          lockMode: LockMode.forUpdate,
        );
        if (batch == null) {
          throw NotFoundException(
            message: 'Batch not found.',
            resource: 'batch',
          );
        }
        await Batch.db.updateRow(
          session,
          batch.copyWith(
            status: BatchStatus.shipped,
            recallReason: null,
            recalledAt: null,
            recalledBy: null,
            updatedAt: now,
          ),
          transaction: tx,
        );
        final identities = await ProductIdentity.db.find(
          session,
          where: (t) =>
              t.batchId.equals(record.batchId) &
              t.status.equals(IdentityStatus.recalled),
          limit: 50000,
          transaction: tx,
        );
        for (final identity in identities) {
          await ProductIdentity.db.updateRow(
            session,
            identity.copyWith(
              status: IdentityStatus.active,
              recallReason: null,
              recalledAt: null,
            ),
            transaction: tx,
          );
          affected++;
        }
      } else if (record.identityId != null) {
        final identity = await ProductIdentity.db.findById(
          session,
          record.identityId!,
          transaction: tx,
          lockMode: LockMode.forUpdate,
        );
        if (identity != null) {
          await ProductIdentity.db.updateRow(
            session,
            identity.copyWith(
              status: IdentityStatus.active,
              recallReason: null,
              recalledAt: null,
            ),
            transaction: tx,
          );
          affected = 1;
        }
      }

      updated = await RecallRecord.db.updateRow(
        session,
        record.copyWith(lifted: true, liftedAt: now, liftedBy: actorIdentifier),
        transaction: tx,
      );

      await AuditService.record(
        session,
        workspaceId: workspace.id!,
        action: 'recall.lifted',
        targetType: 'recall_record',
        targetId: recallId,
        actorType: ActorType.user,
        actorIdentifier: actorIdentifier,
        metadata: <String, dynamic>{
          'note': note,
          'affected_identities': affected,
        },
        transaction: tx,
      );
    });

    await LiveEvents.publish(
      session,
      workspaceId: workspace.id!,
      type: LiveEventType.batchRecalled,
      title: 'Recall lifted',
      subtitle: '${record.scope.name} recall reversed',
      batchId: record.batchId,
      severity: AlertSeverity.medium,
      payload: <String, dynamic>{'affected_identities': affected},
    );

    return (record: updated, affected: affected);
  }

  /// Lists recalls for the workspace, newest first.
  static Future<List<RecallRecord>> list(
    Session session, {
    required UuidValue workspaceId,
    bool includeLifted = true,
    int limit = 50,
  }) {
    return RecallRecord.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(workspaceId);
        if (!includeLifted) {
          expression = expression & t.lifted.equals(false);
        }
        return expression;
      },
      orderBy: (t) => t.issuedAt.desc(),
      limit: limit,
    );
  }

  /// The active recall for one identity, if any (instance first, then batch).
  static Future<RecallRecord?> activeForIdentity(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue identityId,
    required UuidValue batchId,
  }) async {
    final instance = await RecallRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.identityId.equals(identityId) &
          t.lifted.equals(false),
      orderBy: (t) => t.issuedAt.desc(),
    );
    if (instance != null) return instance;
    return RecallRecord.db.findFirstRow(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.batchId.equals(batchId) &
          t.identityId.equals(null) &
          t.lifted.equals(false),
      orderBy: (t) => t.issuedAt.desc(),
    );
  }
}
