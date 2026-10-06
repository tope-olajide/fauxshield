import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/audit_service.dart';
import '../services/idempotency_service.dart';
import '../services/identity_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Manufacturing batch management.
class BatchEndpoint extends Endpoint {
  /// Lists batches for the workspace, optionally for one product.
  Future<List<Batch>> list(
    Session session, {
    UuidValue? workspaceId,
    UuidValue? productId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.batchesRead);
    return Batch.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        if (productId != null) {
          expression = expression & t.productId.equals(productId);
        }
        return expression;
      },
      orderBy: (t) => t.createdAt.desc(),
      limit: 200,
    );
  }

  /// Loads one batch.
  Future<Batch> get(Session session, UuidValue batchId) async {
    final batch = await Batch.db.findById(session, batchId);
    if (batch == null) {
      throw NotFoundException(message: 'Batch not found.', resource: 'batch');
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: batch.workspaceId,
    );
    WorkspaceService.require(context, Permission.batchesRead);
    return batch;
  }

  /// Creates a batch for a product.
  Future<Batch> create(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue productId,
    required String reference,
    required DateTime manufactureDate,
    DateTime? expiryDate,
    required String distributionRegion,
    required int quantity,
    String? notes,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.batchesWrite);

    final product = await Product.db.findById(session, productId);
    if (product == null || product.workspaceId != context.workspaceId) {
      throw NotFoundException(
        message: 'Product not found.',
        resource: 'product',
      );
    }
    final trimmedReference = reference.trim();
    if (trimmedReference.length < 2) {
      throw ValidationException(
        message: 'Batch reference must be at least 2 characters.',
        field: 'reference',
      );
    }
    if (quantity < 1) {
      throw ValidationException(
        message: 'Batch quantity must be at least 1.',
        field: 'quantity',
      );
    }
    final region = distributionRegion.trim();
    if (region.isEmpty) {
      throw ValidationException(
        message: 'Set the distribution region for the batch.',
        field: 'distributionRegion',
      );
    }

    final now = DateTime.now().toUtc();
    final batch = await Batch.db.insertRow(
      session,
      Batch(
        workspaceId: context.workspaceId,
        productId: productId,
        reference: trimmedReference,
        manufactureDate: manufactureDate.toUtc(),
        expiryDate: expiryDate?.toUtc(),
        distributionRegion: region,
        quantity: quantity,
        notes: notes,
        status: BatchStatus.created,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'batch.created',
      targetType: 'batch',
      targetId: batch.id,
      metadata: <String, dynamic>{
        'reference': batch.reference,
        'quantity': batch.quantity,
      },
    );
    return batch;
  }

  /// Updates an active batch. Recalled batches are immutable.
  Future<Batch> update(
    Session session, {
    required UuidValue batchId,
    String? reference,
    DateTime? expiryDate,
    String? distributionRegion,
    int? quantity,
    String? notes,
    BatchStatus? status,
  }) async {
    final batch = await Batch.db.findById(session, batchId);
    if (batch == null) {
      throw NotFoundException(message: 'Batch not found.', resource: 'batch');
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: batch.workspaceId,
    );
    WorkspaceService.require(context, Permission.batchesWrite);
    if (batch.status == BatchStatus.recalled) {
      throw ConflictException(
        message: 'A recalled batch cannot be edited.',
        resource: 'batch',
      );
    }

    final updated = await Batch.db.updateRow(
      session,
      batch.copyWith(
        reference: reference?.trim() ?? batch.reference,
        expiryDate: expiryDate?.toUtc() ?? batch.expiryDate,
        distributionRegion:
            distributionRegion?.trim() ?? batch.distributionRegion,
        quantity: quantity ?? batch.quantity,
        notes: notes ?? batch.notes,
        status: status ?? batch.status,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'batch.updated',
      targetType: 'batch',
      targetId: batchId,
    );
    return updated;
  }

  /// Generates serialized identities for a batch.
  ///
  /// Safe to retry: the same idempotency key replays the original result
  /// instead of minting another run of tokens.
  Future<IdentityGenerationResult> generateIdentities(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue batchId,
    required int quantity,
    required String idempotencyKey,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesGenerate);
    return IdempotencyService.run(
      session,
      workspaceId: context.workspaceId,
      operation: 'identity.generate',
      key: idempotencyKey,
      request: <String, dynamic>{
        'batch_id': batchId.uuid,
        'quantity': quantity,
      },
      decode: IdentityGenerationResult.fromJson,
      encode: (value) => value.toJson(),
      action: () => IdentityService().generateForBatch(
        session,
        workspaceId: context.workspaceId,
        batchId: batchId,
        quantity: quantity,
        actorIdentifier: context.userIdentifier,
      ),
    );
  }

  /// Identity level statistics for the batch detail screen.
  Future<BatchStats> stats(Session session, UuidValue batchId) async {
    final batch = await Batch.db.findById(session, batchId);
    if (batch == null) {
      throw NotFoundException(message: 'Batch not found.', resource: 'batch');
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: batch.workspaceId,
    );
    WorkspaceService.require(context, Permission.batchesRead);

    final active = await ProductIdentity.db.count(
      session,
      where: (t) =>
          t.batchId.equals(batchId) &
          t.deletedAt.equals(null) &
          t.status.equals(IdentityStatus.active),
    );
    final verified = await ProductIdentity.db.count(
      session,
      where: (t) => t.batchId.equals(batchId) & t.firstVerified.equals(true),
    );
    final locked = await ProductIdentity.db.count(
      session,
      where: (t) =>
          t.batchId.equals(batchId) & t.status.equals(IdentityStatus.locked),
    );
    final recalled = await ProductIdentity.db.count(
      session,
      where: (t) =>
          t.batchId.equals(batchId) & t.status.equals(IdentityStatus.recalled),
    );
    final deleted = await ProductIdentity.db.count(
      session,
      where: (t) => t.batchId.equals(batchId) & t.deletedAt.notEquals(null),
    );

    final signals = await FraudSignalRecord.db.find(
      session,
      where: (t) =>
          t.batchId.equals(batchId) &
          t.type.notEquals(SignalType.offlineBackfill),
      limit: 5000,
    );
    final flagged = signals
        .map((signal) => signal.identityId.uuid)
        .toSet()
        .length;

    return BatchStats(
      batchId: batchId,
      totalIdentities: batch.quantity,
      active: active,
      verified: verified,
      locked: locked,
      recalled: recalled,
      deleted: deleted,
      flagged: flagged,
      generatedAt: DateTime.now().toUtc(),
    );
  }
}
