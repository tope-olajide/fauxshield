import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../core/geo_dataset.dart';
import '../generated/protocol.dart';
// Brings the generated `Serverpod.futureCalls` extension into scope.
import '../generated/serverpod.dart' show ServerpodFutureCallsGetter;
import 'audit_service.dart';
import 'live_events.dart';
import 'verification_service.dart';
import 'workspace_service.dart';

/// Runs scripted attack scenarios through the real pipeline.
///
/// Every simulation step creates genuine verification sessions through the
/// normal [VerificationService], so the fraud engine, alerts, notifications,
/// webhooks, and live events fire exactly as they would for real traffic.
/// Brands rehearse their response without staging production incidents.
///
/// Scenarios:
/// * `cloneAttack` — one authentic code scanned from distant cities until
///   impossible travel plus velocity escalate to fraud suspected.
/// * `pinBruteForce` — wrong PINs until the identity locks out.
/// * `scanBurst` — bot speed scans of one token that trip velocity detection.
/// * `greyMarketLeak` — units repeatedly verified in a restricted market
///   until batch duplication escalates the alert.
///
/// Delayed runs unfold in real time through scheduled future calls; a zero
/// delay executes inline and returns the finished record.
class SimulationService {
  SimulationService({VerificationService? verificationService})
    : _verification = verificationService ?? VerificationService();

  final VerificationService _verification;

  static const List<String> _wrongPins = <String>[
    '000001',
    '123123',
    '999999',
    '000000',
    '111111',
    '222222',
    '777777',
  ];

  /// Creates a simulation and kicks off its first step.
  Future<AttackSimulation> start(
    Session session, {
    required UuidValue workspaceId,
    required SimulationRequest request,
    required String createdBy,
  }) async {
    final workspace = await WorkspaceResolver.resolve(session, workspaceId);
    final batch = await _resolveBatch(
      session,
      workspaceId: workspaceId,
      requested: request.batchId,
    );
    final identities = await _targetIdentities(session, batch);
    if (identities.isEmpty) {
      throw ValidationException(
        message:
            'Generate product identities for batch ${batch.reference} before running a simulation.',
        field: 'batchId',
      );
    }

    final policy = workspace.fraudPolicy ?? FraudPolicy();
    final steps = (request.steps ?? _defaultSteps(request.type, policy)).clamp(
      1,
      FauxShieldLimits.maxSimulationSteps,
    );
    final delay =
        (request.stepDelaySeconds ??
                FauxShieldLimits.defaultSimulationStepSeconds)
            .clamp(0, 60);

    final params = <String, dynamic>{
      'batch_id': batch.id!.uuid,
      'step_delay_seconds': delay,
      'identity_ids': identities
          .map((identity) => identity.id!.uuid)
          .toList(growable: false),
    };
    if (request.type == SimulationType.greyMarketLeak) {
      final restricted = workspace.restrictedCountries;
      if (restricted == null || restricted.isEmpty) {
        throw ValidationException(
          message:
              'Add at least one restricted market to the workspace before running a grey market simulation.',
          field: 'type',
        );
      }
      params['market'] = restricted.first;
    }
    if (request.type == SimulationType.cloneAttack) {
      params['origin'] = demoLocationForIp('102.89.0.1').toJson();
    }

    var simulation = AttackSimulation(
      workspaceId: workspaceId,
      type: request.type,
      status: SimulationStatus.queued,
      label: request.label ?? _defaultLabel(request.type),
      paramsJson: jsonEncode(params),
      totalSteps: steps,
      createdBy: createdBy,
      createdAt: DateTime.now().toUtc(),
    );
    simulation = await AttackSimulation.db.insertRow(session, simulation);

    await AuditService.record(
      session,
      workspaceId: workspaceId,
      action: 'simulation.started',
      targetType: 'attack_simulation',
      targetId: simulation.id,
      actorType: ActorType.user,
      metadata: <String, dynamic>{
        'type': request.type.name,
        'steps': steps,
        'delay_seconds': delay,
        'batch_id': batch.id!.uuid,
      },
    );
    await LiveEvents.publish(
      session,
      workspaceId: workspaceId,
      type: LiveEventType.simulationProgress,
      title: 'Attack simulation queued',
      subtitle: '${simulation.label} — $steps steps',
      severity: AlertSeverity.low,
      batchId: batch.id,
      payload: <String, dynamic>{'simulation_id': simulation.id!.uuid},
    );

    if (delay <= 0) {
      return runToCompletion(session, simulationId: simulation.id!);
    }

    await scheduleNextStep(session, simulation);
    return simulation;
  }

