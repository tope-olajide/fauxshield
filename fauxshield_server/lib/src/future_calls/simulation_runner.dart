import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/simulation_service.dart';

/// Advances an attack simulation by one step and schedules the next one.
///
/// The chain is self perpetuating: `start` schedules step zero, and every
/// executed step schedules its successor until the simulation completes,
/// fails, or is cancelled. This gives the command center a live, paced
/// unfolding of the attack instead of a single burst.
class SimulationRunner extends FutureCall {
  Future<void> step(Session session, SimulationStepRequest request) async {
    final service = SimulationService();
    final simulation = await service.executeStep(
      session,
      simulationId: request.simulationId,
    );

    final active =
        simulation.status == SimulationStatus.queued ||
        simulation.status == SimulationStatus.running;
    if (!active) return;

    await SimulationService.scheduleNextStep(session, simulation);
  }
}
