import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';

/// Product catalog.
class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
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
      final products = await client.product.list(
        workspaceId: widget.controller.workspaceId,
        includeArchived: false,
      );
      if (!mounted) return;
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is ApiException ? error.message : error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: <Widget>[
          IconButton(
            tooltip: 'New product',
            onPressed: widget.controller.can('productsWrite')
                ? _createProduct
                : null,
            icon: const Icon(Icons.add_rounded),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_products.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_rounded,
        title: 'No products yet',
        message: 'Add a product, then create batches and serialize its units.',
        action: FilledButton.icon(
          onPressed: _createProduct,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add a product'),
        ),
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
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.inventory_2_rounded),
              ),
              title: Text(product.name),
              subtitle: Text(
                <String?>[
                      if (product.sku != null) 'SKU ${product.sku}',
                      if (product.category != null) product.category,
                      product.description,
                    ]
                    .whereType<String>()
                    .where((part) => part.isNotEmpty)
                    .join(' · '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => BatchListScreen(
                      controller: widget.controller,
                      product: product,
                    ),
                  ),
                );
                _load();
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _createProduct() async {
    final name = TextEditingController();
    final sku = TextEditingController();
    final category = TextEditingController();
    final description = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LabeledField(label: 'Name', controller: name),
              LabeledField(label: 'SKU', controller: sku),
              LabeledField(label: 'Category', controller: category),
              LabeledField(
                label: 'Description',
                controller: description,
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (confirmed == true && name.text.trim().isNotEmpty) {
      try {
        await client.product.create(
          workspaceId: widget.controller.workspaceId,
          name: name.text.trim(),
          sku: sku.text.trim().isEmpty ? null : sku.text.trim(),
          category: category.text.trim().isEmpty ? null : category.text.trim(),
          description: description.text.trim().isEmpty
              ? null
              : description.text.trim(),
        );
        if (mounted) showMessage(context, 'Product created.');
      } catch (error) {
        if (mounted) {
          showMessage(
            context,
            error is ApiException ? error.message : error.toString(),
            error: true,
          );
        }
      }
    }
    name.dispose();
    sku.dispose();
    category.dispose();
    description.dispose();
    _load();
  }
}

/// Batches for one product.
class BatchListScreen extends StatefulWidget {
  const BatchListScreen({
    super.key,
    required this.controller,
    required this.product,
  });

  final AppController controller;
  final Product product;

  @override
  State<BatchListScreen> createState() => _BatchListScreenState();
}

