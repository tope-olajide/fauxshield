import 'dart:convert';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import 'alert_detail_screen.dart';
import '../utils/request_recovery.dart';

/// The fraud alert queue, with the raw signal feed that feeds it.
///
/// Alerts are the escalation layer: only risk that crosses the workspace
/// policy threshold is queued. Everything below that — a first wrong PIN, a
/// repeat scan, an unusual location — is a *signal*, so this screen shows both
/// instead of leaving an empty queue as the last word after a suspicious scan.
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<FraudAlert> _alerts = <FraudAlert>[];
  bool _loading = true;
  String? _error;
  AlertStatus? _statusFilter;
  List<FraudSignalRecord> _signals = <FraudSignalRecord>[];
  bool _signalsLoading = true;
  String? _signalsError;
  bool _showingSignals = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    await Future.wait<void>(<Future<void>>[_load(), _loadSignals()]);
  }

  Future<void> _loadSignals() async {
    setState(() {
      _signalsLoading = _signals.isEmpty;
      _signalsError = null;
    });
    try {
      final signals = await client.alert.signals(
        workspaceId: widget.controller.workspaceId,
        page: 0,
        pageSize: 50,
      );
      if (!mounted) return;
      setState(() {
        _signals = signals;
        _signalsLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _signalsError = describeRequestError(error);
        _signalsLoading = false;
      });
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = _alerts.isEmpty;
      _error = null;
    });
    try {
      final alerts = await client.alert.list(
        workspaceId: widget.controller.workspaceId,
        status: _statusFilter,
        page: 0,
        pageSize: 50,
      );
      if (!mounted) return;
      setState(() {
        _alerts = alerts;
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
        title: const Text('Fraud alerts'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: SegmentedButton<bool>(
              segments: <ButtonSegment<bool>>[
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Alerts (${_alerts.length})'),
                ),
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Signals (${_signals.length})'),
                ),
              ],
              selected: <bool>{_showingSignals},
              onSelectionChanged: (selection) {
                setState(() => _showingSignals = selection.first);
              },
            ),
          ),
          if (!_showingSignals)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: <Widget>[
                  FilterChip(
                    label: const Text('All'),
                    selected: _statusFilter == null,
                    onSelected: (_) {
                      setState(() => _statusFilter = null);
                      _load();
                    },
                  ),
                  for (final status in AlertStatus.values) ...<Widget>[
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(_statusLabel(status)),
                      selected: _statusFilter == status,
                      onSelected: (_) {
                        setState(() => _statusFilter = status);
                        _load();
                      },
                    ),
                  ],
                ],
              ),
            ),
          const Divider(height: 1),
          Expanded(child: _showingSignals ? _buildSignals() : _buildList()),
        ],
      ),
    );
  }

  Widget _buildSignals() {
    if (_signalsLoading) return const LoadingView();
    if (_signalsError != null) {
      return ErrorState(message: _signalsError!, onRetry: _loadSignals);
    }
    if (_signals.isEmpty) {
      return const EmptyState(
        icon: Icons.radar_rounded,
        title: 'No signals yet',
        message:
            'Signals are recorded here as codes are scanned: a wrong PIN, a '
            'repeat scan, a code seen outside its region.',
      );
    }
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: _ThresholdNote(),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
              itemCount: _signals.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) =>
                  _SignalRow(signal: _signals[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildList() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_alerts.isEmpty) {
      return Column(
        children: <Widget>[
          const Expanded(
            child: EmptyState(
              icon: Icons.verified_user_rounded,
              title: 'No alerts',
              message: 'Nothing in the queue for this filter.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              children: <Widget>[
                const _ThresholdNote(),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => setState(() => _showingSignals = true),
                  icon: const Icon(Icons.radar_rounded),
                  label: Text(
                    _signals.isEmpty
                        ? 'See recorded signals'
                        : 'See ${_signals.length} recorded signal(s)',
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        itemCount: _alerts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final alert = _alerts[index];
          return Card(
            margin: EdgeInsets.zero,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => AlertDetailScreen(
                      controller: widget.controller,
                      alertId: alert.id!,
                    ),
                  ),
                );
                _load();
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.gpp_maybe_rounded,
                          color: severityColor(context, alert.severity),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            alert.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Pill(
                          label: alert.severity.name.toUpperCase(),
                          color: severityColor(context, alert.severity),
                          dense: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Pill(
                          label: alert.status.name,
                          color: Theme.of(context).colorScheme.primary,
                          dense: true,
                        ),
                        if (alert.autoLocked)
                          const Pill(
                            label: 'auto-locked',
                            color: Color(0xFFC2410C),
                            dense: true,
                          ),
                        Text(
                          relativeTime(alert.createdAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static String _statusLabel(AlertStatus status) {
    switch (status) {
      case AlertStatus.open:
        return 'Open';
      case AlertStatus.investigating:
        return 'Investigating';
      case AlertStatus.resolved:
        return 'Resolved';
      case AlertStatus.dismissed:
        return 'Dismissed';
    }
  }
}

/// Explains the difference between an alert and a signal, which is the answer
/// to "I entered a wrong PIN and the queue is empty".
class _ThresholdNote extends StatelessWidget {
  const _ThresholdNote();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Alerts are queued only when risk crosses your policy threshold '
              '(high risk or worse). Every scan below that — a wrong PIN, a '
              'repeat scan, a code far from its batch — is stored as a signal, '
              'and enough of them escalate into an alert.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// One raw fraud signal in the intelligence feed.
class _SignalRow extends StatelessWidget {
  const _SignalRow({required this.signal});

  final FraudSignalRecord signal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _signalColor(context, signal.severity);
    final reasons = _reasons(signal.dataJson);
    final source = _source(signal.dataJson);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.radar_rounded, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        signalLabel(signal.type),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Pill(
                      label: signal.severity.name,
                      color: color,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                for (final reason in reasons)
                  Text('• $reason', style: theme.textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  source == null
                      ? relativeTime(signal.detectedAt)
                      : '${relativeTime(signal.detectedAt)} · $source',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The signal rows store their reasons as JSON; a malformed row should still
  /// be readable rather than blank.
  static List<String> _reasons(String dataJson) {
    try {
      final decoded = jsonDecode(dataJson);
      if (decoded is Map<String, dynamic>) {
        final reasons = decoded['reasons'];
        if (reasons is List) {
          return reasons.map((reason) => '$reason').toList();
        }
      }
    } catch (_) {
      // Fall through to the raw payload below.
    }
    return dataJson.isEmpty ? const <String>[] : <String>[dataJson];
  }

  static String? _source(String dataJson) {
    try {
      final decoded = jsonDecode(dataJson);
      if (decoded is Map<String, dynamic>) {
        final source = decoded['source'];
        if (source is String && source.isNotEmpty) {
          return source == 'offline' ? 'offline scan' : source;
        }
      }
    } catch (_) {
      // A payload we cannot read simply shows no source.
    }
    return null;
  }
}

/// Color for a signal's risk severity.
Color _signalColor(BuildContext context, RiskScore score) {
  switch (score) {
    case RiskScore.low:
      return const Color(0xFF2563EB);
    case RiskScore.medium:
      return const Color(0xFFB45309);
    case RiskScore.high:
      return const Color(0xFFC2410C);
    case RiskScore.fraudSuspected:
      return Theme.of(context).colorScheme.error;
  }
}
