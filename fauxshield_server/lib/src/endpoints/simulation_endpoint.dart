import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../generated/protocol.dart';
import '../services/rbac.dart';
import '../services/simulation_service.dart';
import '../services/workspace_service.dart';

/// Attack simulation control.
///
/// Simulations run realistic attack scenarios through the real fraud
/// pipeline, so the command center can rehearse its response to clone
/// attacks, PIN brute force, scan bursts, and grey market leaks.
class SimulationEndpoint extends Endpoint {
  /// Starts a simulation. Zero delay runs to completion inline.
  Future<AttackSimulation> start(
    Session session, {
    UuidValue? workspaceId,
    required SimulationRequest request,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.simulationsRun);
    return SimulationService().start(
      session,
      workspaceId: context.workspaceId,
      request: request,
      createdBy: context.userIdentifier,
    );
  }

  /// Lists recent simulations.
  Future<List<AttackSimulation>> list(
    Session session, {
    UuidValue? workspaceId,
    int page = 0,
    int pageSize = 25,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.simulationsRun);
    final size = pageSize.clamp(1, FauxShieldLimits.maxPageSize);
    final offset = (page < 0 ? 0 : page) * size;
    return AttackSimulation.db.find(
      session,
      where: (t) => t.workspaceId.equals(context.workspaceId),
      orderBy: (t) => t.createdAt.desc(),
      limit: size,
      offset: offset,
    );
  }

  /// Loads one simulation.
  Future<AttackSimulation> get(
    Session session,
    UuidValue simulationId,
  ) async {
    final simulation = await SimulationService().simulation(
      session,
      simulationId: simulationId,
    );
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: simulation.workspaceId,
    );
    WorkspaceService.require(context, Permission.simulationsRun);
    return simulation;
  }

  /// Advances a simulation by one step immediately.
  ///
  /// Useful for tests and for walking a simulation forward by hand while
  /// watching the command center stream.
  Future<AttackSimulation> step(
    Session session,
    UuidValue simulationId,
  ) async {
    final simulation = await SimulationService().simulation(
      session,
      simulationId: simulationId,
    );
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: simulation.workspaceId,
    );
    WorkspaceService.require(context, Permission.simulationsRun);
    return SimulationService().executeStep(
      session,
      simulationId: simulationId,
    );
  }

  /// Runs any remaining steps inline.
  Future<AttackSimulation> run(
    Session session,
    UuidValue simulationId,
  ) async {
    final simulation = await SimulationService().simulation(
      session,
      simulationId: simulationId,
    );
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: simulation.workspaceId,
    );
    WorkspaceService.require(context, Permission.simulationsRun);
    return SimulationService().runToCompletion(
      session,
      simulationId: simulationId,
    );
  }

  /// Cancels a queued or running simulation.
  Future<AttackSimulation> cancel(
    Session session,
    UuidValue simulationId,
  ) async {
    final simulation = await SimulationService().simulation(
      session,
      simulationId: simulationId,
    );
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: simulation.workspaceId,
    );
    WorkspaceService.require(context, Permission.simulationsRun);
    return SimulationService().cancel(
      session,
      simulationId: simulationId,
    );
  }
}
