import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';

/// API keys for machine access to the workspace.
class ApiKeysScreen extends StatefulWidget {
  const ApiKeysScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<ApiKeysScreen> createState() => _ApiKeysScreenState();
}

class _ApiKeysScreenState extends State<ApiKeysScreen> {
  List<ApiKey> _keys = <ApiKey>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _keys.isEmpty;
      _error = null;
    });
    try {
      final keys = await client.apiKey.list(
        workspaceId: widget.controller.workspaceId,
      );
      if (!mounted) return;
      setState(() {
        _keys = keys;
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
        title: const Text('API keys'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: widget.controller.can('apiKeysWrite')
          ? FloatingActionButton.extended(
              onPressed: _createDialog,
              icon: const Icon(Icons.key_rounded),
              label: const Text('New key'),
            )
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_keys.isEmpty) {
      return EmptyState(
        icon: Icons.key_rounded,
        title: 'No API keys yet',
        message:
            'Issue scoped machine credentials for your ERP, ecommerce, or '
            'inspection systems.',
        action: widget.controller.can('apiKeysWrite')
            ? FilledButton.icon(
                onPressed: _createDialog,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create a key'),
              )
            : null,
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
        itemCount: _keys.length,
        itemBuilder: (context, index) => _keyCard(_keys[index]),
      ),
    );
  }

  Widget _keyCard(ApiKey key) {
    final theme = Theme.of(context);
    final revoked = key.revoked;
    final color = revoked ? theme.colorScheme.outline : const Color(0xFF0F7B4D);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        key.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${key.keyPrefix}… · created ${relativeTime(key.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Pill(
                  label: revoked ? 'REVOKED' : 'ACTIVE',
                  color: color,
                  dense: true,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: <Widget>[
                for (final scope in key.scopes.take(6))
                  Pill(
                    label: scope.name,
                    color: theme.colorScheme.primary,
                    dense: true,
                  ),
                if (key.scopes.length > 6)
                  Pill(
                    label: '+${key.scopes.length - 6}',
                    color: theme.colorScheme.outline,
                    dense: true,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    <String>[
                      '${key.rateLimitPerMinute}/min',
                      if (key.lastUsedAt != null)
                        'last used ${relativeTime(key.lastUsedAt!)}'
                      else
                        'never used',
                    ].join(' · '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (!revoked && widget.controller.can('apiKeysWrite'))
                  TextButton.icon(
                    onPressed: () => _revoke(key),
                    icon: const Icon(Icons.block_rounded, size: 18),
                    label: const Text('Revoke'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _revoke(ApiKey key) async {
    final confirmed = await confirmAction(
      context,
      title: 'Revoke key',
      message: '${key.label} stops working immediately for every caller.',
      confirmLabel: 'Revoke',
    );
    if (!confirmed) return;
    try {
      await client.apiKey.revoke(
        workspaceId: widget.controller.workspaceId,
        apiKeyId: key.id!,
      );
      if (mounted) showMessage(context, 'Key revoked.');
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          error is ApiException ? error.message : error.toString(),
          error: true,
        );
      }
    }
    _load();
  }

  Future<void> _createDialog() async {
    final label = TextEditingController();
    final rateLimit = TextEditingController(text: '120');
    final scopes = <ApiScope>{
      ApiScope.productsRead,
      ApiScope.verificationsRead,
    };
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('New API key'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LabeledField(
                  label: 'Label',
                  controller: label,
                  hint: 'e.g. Warehouse scanner fleet',
                ),
                LabeledField(
                  label: 'Rate limit per minute',
                  controller: rateLimit,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                Text('Scopes', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: <Widget>[
                    for (final scope in ApiScope.values)
                      FilterChip(
                        label: Text(scope.name),
                        selected: scopes.contains(scope),
                        onSelected: (selected) => setDialogState(() {
                          if (selected) {
                            scopes.add(scope);
                          } else {
                            scopes.remove(scope);
                          }
                        }),
                      ),
                  ],
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
    if (confirmed == true &&
        label.text.trim().isNotEmpty &&
        scopes.isNotEmpty) {
      try {
        final created = await client.apiKey.create(
          workspaceId: widget.controller.workspaceId,
          label: label.text.trim(),
          scopes: scopes.toList(),
          rateLimitPerMinute: int.tryParse(rateLimit.text) ?? 120,
        );
        if (!mounted) return;
        await _showSecretDialog(created);
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
    label.dispose();
    rateLimit.dispose();
    _load();
  }

  Future<void> _showSecretDialog(ApiKeySecret secret) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API key created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SelectableText(
              secret.secret,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
            const SizedBox(height: 12),
            Text(secret.warning, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: secret.secret));
              if (context.mounted) {
                Navigator.pop(context);
                showMessage(context, 'Key copied.');
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
  }
}
