import 'dart:convert';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import '../utils/request_recovery.dart';

/// Full investigation view for one alert.
///
/// Loads the assembled evidence: the alert, the unit, the batch and product,
/// every related session, the detected signals, consumer reports, and recall
/// history.
class AlertDetailScreen extends StatefulWidget {
  const AlertDetailScreen({
    super.key,
    required this.controller,
    required this.alertId,
  });

  final AppController controller;
  final UuidValue alertId;

  @override
  State<AlertDetailScreen> createState() => _AlertDetailScreenState();
}

class _AlertDetailScreenState extends State<AlertDetailScreen> {
  AlertEvidence? _evidence;
  bool _loading = true;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _evidence == null;
      _error = null;
    });
    try {
      final evidence = await client.alert.evidence(widget.alertId);
      if (!mounted) return;
      setState(() {
        _evidence = evidence;
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
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      showMessage(context, success);
      await _load();
    } catch (error) {
      if (!mounted) return;
      showMessage(
        context,
        describeRequestError(error),
        error: true,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alert = _evidence?.alert;
    return Scaffold(
      appBar: AppBar(
        title: Text(alert?.title ?? 'Alert'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _evidence == null ? null : _actions(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    final evidence = _evidence;
    if (evidence == null) {
      return ErrorState(
        message: _error ?? 'Could not load the alert.',
        onRetry: _load,
      );
    }
    final alert = evidence.alert;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Pill(
                      label: alert.severity.name.toUpperCase(),
                      color: severityColor(context, alert.severity),
                      icon: Icons.priority_high_rounded,
                    ),
                    const SizedBox(width: 8),
                    Pill(
                      label: alert.status.name,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Spacer(),
                    Text(
                      relativeTime(alert.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(alert.description),
                if (alert.recommendedAction != null) ...<Widget>[
                  const Divider(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.tips_and_updates_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(alert.recommendedAction!)),
                    ],
                  ),
                ],
                if (alert.assignee != null) ...<Widget>[
                  const SizedBox(height: 8),
                  InfoRow(label: 'Assignee', value: alert.assignee!),
                ],
              ],
            ),
          ),
        ),
        if (evidence.signals.isNotEmpty)
          SectionCard(
            title: 'Detected signals',
            subtitle: '${evidence.signals.length} signal(s)',
            child: Column(
              children: <Widget>[
                for (final signal in evidence.signals)
                  _SignalTile(signal: signal),
              ],
            ),
          ),
        if (evidence.identity != null)
          SectionCard(
            title: 'Unit under investigation',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InfoRow(
                  label: 'Status',
                  value: evidence.identity!.status.name,
                ),
                InfoRow(
                  label: 'First verified',
                  value: evidence.identity!.firstVerified ? 'yes' : 'no',
                ),
                InfoRow(
                  label: 'Scans',
                  value: '${evidence.identity!.verificationCount}',
                ),
                InfoRow(
                  label: 'Failed PINs',
                  value: '${evidence.identity!.failedPinAttempts}',
                ),
                InfoRow(
                  label: 'Product',
                  value: evidence.product?.name ?? 'unknown',
                ),
                InfoRow(
                  label: 'Batch',
                  value: evidence.batch?.reference ?? 'unknown',
                ),
                if (evidence.batch != null)
                  InfoRow(
                    label: 'Distribution',
                    value: evidence.batch!.distributionRegion,
                  ),
              ],
            ),
          ),
        if (evidence.recall != null)
          SectionCard(
            title: 'Recall',
            subtitle: evidence.recall!.lifted ? 'lifted' : 'active',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(evidence.recall!.reason),
                const SizedBox(height: 8),
                InfoRow(
                  label: 'Issued',
                  value: relativeTime(evidence.recall!.issuedAt),
                ),
                if (evidence.recall!.lifted)
                  InfoRow(
                    label: 'Lifted',
                    value: evidence.recall!.liftedAt == null
                        ? 'yes'
                        : relativeTime(evidence.recall!.liftedAt!),
                  ),
              ],
            ),
          ),
        if (evidence.reports.isNotEmpty)
          SectionCard(
            title: 'Consumer reports',
            subtitle: '${evidence.reports.length} report(s)',
            child: Column(
              children: <Widget>[
                for (final report in evidence.reports)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.report_rounded, size: 20),
                    title: Text(report.reason),
                    subtitle: Text(
                      <String?>[
                            report.status.name,
                            report.city,
                            if (report.comment != null) report.comment,
                          ]
                          .whereType<String>()
                          .where((part) => part.isNotEmpty)
                          .join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(relativeTime(report.createdAt)),
                  ),
              ],
            ),
          ),
        SectionCard(
          title: 'Related sessions',
          subtitle:
              '${evidence.sessions.length} linked · ${evidence.identitySessions.length} for this unit',
          child: evidence.identitySessions.isEmpty
              ? Text(
                  'No sessions recorded.',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : Column(
                  children: <Widget>[
                    for (final session in evidence.identitySessions.take(10))
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          outcomeIcon(session.outcome),
                          color: outcomeColor(context, session.outcome),
                          size: 20,
                        ),
                        title: Text(
                          outcomeLabel(session.outcome),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          <String?>[
                                session.city,
                                session.countryCode,
                                session.source.name,
                                if (session.riskScore != null)
                                  'risk: ${session.riskScore!.name}',
                              ]
                              .whereType<String>()
                              .where((part) => part.isNotEmpty)
                              .join(' · '),
                        ),
                        trailing: Text(relativeTime(session.createdAt)),
                      ),
                  ],
                ),
        ),
        SectionCard(
          title: 'Audit trail for this alert',
          subtitle: 'Actions taken on this investigation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InfoRow(label: 'Created', value: shortDate(alert.createdAt)),
              if (alert.acknowledgedAt != null)
                InfoRow(
                  label: 'Acknowledged',
                  value: shortDate(alert.acknowledgedAt!),
                ),
              if (alert.resolvedAt != null)
                InfoRow(label: 'Closed', value: shortDate(alert.resolvedAt!)),
              if (alert.resolutionNote != null)
                InfoRow(label: 'Note', value: alert.resolutionNote!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actions() {
    final alert = _evidence!.alert;
    final canWrite = widget.controller.can('fraudWrite');
    final identity = _evidence!.identity;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            if (alert.status == AlertStatus.open)
              FilledButton.tonalIcon(
                onPressed: _busy || !canWrite
                    ? null
                    : () => _run(
                        () => client.alert.updateStatus(
                          workspaceId: widget.controller.workspaceId,
                          alertId: alert.id!,
                          status: AlertStatus.investigating,
                        ),
                        'Alert marked as investigating.',
                      ),
                icon: const Icon(Icons.search_rounded),
                label: const Text('Investigate'),
              ),
            FilledButton.icon(
              onPressed: _busy || !canWrite
                  ? null
                  : () => _resolveDialog(alert),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Resolve'),
            ),
            OutlinedButton.icon(
              onPressed: _busy || !canWrite
                  ? null
                  : () => _run(
                      () => client.alert.updateStatus(
                        workspaceId: widget.controller.workspaceId,
                        alertId: alert.id!,
                        status: AlertStatus.dismissed,
                      ),
                      'Alert dismissed.',
                    ),
              icon: const Icon(Icons.close_rounded),
              label: const Text('Dismiss'),
            ),
            if (identity != null)
              OutlinedButton.icon(
                onPressed: _busy || !canWrite
                    ? null
                    : () => identity.status == IdentityStatus.locked
                          ? _run(
                              () => client.identity.unlock(
                                workspaceId: widget.controller.workspaceId,
                                identityId: identity.id!,
                                note: 'Unlocked after investigation.',
                              ),
                              'Unit unlocked.',
                            )
                          : _run(
                              () => client.identity.lock(
                                workspaceId: widget.controller.workspaceId,
                                identityId: identity.id!,
                                reason: 'Locked from alert investigation.',
                              ),
                              'Unit locked.',
                            ),
                icon: Icon(
                  identity.status == IdentityStatus.locked
                      ? Icons.lock_open_rounded
                      : Icons.lock_rounded,
                ),
                label: Text(
                  identity.status == IdentityStatus.locked
                      ? 'Unlock unit'
                      : 'Lock unit',
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _resolveDialog(FraudAlert alert) async {
    final note = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve alert'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Add a short resolution note for the audit trail.'),
            const SizedBox(height: 12),
            TextField(
              controller: note,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'What did you find?'),
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
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _run(
        () => client.alert.updateStatus(
          workspaceId: widget.controller.workspaceId,
          alertId: alert.id!,
          status: AlertStatus.resolved,
          note: note.text.trim().isEmpty ? null : note.text.trim(),
        ),
        'Alert resolved.',
      );
    }
    note.dispose();
  }
}

class _SignalTile extends StatelessWidget {
  const _SignalTile({required this.signal});

  final FraudSignalRecord signal;

  @override
  Widget build(BuildContext context) {
    final colors = _severityColors(context, signal.severity);
    final reasons = _reasons(signal.dataJson);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.radar_rounded, size: 20, color: colors.$1),
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
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Pill(
                      label: signal.severity.name,
                      color: colors.$1,
                      dense: true,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                for (final reason in reasons)
                  Text(
                    '• $reason',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                Text(
                  relativeTime(signal.detectedAt),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static (Color, Color) _severityColors(
    BuildContext context,
    RiskScore score,
  ) {
    switch (score) {
      case RiskScore.low:
        return (const Color(0xFF2563EB), const Color(0xFF2563EB));
      case RiskScore.medium:
        return (const Color(0xFFB45309), const Color(0xFFB45309));
      case RiskScore.high:
      case RiskScore.fraudSuspected:
        return (
          Theme.of(context).colorScheme.error,
          Theme.of(context).colorScheme.error,
        );
    }
  }

  static List<String> _reasons(String dataJson) {
    try {
      final decoded = jsonDecode(dataJson);
      if (decoded is Map && decoded['reasons'] is List) {
        return (decoded['reasons'] as List)
            .map((reason) => reason.toString())
            .toList(growable: false);
      }
    } catch (_) {}
    return const <String>[];
  }
}
