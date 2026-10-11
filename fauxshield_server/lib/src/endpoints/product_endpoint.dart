import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

import '../core/public_url.dart';
import '../generated/protocol.dart';
import '../services/audit_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Maximum size of a single uploaded product image: 2 MB.
const int _maxProductImageBytes = 2 * 1024 * 1024;

/// Maximum number of images a product may carry (matches the reference app).
const int _maxProductImages = 5;

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
    final rows = await Product.db.find(
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
  /// sniffing and a 2 MB cap, written under `web/static/media/products/`,
  /// and served by the static route at `/web/media/products/<file>`.
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

    final directory = Directory('web/static/media/products');
    await directory.create(recursive: true);
    final stamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final suffix = Random.secure().nextInt(0xFFFFFF).toRadixString(36);
    final storedName = '${stamp}_$suffix.$extension';
    await File(
      '${directory.path}/$storedName',
    ).writeAsBytes(bytes, flush: true);
    final url = '/web/media/products/$storedName';

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
}
