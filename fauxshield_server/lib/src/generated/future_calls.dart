/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: depend_on_referenced_packages

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:clock/clock.dart' as _io0w16m8;
import 'package:fauxshield_server/src/generated/simulation/simulation_step_request.dart'
    as _i53ecdb0;
import 'package:serverpod/serverpod.dart' as _is;
import '../future_calls/daily_rollup.dart' as _ii66il9a;
import '../future_calls/maintenance_sweep.dart' as _iv11og8a;
import '../future_calls/offline_scan_converter.dart' as _i9vr1a04;
import '../future_calls/simulation_runner.dart' as _istgskll;
import '../future_calls/webhook_drain.dart' as _ixsxi933;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _is.SerializableModel? object);

extension ServerpodFutureCallsGetter on _is.Serverpod {
  /// Generated future calls.
  FutureCalls get futureCalls => FutureCalls();
}

class FutureCalls extends _is.FutureCallDispatch<_FutureCallRef> {
  FutureCalls._();

  factory FutureCalls() {
    return _instance;
  }

  static final FutureCalls _instance = FutureCalls._();

  _is.FutureCallManager? _futureCallManager;

  String? _serverId;

  String get _effectiveServerId {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _serverId!;
  }

  _is.FutureCallManager get _effectiveFutureCallManager {
    if (_futureCallManager == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _futureCallManager!;
  }

  @override
  void initialize(
    _is.FutureCallManager futureCallManager,
    String serverId,
  ) {
    var registeredFutureCalls = <String, _is.InvokableFutureCall>{
      'DailyRollupRollupFutureCall': DailyRollupRollupFutureCall(),
      'MaintenanceSweepSweepFutureCall': MaintenanceSweepSweepFutureCall(),
      'OfflineScanConverterConvertFutureCall':
          OfflineScanConverterConvertFutureCall(),
      'SimulationRunnerStepFutureCall': SimulationRunnerStepFutureCall(),
      'WebhookDrainDrainFutureCall': WebhookDrainDrainFutureCall(),
    };
    _futureCallManager = futureCallManager;
    _serverId = serverId;
    for (final entry in registeredFutureCalls.entries) {
      _futureCallManager?.registerFutureCall(entry.value, entry.key);
    }
  }

  @override
  _FutureCallRef callAtTime(
    DateTime time, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          time,
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  _FutureCallRef callWithDelay(
    Duration delay, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          DateTime.now().toUtc().add(delay),
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  _is.RecurringFutureCallDispatch<_FutureCallRef> callRecurring({
    String? identifier,
  }) {
    return _RecurringFutureCallDispatchImpl(
      _effectiveFutureCallManager,
      _effectiveServerId,
      identifier,
    );
  }

  @override
  Future<void> cancel(String identifier) async {
    await _effectiveFutureCallManager.cancelFutureCall(identifier);
  }
}

class _RecurringFutureCallDispatchImpl
    extends _is.RecurringFutureCallDispatch<_FutureCallRef> {
  _RecurringFutureCallDispatchImpl(
    this._futureCallManager,
    this._serverId,
    this._identifier,
  );

  final _is.FutureCallManager _futureCallManager;

  final String _serverId;

  final String? _identifier;

  @override
  _FutureCallRef cron(String cronExpression) {
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          _is.Cron.parse(cronExpression).nextTime(),
          _serverId,
          _identifier,
          scheduling: _is.CronFutureCallScheduling(cron: cronExpression),
        );
      },
    );
  }

  @override
  _FutureCallRef every(
    Duration interval, {
    DateTime? start,
  }) {
    final now = _io0w16m8.clock.now().toUtc();
    return _FutureCallRef(
      (name, object) {
        return _futureCallManager.scheduleFutureCall(
          name,
          object,
          start ?? now.add(interval),
          _serverId,
          _identifier,
          scheduling: _is.IntervalFutureCallScheduling(
            interval: interval,
            start: start,
          ),
        );
      },
    );
  }
}

class _FutureCallRef {
  _FutureCallRef(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  late final dailyRollup = _DailyRollupFutureCallDispatcher(_invokeFutureCall);

  late final maintenanceSweep = _MaintenanceSweepFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final offlineScanConverter = _OfflineScanConverterFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final simulationRunner = _SimulationRunnerFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final webhookDrain = _WebhookDrainFutureCallDispatcher(
    _invokeFutureCall,
  );
}

class _DailyRollupFutureCallDispatcher {
  _DailyRollupFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> rollup() {
    return _invokeFutureCall(
      'DailyRollupRollupFutureCall',
      null,
    );
  }
}

class _MaintenanceSweepFutureCallDispatcher {
  _MaintenanceSweepFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> sweep() {
    return _invokeFutureCall(
      'MaintenanceSweepSweepFutureCall',
      null,
    );
  }
}

class _OfflineScanConverterFutureCallDispatcher {
  _OfflineScanConverterFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> convert() {
    return _invokeFutureCall(
      'OfflineScanConverterConvertFutureCall',
      null,
    );
  }
}

class _SimulationRunnerFutureCallDispatcher {
  _SimulationRunnerFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> step(_i53ecdb0.SimulationStepRequest request) {
    return _invokeFutureCall(
      'SimulationRunnerStepFutureCall',
      request,
    );
  }
}

class _WebhookDrainFutureCallDispatcher {
  _WebhookDrainFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> drain() {
    return _invokeFutureCall(
      'WebhookDrainDrainFutureCall',
      null,
    );
  }
}

class DailyRollupRollupFutureCall extends _is.FutureCall
    implements _is.InvokableFutureCall {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _is.SerializableModel? object,
  ) async {
    await _ii66il9a.DailyRollup().rollup(session);
  }
}

class MaintenanceSweepSweepFutureCall extends _is.FutureCall
    implements _is.InvokableFutureCall {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _is.SerializableModel? object,
  ) async {
    await _iv11og8a.MaintenanceSweep().sweep(session);
  }
}

class OfflineScanConverterConvertFutureCall extends _is.FutureCall
    implements _is.InvokableFutureCall {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _is.SerializableModel? object,
  ) async {
    await _i9vr1a04.OfflineScanConverter().convert(session);
  }
}

class SimulationRunnerStepFutureCall
    extends _is.FutureCall<_i53ecdb0.SimulationStepRequest>
    implements _is.InvokableFutureCall<_i53ecdb0.SimulationStepRequest> {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _i53ecdb0.SimulationStepRequest? request,
  ) async {
    await _istgskll.SimulationRunner().step(
      session,
      request!,
    );
  }
}

class WebhookDrainDrainFutureCall extends _is.FutureCall
    implements _is.InvokableFutureCall {
  @override
  _ida.Future<void> invoke(
    _is.Session session,
    _is.SerializableModel? object,
  ) async {
    await _ixsxi933.WebhookDrain().drain(session);
  }
}
