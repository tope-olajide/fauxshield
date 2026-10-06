import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../generated/protocol.dart';
import '../services/audit_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Append-only audit log access.
class AuditEndpoint extends Endpoint {
  /// Queries audit events with optional filters.
  Future<List<AuditEvent>> query(
    Session session, {
    UuidValue? workspaceId,
    String? action,
    String? actorIdentifier,
    String? targetType,
    UuidValue? targetId,
    DateTime? from,
    DateTime? to,
    int page = 0,
    int pageSize = 50,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.auditRead);
    final size = pageSize.clamp(1, FauxShieldLimits.maxAuditPageSize);
    final offset = (page < 0 ? 0 : page) * size;
    return AuditService.query(
      session,
      workspaceId: context.workspaceId,
      action: action,
      actorIdentifier: actorIdentifier,
      targetType: targetType,
      targetId: targetId,
      from: from,
      to: to,
      limit: size,
      offset: offset,
    );
  }
}
