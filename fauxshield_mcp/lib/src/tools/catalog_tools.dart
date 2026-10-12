import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:mcp_dart/mcp_dart.dart';

import '../gateway.dart';
import '../tool_support.dart';

/// Products, manufacturing batches, and the serialized units inside them.
void registerCatalogTools(ToolRegistry registry, FauxShieldGateway gateway) {
  final client = gateway.client;
  final workspaceId = gateway.workspaceId;

  // ---------------------------------------------------------------- products

  registry.read(
    'list_products',
    description:
        'List the products a brand has registered. Use the search argument to '
        'match on name or SKU.',
    properties: <String, JsonSchema>{
      'search': JsonSchema.string(
        description: 'Match products by name or SKU.',
      ),
      'include_archived': JsonSchema.boolean(
        description: 'Include archived products. Defaults to false.',
      ),
    },
    body: (args, context) => client.product.list(
      workspaceId: workspaceId,
      search: args.optionalString('search'),
      includeArchived: args.optionalBool('include_archived'),
    ),
  );

  registry.read(
    'get_product',
    description:
        'Read one product by id, including packaging and branding copy.',
    properties: <String, JsonSchema>{
      'product_id': JsonSchema.string(description: 'Product uuid.'),
    },
    required: <String>['product_id'],
    body: (args, context) =>
        client.product.get(args.requiredUuid('product_id')),
  );

  registry.write(
    'create_product',
    description: 'Register a new product for serialization.',
    properties: <String, JsonSchema>{
      'name': JsonSchema.string(description: 'Product name.'),
      'sku': JsonSchema.string(description: 'Stock keeping unit.'),
      'category': JsonSchema.string(description: 'Category, for example food.'),
      'description': JsonSchema.string(description: 'Short description.'),
      'packaging': JsonSchema.string(description: 'Packaging description.'),
      'shelf_life': JsonSchema.string(description: 'Shelf life, as printed.'),
      'country_restrictions': JsonSchema.array(
        items: JsonSchema.string(),
        description: 'Countries this product may be sold in.',
      ),
      'safety_instructions': JsonSchema.string(
        description: 'Safety or handling instructions.',
      ),
    },
    required: <String>['name'],
    body: (args, context) => client.product.create(
      workspaceId: workspaceId,
      name: args.requiredString('name'),
      sku: args.optionalString('sku'),
      category: args.optionalString('category'),
      description: args.optionalString('description'),
      packaging: args.optionalString('packaging'),
      shelfLife: args.optionalString('shelf_life'),
      countryRestrictions: args.optionalStringList('country_restrictions'),
      safetyInstructions: args.optionalString('safety_instructions'),
    ),
  );

  registry.write(
    'update_product',
    description: 'Update the details of an existing product.',
    properties: <String, JsonSchema>{
      'product_id': JsonSchema.string(description: 'Product uuid.'),
      'name': JsonSchema.string(description: 'New name.'),
      'sku': JsonSchema.string(description: 'New SKU.'),
      'category': JsonSchema.string(description: 'New category.'),
      'description': JsonSchema.string(description: 'New description.'),
      'packaging': JsonSchema.string(description: 'New packaging copy.'),
      'shelf_life': JsonSchema.string(description: 'New shelf life.'),
      'safety_instructions': JsonSchema.string(
        description: 'New safety instructions.',
      ),
    },
    required: <String>['product_id'],
    idempotent: true,
    body: (args, context) => client.product.update(
      productId: args.requiredUuid('product_id'),
      name: args.optionalString('name'),
      sku: args.optionalString('sku'),
      category: args.optionalString('category'),
      description: args.optionalString('description'),
      packaging: args.optionalString('packaging'),
      shelfLife: args.optionalString('shelf_life'),
      safetyInstructions: args.optionalString('safety_instructions'),
    ),
  );

  registry.write(
    'archive_product',
    description:
        'Archive a product. Archives keep history and can be restored; they do '
        'not delete anything.',
    properties: <String, JsonSchema>{
      'product_id': JsonSchema.string(description: 'Product uuid.'),
    },
    required: <String>['product_id'],
    idempotent: true,
    body: (args, context) =>
        client.product.archive(args.requiredUuid('product_id')),
  );

  registry.write(
    'restore_product',
    description: 'Restore a product from the recycle bin.',
    properties: <String, JsonSchema>{
      'product_id': JsonSchema.string(description: 'Product uuid.'),
    },
    required: <String>['product_id'],
    idempotent: true,
    body: (args, context) => client.product.restore(
      workspaceId: workspaceId,
      productId: args.requiredUuid('product_id'),
    ),
  );

  registry.read(
    'product_delete_impact',
    description:
        'Report what deleting a product would remove: batches, units, and '
        'verification history. Read this before asking to delete.',
    properties: <String, JsonSchema>{
      'product_id': JsonSchema.string(description: 'Product uuid.'),
    },
    required: <String>['product_id'],
    body: (args, context) => client.product.deleteImpact(
      workspaceId: workspaceId,
      productId: args.requiredUuid('product_id'),
    ),
  );

  // ---------------------------------------------------------------- batches

  registry.read(
    'list_batches',
    description: 'List manufacturing batches, optionally for one product.',
    properties: <String, JsonSchema>{
      'product_id': JsonSchema.string(
        description: 'Only batches of this product.',
      ),
    },
    body: (args, context) => client.batch.list(
      workspaceId: workspaceId,
      productId: args.optionalUuid('product_id'),
    ),
  );

  registry.read(
    'get_batch',
    description: 'Read one batch by id.',
    properties: <String, JsonSchema>{
      'batch_id': JsonSchema.string(description: 'Batch uuid.'),
    },
    required: <String>['batch_id'],
    body: (args, context) => client.batch.get(args.requiredUuid('batch_id')),
  );

  registry.read(
    'batch_stats',
    description:
        'Count the units of a batch by state: active, verified, locked, '
        'recalled, and flagged.',
    properties: <String, JsonSchema>{
      'batch_id': JsonSchema.string(description: 'Batch uuid.'),
    },
    required: <String>['batch_id'],
    body: (args, context) => client.batch.stats(args.requiredUuid('batch_id')),
  );

  registry.write(
    'create_batch',
    description:
        'Create a manufacturing batch. Units are minted separately with '
        'generate_units.',
    properties: <String, JsonSchema>{
      'product_id': JsonSchema.string(
        description: 'Product this batch is for.',
      ),
      'reference': JsonSchema.string(
        description: 'Batch or lot reference, for example LOT-2026-04.',
      ),
      'quantity': JsonSchema.integer(
        description: 'Planned unit count for this batch.',
      ),
      'distribution_region': JsonSchema.string(
        description:
            'Declared distribution region. Scans outside it are leakage '
            'signals.',
      ),
      'manufacture_date': JsonSchema.string(
        description: 'ISO 8601 manufacture date. Defaults to now.',
      ),
      'expiry_date': JsonSchema.string(
        description: 'Optional ISO 8601 expiry date.',
      ),
      'notes': JsonSchema.string(description: 'Internal notes.'),
    },
    required: <String>[
      'product_id',
      'reference',
      'quantity',
      'distribution_region',
    ],
    body: (args, context) => client.batch.create(
      workspaceId: workspaceId,
      productId: args.requiredUuid('product_id'),
      reference: args.requiredString('reference'),
      quantity: args.requiredInt('quantity', min: 1, max: 1000000),
      distributionRegion: args.requiredString('distribution_region'),
      manufactureDate: args.requiredDateOrNow('manufacture_date'),
      expiryDate: args.optionalDate('expiry_date'),
      notes: args.optionalString('notes'),
    ),
  );

  registry.write(
    'update_batch',
    description: 'Update a batch reference, region, quantity, notes or status.',
    properties: <String, JsonSchema>{
      'batch_id': JsonSchema.string(description: 'Batch uuid.'),
      'reference': JsonSchema.string(description: 'New reference.'),
      'distribution_region': JsonSchema.string(description: 'New region.'),
      'quantity': JsonSchema.integer(description: 'New planned quantity.'),
      'notes': JsonSchema.string(description: 'New notes.'),
      'status': JsonSchema.string(
        description: 'New status.',
        enumValues: <String>['created', 'inProduction', 'shipped', 'recalled'],
      ),
      'expiry_date': JsonSchema.string(
        description: 'New ISO 8601 expiry date.',
      ),
    },
    required: <String>['batch_id'],
    idempotent: true,
    body: (args, context) => client.batch.update(
      batchId: args.requiredUuid('batch_id'),
      reference: args.optionalString('reference'),
      distributionRegion: args.optionalString('distribution_region'),
      quantity: args.optionalInt('quantity'),
      notes: args.optionalString('notes'),
      status: args.optionalEnum<BatchStatus>('status', BatchStatus.values),
      expiryDate: args.optionalDate('expiry_date'),
    ),
  );

  // ------------------------------------------------------------------ units

  registry.write(
    'generate_units',
    description:
        'Mint serialized units for a batch: a signed QR token and a packaging '
        'PIN per unit. Safe to retry with the same idempotency_key.',
    properties: <String, JsonSchema>{
      'batch_id': JsonSchema.string(description: 'Batch to serialize.'),
      'quantity': JsonSchema.integer(description: 'How many units to mint.'),
      'idempotency_key': JsonSchema.string(
        description:
            'Repeats an earlier run instead of minting twice. Pass the key '
            'from a previous attempt when retrying.',
      ),
    },
    required: <String>['batch_id', 'quantity'],
    idempotent: true,
    body: (args, context) => client.batch.generateIdentities(
      workspaceId: workspaceId,
      batchId: args.requiredUuid('batch_id'),
      quantity: args.requiredInt('quantity', min: 1, max: 5000),
      idempotencyKey: gateway.idempotencyKey(
        'generate_units',
        args.optionalString('idempotency_key'),
      ),
    ),
  );

  registry.read(
    'list_units',
    description: 'List serialized units, optionally for one batch.',
    properties: <String, JsonSchema>{
      'batch_id': JsonSchema.string(description: 'Only units in this batch.'),
      'status': JsonSchema.string(
        description: 'Filter by unit status.',
        enumValues: <String>[
          'active',
          'locked',
          'recalled',
          'regenerated',
          'deleted',
        ],
      ),
      'only_flagged': JsonSchema.boolean(
        description: 'Only units that carry fraud signals.',
      ),
      'page': JsonSchema.integer(description: 'Page number, starting at 1.'),
      'page_size': JsonSchema.integer(description: 'Rows per page, max 200.'),
    },
    body: (args, context) {
      final paging = args.paging();
      return client.identity.list(
        workspaceId: workspaceId,
        batchId: args.optionalUuid('batch_id'),
        status: args.optionalEnum<IdentityStatus>(
          'status',
          IdentityStatus.values,
        ),
        onlyFlagged: args.optionalBool('only_flagged'),
        page: paging.page,
        pageSize: paging.pageSize,
      );
    },
  );

  registry.read(
    'get_unit',
    description: 'Read one serialized unit by id.',
    properties: <String, JsonSchema>{
      'unit_id': JsonSchema.string(description: 'Unit uuid.'),
    },
    required: <String>['unit_id'],
    body: (args, context) => client.identity.get(args.requiredUuid('unit_id')),
  );

  registry.read(
    'export_units',
    description:
        'Export the units of a batch as CSV or JSON, for handoff to a printing '
        'or packaging partner.',
    properties: <String, JsonSchema>{
      'batch_id': JsonSchema.string(description: 'Batch uuid.'),
      'format': JsonSchema.string(
        description: 'Export format.',
        enumValues: <String>['csv', 'json'],
      ),
    },
    required: <String>['batch_id'],
    body: (args, context) async {
      final export = await client.identity.export(
        workspaceId: workspaceId,
        batchId: args.requiredUuid('batch_id'),
        format:
            args.optionalEnum<ExportFormat>('format', ExportFormat.values) ??
            ExportFormat.csv,
      );
      return <String, dynamic>{
        'filename': export.filename,
        'mime_type': export.mimeType,
        'row_count': export.rowCount,
        'truncated': export.truncated,
        'content': export.content,
      };
    },
  );

  registry.write(
    'lock_unit',
    description:
        'Lock a unit so its next scan is reported as locked, for example after '
        'a confirmed clone.',
    properties: <String, JsonSchema>{
      'unit_id': JsonSchema.string(description: 'Unit uuid.'),
      'reason': JsonSchema.string(description: 'Why the unit is locked.'),
    },
    required: <String>['unit_id'],
    idempotent: true,
    body: (args, context) => client.identity.lock(
      workspaceId: workspaceId,
      identityId: args.requiredUuid('unit_id'),
      reason: args.optionalString('reason'),
    ),
  );

  registry.write(
    'unlock_unit',
    description: 'Release a unit lock after an investigation clears it.',
    properties: <String, JsonSchema>{
      'unit_id': JsonSchema.string(description: 'Unit uuid.'),
      'note': JsonSchema.string(description: 'Why the unit was cleared.'),
    },
    required: <String>['unit_id'],
    idempotent: true,
    body: (args, context) => client.identity.unlock(
      workspaceId: workspaceId,
      identityId: args.requiredUuid('unit_id'),
      note: args.optionalString('note'),
    ),
  );

  registry.write(
    'regenerate_unit_token',
    description:
        'Issue a replacement token for a compromised unit. The original token '
        'stops resolving, and the new one is linked to it.',
    properties: <String, JsonSchema>{
      'unit_id': JsonSchema.string(description: 'Unit uuid.'),
      'reason': JsonSchema.string(description: 'Why the token is replaced.'),
    },
    required: <String>['unit_id'],
    destructive: true,
    body: (args, context) => client.identity.regenerateToken(
      workspaceId: workspaceId,
      identityId: args.requiredUuid('unit_id'),
      reason: args.optionalString('reason'),
    ),
  );
}
