import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../widgets/common.dart';
import '../utils/request_recovery.dart';

/// Deleted products waiting to be restored or permanently erased.
///
/// Products deleted from the catalog land here first. Restoring is lossless;
/// a permanent delete erases the product and everything under it (batches,
/// serialized units, verification records) and cannot be undone.
class RecycleBinScreen extends StatefulWidget {
  const RecycleBinScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  List<Product> _products = <Product>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _products.isEmpty;
      _error = null;
    });
    try {
      final products = await client.product.listDeleted(
        workspaceId: widget.controller.workspaceId,
      );
      if (!mounted) return;
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = describeRequestError(error);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recycle bin')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_products.isEmpty) {
      return const EmptyState(
        icon: Icons.delete_outline_rounded,
        title: 'Recycle bin is empty',
        message:
            'Products you delete from the catalog appear here and can be '
            'restored until they are permanently deleted.',
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        itemCount: _products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                child: const Icon(Icons.delete_outline_rounded),
              ),
              title: Text(product.name),
              subtitle: Text(_subtitle(product)),
              trailing: PopupMenuButton<String>(
                tooltip: 'Product actions',
                onSelected: (value) {
                  if (value == 'restore') _restore(product);
                  if (value == 'purge') _purge(product);
                },
                itemBuilder: (context) => const <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'restore',
                    child: Text('Restore product'),
                  ),
                  PopupMenuItem<String>(
                    value: 'purge',
                    child: Text('Delete permanently'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _subtitle(Product product) {
    final deletedAt = product.deletedAt;
    final stamp = deletedAt == null
        ? ''
        : ' · deleted ${deletedAt.toLocal().toString().split('.').first}';
    final sku = product.sku == null || product.sku!.isEmpty
        ? ''
        : ' · SKU ${product.sku}';
    return 'Recycle bin$sku$stamp';
  }

  Future<void> _restore(Product product) async {
    try {
      await client.product.restore(
        workspaceId: widget.controller.workspaceId,
        productId: product.id!,
      );
      if (!mounted) return;
      showMessage(context, '${product.name} restored to the catalog.');
      _load();
    } catch (error) {
      if (!mounted) return;
      showMessage(
        context,
        describeRequestError(error),
        error: true,
      );
    }
  }

  /// Confirms and performs the irreversible purge.
  ///
  /// The dialog is deliberately blunt: it lists exactly what will be erased,
  /// states that the action cannot be undone, and names what is kept (audit
  /// history and fraud alerts) so nothing is surprising afterwards.
  Future<void> _purge(Product product) async {
    ProductDeleteImpact impact;
    try {
      impact = await client.product.deleteImpact(
        workspaceId: widget.controller.workspaceId,
        productId: product.id!,
      );
    } catch (_) {
      if (!mounted) return;
      showMessage(context, 'Could not load deletion details.', error: true);
      return;
    }
    if (!mounted) return;
    final lines = <String>[
      if (impact.batchCount > 0)
        '• ${impact.batchCount} ${impact.batchCount == 1 ? 'batch' : 'batches'}',
      if (impact.identityCount > 0)
        '• ${impact.identityCount} serialized '
            '${impact.identityCount == 1 ? 'unit' : 'units'} — their QR codes '
            'stop resolving forever',
      if (impact.verificationCount > 0)
        '• ${impact.verificationCount} verification '
            '${impact.verificationCount == 1 ? 'record' : 'records'}',
      if (impact.alertCount > 0)
        '• ${impact.alertCount} fraud ${impact.alertCount == 1 ? 'alert' : 'alerts'} '
            '(kept as history)',
    ];
    final confirmed = await confirmAction(
      context,
      title: 'Permanently delete ${product.name}?',
      message:
          '⚠️ This is very dangerous and cannot be undone.\n\n'
          'The following will be deleted forever:\n'
          '${lines.isEmpty ? '• Nothing is attached to this product' : lines.join('\n')}\n\n'
          'Audit log entries are kept as history. Only continue if you are '
          'absolutely sure.',
      confirmLabel: 'Delete forever',
    );
    if (confirmed != true || !mounted) return;
    try {
      await client.product.purge(
        workspaceId: widget.controller.workspaceId,
        productId: product.id!,
      );
      if (!mounted) return;
      showMessage(context, '${product.name} was permanently deleted.');
      _load();
    } catch (error) {
      if (!mounted) return;
      showMessage(
        context,
        describeRequestError(error),
        error: true,
      );
    }
  }
}
