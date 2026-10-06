import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/rbac.dart';
import '../services/recall_service.dart';
import '../services/workspace_service.dart';

/// Batch and identity recalls.
///
/// Verification reports the recalled outcome while a recall is active, and
/// every recall is announced through live events, notifications, and webhooks.
class RecallEndpoint extends Endpoint {
  /// Lists recall history.
  Future<List<RecallRecord>> list(
    Session session, {
    UuidValue? workspaceId,
    bool includeLifted = true,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.batchesRead);
    return RecallService.list(
      session,
      workspaceId: context.workspaceId,
      includeLifted: includeLifted,
    );
  }

  /// Recalls a whole batch.
  Future<RecallResult> recallBatch(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue batchId,
    required String reason,
    String? notes,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.batchesWrite);
    final result = await RecallService.recallBatch(
      session,
      workspace: context.workspace,
      batchId: batchId,
      reason: reason,
      actorIdentifier: context.userIdentifier,
      notes: notes,
    );
    return RecallResult(recall: result.record, affected: result.affected);
  }

  /// Recalls one identity.
  Future<RecallResult> recallIdentity(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue identityId,
    required String reason,
    String? notes,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.batchesWrite);
    final result = await RecallService.recallIdentity(
      session,
      workspace: context.workspace,
      identityId: identityId,
      reason: reason,
      actorIdentifier: context.userIdentifier,
      notes: notes,
    );
    return RecallResult(recall: result.record, affected: 1);
  }

  /// Lifts a recall. Units return to normal verification.
  Future<RecallResult> lift(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue recallId,
    String? note,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.batchesWrite);
    final result = await RecallService.lift(
      session,
      workspace: context.workspace,
      recallId: recallId,
      actorIdentifier: context.userIdentifier,
      note: note,
    );
    return RecallResult(recall: result.record, affected: result.affected);
  }
}
