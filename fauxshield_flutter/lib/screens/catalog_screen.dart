import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/batch_qr_dialog.dart';
import '../widgets/batch_stats_grid.dart';
import '../widgets/common.dart';
import '../widgets/identity_qr_dialog.dart';
import 'product_editor_screen.dart';

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
        title: const Text('Products'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: widget.controller.can('productsWrite')
          ? FloatingActionButton.extended(
              onPressed: _createProduct,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New product'),
            )
          : null,
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
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 88),
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
              leading: _productThumb(product),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (widget.controller.can('productsWrite'))
                    PopupMenuButton<String>(
                      tooltip: 'Product actions',
                      onSelected: (value) {
                        if (value == 'delete') _deleteProduct(product);
                      },
                      itemBuilder: (context) => const <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete product'),
                        ),
                      ],
                    ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
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
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ProductEditorScreen()),
    );
    if (created == true && mounted) showMessage(context, 'Product created.');
    _load();
  }

  /// Confirms and performs a soft delete into the recycle bin.
  ///
  /// The dialog spells out exactly what sits under the product (batches,
  /// serialized units, scans, alerts) so the operator knows the blast radius
  /// before continuing, and states that the product can be restored from the
  /// recycle bin in Settings.
  Future<void> _deleteProduct(Product product) async {
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
            '${impact.identityCount == 1 ? 'unit' : 'units'} (their QR codes '
            'stop resolving)',
      if (impact.verificationCount > 0)
        '• ${impact.verificationCount} verification '
            '${impact.verificationCount == 1 ? 'record' : 'records'}',
      if (impact.alertCount > 0)
        '• ${impact.alertCount} fraud ${impact.alertCount == 1 ? 'alert' : 'alerts'}',
    ];
    final confirmed = await confirmAction(
      context,
      title: 'Delete ${product.name}?',
      message:
          'This is a dangerous action. Deleting this product affects everything '
          'created under it:\n\n'
          '${lines.isEmpty ? '• Nothing is attached to this product yet' : lines.join('\n')}\n\n'
          'The product moves to the recycle bin (Settings → Recycle bin) and '
          'stops appearing in the catalog. You can restore it there, or '
          'permanently delete it and everything above.',
      confirmLabel: 'Delete product',
    );
    if (confirmed != true || !mounted) return;
    try {
      await client.product.delete(
        workspaceId: widget.controller.workspaceId,
        productId: product.id!,
      );
      if (!mounted) return;
      showMessage(
        context,
        '${product.name} moved to the recycle bin. Restore it from Settings.',
      );
      _load();
    } catch (error) {
      if (!mounted) return;
      showMessage(
        context,
        error is ApiException ? error.message : error.toString(),
        error: true,
      );
    }
  }

  /// Product thumbnail for the list: first uploaded image, or the default
  /// inventory icon when the product has no imagery yet.
  Widget _productThumb(Product product) {
    final theme = Theme.of(context);
    final fallback = CircleAvatar(
      backgroundColor: theme.colorScheme.primaryContainer,
      child: const Icon(Icons.inventory_2_rounded),
    );
    final images = product.imageUrls;
    if (images == null || images.isEmpty) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        images.first,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback,
      ),
    );
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
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
        children: <Widget>[
          _productOverview(),
          const SizedBox(height: 8),
          for (var index = 0; index < _batches.length; index++) ...<Widget>[
            if (index > 0) const SizedBox(height: 8),
            _batchCard(_batches[index]),
          ],
        ],
      ),
    );
  }

  /// Product overview card shown above the batch list, mirroring the
  /// reference product detail header: imagery plus the distribution and
  /// safety fields.
  Widget _productOverview() {
    final product = widget.product;
    final theme = Theme.of(context);
    final images = product.imageUrls ?? <String>[];
    final restrictions = (product.countryRestrictions ?? <String>[]).join(', ');
    final meta = <String?>[
      product.category,
      if (product.sku != null && product.sku!.isNotEmpty) 'SKU ${product.sku}',
    ].whereType<String>().join(' · ');
    return SectionCard(
      title: 'Product details',
      subtitle: meta.isEmpty ? 'Overview' : meta,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (images.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  images.first,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          InfoRow(
            label: 'Category',
            value: _orNotSpecified(product.category),
          ),
          InfoRow(
            label: 'SKU',
            value: _orNotSpecified(product.sku),
          ),
          InfoRow(
            label: 'Packaging',
            value: _orNotSpecified(product.packaging),
          ),
          InfoRow(
            label: 'Shelf life',
            value: _orNotSpecified(product.shelfLife),
          ),
          InfoRow(
            label: 'Restricted countries',
            value: restrictions.isEmpty ? 'None' : restrictions,
          ),
          if (product.description != null &&
              product.description!.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              'Description',
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Text(product.description!, style: theme.textTheme.bodyMedium),
          ],
          if (product.safetyInstructions != null &&
              product.safetyInstructions!.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              'Safety instructions',
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Text(
              product.safetyInstructions!,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  static String _orNotSpecified(String? value) =>
      value == null || value.isEmpty ? 'Not specified' : value;

  Widget _batchCard(Batch batch) {
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
  }

  Future<void> _createBatch() async {
    final reference = TextEditingController();
    final region = TextEditingController(text: 'NG');
    final quantity = TextEditingController(text: '50');
    var manufactureDate = DateTime.now();
    DateTime? expiryDate;
    String formatDate(DateTime date) {
      const months = <String>[
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
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
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Manufacture date',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: manufactureDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setDialogState(() => manufactureDate = picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_today_rounded),
                    ),
                    child: Text(formatDate(manufactureDate)),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Expiry date (optional)',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: expiryDate ?? manufactureDate,
                      firstDate: manufactureDate,
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (picked != null) {
                      setDialogState(() => expiryDate = picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.event_rounded),
                      suffixIcon: expiryDate == null
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear_rounded),
                              onPressed: () =>
                                  setDialogState(() => expiryDate = null),
                            ),
                    ),
                    child: Text(
                      expiryDate == null ? 'Not set' : formatDate(expiryDate!),
                    ),
                  ),
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
      ),
    );
    if (confirmed == true && reference.text.trim().isNotEmpty && mounted) {
      // Serializing a batch can take a while; block the UI with feedback.
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Creating batch…'),
                ],
              ),
            ),
          ),
        ),
      );
      try {
        await client.batch.create(
          workspaceId: widget.controller.workspaceId,
          productId: widget.product.id!,
          reference: reference.text.trim(),
          manufactureDate: manufactureDate.toUtc(),
          expiryDate: expiryDate?.toUtc(),
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
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
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
        padding: EdgeInsets.zero,
        children: <Widget>[
          Center(
            child: ConstrainedBox(
              // Keep a comfortable measure on wide desktop windows.
              constraints: const BoxConstraints(maxWidth: 1080),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SectionCard(
                      title: widget.product.name,
                      subtitle:
                          'Region ${widget.batch.distributionRegion}'
                          ' · ${widget.batch.quantity} planned'
                          ' · ${_stats?.generated ?? 0} generated'
                          ' · ${_stats?.active ?? 0} active',
                      trailing: _statusPill(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _productHeaderImage(widget.product),
                          _statsGrid(),
                        ],
                      ),
                    ),
                    _actions(),
                    SectionCard(
                      title: 'Serialized units',
                      subtitle: '${_identities.length} loaded',
                      child: _identityList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Product imagery for the batch header: the first uploaded picture, or a
  /// quiet fallback tile when the product has none.
  Widget _productHeaderImage(Product product) {
    final images = product.imageUrls;
    final theme = Theme.of(context);
    final fallback = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.inventory_2_rounded),
    );
    if (images == null || images.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: fallback,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          images.first,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => fallback,
        ),
      ),
    );
  }

  /// Status badge for the batch header, mirroring the reference chip.
  Widget _statusPill() {
    final status = widget.batch.status;
    final color = switch (status) {
      BatchStatus.recalled => Theme.of(context).colorScheme.error,
      BatchStatus.shipped => const Color(0xFF0F7B4D),
      BatchStatus.inProduction => const Color(0xFFB45309),
      BatchStatus.created => Theme.of(context).colorScheme.outline,
    };
    return Pill(label: status.name, color: color, dense: true);
  }

  Widget _statsGrid() {
    final stats = _stats;
    if (stats == null) return const SizedBox.shrink();
    return BatchStatsGrid(stats: stats);
  }

  Widget _actions() {
    final stats = _stats;
    final generated = stats?.generated ?? 0;
    final active = stats?.active ?? 0;
    final recalled = widget.batch.status == BatchStatus.recalled;
    final canGenerate = widget.controller.can('identitiesGenerate');
    final canExport = widget.controller.can('identitiesExport');
    final canRecall = widget.controller.can('batchesWrite');
    final hasExportable = active > 0;

    // Same gating as the reference: export, QR and recall need live units,
    // generation is blocked on a recalled batch, and a disabled action
    // explains itself.
    String? hint;
    if (generated == 0) {
      hint = 'Generate identities to enable export, QR, and recall actions.';
    } else if (!hasExportable) {
      hint =
          'All generated identities are unavailable. '
          'Restore a unit to enable export, QR, and recall actions.';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              FilledButton.tonalIcon(
                onPressed: canGenerate && !recalled ? _generateDialog : null,
                icon: const Icon(Icons.qr_code_2_rounded),
                label: const Text('Generate units'),
              ),
              OutlinedButton.icon(
                onPressed: hasExportable ? _showBatchQr : null,
                icon: const Icon(Icons.qr_code_scanner_rounded),
                label: const Text('QR sheet'),
              ),
              OutlinedButton.icon(
                onPressed: canExport && hasExportable ? _export : null,
                icon: const Icon(Icons.download_rounded),
                label: const Text('Export CSV'),
              ),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withValues(alpha: 0.45),
                  ),
                ),
                onPressed: canRecall && !recalled && hasExportable
                    ? _recallDialog
                    : null,
                icon: const Icon(Icons.campaign_rounded),
                label: const Text('Recall batch'),
              ),
            ],
          ),
          if (hint != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                hint,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  tooltip: 'QR code',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _showIdentityQr(identity),
                  icon: const Icon(Icons.qr_code_2_rounded, size: 20),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Unit actions',
                  onSelected: (value) => _identityAction(identity, value),
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'qr',
                      child: Text('Show QR code'),
                    ),
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
                        identity.deletedAt == null
                            ? 'Delete unit'
                            : 'Restore unit',
                      ),
                    ),
                  ],
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

  void _showIdentityQr(ProductIdentity identity) {
    showDialog<void>(
      context: context,
      builder: (context) => IdentityQrDialog(
        identity: identity,
        batchReference: widget.batch.reference,
      ),
    );
  }

  void _showBatchQr() {
    showDialog<void>(
      context: context,
      builder: (context) => BatchQrDialog(
        controller: widget.controller,
        batch: widget.batch,
        total: _stats?.totalIdentities ?? _identities.length,
      ),
    );
  }

  Future<void> _identityAction(ProductIdentity identity, String action) async {
    try {
      switch (action) {
        case 'qr':
          _showIdentityQr(identity);
          return;
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
      if (mounted) {
        // Serializing units can take a while; block the UI with feedback.
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Generating serialized units…'),
                  ],
                ),
              ),
            ),
          ),
        );
      }
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
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
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
