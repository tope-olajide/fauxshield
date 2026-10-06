import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/idempotency_service.dart';
import '../services/live_events.dart';

/// Housekeeping that keeps the platform healthy.
///
/// * Prunes expired idempotency records so keys can be safely reused.
/// * Fails simulations that have been stuck in queued or running for more
///   than an hour, publishing a live event for the command center.
class MaintenanceSweep extends FutureCall {
  Future<void> sweep(Session session) async {
    await IdempotencyService.prune(session);

    final now = DateTime.now().toUtc();
    final staleBefore = now.subtract(const Duration(hours: 1));
    final stale = await AttackSimulation.db.find(
      session,
      where: (t) =>
          (t.status.equals(SimulationStatus.queued) |
              t.status.equals(SimulationStatus.running)) &
          (t.createdAt < staleBefore),
      limit: 100,
    );
    for (final simulation in stale) {
      final updated = await AttackSimulation.db.updateRow(
        session,
        simulation.copyWith(
          status: SimulationStatus.failed,
          completedAt: now,
          summaryJson: jsonEncode(<String, dynamic>{
            'error': 'Timed out without advancing within one hour.',
            'progress': simulation.progress,
          }),
        ),
      );
      await LiveEvents.publish(
        session,
        workspaceId: updated.workspaceId,
        type: LiveEventType.simulationProgress,
        title: 'Simulation timed out',
        subtitle: updated.label ?? 'Attack simulation',
        severity: AlertSeverity.medium,
        payload: <String, dynamic>{'simulation_id': updated.id!.uuid},
      );
    }
  }
}
