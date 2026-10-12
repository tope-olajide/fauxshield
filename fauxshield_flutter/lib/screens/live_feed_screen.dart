import 'dart:async';
import 'dart:convert';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import 'alert_detail_screen.dart';
import '../utils/request_recovery.dart';

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
  bool _historyLoaded = false;
  String? _error;
  Timer? _retry;

  /// How many of each record the feed opens with.
  static const int _historyPerSource = 25;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _subscribe();
  }

  /// Seeds the feed with what already happened.
  ///
  /// The event channel only carries what happens while it is open, so a
  /// refresh used to empty the feed even though the activity is all in the
  /// database. Scans, alerts, and recalls are read back first; the stream then
  /// appends live on top of them, in the same order.
  Future<void> _loadHistory() async {
    final workspaceId = widget.controller.workspaceId;
    final history = <LiveEvent>[];
    try {
      final sessions = await client.verification.list(
        workspaceId: workspaceId,
        page: 0,
        pageSize: _historyPerSource,
      );
      history.addAll(sessions.map(_eventFromSession));
    } catch (_) {
      // A source that fails leaves the rest of the history in place.
    }
    try {
      final alerts = await client.alert.list(
        workspaceId: workspaceId,
        page: 0,
        pageSize: _historyPerSource,
      );
      history.addAll(alerts.map(_eventFromAlert));
    } catch (_) {}
    try {
      final recalls = await client.recall.list(includeLifted: true);
      history.addAll(recalls.map(_eventFromRecall));
    } catch (_) {}

    if (!mounted) return;
    setState(() {
      _historyLoaded = true;
      _merge(history);
    });
  }

  /// Adds events to the feed, drops the duplicates, and keeps it newest first.
  void _merge(Iterable<LiveEvent> incoming) {
    final seen = <String>{
      for (final event in _events) _eventKey(event),
    };
    for (final event in incoming) {
      if (seen.add(_eventKey(event))) _events.add(event);
    }
    _events.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    if (_events.length > 250) _events.removeRange(250, _events.length);
  }

  /// One event per record, so a stream event does not repeat a seeded one.
  static String _eventKey(LiveEvent event) => <String>[
    event.type.name,
    event.sessionId?.uuid ??
        event.alertId?.uuid ??
        event.batchId?.uuid ??
        event.identityId?.uuid ??
        event.occurredAt.toIso8601String(),
    event.title,
  ].join(':');

  static LiveEvent _eventFromSession(VerificationSession session) => LiveEvent(
    type: LiveEventType.verificationCompleted,
    workspaceId: session.workspaceId,
    occurredAt: session.completedAt ?? session.createdAt,
    title: session.outcome == null
        ? 'Scan recorded'
        : outcomeLabel(session.outcome),
    subtitle: 'source: ${session.source.name}',
    outcome: session.outcome,
    riskScore: session.riskScore,
    country: session.country,
    countryCode: session.countryCode,
    city: session.city,
    latitude: session.latitude,
    longitude: session.longitude,
    identityId: session.identityId,
    sessionId: session.id,
  );

  static LiveEvent _eventFromAlert(FraudAlert alert) => LiveEvent(
    type: alert.status == AlertStatus.open
        ? LiveEventType.fraudAlertCreated
        : LiveEventType.fraudAlertUpdated,
    workspaceId: alert.workspaceId,
    occurredAt: alert.updatedAt.isAfter(alert.createdAt)
        ? alert.updatedAt
        : alert.createdAt,
    title: alert.title,
    subtitle: alert.description,
    severity: alert.severity,
    identityId: alert.identityId,
    sessionId: alert.sessionId,
    alertId: alert.id,
    batchId: alert.batchId,
  );

  static LiveEvent _eventFromRecall(RecallRecord recall) => LiveEvent(
    type: LiveEventType.batchRecalled,
    workspaceId: recall.workspaceId,
    occurredAt: recall.liftedAt ?? recall.issuedAt,
    title: recall.lifted ? 'Recall lifted' : 'Batch recalled',
    subtitle: recall.reason,
    identityId: recall.identityId,
    batchId: recall.batchId,
  );

  @override
  void dispose() {
    _retry?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  void _subscribe() {
    _subscription?.cancel();
    var subscribed = false;
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
            _merge(<LiveEvent>[event]);
          });
        },
        onError: (Object error) {
          if (!mounted) return;
          setState(() {
            _connected = false;
            _error = describeRequestError(error);
          });
          _scheduleRetry();
        },
        onDone: () {
          if (!mounted) return;
          setState(() => _connected = false);
          _scheduleRetry();
        },
      );
      subscribed = true;
    } catch (error) {
      setState(() {
        _error = error.toString();
        _connected = false;
      });
      _scheduleRetry();
    }
    // Listening to the stream is what opens the connection. It stays open
    // while idle, so an empty feed is "live, nothing yet", not "connecting".
    // Failures arrive through the error/done handlers, which flip the state
    // back to reconnecting.
    if (subscribed && mounted) setState(() => _connected = true);
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
              title: _connected ? 'No activity yet' : 'Reconnecting…',
              message:
                  _error ??
                  (_historyLoaded
                      ? 'Nothing has happened in this workspace yet. Scans, '
                            'alerts, recalls, offline ingest, and simulations '
                            'appear here in real time.'
                      : 'Loading recent activity…'),
              action: _connected && _error == null
                  ? null
                  : FilledButton.tonalIcon(
                      onPressed: _subscribe,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
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
