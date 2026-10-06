import 'dart:async';
import 'dart:convert';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import 'alert_detail_screen.dart';

/// The live command center.
///
/// Subscribes to the workspace event channel through Serverpod's streaming
/// API, so scans, alerts, recalls, offline ingest, and simulation progress
/// appear the moment they happen.
class LiveFeedScreen extends StatefulWidget {
  const LiveFeedScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<LiveFeedScreen> createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends State<LiveFeedScreen> {
  final List<LiveEvent> _events = <LiveEvent>[];
  StreamSubscription<LiveEvent>? _subscription;
  bool _connected = false;
  String? _error;
  Timer? _retry;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void dispose() {
    _retry?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  void _subscribe() {
    _subscription?.cancel();
    try {
      final stream = client.verification.watchWorkspace(
        workspaceId: widget.controller.workspaceId,
      );
      _subscription = stream.listen(
        (event) {
          if (!mounted) return;
          setState(() {
            _connected = true;
            _error = null;
            _events.insert(0, event);
            if (_events.length > 250) _events.removeLast();
          });
        },
        onError: (Object error) {
          if (!mounted) return;
          setState(() {
            _connected = false;
            _error = error is ApiException ? error.message : error.toString();
          });
          _scheduleRetry();
        },
        onDone: () {
          if (!mounted) return;
          setState(() => _connected = false);
          _scheduleRetry();
        },
      );
    } catch (error) {
      setState(() {
        _error = error.toString();
        _connected = false;
      });
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retry?.cancel();
    _retry = Timer(const Duration(seconds: 4), () {
      if (mounted) _subscribe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live command center'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Pill(
                label: _connected ? 'LIVE' : 'RECONNECTING',
                color: _connected
                    ? const Color(0xFF0F7B4D)
                    : theme.colorScheme.error,
                icon: _connected
                    ? Icons.sensors_rounded
                    : Icons.sensors_off_rounded,
                dense: true,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Clear feed',
            onPressed: _events.isEmpty ? null : () => setState(_events.clear),
            icon: const Icon(Icons.clear_all_rounded),
          ),
        ],
      ),
      body: _events.isEmpty
          ? EmptyState(
              icon: Icons.sensors_rounded,
              title: _connected ? 'Listening for activity' : 'Connecting…',
              message:
                  _error ??
                  'Scans, alerts, recalls, offline ingest, and simulations '
                      'will appear here in real time. Run a simulation to see it live.',
              action: FilledButton.tonalIcon(
                onPressed: _subscribe,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reconnect'),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
              itemCount: _events.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final event = _events[index];
                return _EventTile(
                  event: event,
                  onTap: () => _showDetails(event),
                );
              },
            ),
    );
  }

  Future<void> _showDetails(LiveEvent event) async {
    if (event.alertId != null) {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => AlertDetailScreen(
            controller: widget.controller,
            alertId: event.alertId!,
          ),
        ),
      );
      return;
    }
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
            Text(event.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (event.subtitle != null) Text(event.subtitle!),
            const Divider(height: 24),
            InfoRow(label: 'Type', value: liveEventLabel(event.type)),
            InfoRow(label: 'When', value: relativeTime(event.occurredAt)),
            if (event.outcome != null)
              InfoRow(label: 'Outcome', value: outcomeLabel(event.outcome)),
            if (event.riskScore != null)
              InfoRow(label: 'Risk', value: event.riskScore!.name),
            if (event.city != null || event.country != null)
              InfoRow(
                label: 'Location',
                value: <String?>[event.city, event.country]
                    .whereType<String>()
                    .where((part) => part.isNotEmpty)
                    .join(', '),
              ),
            if (event.payloadJson != null)
              InfoRow(
                label: 'Payload',
                value: _prettyPayload(event.payloadJson!),
              ),
          ],
        ),
      ),
    );
  }

  static String _prettyPayload(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return raw;
    }
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event, required this.onTap});

  final LiveEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = event.severity != null
        ? severityColor(context, event.severity!)
        : (event.outcome != null
              ? outcomeColor(context, event.outcome)
              : theme.colorScheme.primary);
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.14),
        foregroundColor: color,
        child: Icon(liveEventIcon(event.type), size: 20),
      ),
      title: Text(
        event.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        <String?>[
          event.subtitle,
          <String?>[
            event.city,
            event.countryCode,
          ].whereType<String>().where((part) => part.isNotEmpty).join(' '),
        ].whereType<String>().where((part) => part.isNotEmpty).join(' · '),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        relativeTime(event.occurredAt),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