  /// Loads one simulation or throws a typed not-found failure.
  Future<AttackSimulation> simulation(
    Session session, {
    required UuidValue simulationId,
  }) => _require(session, simulationId);

  /// Executes exactly one scenario step and reschedules when more remain.
  Future<AttackSimulation> executeStep(
    Session session, {
    required UuidValue simulationId,
  }) async {
    var simulation = await _require(session, simulationId);
    if (simulation.status != SimulationStatus.queued &&
        simulation.status != SimulationStatus.running) {
      return simulation;
    }
    if (simulation.progress >= simulation.totalSteps) {
      return _complete(session, simulation);
    }

    final params = _decodeParams(simulation);
    final batch = await _batchFromParams(session, params);
    if (batch == null) {
      return _fail(session, simulation, 'The target batch no longer exists.');
    }
    final identities = await _identitiesFromParams(session, params);
    if (identities.isEmpty) {
      return _fail(
        session,
        simulation,
        'The target batch no longer has identities to attack.',
      );
    }

    simulation = await AttackSimulation.db.updateRow(
      session,
      simulation.copyWith(
        status: SimulationStatus.running,
        startedAt: simulation.startedAt ?? DateTime.now().toUtc(),
      ),
    );

    final stepIndex = simulation.progress;
    try {
      switch (simulation.type) {
        case SimulationType.cloneAttack:
          await _cloneAttackStep(
            session,
            simulation: simulation,
            params: params,
            identities: identities,
            stepIndex: stepIndex,
          );
        case SimulationType.pinBruteForce:
          await _pinBruteForceStep(
            session,
            simulation: simulation,
            target: identities.first,
            stepIndex: stepIndex,
          );
        case SimulationType.scanBurst:
          await _scanBurstStep(
            session,
            simulation: simulation,
            params: params,
            target: identities.first,
          );
        case SimulationType.greyMarketLeak:
          await _greyMarketStep(
            session,
            simulation: simulation,
            params: params,
            identities: identities,
            stepIndex: stepIndex,
          );
      }
    } catch (error) {
      return _fail(session, simulation, _describe(error));
    }

    final progress = stepIndex + 1;
    final completed = progress >= simulation.totalSteps;
    final sessionCount = await VerificationSession.db.count(
      session,
      where: (t) => t.simulationId.equals(simulation.id!),
    );
    final now = DateTime.now().toUtc();
    final updated = await AttackSimulation.db.updateRow(
      session,
      simulation.copyWith(
        status: completed
            ? SimulationStatus.completed
            : SimulationStatus.running,
        progress: progress,
        completedAt: completed ? now : null,
        summaryJson: jsonEncode(<String, dynamic>{
          'sessions': sessionCount,
          'progress': progress,
          'total_steps': simulation.totalSteps,
          if (completed) 'completed_at': now.toIso8601String(),
        }),
      ),
    );

    await LiveEvents.publish(
      session,
      workspaceId: simulation.workspaceId,
      type: LiveEventType.simulationProgress,
      title: completed
          ? 'Simulation complete: ${simulation.label}'
          : 'Simulation step $progress of ${simulation.totalSteps}',
      subtitle: simulation.label,
      severity: AlertSeverity.low,
      batchId: batch.id,
      payload: <String, dynamic>{
        'simulation_id': simulation.id!.uuid,
        'progress': progress,
        'total_steps': simulation.totalSteps,
        'sessions': sessionCount,
      },
    );
    return updated;
  }

  /// Runs residual steps inline, used for zero delay demos and tests.
  Future<AttackSimulation> runToCompletion(
    Session session, {
    required UuidValue simulationId,
    int maxSteps = FauxShieldLimits.maxSimulationSteps,
  }) async {
    var simulation = await _require(session, simulationId);
    var executed = 0;
    while ((simulation.status == SimulationStatus.queued ||
            simulation.status == SimulationStatus.running) &&
        executed < maxSteps) {
      simulation = await executeStep(session, simulationId: simulationId);
      executed++;
    }
    return simulation;
  }

