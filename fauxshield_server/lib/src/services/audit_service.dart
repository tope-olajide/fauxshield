import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Writes workspace scoped audit events.
///
/// Audit rows are append-only at the application level: there is no update or
/// delete path anywhere in the codebase, and endpoints never expose one.
abstract final class AuditService {
  static Future<AuditEvent> record(
    Session session, {
    required UuidValue workspaceId,
    required String action,
    required String targetType,
    UuidValue? targetId,
    ActorType actorType = ActorType.system,
    String? actorIdentifier,
    UuidValue? apiKeyId,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    Transaction? transaction,
  }) async {
    final event = AuditEvent(
      workspaceId: workspaceId,
      actorType: actorType,
      actorIdentifier: actorIdentifier,
      apiKeyId: apiKeyId,
      action: action,
      targetType: targetType,
      targetId: targetId,
      metadataJson: metadata == null || metadata.isEmpty
          ? null
          : jsonEncode(metadata),
      ipAddress: ipAddress,
    );
    return AuditEvent.db.insertRow(session, event, transaction: transaction);
  }

  /// Records an event for an authenticated operator.
  static Future<AuditEvent> recordForUser(
    Session session, {
    required UuidValue workspaceId,
    required String action,
    required String targetType,
    UuidValue? targetId,
    Map<String, dynamic>? metadata,
    String? ipAddress,
    Transaction? transaction,
  }) {
    return record(
      session,
      workspaceId: workspaceId,
      action: action,
      targetType: targetType,
      targetId: targetId,
      actorType: ActorType.user,
      actorIdentifier: session.authenticated?.userIdentifier,
      metadata: metadata,
      ipAddress: ipAddress,
      transaction: transaction,
    );
  }

  static Future<List<AuditEvent>> query(
    Session session, {
    required UuidValue workspaceId,
    String? action,
    String? actorIdentifier,
    String? targetType,
    UuidValue? targetId,
    DateTime? from,
    DateTime? to,
    int limit = 50,
    int offset = 0,
  }) {
    return AuditEvent.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(workspaceId);
        if (action != null && action.isNotEmpty) {
          expression = expression & t.action.like('%$action%');
        }
        if (actorIdentifier != null && actorIdentifier.isNotEmpty) {
          expression = expression & t.actorIdentifier.equals(actorIdentifier);
        }
        if (targetType != null && targetType.isNotEmpty) {
          expression = expression & t.targetType.equals(targetType);
        }
        if (targetId != null) {
          expression = expression & t.targetId.equals(targetId);
        }
        if (from != null) {
          expression = expression & (t.createdAt >= from.toUtc());
        }
        if (to != null) {
          expression = expression & (t.createdAt <= to.toUtc());
        }
        return expression;
      },
      orderBy: (t) => t.createdAt.desc(),
      limit: limit,
      offset: offset,
    );
  }

  /// Deletes audit rows older than [cutoff] and returns how many were removed.
  static Future<int> prune(Session session, DateTime cutoff) async {
    final removed = await AuditEvent.db.deleteWhere(
      session,
      where: (t) => t.createdAt < cutoff.toUtc(),
    );
    return removed.length;
  }
}
