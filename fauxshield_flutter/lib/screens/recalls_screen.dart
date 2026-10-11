import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';

/// Recall management: the recall history for the workspace, mirroring the
/// reference app's Recalls page. Active recalls can be lifted by operators
/// with batch write permission.
class RecallsScreen extends StatefulWidget {
  const RecallsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<RecallsScreen> createState() => _RecallsScreenState();
}

class _RecallsScreenState extends State<RecallsScreen> {
  List<RecallRecord> _records = <RecallRecord>[];
  Map<UuidValue, Batch> _batches = <UuidValue, Batch>{};
  bool _loading = true;
  bool _errorState = false;
  String? _error;
  bool _includeLifted = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _records.isEmpty;
      _error = null;
      _errorState = false;
    });
    try {
      final results = await Future.wait<Object>(<Future<Object>>[
        client.recall.list(
          workspaceId: widget.controller.workspaceId,
          includeLifted: _includeLifted,
        ),
        client.batch.list(workspaceId: widget.controller.workspaceId),
      ]);
      final records = results[0] as List<RecallRecord>;
      final batches = results[1] as List<Batch>;
      if (!mounted) return;
      setState(() {
        _records = records;
        _batches = <UuidValue, Batch>{
          for (final batch in batches)
            if (batch.id != null) batch.id!: batch,
        };
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is ApiException ? error.message : error.toString();
        _errorState = true;
        _loading = false;
      });
    }
  }

  Future<void> _lift(RecallRecord record) async {
    final confirmed = await confirmAction(
      context,
      title: 'Lift recall',
      message:
          'Units in this scope will verify normally again. '
          'The lift is recorded in the audit log.',
      confirmLabel: 'Lift recall',
      destructive: false,
    );
    if (!confirmed) return;
    try {
      await client.recall.lift(
        workspaceId: widget.controller.workspaceId,
        recallId: record.id!,
        note: 'Lifted from the app.',
      );
      if (mounted) showMessage(context, 'Recall lifted.');
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recalls'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: <Widget>[
            SectionCard(
              title: 'Recall management',
              subtitle:
                  'Every recall issued against a batch or a single unit, '
                  'and whether it has been lifted',
              trailing: Switch(
                value: _includeLifted,
                onChanged: (value) {
                  setState(() => _includeLifted = value);
                  _records = <RecallRecord>[];
                  _load();
                },
              ),
              child: _loading
                  ? const LoadingView()
                  : _errorState
                  ? ErrorState(message: _error ?? 'Something went wrong.')
                  : _records.isEmpty
                  ? const EmptyState(
                      icon: Icons.campaign_rounded,
                      title: 'No recalls yet',
                      message:
                          'Recall a batch from its detail page to see the '
                          'history here.',
                    )
                  : Column(
                      children: <Widget>[
                        for (final record in _records) _row(record, theme),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(RecallRecord record, ThemeData theme) {
    final batch = _batches[record.batchId];
    final scopeLabel = record.identityId != null
        ? 'Single unit'
        : 'Batch ${batch?.reference ?? record.batchId.uuid.substring(0, 8)}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                record.lifted
                    ? Icons.campaign_outlined
                    : Icons.campaign_rounded,
                size: 20,
                color: record.lifted
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.error,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  scopeLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Pill(
                label: record.lifted ? 'LIFTED' : 'ACTIVE',
                color: record.lifted
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.error,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(record.reason, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 2),
                Text(
                  <String>[
                    'Issued ${shortDate(record.issuedAt)}'
                        '${record.issuedBy.isEmpty ? '' : ' by ${record.issuedBy}'}',
                    if (record.lifted && record.liftedAt != null)
                      'Lifted ${shortDate(record.liftedAt!)}',
                  ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (!record.lifted && widget.controller.can('batchesWrite'))
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => _lift(record),
                      icon: const Icon(Icons.undo_rounded, size: 16),
                      label: const Text('Lift recall'),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 20),
        ],
      ),
    );
  }
}