  /// Cancels a queued or running simulation.
  Future<AttackSimulation> cancel(
    Session session, {
    required UuidValue simulationId,
  }) async {
    final simulation = await _require(session, simulationId);
    if (simulation.status == SimulationStatus.completed ||
        simulation.status == SimulationStatus.failed ||
        simulation.status == SimulationStatus.cancelled) {
      return simulation;
    }
    final now = DateTime.now().toUtc();
    final updated = await AttackSimulation.db.updateRow(
      session,
      simulation.copyWith(
        status: SimulationStatus.cancelled,
        cancelledAt: now,
        completedAt: now,
      ),
    );
    await AuditService.record(
      session,
      workspaceId: simulation.workspaceId,
      action: 'simulation.cancelled',
      targetType: 'attack_simulation',
      targetId: simulation.id,
      actorType: ActorType.user,
      metadata: <String, dynamic>{'progress': simulation.progress},
    );
    await LiveEvents.publish(
      session,
      workspaceId: simulation.workspaceId,
      type: LiveEventType.simulationProgress,
      title: 'Simulation cancelled',
      subtitle: simulation.label,
      severity: AlertSeverity.low,
      payload: <String, dynamic>{
        'simulation_id': simulation.id!.uuid,
        'progress': simulation.progress,
      },
    );
    return updated;
  }

  // ---------------------------------------------------------------------------
  // Scenario steps
  // ---------------------------------------------------------------------------

  Future<void> _cloneAttackStep(
    Session session, {
    required AttackSimulation simulation,
    required Map<String, dynamic> params,
    required List<ProductIdentity> identities,
    required int stepIndex,
  }) async {
    final origin =
        _geoFromJson(params['origin']) ??
        const GeoResult(country: 'Nigeria', countryCode: 'NG', city: 'Lagos');
    final cities = <GeoResult>[
      origin,
      demoCity('GB', 'London'),
      demoCity('US', 'New York'),
      demoCity('JP', 'Tokyo'),
      demoCity('BR', 'Sao Paulo'),
      demoCity('AE', 'Dubai'),
    ];
    await _scan(
      session,
      simulation: simulation,
      identity: identities.first,
      location: cities[stepIndex % cities.length],
      fingerprint: 'sim-clone-${simulation.id!.uuid}',
    );
  }

  Future<void> _pinBruteForceStep(
    Session session, {
    required AttackSimulation simulation,
    required ProductIdentity target,
    required int stepIndex,
  }) async {
    final fingerprint = 'sim-pin-${simulation.id!.uuid}';
    var verification = await _verification.resolveToken(
      session,
      token: target.qrToken,
      deviceFingerprint: fingerprint,
      source: ScanSource.simulation,
      simulationId: simulation.id,
    );
    if (verification.state == VerificationState.tokenResolved) {
      verification = await _verification.advanceState(
        session,
        sessionId: verification.id!,
        deviceFingerprint: fingerprint,
        targetState: VerificationState.pinPrompted,
      );
    }
    if (verification.state == VerificationState.pinPrompted) {
      verification = await _verification.advanceState(
        session,
        sessionId: verification.id!,
        deviceFingerprint: fingerprint,
        targetState: VerificationState.pinSubmitted,
      );
    }
    if (verification.state == VerificationState.pinSubmitted) {
      try {
        await _verification.submitPin(
          session,
          sessionId: verification.id!,
          deviceFingerprint: fingerprint,
          pin: _wrongPins[stepIndex % _wrongPins.length],
        );
      } on VerificationException catch (error) {
        // Reaching the temporary lockout is the scenario succeeding, not a
        // failure: the remaining steps keep the attack running against a
        // locked unit, which is exactly what a real brute force looks like.
        if (error.reason != VerificationErrorReason.pinLockout) rethrow;
      }
    }
  }

  Future<void> _scanBurstStep(
    Session session, {
    required AttackSimulation simulation,
    required Map<String, dynamic> params,
    required ProductIdentity target,
  }) async {
    final origin =
        _geoFromJson(params['origin']) ??
        const GeoResult(country: 'Nigeria', countryCode: 'NG', city: 'Lagos');
    await _scan(
      session,
      simulation: simulation,
      identity: target,
      location: origin,
      fingerprint: 'sim-burst-${simulation.id!.uuid}',
    );
  }

