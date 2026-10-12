import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../core/public_url.dart';
import '../generated/protocol.dart';
import '../services/audit_service.dart';
import '../services/product_lifecycle_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Maximum size of a single uploaded product image: 2 MB.
const int _maxProductImageBytes = 2 * 1024 * 1024;

/// The storage uploaded product images are written to.
///
/// `public` is the storage meant to be readable by anyone, which is what a
/// product photo is; it is registered in `server.dart`.
const String cloudStoragePublicId = 'public';

/// Maximum number of images a product may carry (matches the reference app).
const int _maxProductImages = 5;

/// Product catalog management.
class ProductEndpoint extends Endpoint {
  final ProductLifecycleService _lifecycle = ProductLifecycleService();

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
    final rows = await Product.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        // Recycled products are hidden from the live catalog; the recycle bin
        // lists them through [listDeleted].
        expression = expression & t.deletedAt.equals(null);
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
    return [
      for (final product in rows)
        product.copyWith(
          imageUrls: absoluteWebUrls(session, product.imageUrls),
        ),
    ];
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
    return product.copyWith(
      imageUrls: absoluteWebUrls(session, product.imageUrls),
    );
  }

  /// Uploads a product image and returns its public URL.
  ///
  /// Flutter web cannot post multipart forms to Serverpod endpoints, so the
  /// bytes arrive base64-encoded. The payload is validated by magic-byte
  /// sniffing and a 2 MB cap, written to the public cloud storage under
  /// `products/`, and returned as the absolute URL the storage serves it from.
  /// Storage rather than the podlet's disk is what makes the image survive a
  /// deploy, a restart, and a second instance.
  ///
  /// When [productId] is given the URL is appended to the product's
  /// `imageUrls` (capped at [_maxProductImages] images).
  Future<String> uploadImage(
    Session session, {
    UuidValue? workspaceId,
    required String fileName,
    required String data,
    UuidValue? productId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.productsWrite);

    final Uint8List bytes;
    try {
      bytes = base64Decode(data.replaceAll(RegExp(r'\s'), ''));
    } on FormatException {
      throw ValidationException(
        message: 'Image data must be base64 encoded.',
        field: 'data',
      );
    }
    if (bytes.isEmpty) {
      throw ValidationException(
        message: 'Image file cannot be empty.',
        field: 'data',
      );
    }
    if (bytes.length > _maxProductImageBytes) {
      throw ValidationException(
        message: 'Image files must be 2 MB or smaller.',
        field: 'data',
      );
    }
    final extension = _productImageExtension(fileName, bytes);
    if (extension == null) {
      throw ValidationException(
        message: 'Allowed image types are PNG, JPEG, WebP, and SVG.',
        field: 'fileName',
      );
    }

    Product? product;
    if (productId != null) {
      product = await Product.db.findById(session, productId);
      if (product == null || product.workspaceId != context.workspaceId) {
        throw NotFoundException(
          message: 'Product not found.',
          resource: 'product',
        );
      }
      if ((product.imageUrls ?? []).length >= _maxProductImages) {
        throw ValidationException(
          message: 'A product can have at most $_maxProductImages images.',
          field: 'imageUrls',
        );
      }
    }

    // Durable object storage, not the podlet's own disk. Files written under
    // web/static are wiped by the next deploy or restart, so an uploaded image
    // showed up until something recycled the container and then 404ed for
    // everyone who had not cached it. Serverpod Cloud buckets back this in
    // production; locally it is the database, which is just as durable.
    final storage = session.serverpod.storage[cloudStoragePublicId];
    if (storage == null) {
      throw ServiceUnavailableException(
        message: 'Image storage is not configured on this server.',
        reason: 'storageUnavailable',
      );
    }

    final stamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final suffix = Random.secure().nextInt(0xFFFFFF).toRadixString(36);
    final path = 'products/${stamp}_$suffix.$extension';
    final String url;
    try {
      await storage.storeFile(
        session: session,
        path: path,
        byteData: ByteData.sublistView(bytes),
      );
      url = (await storage.publicDownloadUrl(
        session: session,
        path: path,
      )).toString();
    } on CloudStorageException catch (error) {
      throw ServiceUnavailableException(
        message: 'Could not store the image. (${error.message})',
        reason: 'storageUnavailable',
      );
    }

    if (product != null) {
      await Product.db.updateRow(
        session,
        product.copyWith(
          imageUrls: <String>[...?product.imageUrls, url],
        ),
      );
      await AuditService.recordForUser(
        session,
        workspaceId: context.workspaceId,
        action: 'product.image_added',
        targetType: 'product',
        targetId: product.id,
        metadata: <String, dynamic>{'url': url},
      );
    }
    return absoluteWebUrl(session, url);
  }

  /// Returns the storage extension for a validated image, or null when the
  /// payload does not match an allowed image type.
  static String? _productImageExtension(String fileName, Uint8List bytes) {
    // PNG: 89 50 4E 47.
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    }
    // JPEG: FF D8 FF.
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'jpg';
    }
    // WebP: RIFF....WEBP.
    if (bytes.length >= 12 &&
        bytes[4] == 0x52 &&
        bytes[5] == 0x49 &&
        bytes[6] == 0x46 &&
        bytes[7] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'webp';
    }
    // SVG is text: an .svg name plus a leading '<'.
    if (fileName.toLowerCase().endsWith('.svg') &&
        bytes.isNotEmpty &&
        bytes[0] == 0x3C) {
      return 'svg';
    }
    return null;
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
    if (imageUrls != null && imageUrls.length > _maxProductImages) {
      throw ValidationException(
        message: 'A product can have at most $_maxProductImages images.',
        field: 'imageUrls',
      );
    }
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
        imageUrls: relativeWebPaths(session, imageUrls),
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
        imageUrls: relativeWebPaths(session, imageUrls) ?? product.imageUrls,
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
    return updated.copyWith(
      imageUrls: absoluteWebUrls(session, updated.imageUrls),
    );
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
    return updated.copyWith(
      imageUrls: absoluteWebUrls(session, updated.imageUrls),
    );
  }

  /// Moves a product to the recycle bin. Batches and identities stay attached
  /// and the product can be restored with [restore] until it is purged.
  Future<Product> delete(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue productId,
    String? reason,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.productsWrite);
    final deleted = await _lifecycle.softDelete(
      session,
      workspaceId: context.workspaceId,
      productId: productId,
      actorIdentifier: context.userIdentifier,
      reason: reason,
    );
    return deleted.copyWith(
      imageUrls: absoluteWebUrls(session, deleted.imageUrls),
    );
  }

  /// Lists the products sitting in the recycle bin.
  Future<List<Product>> listDeleted(
    Session session, {
    UuidValue? workspaceId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.productsRead);
    final rows = await Product.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(context.workspaceId) &
          t.deletedAt.notEquals(null),
      orderBy: (t) => t.deletedAt.desc(),
    );
    return [
      for (final product in rows)
        product.copyWith(
          imageUrls: absoluteWebUrls(session, product.imageUrls),
        ),
    ];
  }

  /// Restores a recycled product to the live catalog.
  Future<Product> restore(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue productId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.productsWrite);
    final restored = await _lifecycle.restore(
      session,
      workspaceId: context.workspaceId,
      productId: productId,
    );
    return restored.copyWith(
      imageUrls: absoluteWebUrls(session, restored.imageUrls),
    );
  }

  /// Counts everything a delete or purge would affect, so the confirmation
  /// dialogs can spell out exactly what is at stake.
  Future<ProductDeleteImpact> deleteImpact(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue productId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.productsRead);
    return _lifecycle.impact(
      session,
      workspaceId: context.workspaceId,
      productId: productId,
    );
  }

  /// Permanently deletes a recycled product and everything attached to it:
  /// batches, serialized units, verification sessions, reports, and fraud
  /// evidence. Audit events and fraud alerts are kept as history. This cannot
  /// be undone.
  Future<void> purge(
    Session session, {
    UuidValue? workspaceId,
    required UuidValue productId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.productsWrite);
    await _lifecycle.purge(
      session,
      workspaceId: context.workspaceId,
      productId: productId,
    );
  }
}