class _BatchListScreenState extends State<BatchListScreen> {
  List<Batch> _batches = <Batch>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _batches.isEmpty;
      _error = null;
    });
    try {
      final batches = await client.batch.list(
        workspaceId: widget.controller.workspaceId,
        productId: widget.product.id,
      );
      if (!mounted) return;
      setState(() {
        _batches = batches;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is ApiException ? error.message : error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      floatingActionButton: widget.controller.can('batchesWrite')
          ? FloatingActionButton.extended(
              onPressed: _createBatch,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New batch'),
            )
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_batches.isEmpty) {
      return const EmptyState(
        icon: Icons.inventory_rounded,
        title: 'No batches',
        message: 'Create a batch to start serializing units.',
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
        itemCount: _batches.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final batch = _batches[index];
          return Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Icon(
                batch.status == BatchStatus.recalled
                    ? Icons.campaign_rounded
                    : Icons.inventory_rounded,
                color: batch.status == BatchStatus.recalled
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
              title: Text(batch.reference),
              subtitle: Text(
                '${batch.quantity} planned · region ${batch.distributionRegion} · '
                '${batch.status.name}',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => BatchDetailScreen(
                      controller: widget.controller,
                      batch: batch,
                      product: widget.product,
                    ),
                  ),
                );
                _load();
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _createBatch() async {
    final reference = TextEditingController();
    final region = TextEditingController(text: 'NG');
    final quantity = TextEditingController(text: '50');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New batch'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LabeledField(label: 'Reference', controller: reference),
              LabeledField(
                label: 'Distribution region',
                controller: region,
                hint: 'Country name or ISO code',
              ),
              LabeledField(
                label: 'Planned quantity',
                controller: quantity,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (confirmed == true && reference.text.trim().isNotEmpty) {
      try {
        await client.batch.create(
          workspaceId: widget.controller.workspaceId,
          productId: widget.product.id!,
          reference: reference.text.trim(),
          manufactureDate: DateTime.now().toUtc(),
          distributionRegion: region.text.trim().isEmpty
              ? 'NG'
              : region.text.trim(),
          quantity: int.tryParse(quantity.text) ?? 50,
        );
        if (mounted) showMessage(context, 'Batch created.');
      } catch (error) {
        if (mounted) {
          showMessage(
            context,
            error is ApiException ? error.message : error.toString(),
            error: true,
          );
        }
      }
    }
    reference.dispose();
    region.dispose();
    quantity.dispose();
    _load();
  }
}

/// Batch detail: stats, actions, and the serialized identity list.
class BatchDetailScreen extends StatefulWidget {
  const BatchDetailScreen({
    super.key,
    required this.controller,
    required this.batch,
    required this.product,
  });

  final AppController controller;
  final Batch batch;
  final Product product;

  @override
  State<BatchDetailScreen> createState() => _BatchDetailScreenState();
}

class _BatchDetailScreenState extends State<BatchDetailScreen> {
  BatchStats? _stats;
  List<ProductIdentity> _identities = <ProductIdentity>[];
  bool _loading = true;
  String? _error;
  int _page = 0;
  static const int _pageSize = 25;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _identities.isEmpty;
      _error = null;
    });
    try {
      final stats = await client.batch.stats(widget.batch.id!);
      final identities = await client.identity.list(
        workspaceId: widget.controller.workspaceId,
        batchId: widget.batch.id,
        onlyFlagged: false,
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _stats = stats;
        if (_page == 0) {
          _identities = identities;
        } else {
          _identities = <ProductIdentity>[..._identities, ...identities];
        }
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is ApiException ? error.message : error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.batch.reference),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              _page = 0;
              _load();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    return RefreshIndicator(
      onRefresh: () {
        _page = 0;
        return _load();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: <Widget>[
          SectionCard(
            title: widget.product.name,
            subtitle:
                'Region ${widget.batch.distributionRegion} · ${widget.batch.status.name}',
            child: _statsGrid(),
          ),
          _actions(),
          SectionCard(
            title: 'Serialized units',
            subtitle: '${_identities.length} loaded',
            child: _identityList(),
          ),
        ],
      ),
    );
  }

  Widget _statsGrid() {
    final stats = _stats;
    if (stats == null) return const SizedBox.shrink();
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.35,
      children: <Widget>[
        StatTile(label: 'Planned', value: '${stats.totalIdentities}'),
        StatTile(label: 'Active', value: '${stats.active}'),
        StatTile(label: 'Verified', value: '${stats.verified}'),
        StatTile(
          label: 'Flagged',
          value: '${stats.flagged}',
          color: const Color(0xFFB45309),
        ),
        StatTile(
          label: 'Locked',
          value: '${stats.locked}',
          color: const Color(0xFFC2410C),
        ),
        StatTile(
          label: 'Recalled',
          value: '${stats.recalled}',
          color: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  Widget _actions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          FilledButton.tonalIcon(
            onPressed: widget.controller.can('identitiesGenerate')
                ? _generateDialog
                : null,
            icon: const Icon(Icons.qr_code_2_rounded),
            label: const Text('Generate units'),
          ),
          OutlinedButton.icon(
            onPressed: widget.controller.can('identitiesExport')
                ? _export
                : null,
            icon: const Icon(Icons.download_rounded),
            label: const Text('Export CSV'),
          ),
          OutlinedButton.icon(
            onPressed:
                widget.controller.can('batchesWrite') &&
                    widget.batch.status != BatchStatus.recalled
                ? _recallDialog
                : null,
            icon: const Icon(Icons.campaign_rounded),
            label: const Text('Recall batch'),
          ),
        ],
      ),
    );
  }

  Widget _identityList() {
    if (_identities.isEmpty) {
      return Text(
        'No units generated yet. Generate serialized identities to start.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Column(
      children: <Widget>[
        for (final identity in _identities)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              outcomeIcon(
                identity.status == IdentityStatus.locked
                    ? VerificationOutcome.fraudSuspected
                    : identity.firstVerified
                    ? VerificationOutcome.authentic
                    : null,
              ),
              color: outcomeColor(
                context,
                identity.status == IdentityStatus.locked
                    ? VerificationOutcome.fraudSuspected
                    : identity.firstVerified
                    ? VerificationOutcome.authentic
                    : null,
              ),
              size: 20,
            ),
            title: Text(
              identity.qrToken.length > 18
                  ? '${identity.qrToken.substring(0, 10)}…${identity.qrToken.substring(identity.qrToken.length - 6)}'
                  : identity.qrToken,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
            subtitle: Text(
              '${identity.status.name} · ${identity.verificationCount} scans'
              '${identity.failedPinAttempts > 0 ? ' · ${identity.failedPinAttempts} failed PINs' : ''}',
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _identityAction(identity, value),
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'pin',
                  child: Text('Reveal packaging PIN'),
                ),
                const PopupMenuItem<String>(
                  value: 'regenerate',
                  child: Text('Regenerate token'),
                ),
                PopupMenuItem<String>(
                  value: identity.status == IdentityStatus.locked
                      ? 'unlock'
                      : 'lock',
                  child: Text(
                    identity.status == IdentityStatus.locked
                        ? 'Unlock unit'
                        : 'Lock unit',
                  ),
                ),
                PopupMenuItem<String>(
                  value: identity.deletedAt == null ? 'delete' : 'restore',
                  child: Text(
                    identity.deletedAt == null ? 'Delete unit' : 'Restore unit',
                  ),
                ),
              ],
            ),
          ),
        if (_identities.length % _pageSize == 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              onPressed: () {
                _page++;
                _load();
              },
              icon: const Icon(Icons.expand_more_rounded),
              label: const Text('Load more'),
            ),
          ),
      ],
    );
  }

  Future<void> _identityAction(ProductIdentity identity, String action) async {
    try {
      switch (action) {
        case 'pin':
          final revealed = await client.identity.revealPin(
            workspaceId: widget.controller.workspaceId,
            identityId: identity.id!,
          );
          if (!mounted) return;
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Packaging PIN'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SelectableText(
                    revealed.pin,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This reveal is recorded in the audit log.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        case 'regenerate':
          final confirmed = await confirmAction(
            context,
            title: 'Regenerate token',
            message:
                'The printed QR code will stop working and a new token is issued. '
                'Only do this for a compromised unit.',
            confirmLabel: 'Regenerate',
          );
          if (!confirmed) return;
          await client.identity.regenerateToken(
            workspaceId: widget.controller.workspaceId,
            identityId: identity.id!,
            reason: 'Regenerated from the app.',
          );
          if (mounted) showMessage(context, 'Token regenerated.');
        case 'lock':
          await client.identity.lock(
            workspaceId: widget.controller.workspaceId,
            identityId: identity.id!,
          );
          if (mounted) showMessage(context, 'Unit locked.');
        case 'unlock':
          await client.identity.unlock(
            workspaceId: widget.controller.workspaceId,
            identityId: identity.id!,
          );
          if (mounted) showMessage(context, 'Unit unlocked.');
        case 'delete':
          final confirmed = await confirmAction(
            context,
            title: 'Delete unit',
            message:
                'The QR code will stop resolving. You can restore it later.',
          );
          if (!confirmed) return;
          await client.identity.delete(
            workspaceId: widget.controller.workspaceId,
            identityId: identity.id!,
          );
          if (mounted) showMessage(context, 'Unit deleted.');
        case 'restore':
          await client.identity.restore(
            workspaceId: widget.controller.workspaceId,
            identityId: identity.id!,
          );
          if (mounted) showMessage(context, 'Unit restored.');
      }
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          error is ApiException ? error.message : error.toString(),
          error: true,
        );
      }
    }
    _page = 0;
    _load();
  }

  Future<void> _generateDialog() async {
    final quantity = TextEditingController(text: '50');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate serialized units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Each unit gets a random 128 bit QR token, an HMAC signature, '
              'and a unique packaging PIN.',
            ),
            const SizedBox(height: 12),
            LabeledField(
              label: 'Quantity',
              controller: quantity,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Generate'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        final result = await client.batch.generateIdentities(
          workspaceId: widget.controller.workspaceId,
          batchId: widget.batch.id!,
          quantity: int.tryParse(quantity.text) ?? 50,
          idempotencyKey:
              'gen-${widget.batch.id!.uuid}-${DateTime.now().millisecondsSinceEpoch}',
        );
        if (mounted) {
          showMessage(context, '${result.created} units generated.');
        }
      } catch (error) {
        if (mounted) {
          showMessage(
            context,
            error is ApiException ? error.message : error.toString(),
            error: true,
          );
        }
      }
    }
    quantity.dispose();
    _page = 0;
    _load();
  }

  Future<void> _export() async {
    try {
      final export = await client.identity.export(
        workspaceId: widget.controller.workspaceId,
        batchId: widget.batch.id,
        format: ExportFormat.csv,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('${export.filename} (${export.rowCount} rows)'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: SelectableText(
                export.content,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: export.content));
                if (context.mounted) {
                  Navigator.pop(context);
                  showMessage(context, 'CSV copied to the clipboard.');
                }
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          error is ApiException ? error.message : error.toString(),
          error: true,
        );
      }
    }
  }

  Future<void> _recallDialog() async {
    final reason = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recall batch'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Every unit in this batch will verify as recalled and the team '
              'will be notified.',
            ),
            const SizedBox(height: 12),
            LabeledField(
              label: 'Reason',
              controller: reason,
              maxLines: 2,
              hint: 'Why is this batch being recalled?',
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Recall'),
          ),
        ],
      ),
    );
    if (confirmed == true && reason.text.trim().length >= 3) {
      try {
        final result = await client.recall.recallBatch(
          workspaceId: widget.controller.workspaceId,
          batchId: widget.batch.id!,
          reason: reason.text.trim(),
        );
        if (mounted) {
          showMessage(context, '${result.affected} units recalled.');
        }
      } catch (error) {
        if (mounted) {
          showMessage(
            context,
            error is ApiException ? error.message : error.toString(),
            error: true,
          );
        }
      }
    }
    reason.dispose();
    _page = 0;
    _load();
  }
}