  Future<void> _greyMarketStep(
    Session session, {
    required AttackSimulation simulation,
    required Map<String, dynamic> params,
    required List<ProductIdentity> identities,
    required int stepIndex,
  }) async {
    final location = _cityForMarket(params['market'] as String?);
    final target = identities[stepIndex % identities.length];
    await _scan(
      session,
      simulation: simulation,
      identity: target,
      location: location,
      fingerprint: 'sim-grey-${simulation.id!.uuid}-${target.id!.uuid}',
    );
  }

  /// Creates one simulation scan and finalizes it without a consumer PIN.
  Future<void> _scan(
    Session session, {
    required AttackSimulation simulation,
    required ProductIdentity identity,
    required GeoResult location,
    required String fingerprint,
  }) async {
    final verification = await _verification.resolveToken(
      session,
      token: identity.qrToken,
      deviceFingerprint: fingerprint,
      source: ScanSource.simulation,
      locationOverride: location,
      simulationId: simulation.id,
    );
    if (verification.state != VerificationState.resultDetermined) {
      await _verification.finalizeInspectorScan(
        session,
        sessionId: verification.id!,
        deviceFingerprint: fingerprint,
      );
    }
  }

  /// Schedules the next step of [simulation] through the future call queue.
  static Future<void> scheduleNextStep(
    Session session,
    AttackSimulation simulation,
  ) async {
    final delay = stepDelaySeconds(simulation);
    await session.serverpod.futureCalls
        .callWithDelay(Duration(seconds: delay <= 0 ? 1 : delay))
        .simulationRunner
        .step(
          SimulationStepRequest(
            simulationId: simulation.id!,
            delaySeconds: delay,
          ),
        );
  }

