import 'dart:async';
import 'dart:convert';

import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart';

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';
import '../utils/request_recovery.dart';

/// Attack simulations: rehearse the brand's fraud response.
///
/// Every scenario runs through the real verification and fraud pipeline, so
/// the sessions, signals, alerts, and live events it produces are real.
class SimulationsScreen extends StatefulWidget {
  const SimulationsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<SimulationsScreen> createState() => _SimulationsScreenState();
}

class _SimulationsScreenState extends State<SimulationsScreen> {
  List<AttackSimulation> _simulations = <AttackSimulation>[];
  bool _loading = true;
  String? _error;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _simulations.isEmpty;
      _error = null;
    });
    try {
      final simulations = await client.simulation.list(
        workspaceId: widget.controller.workspaceId,
        page: 0,
        pageSize: 25,
      );
      if (!mounted) return;
      setState(() {
        _simulations = simulations;
        _loading = false;
      });
      _schedulePoll();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = describeRequestError(error);
        _loading = false;
      });
    }
  }

  void _schedulePoll() {
    _poll?.cancel();
    final active = _simulations.any(
      (simulation) =>
          simulation.status == SimulationStatus.queued ||
          simulation.status == SimulationStatus.running,
    );
    if (!active) return;
    _poll = Timer(const Duration(seconds: 3), _load);
  }

  Future<void> _run(Future<void> Function() action, String success) async {
    try {
      await action();
      if (mounted) showMessage(context, success);
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
        title: const Text('Simulations'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: widget.controller.can('simulationsRun')
          ? FloatingActionButton.extended(
              onPressed: _startDialog,
              icon: const Icon(Icons.science_rounded),
              label: const Text('New simulation'),
            )
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    if (_simulations.isEmpty) {
      return EmptyState(
        icon: Icons.science_rounded,
        title: 'No simulations yet',
        message:
            'Rehearse a clone attack, PIN brute force, scan burst, or grey '
            'market leak. Everything runs through the real pipeline.',
        action: widget.controller.can('simulationsRun')
            ? FilledButton.icon(
                onPressed: _startDialog,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Run the first one'),
              )
            : null,
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
        itemCount: _simulations.length,
        itemBuilder: (context, index) => _card(_simulations[index]),
      ),
    );
  }

  Widget _card(AttackSimulation simulation) {
    final theme = Theme.of(context);
    final status = simulation.status;
    final color = switch (status) {
      SimulationStatus.queued => const Color(0xFFB45309),
      SimulationStatus.running => const Color(0xFF2563EB),
      SimulationStatus.completed => const Color(0xFF0F7B4D),
      SimulationStatus.cancelled => theme.colorScheme.outline,
      SimulationStatus.failed => theme.colorScheme.error,
    };
    final progress = simulation.totalSteps == 0
        ? 0.0
        : simulation.progress / simulation.totalSteps;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        simulation.label ??
                            simulationTypeLabel(simulation.type),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${simulationTypeLabel(simulation.type)} · started '
                        '${relativeTime(simulation.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Pill(
                  label: status.name.toUpperCase(),
                  color: color,
                  dense: true,
                ),
              ],
            ),
            if (status == SimulationStatus.running ||
                status == SimulationStatus.queued) ...<Widget>[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  minHeight: 8,
                  value: status == SimulationStatus.queued ? null : progress,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${simulation.progress} of ${simulation.totalSteps} steps',
                style: theme.textTheme.bodySmall,
              ),
            ],
            if (simulation.summaryJson != null) ...<Widget>[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _pretty(simulation.summaryJson!),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                ),
              ),
            ],
            if (widget.controller.can('simulationsRun') &&
                (status == SimulationStatus.queued ||
                    status == SimulationStatus.running))
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Wrap(
                  spacing: 6,
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () => _run(
                        () =>
                            client.simulation.step(simulation.id!).then((_) {}),
                        'Advanced one step.',
                      ),
                      icon: const Icon(Icons.skip_next_rounded, size: 18),
                      label: const Text('Step'),
                    ),
                    TextButton.icon(
                      onPressed: () => _run(
                        () =>
                            client.simulation.run(simulation.id!).then((_) {}),
                        'Simulation finished.',
                      ),
                      icon: const Icon(Icons.fast_forward_rounded, size: 18),
                      label: const Text('Run now'),
                    ),
                    TextButton.icon(
                      onPressed: () => _run(
                        () => client.simulation
                            .cancel(simulation.id!)
                            .then((_) {}),
                        'Simulation cancelled.',
                      ),
                      icon: const Icon(Icons.stop_circle_outlined, size: 18),
                      label: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  static String _pretty(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (_) {
      return raw;
    }
  }

  Future<void> _startDialog() async {
    var type = SimulationType.cloneAttack;
    var pace = 2;
    final label = TextEditingController();
    final steps = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Start a simulation'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DropdownButtonFormField<SimulationType>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Scenario'),
                  items: <DropdownMenuItem<SimulationType>>[
                    for (final value in SimulationType.values)
                      DropdownMenuItem<SimulationType>(
                        value: value,
                        child: Text(simulationTypeLabel(value)),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => type = value);
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  _scenarioHint(type),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                LabeledField(
                  label: 'Label (optional)',
                  controller: label,
                  hint: 'e.g. Q4 warehouse rehearsal',
                ),
                LabeledField(
                  label: 'Steps (optional)',
                  controller: steps,
                  keyboardType: TextInputType.number,
                  hint: 'Leave blank for the scenario default',
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  initialValue: pace,
                  decoration: const InputDecoration(labelText: 'Pace'),
                  items: const <DropdownMenuItem<int>>[
                    DropdownMenuItem<int>(
                      value: 0,
                      child: Text('Inline (finish immediately)'),
                    ),
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text('Fast (2s per step)'),
                    ),
                    DropdownMenuItem<int>(
                      value: 5,
                      child: Text('Demo (5s per step)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setDialogState(() => pace = value);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Start'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      final parsedSteps = int.tryParse(steps.text.trim());
      await _run(
        () => client.simulation
            .start(
              workspaceId: widget.controller.workspaceId,
              request: SimulationRequest(
                type: type,
                label: label.text.trim().isEmpty ? null : label.text.trim(),
                steps: parsedSteps,
                stepDelaySeconds: pace,
              ),
            )
            .then((_) {}),
        'Simulation started.',
      );
    }
    label.dispose();
    steps.dispose();
  }

  static String _scenarioHint(SimulationType type) {
    switch (type) {
      case SimulationType.cloneAttack:
        return 'One token scanned in far apart locations until the clone '
            'detector fires and locks the unit.';
      case SimulationType.pinBruteForce:
        return 'Wrong PINs hammer a unit until the lockout threshold trips '
            'and a PIN attack signal is raised.';
      case SimulationType.scanBurst:
        return 'A burst of scans inside the velocity window, like a '
            'distributor dumping stock into one market.';
      case SimulationType.greyMarketLeak:
        return 'Scans keep coming from restricted countries until a grey '
            'market signal and alert are raised.';
    }
  }
}
