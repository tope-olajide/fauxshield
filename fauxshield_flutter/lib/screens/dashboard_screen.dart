import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import 'alert_detail_screen.dart';
import 'scan_screen.dart';
import '../utils/request_recovery.dart';

/// The operator dashboard: platform health at a glance.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardSummary? _summary;
  bool _loading = true;
  String? _error;
  int _windowDays = 14;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _summary == null;
      _error = null;
    });
    try {
      final summary = await client.analytics.dashboard(
        workspaceId: widget.controller.workspaceId,
        windowDays: _windowDays,
      );
      if (!mounted) return;
      setState(() {
        _summary = summary;
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => ScanScreen(controller: widget.controller),
          ),
        ),
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: const Text('Scan'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    final summary = _summary;
    if (summary == null) {
      return ErrorState(
        message: _error ?? 'Could not load the dashboard.',
        onRetry: _load,
      );
    }

    final wide = MediaQuery.sizeOf(context).width >= 900;

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: wide
            ? const EdgeInsets.fromLTRB(28, 24, 28, 96)
            : const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: <Widget>[
          _pageHeader(),
          const SizedBox(height: 20),
          _metricGrid(summary),
          const SizedBox(height: 10),
          _dashboardCards(summary),
        ],
      ),
    );
  }

  /// Page header matching the reference `PageHeader` component: bold title,
  /// muted description, refresh action, demo pill.
  Widget _pageHeader() {
    final theme = Theme.of(context);
    final workspace = widget.controller.bootstrap?.workspace;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      'Dashboard',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (widget.controller.isDemo)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Pill(
                        label: 'DEMO',
                        color: Color(0xFF2563EB),
                        dense: true,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Overview of ${workspace?.branding?.displayName ?? workspace?.name ?? 'your workspace'}'
                ' verification activity and metrics.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Refresh',
          onPressed: _load,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }

  /// The four metric cards, mirroring the reference `MetricCard` grid
  /// (`sm:grid-cols-2 lg:grid-cols-4`).
  Widget _metricGrid(DashboardSummary summary) {
    final metrics = <(String, String, String)>[
      (
        'Total verifications',
        '${summary.totalVerifications}',
        'Last ${summary.windowDays} days',
      ),
      (
        'Authentic',
        '${summary.authentic}',
        'Successful verifications',
      ),
      (
        'Fraud alerts',
        '${summary.openAlerts}',
        summary.criticalAlerts > 0
            ? '${summary.criticalAlerts} critical right now'
            : 'Open alerts across the workspace',
      ),
      (
        'Serialized units',
        '${summary.identitiesTotal}',
        '${summary.batchesTotal} batches',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1024
            ? 4
            : width >= 640
            ? 2
            : 1;
        const gap = 12.0;
        final cardWidth = (width - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final (title, value, description) in metrics)
              _MetricCard(
                width: cardWidth,
                title: title,
                value: value,
                description: description,
              ),
          ],
        );
      },
    );
  }

  /// Dashboard cards: two columns on wide layouts, stacked on narrow ones,
  /// matching the reference `grid gap-4 md:grid-cols-2` arrangement.
  Widget _dashboardCards(DashboardSummary summary) {
    final trendCard = SectionCard(
      title: 'Verifications over time',
      subtitle: 'Last ${summary.windowDays} days',
      trailing: SegmentedButton<int>(
        showSelectedIcon: false,
        style: const ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        segments: const <ButtonSegment<int>>[
          ButtonSegment<int>(value: 7, label: Text('7d')),
          ButtonSegment<int>(value: 14, label: Text('14d')),
          ButtonSegment<int>(value: 30, label: Text('30d')),
        ],
        selected: <int>{_windowDays},
        onSelectionChanged: (selection) {
          setState(() => _windowDays = selection.first);
          _load();
        },
      ),
      child: _TrendChart(trend: summary.trend),
    );
    final outcomeCard = SectionCard(
      title: 'Outcome distribution',
      subtitle: '${summary.totalVerifications} verifications in window',
      child: _outcomeBreakdown(summary),
    );
    final countriesCard = SectionCard(
      title: 'Top countries',
      subtitle: 'Where your products are being scanned',
      child: _countries(summary),
    );
    final alertsCard = SectionCard(
      title: 'Recent alerts',
      subtitle:
          '${summary.openAlerts} open · ${summary.criticalAlerts} critical',
      child: _recentAlerts(summary),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            children: <Widget>[
              trendCard,
              outcomeCard,
              countriesCard,
              alertsCard,
            ],
          );
        }
        return Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: trendCard),
                const SizedBox(width: 12),
                Expanded(child: outcomeCard),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: countriesCard),
                const SizedBox(width: 12),
                Expanded(child: alertsCard),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _outcomeBreakdown(DashboardSummary summary) {
    final total = summary.totalVerifications == 0
        ? 1
        : summary.totalVerifications;
    final entries = <(String, int, Color)>[
      ('Authentic', summary.authentic, const Color(0xFF0F7B4D)),
      ('Already verified', summary.alreadyVerified, const Color(0xFF2563EB)),
      ('Invalid PIN', summary.invalidPin, const Color(0xFFB45309)),
      ('High risk', summary.highRisk, const Color(0xFFC2410C)),
      (
        'Fraud suspected',
        summary.fraudSuspected,
        Theme.of(context).colorScheme.error,
      ),
      ('Recalled', summary.recalled, const Color(0xFF9F1239)),
    ];
    return Column(
      children: <Widget>[
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 120,
                  child: Text(
                    entry.$1,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: entry.$2 / total,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(entry.$3),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 44,
                  child: Text(
                    '${entry.$2}',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _countries(DashboardSummary summary) {
    if (summary.topCountries.isEmpty) {
      return Text(
        'No geographic data yet.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Column(
      children: <Widget>[
        for (final country in summary.topCountries.take(6))
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.public_rounded, size: 20),
            title: Text(country.country),
            subtitle: Text(
              '${country.fraud} flagged of ${country.verifications}',
            ),
            trailing: Text(
              '${country.verifications}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget _recentAlerts(DashboardSummary summary) {
    if (summary.recentAlerts.isEmpty) {
      return Text(
        'No alerts yet. Your products look clean.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Column(
      children: <Widget>[
        for (final alert in summary.recentAlerts.take(4))
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.gpp_maybe_rounded,
              color: severityColor(context, alert.severity),
            ),
            title: Text(
              alert.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${alert.status.name} · ${relativeTime(alert.createdAt)}',
            ),
            trailing: Pill(
              label: alert.severity.name.toUpperCase(),
              color: severityColor(context, alert.severity),
              dense: true,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => AlertDetailScreen(
                  controller: widget.controller,
                  alertId: alert.id!,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A metric card matching the reference `MetricCard`: bordered card,
/// medium title, bold value, muted description.
class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.width,
    required this.title,
    required this.value,
    required this.description,
  });

  final double width;
  final String title;
  final String value;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A compact bar chart of verifications per day.
class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.trend});

  final List<TrendPoint> trend;

  @override
  Widget build(BuildContext context) {
    if (trend.isEmpty) {
      return Text(
        'No data in this window yet.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    final maxValue = trend
        .map((point) => point.verifications)
        .fold<int>(0, (a, b) => a > b ? a : b);
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          for (final point in trend)
            Expanded(
              child: Tooltip(
                message:
                    '${shortDate(point.date)}: ${point.verifications} scans, ${point.fraud} fraud',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      if (point.fraud > 0)
                        Container(
                          height: 3,
                          margin: const EdgeInsets.only(bottom: 2),
                          decoration: BoxDecoration(
                            color: scheme.error,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: maxValue == 0
                              ? 0.02
                              : (point.verifications / maxValue).clamp(
                                  0.02,
                                  1.0,
                                ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.75),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