  /// The configured seconds between scheduled steps for [simulation].
  static int stepDelaySeconds(AttackSimulation simulation) {
    final delay = _decodeParams(simulation)['step_delay_seconds'];
    if (delay is int) return delay.clamp(0, 60);
    return FauxShieldLimits.defaultSimulationStepSeconds;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<AttackSimulation> _require(
    Session session,
    UuidValue simulationId,
  ) async {
    final simulation = await AttackSimulation.db.findById(
      session,
      simulationId,
    );
    if (simulation == null) {
      throw NotFoundException(
        message: 'Simulation not found.',
        resource: 'attack_simulation',
      );
    }
    return simulation;
  }

  Future<AttackSimulation> _complete(
    Session session,
    AttackSimulation simulation,
  ) async {
    final sessionCount = await VerificationSession.db.count(
      session,
      where: (t) => t.simulationId.equals(simulation.id!),
    );
    final now = DateTime.now().toUtc();
    return AttackSimulation.db.updateRow(
      session,
      simulation.copyWith(
        status: SimulationStatus.completed,
        completedAt: now,
        summaryJson: jsonEncode(<String, dynamic>{
          'sessions': sessionCount,
          'progress': simulation.progress,
          'total_steps': simulation.totalSteps,
          'completed_at': now.toIso8601String(),
        }),
      ),
    );
  }

  Future<AttackSimulation> _fail(
    Session session,
    AttackSimulation simulation,
    String message,
  ) async {
    final now = DateTime.now().toUtc();
    final updated = await AttackSimulation.db.updateRow(
      session,
      simulation.copyWith(
        status: SimulationStatus.failed,
        completedAt: now,
        summaryJson: jsonEncode(<String, dynamic>{
          'error': message,
          'progress': simulation.progress,
        }),
      ),
    );
    await AuditService.record(
      session,
      workspaceId: simulation.workspaceId,
      action: 'simulation.failed',
      targetType: 'attack_simulation',
      targetId: simulation.id,
      actorType: ActorType.system,
      metadata: <String, dynamic>{'error': message},
    );
    await LiveEvents.publish(
      session,
      workspaceId: simulation.workspaceId,
      type: LiveEventType.simulationProgress,
      title: 'Simulation failed',
      subtitle: message,
      severity: AlertSeverity.high,
      payload: <String, dynamic>{'simulation_id': simulation.id!.uuid},
    );
    return updated;
  }

  Future<Batch> _resolveBatch(
    Session session, {
    required UuidValue workspaceId,
    UuidValue? requested,
  }) async {
    if (requested != null) {
      final batch = await Batch.db.findById(session, requested);
      if (batch == null || batch.workspaceId != workspaceId) {
        throw NotFoundException(message: 'Batch not found.', resource: 'batch');
      }
      return batch;
    }
    final batch = await Batch.db.findFirstRow(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
      orderBy: (t) => t.createdAt.desc(),
    );
    if (batch == null) {
      throw ValidationException(
        message: 'Create a batch before running an attack simulation.',
        field: 'batchId',
      );
    }
    return batch;
  }

  Future<List<ProductIdentity>> _targetIdentities(
    Session session,
    Batch batch,
  ) {
    return ProductIdentity.db.find(
      session,
      where: (t) => t.batchId.equals(batch.id!) & t.deletedAt.equals(null),
      orderBy: (t) => t.createdAt,
      limit: 10,
    );
  }

  Future<Batch?> _batchFromParams(
    Session session,
    Map<String, dynamic> params,
  ) async {
    final raw = params['batch_id'];
    if (raw is! String) return null;
    try {
      return await Batch.db.findById(session, UuidValue.fromString(raw));
    } catch (_) {
      return null;
    }
  }

  Future<List<ProductIdentity>> _identitiesFromParams(
    Session session,
    Map<String, dynamic> params,
  ) {
    final ids = _uuidList(params['identity_ids']);
    if (ids.isEmpty) {
      return Future<List<ProductIdentity>>.value(<ProductIdentity>[]);
    }
    return ProductIdentity.db.find(
      session,
      where: (t) => t.id.inSet(ids.toSet()) & t.deletedAt.equals(null),
      orderBy: (t) => t.createdAt,
      limit: 10,
    );
  }

  static Map<String, dynamic> _decodeParams(AttackSimulation simulation) {
    final raw = simulation.paramsJson;
    if (raw == null || raw.isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  static List<UuidValue> _uuidList(Object? value) {
    if (value is! List) return const <UuidValue>[];
    final ids = <UuidValue>[];
    for (final entry in value) {
      if (entry is! String) continue;
      try {
        ids.add(UuidValue.fromString(entry));
      } catch (_) {
        // Ignore malformed ids; the simulation skips them.
      }
    }
    return ids;
  }

  static GeoResult? _geoFromJson(Object? value) {
    if (value is! Map) return null;
    final country = value['country'];
    if (country is! String) return null;
    return GeoResult(
      country: country,
      countryCode: (value['countryCode'] as String?) ?? '',
      city: (value['city'] as String?) ?? 'Unknown',
      latitude: (value['latitude'] as num?)?.toDouble(),
      longitude: (value['longitude'] as num?)?.toDouble(),
    );
  }

  /// Maps a restricted market (country name or ISO code) to a demo city.
  static GeoResult _cityForMarket(String? market) {
    final trimmed = market?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return const GeoResult(
        country: 'Unknown',
        countryCode: '',
        city: 'Unknown',
      );
    }
    final normalized = trimmed.toUpperCase();
    for (final city in demoCities) {
      if (city.countryCode.toUpperCase() == normalized ||
          city.country.toUpperCase() == normalized) {
        return city;
      }
    }
    return GeoResult(country: trimmed, countryCode: '', city: 'Unknown');
  }

  static int _defaultSteps(SimulationType type, FraudPolicy policy) {
    switch (type) {
      case SimulationType.cloneAttack:
        return policy.velocityThreshold + 2;
      case SimulationType.pinBruteForce:
        // Run past the platform lockout so the rehearsal exercises it.
        return FauxShieldLimits.pinLockoutThreshold + 1;
      case SimulationType.scanBurst:
        return policy.velocityThreshold + 2;
      case SimulationType.greyMarketLeak:
        return policy.batchDuplicationThreshold * 3 + 1;
    }
  }

  static String _defaultLabel(SimulationType type) {
    switch (type) {
      case SimulationType.cloneAttack:
        return 'Clone attack rehearsal';
      case SimulationType.pinBruteForce:
        return 'PIN brute force rehearsal';
      case SimulationType.scanBurst:
        return 'Scan burst rehearsal';
      case SimulationType.greyMarketLeak:
        return 'Grey market leak rehearsal';
    }
  }

  static String _describe(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
