import 'dart:convert';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';

/// Append-only audit log.
class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  final TextEditingController _action = TextEditingController();
  List<AuditEvent> _events = <AuditEvent>[];
  bool _loading = true;
  String? _error;
  int _page = 0;
  static const int _pageSize = 30;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _action.dispose();
    super.dispose();
  }

  Future<void> _load({bool append = false}) async {
    if (!append) {
      setState(() {
        _loading = _events.isEmpty;
        _error = null;
      });
    }
    try {
      final events = await client.audit.query(
        workspaceId: widget.controller.workspaceId,
        action: _action.text.trim().isEmpty ? null : _action.text.trim(),
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _events = append ? <AuditEvent>[..._events, ...events] : events;
        _loading = false;
        _error = null;
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
        title: const Text('Audit log'),
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _action,
              decoration: InputDecoration(
                labelText: 'Filter by action',
                hintText: 'e.g. identity.pin_revealed',
                prefixIcon: const Icon(Icons.filter_alt_rounded),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () {
                    _page = 0;
                    _load();
                  },
                ),
              ),
              onSubmitted: (_) {
                _page = 0;
                _load();
              },
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null && _events.isEmpty) {
      return ErrorState(message: _error!, onRetry: _load);
    }
    if (_events.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'No audit events',
        message: 'Sensitive actions such as PIN reveals and recalls land here.',
      );
    }
    return RefreshIndicator(
      onRefresh: () {
        _page = 0;
        return _load();
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 24),
        itemCount: _events.length + 1,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          if (index == _events.length) {
            return _events.length % _pageSize == 0
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextButton.icon(
                      onPressed: () {
                        _page++;
                        _load(append: true);
                      },
                      icon: const Icon(Icons.expand_more_rounded),
                      label: const Text('Load more'),
                    ),
                  )
                : const SizedBox(height: 12);
          }
          return _eventTile(_events[index]);
        },
      ),
    );
  }

  Widget _eventTile(AuditEvent event) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        foregroundColor: theme.colorScheme.onSurfaceVariant,
        child: Icon(_iconFor(event.action), size: 18),
      ),
      title: Text(
        event.action,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      subtitle: Text(
        <String?>[
          event.actorType.name,
          event.actorIdentifier,
          event.targetType,
          event.ipAddress,
        ].whereType<String>().where((part) => part.isNotEmpty).join(' · '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        relativeTime(event.createdAt),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: event.metadataJson == null ? null : () => _showMetadata(event),
    );
  }

  Future<void> _showMetadata(AuditEvent event) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(event.action, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InfoRow(label: 'Actor', value: event.actorIdentifier ?? 'system'),
            InfoRow(label: 'Target', value: event.targetType),
            InfoRow(label: 'When', value: shortDate(event.createdAt)),
            const SizedBox(height: 8),
            SelectableText(
              _pretty(event.metadataJson!),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  static String _pretty(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return raw;
    }
  }

  static IconData _iconFor(String action) {
    if (action.contains('pin')) return Icons.pin_rounded;
    if (action.contains('recall')) return Icons.campaign_rounded;
    if (action.contains('lock')) return Icons.lock_rounded;
    if (action.contains('delete')) return Icons.delete_outline_rounded;
    if (action.contains('webhook')) return Icons.webhook_rounded;
    if (action.contains('api_key')) return Icons.key_rounded;
    if (action.contains('invitation')) return Icons.mail_outline_rounded;
    if (action.contains('workspace')) return Icons.business_rounded;
    if (action.contains('verification')) return Icons.verified_user_rounded;
    return Icons.receipt_long_rounded;
  }
}
