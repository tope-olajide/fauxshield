import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import 'alert_detail_screen.dart';

/// The fraud alert queue.
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

  @override
  void initState() {
    super.initState();
    _load();
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
        _error = error is ApiException ? error.message : error.toString();
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_alerts.isEmpty) {
      return const EmptyState(
        icon: Icons.verified_user_rounded,
        title: 'No alerts',
        message: 'Nothing in the queue for this filter.',
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
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
