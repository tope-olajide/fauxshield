import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../widgets/common.dart';

/// Geographic intelligence: the full per-country breakdown of verification
/// volume and fraud, mirroring the reference app's Geographic page.
class GeographicScreen extends StatefulWidget {
  const GeographicScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<GeographicScreen> createState() => _GeographicScreenState();
}

class _GeographicScreenState extends State<GeographicScreen> {
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
        _error = error is ApiException ? error.message : error.toString();
        _loading = false;
      });
    }
  }

  void _setWindow(int days) {
    setState(() => _windowDays = days);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = _summary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geographic'),
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
              title: 'Geographic intelligence',
              subtitle:
                  'Where scans happen and where fraud concentrates, over the '
                  'last $_windowDays days',
              trailing: SegmentedButton<int>(
                segments: const <ButtonSegment<int>>[
                  ButtonSegment<int>(value: 7, label: Text('7d')),
                  ButtonSegment<int>(value: 14, label: Text('14d')),
                  ButtonSegment<int>(value: 30, label: Text('30d')),
                ],
                selected: <int>{_windowDays},
                showSelectedIcon: false,
                onSelectionChanged: (selection) => _setWindow(selection.first),
              ),
              child: _loading
                  ? const LoadingView()
                  : _error != null
                  ? ErrorState(message: _error!, onRetry: _load)
                  : _content(summary!, theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(DashboardSummary summary, ThemeData theme) {
    final countries = summary.topCountries;
    if (countries.isEmpty) {
      return const EmptyState(
        icon: Icons.public_rounded,
        title: 'No geographic data yet',
        message: 'Country data appears once consumers start scanning.',
      );
    }
    final totalScans = countries.fold<int>(
      0,
      (sum, country) => sum + country.verifications,
    );
    final totalFraud = countries.fold<int>(
      0,
      (sum, country) => sum + country.fraud,
    );
    final maxScans = countries
        .map((country) => country.verifications)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            _metric(theme, 'Countries', '${countries.length}'),
            const SizedBox(width: 12),
            _metric(theme, 'Scans', '$totalScans'),
            const SizedBox(width: 12),
            _metric(theme, 'Flagged', '$totalFraud'),
          ],
        ),
        const SizedBox(height: 16),
        for (var index = 0; index < countries.length; index++)
          _countryRow(countries[index], index, maxScans, theme),
      ],
    );
  }

  Widget _metric(ThemeData theme, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _countryRow(
    CountryStat country,
    int index,
    int maxScans,
    ThemeData theme,
  ) {
    final fraudShare = country.verifications == 0
        ? 0.0
        : country.fraud / country.verifications;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 26,
                child: Text(
                  '${index + 1}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(
                Icons.public_rounded,
                size: 18,
                color: fraudShare > 0.1
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  country.country,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (country.fraud > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    '${country.fraud} flagged',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Text(
                '${country.verifications}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: maxScans == 0 ? 0 : country.verifications / maxScans,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: fraudShare > 0.1
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
