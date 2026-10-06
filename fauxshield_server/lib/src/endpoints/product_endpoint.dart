import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/audit_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Product catalog management.
class ProductEndpoint extends Endpoint {
  /// Lists products, optionally filtered by a search term.
  Future<List<Product>> list(
    Session session, {
    UuidValue? workspaceId,
    String? search,
    bool includeArchived = false,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.productsRead);
    final term = search?.trim();
    return Product.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        if (!includeArchived) {
          expression = expression & t.archivedAt.equals(null);
        }
        if (term != null && term.isNotEmpty) {
          expression =
              expression & (t.name.ilike('%$term%') | t.sku.ilike('%$term%'));
        }
        return expression;
      },
      orderBy: (t) => t.createdAt.desc(),
      limit: 200,
    );
  }

  /// Loads one product.
  Future<Product> get(Session session, UuidValue productId) async {
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw NotFoundException(
        message: 'Product not found.',
        resource: 'product',
      );
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: product.workspaceId,
    );
    WorkspaceService.require(context, Permission.productsRead);
    return product;
  }

  /// Creates a product.
  Future<Product> create(
    Session session, {
    UuidValue? workspaceId,
    required String name,
    String? sku,
    String? category,
    String? description,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.productsWrite);
    final trimmed = name.trim();
    if (trimmed.length < 2) {
      throw ValidationException(
        message: 'Product name must be at least 2 characters.',
        field: 'name',
      );
    }
    final now = DateTime.now().toUtc();
    final product = await Product.db.insertRow(
      session,
      Product(
        workspaceId: context.workspaceId,
        name: trimmed,
        sku: sku?.trim(),
        category: category?.trim(),
        description: description,
        imageUrls: imageUrls,
        packaging: packaging,
        shelfLife: shelfLife,
        countryRestrictions: countryRestrictions,
        safetyInstructions: safetyInstructions,
        createdBy: context.userIdentifier,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'product.created',
      targetType: 'product',
      targetId: product.id,
      metadata: <String, dynamic>{'name': product.name},
    );
    return product;
  }

  /// Updates product details. Only supplied fields change.
  Future<Product> update(
    Session session, {
    required UuidValue productId,
    String? name,
    String? sku,
    String? category,
    String? description,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
  }) async {
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw NotFoundException(
        message: 'Product not found.',
        resource: 'product',
      );
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: product.workspaceId,
    );
    WorkspaceService.require(context, Permission.productsWrite);

    final updated = await Product.db.updateRow(
      session,
      product.copyWith(
        name: name?.trim() ?? product.name,
        sku: sku?.trim() ?? product.sku,
        category: category?.trim() ?? product.category,
        description: description ?? product.description,
        imageUrls: imageUrls ?? product.imageUrls,
        packaging: packaging ?? product.packaging,
        shelfLife: shelfLife ?? product.shelfLife,
        countryRestrictions: countryRestrictions ?? product.countryRestrictions,
        safetyInstructions: safetyInstructions ?? product.safetyInstructions,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'product.updated',
      targetType: 'product',
      targetId: productId,
    );
    return updated;
  }

  /// Archives a product. Batches and identities are preserved.
  Future<Product> archive(Session session, UuidValue productId) async {
    final product = await Product.db.findById(session, productId);
    if (product == null) {
      throw NotFoundException(
        message: 'Product not found.',
        resource: 'product',
      );
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: product.workspaceId,
    );
    WorkspaceService.require(context, Permission.productsWrite);
    final updated = await Product.db.updateRow(
      session,
      product.copyWith(
        archivedAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await AuditService.recordForUser(
      session,
      workspaceId: context.workspaceId,
      action: 'product.archived',
      targetType: 'product',
      targetId: productId,
    );
    return updated;
  }
}
