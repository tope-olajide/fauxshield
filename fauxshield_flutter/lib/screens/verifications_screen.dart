import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import '../utils/request_recovery.dart';

/// Verification activity: the most recent verification sessions, filterable
/// by product, batch, outcome, risk, and date range — the operator-facing
/// counterpart of the reference app's Verifications page.
class VerificationsScreen extends StatefulWidget {
  const VerificationsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<VerificationsScreen> createState() => _VerificationsScreenState();
}

class _VerificationsScreenState extends State<VerificationsScreen> {
  static const int _pageSize = 25;

  List<Product> _products = <Product>[];
  List<Batch> _batches = <Batch>[];
  List<VerificationSession> _sessions = <VerificationSession>[];

  Product? _product;
  Batch? _batch;
  VerificationOutcome? _outcome;
  RiskScore? _risk;
  DateTime? _startDate;
  DateTime? _endDate;

  bool _loading = true;
  bool _loadingProducts = true;
  String? _error;
  String? _dateError;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _loadFilters();
    _load();
  }

  Future<void> _loadFilters() async {
    try {
      final products = await client.product.list(
        workspaceId: widget.controller.workspaceId,
        includeArchived: false,
      );
      if (!mounted) return;
      setState(() {
        _products = products;
        _loadingProducts = false;
      });
    } catch (error) {
      // Filters degrade gracefully: outcome/risk/date still work.
      if (mounted) setState(() => _loadingProducts = false);
    }
  }

  Future<void> _loadBatches() async {
    final product = _product;
    if (product == null) {
      setState(() => _batches = <Batch>[]);
      return;
    }
    try {
      final batches = await client.batch.list(
        workspaceId: widget.controller.workspaceId,
        productId: product.id,
      );
      if (!mounted) return;
      setState(() => _batches = batches);
    } catch (_) {
      if (mounted) setState(() => _batches = <Batch>[]);
    }
  }

  bool get _hasActiveFilters =>
      _product != null ||
      _batch != null ||
      _outcome != null ||
      _risk != null ||
      _startDate != null ||
      _endDate != null;

  bool _validateDates() {
    if (_startDate != null &&
        _endDate != null &&
        _endDate!.isBefore(_startDate!)) {
      setState(
        () => _dateError = 'The end date must be on or after the start date.',
      );
      return false;
    }
    if (_startDate != null &&
        _endDate != null &&
        _endDate!.difference(_startDate!).inDays > 90) {
      setState(
        () => _dateError = 'Choose a range of up to 90 days.',
      );
      return false;
    }
    setState(() => _dateError = null);
    return true;
  }

  Future<void> _load() async {
    if (!_validateDates()) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = _sessions.isEmpty;
      _error = null;
    });
    try {
      final sessions = await client.verification.list(
        workspaceId: widget.controller.workspaceId,
        batchId: _batch?.id,
        productId: _batch == null ? _product?.id : null,
        outcome: _outcome,
        riskScore: _risk,
        from: _startDate,
        to: _endDate == null
            ? null
            : DateTime(
                _endDate!.year,
                _endDate!.month,
                _endDate!.day,
              ).add(const Duration(days: 1)),
        page: _page,
        pageSize: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        if (_page == 0) {
          _sessions = sessions;
        } else {
          _sessions = <VerificationSession>[..._sessions, ...sessions];
        }
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

  void _applyFilters(VoidCallback change) {
    setState(change);
    _page = 0;
    _sessions = <VerificationSession>[];
    _load();
  }

  void _clearFilters() {
    _applyFilters(() {
      _product = null;
      _batch = null;
      _batches = <Batch>[];
      _outcome = null;
      _risk = null;
      _startDate = null;
      _endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifications'),
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
      body: RefreshIndicator(
        onRefresh: () {
          _page = 0;
          return _load();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: <Widget>[
            _filterCard(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ErrorState(
                  message: _error!,
                  onRetry: () {
                    _page = 0;
                    _load();
                  },
                ),
              )
            else if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 48),
                child: LoadingView(),
              )
            else if (_sessions.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 32),
                child: EmptyState(
                  icon: Icons.fact_check_rounded,
                  title: 'No verification sessions',
                  message:
                      'Sessions appear here when consumers verify products.',
                ),
              )
            else
              ..._rows(),
          ],
        ),
      ),
    );
  }

  Widget _filterCard() {
    final theme = Theme.of(context);
    return SectionCard(
      title: 'Verification activity',
      subtitle: 'Filter sessions by product, batch, outcome, risk, and date',
      trailing: TextButton(
        onPressed: _hasActiveFilters || _dateError != null
            ? _clearFilters
            : null,
        child: const Text('Clear filters'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              SizedBox(
                width: 190,
                child: DropdownButtonFormField<Product?>(
                  initialValue: _product,
                  decoration: const InputDecoration(labelText: 'Product'),
                  isExpanded: true,
                  items: <DropdownMenuItem<Product?>>[
                    const DropdownMenuItem<Product?>(
                      value: null,
                      child: Text('All products'),
                    ),
                    for (final product in _products)
                      DropdownMenuItem<Product?>(
                        value: product,
                        child: Text(product.name),
                      ),
                  ],
                  onChanged: _loadingProducts
                      ? null
                      : (value) {
                          _applyFilters(() {
                            _product = value;
                            _batch = null;
                            _batches = <Batch>[];
                          });
                          if (value != null) _loadBatches();
                        },
                ),
              ),
              SizedBox(
                width: 190,
                child: DropdownButtonFormField<Batch?>(
                  initialValue: _batch,
                  decoration: const InputDecoration(labelText: 'Batch'),
                  isExpanded: true,
                  items: <DropdownMenuItem<Batch?>>[
                    DropdownMenuItem<Batch?>(
                      value: null,
                      child: Text(
                        _product == null
                            ? 'Select a product first'
                            : 'All batches',
                      ),
                    ),
                    for (final batch in _batches)
                      DropdownMenuItem<Batch?>(
                        value: batch,
                        child: Text(batch.reference),
                      ),
                  ],
                  onChanged: _product == null
                      ? null
                      : (value) => _applyFilters(() => _batch = value),
                ),
              ),
              SizedBox(
                width: 170,
                child: DropdownButtonFormField<VerificationOutcome?>(
                  initialValue: _outcome,
                  decoration: const InputDecoration(labelText: 'Outcome'),
                  items: <DropdownMenuItem<VerificationOutcome?>>[
                    const DropdownMenuItem<VerificationOutcome?>(
                      value: null,
                      child: Text('All outcomes'),
                    ),
                    for (final outcome in VerificationOutcome.values)
                      DropdownMenuItem<VerificationOutcome?>(
                        value: outcome,
                        child: Text(outcomeLabel(outcome)),
                      ),
                  ],
                  onChanged: (value) => _applyFilters(() => _outcome = value),
                ),
              ),
              SizedBox(
                width: 170,
                child: DropdownButtonFormField<RiskScore?>(
                  initialValue: _risk,
                  decoration: const InputDecoration(labelText: 'Risk score'),
                  items: <DropdownMenuItem<RiskScore?>>[
                    const DropdownMenuItem<RiskScore?>(
                      value: null,
                      child: Text('All risk scores'),
                    ),
                    for (final risk in RiskScore.values)
                      DropdownMenuItem<RiskScore?>(
                        value: risk,
                        child: Text(risk.name),
                      ),
                  ],
                  onChanged: (value) => _applyFilters(() => _risk = value),
                ),
              ),
              SizedBox(
                width: 170,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      _applyFilters(() => _startDate = picked);
                    }
                  },
                  icon: const Icon(Icons.calendar_today_rounded, size: 16),
                  label: Text(
                    _startDate == null ? 'Start date' : shortDate(_startDate!),
                  ),
                ),
              ),
              SizedBox(
                width: 170,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      _applyFilters(() => _endDate = picked);
                    }
                  },
                  icon: const Icon(Icons.event_rounded, size: 16),
                  label: Text(
                    _endDate == null ? 'End date' : shortDate(_endDate!),
                  ),
                ),
              ),
            ],
          ),
          if (_dateError != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _dateError!,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _rows() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(
          '${_sessions.length} session${_sessions.length == 1 ? '' : 's'} loaded',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      for (final session in _sessions) _row(session),
      if (_sessions.length % _pageSize == 0)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: TextButton.icon(
            onPressed: () {
              _page++;
              _load();
            },
            icon: const Icon(Icons.expand_more_rounded),
            label: const Text('Load more'),
          ),
        ),
    ];
  }

  Widget _row(VerificationSession session) {
    final theme = Theme.of(context);
    final location = <String?>[
      session.city,
      session.country,
    ].whereType<String>().where((part) => part.isNotEmpty).join(', ');
    final token = session.qrToken;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          outcomeIcon(session.outcome),
          color: outcomeColor(context, session.outcome),
          size: 22,
        ),
        title: Text(
          token.length > 18
              ? '${token.substring(0, 10)}…${token.substring(token.length - 6)}'
              : token,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
        ),
        subtitle: Text(
          <String>[
            outcomeLabel(session.outcome),
            if (session.riskScore != null) 'risk ${session.riskScore!.name}',
            if (location.isNotEmpty) location,
            session.source.name,
          ].join(' · '),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              relativeTime(session.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (session.outcome != null)
              Pill(
                label: outcomeLabel(session.outcome),
                color: outcomeColor(context, session.outcome),
                dense: true,
              ),
          ],
        ),
      ),
    );
  }
}
