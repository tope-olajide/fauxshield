import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../widgets/common.dart';
import '../utils/request_recovery.dart';

/// Webhook endpoint administration.
///
/// Deliveries are signed with the endpoint secret (`t=,v1=` scheme), retried
/// with exponential backoff, and every attempt can be inspected here.
class WebhooksScreen extends StatefulWidget {
  const WebhooksScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<WebhooksScreen> createState() => _WebhooksScreenState();
}

class _WebhooksScreenState extends State<WebhooksScreen> {
  List<WebhookEndpoint> _endpoints = <WebhookEndpoint>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _endpoints.isEmpty;
      _error = null;
    });
    try {
      final endpoints = await client.webhookAdmin.list(
        workspaceId: widget.controller.workspaceId,
      );
      if (!mounted) return;
      setState(() {
        _endpoints = endpoints;
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

  Future<void> _run(Future<void> Function() action, String success) async {
    try {
      await action();
      if (mounted) showMessage(context, success);
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          describeRequestError(error),
          error: true,
        );
      }
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final canWrite = widget.controller.can('webhooksWrite');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webhooks'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Drain outbox now',
            onPressed: () => _run(
              () => client.webhookAdmin.drainNow(
                workspaceId: widget.controller.workspaceId,
              ),
              'Outbox drained.',
            ),
            icon: const Icon(Icons.outbox_rounded),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: canWrite
          ? FloatingActionButton.extended(
              onPressed: _createDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add endpoint'),
            )
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_endpoints.isEmpty) {
      return EmptyState(
        icon: Icons.webhook_rounded,
        title: 'No webhooks yet',
        message:
            'Send signed fraud alerts, recalls, and verification events to '
            'your own systems.',
        action: widget.controller.can('webhooksWrite')
            ? FilledButton.icon(
                onPressed: _createDialog,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add an endpoint'),
              )
            : null,
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
        itemCount: _endpoints.length,
        itemBuilder: (context, index) => _endpointCard(_endpoints[index]),
      ),
    );
  }

  Widget _endpointCard(WebhookEndpoint endpoint) {
    final theme = Theme.of(context);
    final healthy = endpoint.enabled && endpoint.consecutiveFailures == 0;
    final color = healthy
        ? const Color(0xFF0F7B4D)
        : (endpoint.enabled
              ? const Color(0xFFB45309)
              : theme.colorScheme.outline);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 8),
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
                        endpoint.url,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'monospace',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (endpoint.description != null)
                        Text(
                          endpoint.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Pill(
                  label: endpoint.enabled ? 'ENABLED' : 'DISABLED',
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
                for (final event in endpoint.subscribedEvents.take(4))
                  Pill(
                    label: event.name,
                    color: theme.colorScheme.primary,
                    dense: true,
                  ),
                if (endpoint.subscribedEvents.length > 4)
                  Pill(
                    label: '+${endpoint.subscribedEvents.length - 4} more',
                    color: theme.colorScheme.outline,
                    dense: true,
                  ),
              ],
            ),
            if (endpoint.consecutiveFailures > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${endpoint.consecutiveFailures} consecutive failures',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            Row(
              children: <Widget>[
                TextButton.icon(
                  onPressed: () => _test(endpoint),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Test'),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => WebhookDeliveriesScreen(
                        controller: widget.controller,
                        endpoint: endpoint,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.history_rounded, size: 18),
                  label: const Text('Deliveries'),
                ),
                if (widget.controller.can('webhooksWrite'))
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'rotate':
                          _rotate(endpoint);
                        case 'toggle':
                          _run(
                            () => client.webhookAdmin.update(
                              workspaceId: widget.controller.workspaceId,
                              endpointId: endpoint.id!,
                              enabled: !endpoint.enabled,
                            ),
                            endpoint.enabled
                                ? 'Endpoint disabled.'
                                : 'Endpoint enabled.',
                          );
                        case 'delete':
                          _delete(endpoint);
                      }
                    },
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'rotate',
                        child: Text('Rotate secret'),
                      ),
                      PopupMenuItem<String>(
                        value: 'toggle',
                        child: Text(
                          endpoint.enabled ? 'Disable' : 'Enable',
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete endpoint'),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _test(WebhookEndpoint endpoint) async {
    try {
      final result = await client.webhookAdmin.test(
        workspaceId: widget.controller.workspaceId,
        endpointId: endpoint.id!,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            result.success ? 'Delivery succeeded' : 'Delivery failed',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(
                result.success
                    ? Icons.check_circle_rounded
                    : Icons.error_rounded,
                color: result.success
                    ? const Color(0xFF0F7B4D)
                    : Theme.of(context).colorScheme.error,
                size: 40,
              ),
              const SizedBox(height: 12),
              if (result.statusCode != null)
                InfoRow(label: 'HTTP status', value: '${result.statusCode}'),
              if (result.responseTimeMs != null)
                InfoRow(
                  label: 'Response time',
                  value: '${result.responseTimeMs} ms',
                ),
              if (result.error != null)
                InfoRow(label: 'Error', value: result.error!),
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
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          describeRequestError(error),
          error: true,
        );
      }
    }
    _load();
  }

  Future<void> _rotate(WebhookEndpoint endpoint) async {
    final confirmed = await confirmAction(
      context,
      title: 'Rotate signing secret',
      message:
          'The previous secret stays valid during rotation so in-flight '
          'deliveries still verify.',
      confirmLabel: 'Rotate',
      destructive: false,
    );
    if (!confirmed) return;
    try {
      final rotated = await client.webhookAdmin.rotateSecret(
        workspaceId: widget.controller.workspaceId,
        endpointId: endpoint.id!,
      );
      if (!mounted) return;
      await _showSecretDialog(rotated, 'New signing secret');
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          describeRequestError(error),
          error: true,
        );
      }
    }
    _load();
  }

  Future<void> _delete(WebhookEndpoint endpoint) async {
    final confirmed = await confirmAction(
      context,
      title: 'Delete endpoint',
      message: '${endpoint.url} stops receiving deliveries immediately.',
      confirmLabel: 'Delete',
    );
    if (!confirmed) return;
    await _run(
      () => client.webhookAdmin.delete(
        workspaceId: widget.controller.workspaceId,
        endpointId: endpoint.id!,
      ),
      'Endpoint deleted.',
    );
  }

  Future<void> _showSecretDialog(
    WebhookEndpointSecret secret,
    String title,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
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
                showMessage(context, 'Secret copied.');
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

  Future<void> _createDialog() async {
    final url = TextEditingController();
    final description = TextEditingController();
    final events = <WebhookEventType>{WebhookEventType.fraudAlertCreated};
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('New webhook endpoint'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LabeledField(
                  label: 'HTTPS URL',
                  controller: url,
                  hint: 'https://example.com/fauxshield',
                ),
                LabeledField(
                  label: 'Description (optional)',
                  controller: description,
                ),
                const SizedBox(height: 8),
                Text(
                  'Events',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: <Widget>[
                    for (final event in WebhookEventType.values)
                      FilterChip(
                        label: Text(event.name),
                        selected: events.contains(event),
                        onSelected: (selected) => setDialogState(() {
                          if (selected) {
                            events.add(event);
                          } else {
                            events.remove(event);
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
        url.text.trim().startsWith('http') &&
        events.isNotEmpty) {
      try {
        final created = await client.webhookAdmin.create(
          workspaceId: widget.controller.workspaceId,
          url: url.text.trim(),
          events: events.toList(),
          description: description.text.trim().isEmpty
              ? null
              : description.text.trim(),
        );
        if (!mounted) return;
        await _showSecretDialog(created, 'Signing secret');
      } catch (error) {
        if (mounted) {
          showMessage(
            context,
            describeRequestError(error),
            error: true,
          );
        }
      }
    }
    url.dispose();
    description.dispose();
    _load();
  }
}

/// Delivery history for one endpoint, with manual redelivery.
class WebhookDeliveriesScreen extends StatefulWidget {
  const WebhookDeliveriesScreen({
    super.key,
    required this.controller,
    required this.endpoint,
  });

  final AppController controller;
  final WebhookEndpoint endpoint;

  @override
  State<WebhookDeliveriesScreen> createState() =>
      _WebhookDeliveriesScreenState();
}

class _WebhookDeliveriesScreenState extends State<WebhookDeliveriesScreen> {
  List<WebhookDelivery> _deliveries = <WebhookDelivery>[];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _deliveries.isEmpty;
      _error = null;
    });
    try {
      final deliveries = await client.webhookAdmin.deliveries(
        workspaceId: widget.controller.workspaceId,
        endpointId: widget.endpoint.id!,
        page: 0,
        pageSize: 50,
      );
      if (!mounted) return;
      setState(() {
        _deliveries = deliveries;
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
      appBar: AppBar(
        title: const Text('Deliveries'),
        actions: <Widget>[
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
    if (_deliveries.isEmpty) {
      return const EmptyState(
        icon: Icons.outbox_rounded,
        title: 'No deliveries yet',
        message:
            'Trigger an event or send a test delivery to see attempts here.',
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        itemCount: _deliveries.length,
        itemBuilder: (context, index) {
          final delivery = _deliveries[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Icon(
                _statusIcon(delivery.status),
                color: _statusColor(context, delivery.status),
              ),
              title: Text(delivery.eventType.name),
              subtitle: Text(
                '${delivery.status.name} · '
                '${delivery.attemptCount}/${delivery.maxAttempts} attempts'
                '${delivery.lastHttpStatus != null ? ' · HTTP ${delivery.lastHttpStatus}' : ''}'
                '${delivery.responseTimeMs != null ? ' · ${delivery.responseTimeMs} ms' : ''}',
              ),
              trailing: delivery.attemptCount > 0
                  ? IconButton(
                      tooltip: 'Redeliver',
                      onPressed: () => _redeliver(delivery),
                      icon: const Icon(Icons.replay_rounded),
                    )
                  : null,
              onTap: () => _showPayload(delivery),
            ),
          );
        },
      ),
    );
  }

  Future<void> _redeliver(WebhookDelivery delivery) async {
    try {
      await client.webhookAdmin.redeliver(
        workspaceId: widget.controller.workspaceId,
        deliveryId: delivery.id!,
      );
      if (mounted) showMessage(context, 'Redelivery queued.');
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          describeRequestError(error),
          error: true,
        );
      }
    }
    _load();
  }

  Future<void> _showPayload(WebhookDelivery delivery) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              delivery.eventType.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (delivery.lastError != null)
              Text(
                delivery.lastError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 12),
            SizedBox(
              height: 260,
              child: SingleChildScrollView(
                child: SelectableText(
                  delivery.payloadJson,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static IconData _statusIcon(DeliveryStatus? status) {
    switch (status) {
      case DeliveryStatus.delivered:
        return Icons.check_circle_rounded;
      case DeliveryStatus.failed:
        return Icons.error_rounded;
      case DeliveryStatus.retrying:
        return Icons.replay_circle_filled_rounded;
      case DeliveryStatus.processing:
        return Icons.sync_rounded;
      case DeliveryStatus.pending:
      case null:
        return Icons.schedule_rounded;
      case DeliveryStatus.disabled:
        return Icons.block_rounded;
    }
  }

  static Color _statusColor(BuildContext context, DeliveryStatus? status) {
    switch (status) {
      case DeliveryStatus.delivered:
        return const Color(0xFF0F7B4D);
      case DeliveryStatus.failed:
        return Theme.of(context).colorScheme.error;
      case DeliveryStatus.retrying:
        return const Color(0xFFB45309);
      case DeliveryStatus.processing:
        return const Color(0xFF2563EB);
      case DeliveryStatus.pending:
      case DeliveryStatus.disabled:
      case null:
        return Theme.of(context).colorScheme.outline;
    }
  }
}
