import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield products ...`
class ProductsCommand extends Command<int> {
  ProductsCommand() {
    addSubcommand(ProductsListCommand());
    addSubcommand(ProductsShowCommand());
    addSubcommand(ProductsCreateCommand());
    addSubcommand(ProductsUpdateCommand());
    addSubcommand(ProductsArchiveCommand());
    addSubcommand(ProductsRestoreCommand());
    addSubcommand(ProductsDeletedCommand());
    addSubcommand(ProductsDeleteImpactCommand());
    addSubcommand(ProductsDeleteCommand());
    addSubcommand(ProductsPurgeCommand());
  }

  @override
  String get name => 'products';

  @override
  String get description => 'Manage the product catalogue.';

  @override
  String get invocation =>
      'fauxshield products '
      '<list|show|create|update|archive|restore|deleted|delete-impact|delete|purge>';
}

/// Lists the products in the active workspace.
class ProductsListCommand extends CliCommand {
  ProductsListCommand() {
    argParser
      ..addOption('search', abbr: 's', help: 'Filter by name or SKU.')
      ..addFlag(
        'archived',
        abbr: 'a',
        negatable: false,
        help: 'Include archived products.',
      );
  }

  @override
  String get name => 'list';

  @override
  String get description => 'List products in the workspace.';

  @override
  Future<int> run() async {
    final context = connect();
    final List<Product> products;
    try {
      products = await context.client.product.list(
        search: argResults?['search'] as String?,
        includeArchived: argResults?['archived'] as bool? ?? false,
      );
    } catch (error) {
      throw CliException('Could not list products: ${describeError(error)}');
    }

    if (context.json) {
      printJson(products.map((product) => product.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['NAME', 'SKU', 'CATEGORY', 'CREATED', 'ID'],
      products
          .map(
            (product) => <String>[
              shorten(product.name, max: 30),
              shorten(product.sku, max: 18),
              shorten(product.category, max: 14),
              formatTime(product.createdAt),
              product.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${products.length} product(s).');
    return 0;
  }
}

/// Creates a product.
class ProductsCreateCommand extends CliCommand {
  ProductsCreateCommand() {
    argParser
      ..addOption('name', abbr: 'n', help: 'Product name.')
      ..addOption('sku', help: 'Stock keeping unit.')
      ..addOption('category', abbr: 'c', help: 'Category, for example food.')
      ..addOption('description', abbr: 'd', help: 'Short description.');
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Create a product.';

  @override
  Future<int> run() async {
    final name = requiredOption('name');
    final context = connect();
    final Product product;
    try {
      product = await context.client.product.create(
        name: name,
        sku: (argResults?['sku'] as String?)?.trim(),
        category: (argResults?['category'] as String?)?.trim(),
        description: (argResults?['description'] as String?)?.trim(),
      );
    } catch (error) {
      throw CliException(
        'Could not create the product: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(product.toJson());
      return 0;
    }

    stdout.writeln('Created ${product.name}');
    stdout.writeln('  id:  ${product.id?.uuid}');
    if (product.sku != null) stdout.writeln('  sku: ${product.sku}');
    return 0;
  }
}

/// Shows one product with everything printed on its packaging.
class ProductsShowCommand extends CliCommand {
  ProductsShowCommand() {
    argParser.addOption(
      'product',
      abbr: 'p',
      help: 'Product id.',
      valueHelp: '<uuid>',
    );
  }

  @override
  String get name => 'show';

  @override
  String get description => 'Show a product.';

  @override
  Future<int> run() async {
    final productId = parseUuid(requiredOption('product'), '--product');
    final context = connect();
    final Product product;
    try {
      product = await context.client.product.get(productId);
    } catch (error) {
      throw CliException('Could not read the product: ${describeError(error)}');
    }

    if (context.json) {
      printJson(product.toJson());
      return 0;
    }

    printProduct(product);
    return 0;
  }
}

/// Updates the fields that were passed.
class ProductsUpdateCommand extends CliCommand {
  ProductsUpdateCommand() {
    argParser
      ..addOption('product', abbr: 'p', help: 'Product id.')
      ..addOption('name', abbr: 'n', help: 'Product name.')
      ..addOption('sku', help: 'Stock keeping unit.')
      ..addOption('category', abbr: 'c', help: 'Category, for example food.')
      ..addOption('description', abbr: 'd', help: 'Short description.')
      ..addOption('packaging', help: 'Packaging description.')
      ..addOption('shelf-life', help: 'Shelf life, for example 12 months.')
      ..addOption(
        'countries',
        help: 'Comma separated ISO country codes to restrict sales to.',
      )
      ..addOption('safety', help: 'Safety instructions.')
      ..addMultiOption('image', help: 'Image URL. Repeat for several images.');
  }

  @override
  String get name => 'update';

  @override
  String get description => 'Update a product.';

  @override
  Future<int> run() async {
    final productId = parseUuid(requiredOption('product'), '--product');
    final images = (argResults?['image'] as List<String>?) ?? const <String>[];
    final countries = (argResults?['countries'] as String?)?.trim() ?? '';
    final context = connect();
    final Product product;
    try {
      product = await context.client.product.update(
        productId: productId,
        name: optionalOption('name'),
        sku: optionalOption('sku'),
        category: optionalOption('category'),
        description: optionalOption('description'),
        packaging: optionalOption('packaging'),
        shelfLife: optionalOption('shelf-life'),
        safetyInstructions: optionalOption('safety'),
        imageUrls: images.isEmpty ? null : images,
        countryRestrictions: countries.isEmpty
            ? null
            : splitList(countries, '--countries'),
      );
    } catch (error) {
      throw CliException(
        'Could not update the product: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(product.toJson());
      return 0;
    }

    stdout.writeln('Updated ${product.name}');
    printProduct(product);
    return 0;
  }
}

/// Archives a product without touching its batches.
class ProductsArchiveCommand extends CliCommand {
  ProductsArchiveCommand() {
    argParser.addOption('product', abbr: 'p', help: 'Product id.');
  }

  @override
  String get name => 'archive';

  @override
  String get description => 'Archive a product.';

  @override
  Future<int> run() async {
    final productId = parseUuid(requiredOption('product'), '--product');
    final context = connect();
    final Product product;
    try {
      product = await context.client.product.archive(productId);
    } catch (error) {
      throw CliException(
        'Could not archive the product: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(product.toJson());
      return 0;
    }
    stdout.writeln(
      'Archived ${product.name} at ${formatTime(product.archivedAt)}.',
    );
    return 0;
  }
}

/// Brings an archived or deleted product back.
class ProductsRestoreCommand extends CliCommand {
  ProductsRestoreCommand() {
    argParser.addOption('product', abbr: 'p', help: 'Product id.');
  }

  @override
  String get name => 'restore';

  @override
  String get description => 'Restore an archived or deleted product.';

  @override
  Future<int> run() async {
    final productId = parseUuid(requiredOption('product'), '--product');
    final context = connect();
    final Product product;
    try {
      product = await context.client.product.restore(productId: productId);
    } catch (error) {
      throw CliException(
        'Could not restore the product: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(product.toJson());
      return 0;
    }
    stdout.writeln('Restored ${product.name}');
    return 0;
  }
}

/// Lists the recycle bin.
class ProductsDeletedCommand extends CliCommand {
  @override
  String get name => 'deleted';

  @override
  String get description => 'List deleted products that can still be restored.';

  @override
  Future<int> run() async {
    final context = connect();
    final List<Product> products;
    try {
      products = await context.client.product.listDeleted();
    } catch (error) {
      throw CliException(
        'Could not list deleted products: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(products.map((product) => product.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['NAME', 'SKU', 'DELETED', 'REASON', 'ID'],
      products
          .map(
            (product) => <String>[
              shorten(product.name, max: 30),
              shorten(product.sku, max: 18),
              formatTime(product.deletedAt),
              shorten(product.deleteReason, max: 24),
              product.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${products.length} deleted product(s).');
    return 0;
  }
}

/// Reports what deleting a product would take with it.
class ProductsDeleteImpactCommand extends CliCommand {
  ProductsDeleteImpactCommand() {
    argParser.addOption('product', abbr: 'p', help: 'Product id.');
  }

  @override
  String get name => 'delete-impact';

  @override
  String get description =>
      'Show what a product delete would cascade to before doing it.';

  @override
  Future<int> run() async {
    final productId = parseUuid(requiredOption('product'), '--product');
    final context = connect();
    final ProductDeleteImpact impact;
    try {
      impact = await context.client.product.deleteImpact(productId: productId);
    } catch (error) {
      throw CliException(
        'Could not read the delete impact: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(impact.toJson());
      return 0;
    }

    stdout.writeln('Product:       ${impact.productName}');
    stdout.writeln('Batches:       ${impact.batchCount}');
    stdout.writeln('Identities:    ${impact.identityCount}');
    stdout.writeln('Verifications: ${impact.verificationCount}');
    stdout.writeln('Alerts:        ${impact.alertCount}');
    if (impact.inRecycleBin) {
      stdout.writeln('This product is already in the recycle bin.');
    }
    return 0;
  }
}

/// Soft deletes a product into the recycle bin.
class ProductsDeleteCommand extends CliCommand {
  ProductsDeleteCommand() {
    argParser
      ..addOption('product', abbr: 'p', help: 'Product id.')
      ..addOption('reason', abbr: 'r', help: 'Why the product is going away.')
      ..addFlag(
        'yes',
        abbr: 'y',
        negatable: false,
        help: 'Skip the confirmation prompt.',
      );
  }

  @override
  String get name => 'delete';

  @override
  String get description => 'Delete a product into the recycle bin.';

  @override
  Future<int> run() async {
    final productId = parseUuid(requiredOption('product'), '--product');
    final context = connect();

    if (!confirmDestructive(
      argResults?['yes'] as bool? ?? false,
      'Delete product $productId? Batches and identities stay readable in the '
      'recycle bin and can be restored.',
    )) {
      stdout.writeln('Cancelled.');
      return 0;
    }

    final Product product;
    try {
      product = await context.client.product.delete(
        productId: productId,
        reason: optionalOption('reason'),
      );
    } catch (error) {
      throw CliException(
        'Could not delete the product: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(product.toJson());
      return 0;
    }
    stdout.writeln(
      'Deleted ${product.name}. Restore it with `products restore`.',
    );
    return 0;
  }
}

/// Permanently removes a deleted product and everything under it.
class ProductsPurgeCommand extends CliCommand {
  ProductsPurgeCommand() {
    argParser
      ..addOption('product', abbr: 'p', help: 'Product id.')
      ..addFlag(
        'yes',
        abbr: 'y',
        negatable: false,
        help: 'Skip the confirmation prompt.',
      );
  }

  @override
  String get name => 'purge';

  @override
  String get description =>
      'Permanently erase a deleted product. This cannot be undone.';

  @override
  Future<int> run() async {
    final productId = parseUuid(requiredOption('product'), '--product');
    final context = connect();

    if (!confirmDestructive(
      argResults?['yes'] as bool? ?? false,
      'Purge product $productId for good? Every batch, identity, and '
      'verification under it goes too, and no backup is kept.',
    )) {
      stdout.writeln('Cancelled.');
      return 0;
    }

    try {
      await context.client.product.purge(productId: productId);
    } catch (error) {
      throw CliException(
        'Could not purge the product: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(<String, dynamic>{'purged': productId.uuid});
    } else {
      stdout.writeln('Purged $productId.');
    }
    return 0;
  }
}

/// Prints the fields a product record carries.
void printProduct(Product product) {
  stdout.writeln('  id:       ${product.id?.uuid}');
  stdout.writeln('  sku:      ${product.sku ?? '-'}');
  stdout.writeln('  category: ${product.category ?? '-'}');
  stdout.writeln('  created:  ${formatTime(product.createdAt)}');
  stdout.writeln('  updated:  ${formatTime(product.updatedAt)}');
  if (product.archivedAt != null) {
    stdout.writeln('  archived: ${formatTime(product.archivedAt)}');
  }
  if (product.deletedAt != null) {
    stdout.writeln('  deleted:  ${formatTime(product.deletedAt)}');
  }
  if (product.packaging != null) {
    stdout.writeln('  packaging: ${product.packaging}');
  }
  if (product.shelfLife != null) {
    stdout.writeln('  shelf life: ${product.shelfLife}');
  }
  if (product.countryRestrictions != null &&
      product.countryRestrictions!.isNotEmpty) {
    stdout.writeln(
      '  restricted to: ${product.countryRestrictions!.join(', ')}',
    );
  }
  if (product.imageUrls != null && product.imageUrls!.isNotEmpty) {
    stdout.writeln('  images:   ${product.imageUrls!.length}');
  }
  if (product.description != null) {
    stdout.writeln('\n${product.description}');
  }
  if (product.safetyInstructions != null) {
    stdout.writeln('\nSafety: ${product.safetyInstructions}');
  }
}
