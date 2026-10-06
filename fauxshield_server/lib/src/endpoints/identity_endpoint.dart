import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../core/identity_crypto.dart';
import '../generated/protocol.dart';
import '../services/alert_service.dart';
import '../services/audit_service.dart';
import '../services/identity_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Serialized identity management: browsing, exports, PIN reveal, token
/// regeneration, and lock state.
class IdentityEndpoint extends Endpoint {
  /// Lists identities with filters and pagination.
  Future<List<ProductIdentity>> list(
    Session session, {
    UuidValue? workspaceId,
    UuidValue? batchId,
    IdentityStatus? status,
    bool onlyFlagged = false,
    int page = 0,
    int pageSize = 25,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesRead);
    final size = pageSize.clamp(1, FauxShieldLimits.maxPageSize);
    final offset = (page < 0 ? 0 : page) * size;

    Set<String>? flaggedIds;
    if (onlyFlagged) {
      final signals = await FraudSignalRecord.db.find(
        session,
        where: (t) =>
            t.workspaceId.equals(context.workspaceId) &
            t.type.notEquals(SignalType.offlineBackfill),
        limit: 5000,
      );
      flaggedIds = signals.map((signal) => signal.identityId.uuid).toSet();
      if (flaggedIds.isEmpty) return <ProductIdentity>[];
    }

    return ProductIdentity.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        if (batchId != null) {
          expression = expression & t.batchId.equals(batchId);
        }
        if (status != null) {
          expression = expression & t.status.equals(status);
        }
        if (flaggedIds != null) {
          expression =
              expression &
              t.id.inSet(
                flaggedIds.map(UuidValue.fromString).toSet(),
              );
        }
        return expression;
      },
      orderBy: (t) => t.createdAt.desc(),
      limit: size,
      offset: offset,
    );
  }

  /// Loads one identity.
  Future<ProductIdentity> get(Session session, UuidValue identityId) async {
    final identity = await ProductIdentity.db.findById(session, identityId);
    if (identity == null) {
      throw NotFoundException(
        message: 'Identity not found.',
        resource: 'identity',
      );
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: identity.workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesRead);
    return identity;
  }

  /// Exports identities as CSV or TSV.
  ///
  /// Bounded so a single call cannot exhaust server resources; truncated
  /// exports are flagged in the result.
  Future<ExportFile> export(
    Session session, {
    UuidValue? workspaceId,
    UuidValue? batchId,
    ExportFormat format = ExportFormat.csv,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesExport);

    final identities = await ProductIdentity.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        if (batchId != null) {
          expression = expression & t.batchId.equals(batchId);
        }
        return expression;
      },
      orderBy: (t) => t.createdAt,
      limit: FauxShieldLimits.maxExportRows + 1,
    );
    final truncated = identities.length > FauxShieldLimits.maxExportRows;
    final rows = truncated
        ? identities.take(FauxShieldLimits.maxExportRows).toList()
        : identities;

    final separator = format == ExportFormat.tsv ? '\t' : ',';
    final buffer = StringBuffer()
      ..writeln(
        <String>[
          'identity_id',
          'batch_id',
          'token_masked',
          'status',
          'first_verified',
          'verification_count',
          'failed_pin_attempts',
          'created_at',
        ].join(separator),
      );
    for (final identity in rows) {
      buffer.writeln(
        <String>[
          identity.id!.uuid,
          identity.batchId.uuid,
          IdentityCrypto.maskToken(identity.qrToken),
          identity.status.name,
          identity.firstVerified.toString(),
          identity.verificationCount.toString(),
          identity.failedPinAttempts.toString(),
          identity.createdAt.toIso8601String(),
        ].join(separator),
      );
    }

    final now = DateTime.now().toUtc();
    final stamp = now.toIso8601String().replaceAll(':', '-').split('.').first;
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'identity.exported',
      targetType: 'product_identity',
      metadata: <String, dynamic>{
        'row_count': rows.length,
        'truncated': truncated,
        'format': format.name,
      },
    );

    return ExportFile(
      filename: 'fauxshield-identities-$stamp.${format.name}',
      mimeType: format == ExportFormat.tsv
          ? 'text/tab-separated-values'
          : 'text/csv',
      content: buffer.toString(),
      rowCount: rows.length,
      truncated: truncated,
    );
  }

  /// Reveals the packaging PIN for one identity. Owner only, always audited.
  Future<RevealedPin> revealPin(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue identityId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesRevealPin);
    return IdentityService().revealPin(
      session,
      workspaceId: context.workspaceId,
      identityId: identityId,
      actorIdentifier: context.userIdentifier,
    );
  }

  /// Regenerates a compromised token. The old token stops resolving.
  Future<ProductIdentity> regenerateToken(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue identityId,
    String? reason,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesGenerate);
    return IdentityService().regenerateToken(
      session,
      workspaceId: context.workspaceId,
      identityId: identityId,
      actorIdentifier: context.userIdentifier,
      reason: reason,
    );
  }

  /// Locks an identity so verification reports fraud until it is unlocked.
  Future<ProductIdentity> lock(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue identityId,
    String? reason,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudWrite);
    return AlertService.lockIdentity(
      session,
      workspaceId: context.workspaceId,
      identityId: identityId,
      actorIdentifier: context.userIdentifier,
      reason: reason,
    );
  }

  /// Unlocks an identity after investigation.
  Future<ProductIdentity> unlock(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue identityId,
    String? note,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.fraudWrite);
    return AlertService.unlockIdentity(
      session,
      workspaceId: context.workspaceId,
      identityId: identityId,
      actorIdentifier: context.userIdentifier,
      note: note,
    );
  }

  /// Soft deletes an identity. The QR token stops resolving.
  Future<ProductIdentity> delete(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue identityId,
    String? reason,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesGenerate);
    return IdentityService().softDelete(
      session,
      workspaceId: context.workspaceId,
      identityId: identityId,
      actorIdentifier: context.userIdentifier,
      reason: reason,
    );
  }

  /// Restores a soft deleted identity to active status.
  Future<ProductIdentity> restore(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue identityId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesGenerate);
    return IdentityService().restore(
      session,
      workspaceId: context.workspaceId,
      identityId: identityId,
      actorIdentifier: context.userIdentifier,
    );
  }
}
