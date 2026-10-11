import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'audit_service.dart';

/// Recycle-bin lifecycle for products: soft delete, restore, impact summary,
/// and the permanent purge.
///
/// Soft delete mirrors `IdentityService.softDelete`: the row stays in place
/// with a `deletedAt` marker, so restore is lossless and listings simply hide
/// the product. Purge is the only destructive step and runs inside a single
/// transaction, deleting children before parents because every foreign key in
/// the schema is `ON DELETE NO ACTION`.
///
/// Purge erases the product, its batches, its serialized units, their
/// verification sessions, consumer reports, fraud signal evidence, and
/// inspector cache entries. Workspace-level history deliberately survives:
/// audit events (append-only) and fraud alerts (documented to outlive
/// identities) keep their rows and only reference ids that no longer resolve.
class ProductLifecycleService {
  /// Moves the product into the recycle bin.
  Future<Product> softDelete(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue productId,
    required String actorIdentifier,
    String? reason,
  }) async {
    final product = await _load(session, workspaceId, productId);
    if (product.deletedAt != null) return product;
    final saved = await Product.db.updateRow(
      session,
      product.copyWith(
        deletedAt: DateTime.now().toUtc(),
        deletedBy: actorIdentifier,
        deleteReason: reason,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: workspaceId,
      action: 'product.deleted',
      targetType: 'product',
      targetId: productId,
      metadata: <String, dynamic>{'reason': reason, 'name': product.name},
    );
    return saved;
  }

  /// Restores a recycled product to the live catalog.
  Future<Product> restore(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue productId,
  }) async {
    final product = await _load(session, workspaceId, productId);
    if (product.deletedAt == null) return product;
    final saved = await Product.db.updateRow(
      session,
      product.copyWith(
        deletedAt: null,
        deletedBy: null,
        deleteReason: null,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: workspaceId,
      action: 'product.restored',
      targetType: 'product',
      targetId: productId,
      metadata: <String, dynamic>{'name': product.name},
    );
    return saved;
  }

  /// Counts everything a purge would erase, for the confirmation dialogs.
  Future<ProductDeleteImpact> impact(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue productId,
  }) async {
    final product = await _load(session, workspaceId, productId);
    final tree = await _loadTree(session, productId);
    if (tree.batchIds.isEmpty) {
      return ProductDeleteImpact(
        productId: productId,
        productName: product.name,
        batchCount: 0,
        identityCount: 0,
        verificationCount: 0,
        alertCount: 0,
        inRecycleBin: product.deletedAt != null,
      );
    }
    final batchIds = tree.batchIds.toSet();
    final identityIds = tree.identityIds;
    return ProductDeleteImpact(
      productId: productId,
      productName: product.name,
      batchCount: batchIds.length,
      identityCount: identityIds.length,
      verificationCount: identityIds.isEmpty
          ? 0
          : await VerificationSession.db.count(
              session,
              where: (t) => t.identityId.inSet(identityIds),
            ),
      alertCount: await FraudAlert.db.count(
        session,
        where: (t) {
          final byBatch = t.batchId.inSet(batchIds);
          return identityIds.isEmpty
              ? byBatch
              : byBatch | t.identityId.inSet(identityIds);
        },
      ),
      inRecycleBin: product.deletedAt != null,
    );
  }

  /// Permanently deletes the product and its whole tree.
  Future<void> purge(
    Session session, {
    required UuidValue workspaceId,
    required UuidValue productId,
  }) async {
    final product = await _load(session, workspaceId, productId);
    final tree = await _loadTree(session, productId);

    await session.db.transaction((txn) async {
      if (tree.identityIds.isNotEmpty) {
        await VerificationSession.db.deleteWhere(
          session,
          where: (t) => t.identityId.inSet(tree.identityIds),
          transaction: txn,
        );
        await FakeReport.db.deleteWhere(
          session,
          where: (t) => t.identityId.inSet(tree.identityIds),
          transaction: txn,
        );
        await FraudSignalRecord.db.deleteWhere(
          session,
          where: (t) => t.identityId.inSet(tree.identityIds),
          transaction: txn,
        );
      }
      if (tree.batchIds.isNotEmpty) {
        await FraudSignalRecord.db.deleteWhere(
          session,
          where: (t) => t.batchId.inSet(tree.batchIds.toSet()),
          transaction: txn,
        );
      }
      await ProductIdentity.db.deleteWhere(
        session,
        where: (t) => t.batchId.inSet(tree.batchIds.toSet()),
        transaction: txn,
      );
      await Batch.db.deleteWhere(
        session,
        where: (t) => t.productId.equals(productId),
        transaction: txn,
      );
      await Product.db.deleteRow(session, product, transaction: txn);
    });

    await AuditService.recordForUser(
      session,
      workspaceId: workspaceId,
      action: 'product.purged',
      targetType: 'product',
      targetId: productId,
      metadata: <String, dynamic>{
        'name': product.name,
        'batches': tree.batchIds.length,
        'identities': tree.identityIds.length,
      },
    );
  }

  Future<Product> _load(
    Session session,
    UuidValue workspaceId,
    UuidValue productId,
  ) async {
    final product = await Product.db.findById(session, productId);
    if (product == null || product.workspaceId != workspaceId) {
      throw NotFoundException(
        message: 'Product not found.',
        resource: 'product',
      );
    }
    return product;
  }

  /// Resolves the product's batch and identity ids once, so counts and the
  /// purge agree on the same tree.
  Future<({List<UuidValue> batchIds, Set<UuidValue> identityIds})> _loadTree(
    Session session,
    UuidValue productId,
  ) async {
    final batches = await Batch.db.find(
      session,
      where: (t) => t.productId.equals(productId),
    );
    final batchIds = batches.map((batch) => batch.id!).toList(growable: false);
    if (batchIds.isEmpty) {
      return (batchIds: batchIds, identityIds: const <UuidValue>{});
    }
    final identities = await ProductIdentity.db.find(
      session,
      where: (t) => t.batchId.inSet(batchIds.toSet()),
    );
    return (
      batchIds: batchIds,
      identityIds: identities.map((identity) => identity.id!).toSet(),
    );
  }
}
