import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield products ...`
class ProductsCommand extends Command<int> {
  ProductsCommand() {
    addSubcommand(ProductsListCommand());
    addSubcommand(ProductsCreateCommand());
  }

  @override
  String get name => 'products';

  @override
  String get description => 'List and create products.';

  @override
  String get invocation => 'fauxshield products <list|create>';
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
