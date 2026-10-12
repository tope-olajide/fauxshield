import 'dart:convert';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import '../utils/request_recovery.dart';

/// Offline field scans.
///
/// Inspector devices queue scans locally, then either upload them for
/// immediate verdicts or let the recurring converter process the synced rows.
class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  List<OfflineScanRecord> _records = <OfflineScanRecord>[];
  bool _loading = true;
  bool _onlyPending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _records.isEmpty;
      _error = null;
    });
    try {
      final records = await client.offline.records(
        workspaceId: widget.controller.workspaceId,
        onlyPending: _onlyPending,
        page: 0,
        pageSize: 50,
      );
      if (!mounted) return;
      setState(() {
        _records = records;
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

  Future<void> _convertNow() async {
    try {
      final converted = await client.offline.convertNow(
        workspaceId: widget.controller.workspaceId,
      );
      if (mounted) {
        showMessage(context, '$converted scans converted.');
      }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline field scans'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Convert pending now',
            onPressed: _convertNow,
            icon: const Icon(Icons.sync_rounded),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _queueDemoScan,
        icon: const Icon(Icons.add_location_alt_rounded),
        label: const Text('Queue scan'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              children: <Widget>[
                FilterChip(
                  label: const Text('Pending only'),
                  selected: _onlyPending,
                  onSelected: (value) {
                    setState(() => _onlyPending = value);
                    _load();
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  '${_records.length} records',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (_records.isEmpty)
            const EmptyState(
              icon: Icons.cloud_sync_rounded,
              title: 'No offline scans',
              message:
                  'Queue a demo scan or sync records from an inspector device.',
            )
          else
            for (final record in _records) _recordCard(record),
        ],
      ),
    );
  }

  Widget _recordCard(OfflineScanRecord record) {
    final theme = Theme.of(context);
    final processed = record.processed;
    final verdict = _verdictOf(record);
    final outcome = verdict?['outcome'] as String?;
    final color = outcome == null
        ? theme.colorScheme.outline
        : outcomeColor(context, VerificationOutcome.fromJson(outcome));
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Icon(
          processed ? Icons.verified_rounded : Icons.schedule_rounded,
          color: color,
        ),
        title: Text(
          record.deviceId,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          <String?>[
            '${record.city ?? ''} ${record.country ?? ''}'.trim(),
            'scanned ${relativeTime(record.scannedAt)}',
            if (processed) 'verdict: ${outcome ?? record.provisionalOutcome}',
            if (!processed) 'pending conversion',
          ].whereType<String>().where((part) => part.isNotEmpty).join(' · '),
        ),
        trailing: processed
            ? Pill(
                label: (outcome ?? 'processed').toUpperCase(),
                color: color,
                dense: true,
              )
            : const Pill(
                label: 'PENDING',
                color: Color(0xFFB45309),
                dense: true,
              ),
        onTap: record.verdictJson == null ? null : () => _showVerdict(record),
      ),
    );
  }

  Future<void> _showVerdict(OfflineScanRecord record) async {
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
            Text(
              record.qrToken,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
            const SizedBox(height: 12),
            SelectableText(
              _pretty(record.verdictJson!),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _queueDemoScan() async {
    const deviceId = 'field-device-01';
    try {
      final workspaceId = widget.controller.workspaceId;
      final products = await client.product.list(
        workspaceId: workspaceId,
        includeArchived: false,
      );
      String? token;
      for (final product in products) {
        final batches = await client.batch.list(
          workspaceId: workspaceId,
          productId: product.id,
        );
        for (final batch in batches) {
          final identities = await client.identity.list(
            workspaceId: workspaceId,
            batchId: batch.id,
            onlyFlagged: false,
            page: 0,
            pageSize: 1,
          );
          if (identities.isNotEmpty) {
            token = identities.first.qrToken;
            break;
          }
        }
        if (token != null) break;
      }
      if (token == null) {
        throw ValidationException(
          message: 'No serialized units to scan. Generate some first.',
        );
      }
      final verdicts = await client.offline.ingest(
        workspaceId: workspaceId,
        deviceId: deviceId,
        scans: <OfflineScanInput>[
          OfflineScanInput(
            localId: 'demo-${DateTime.now().millisecondsSinceEpoch}',
            deviceId: deviceId,
            qrToken: token,
            scannedAt: DateTime.now().toUtc(),
            city: 'Lagos',
            country: 'Nigeria',
            provisionalOutcome: 'pending',
          ),
        ],
      );
      if (!mounted) return;
      showMessage(
        context,
        verdicts.isEmpty
            ? 'Scan queued for conversion.'
            : 'Verdict: ${verdicts.first.message}',
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

  static Map<String, dynamic>? _verdictOf(OfflineScanRecord record) {
    final raw = record.verdictJson;
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  static String _pretty(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return raw;
    }
  }
}
