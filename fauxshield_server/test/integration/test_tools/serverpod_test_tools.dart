/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: no_leading_underscores_for_local_identifiers

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'dart:io' as _idi;
import 'package:fauxshield_server/src/generated/analytics/alert_evidence.dart'
    as _i1kwsoov;
import 'package:fauxshield_server/src/generated/analytics/daily_workspace_stat.dart'
    as _irma5h6x;
import 'package:fauxshield_server/src/generated/analytics/dashboard_summary.dart'
    as _iq89wsqa;
import 'package:fauxshield_server/src/generated/audit/audit_event.dart'
    as _ilhfgg14;
import 'package:fauxshield_server/src/generated/consumer/fake_report.dart'
    as _ici1p2vw;
import 'package:fauxshield_server/src/generated/consumer/report_acknowledgement.dart'
    as _iyw0v2xe;
import 'package:fauxshield_server/src/generated/consumer/verification_presentation.dart'
    as _igsfoz32;
import 'package:fauxshield_server/src/generated/core/batch.dart' as _iup4iqu5;
import 'package:fauxshield_server/src/generated/core/batch_stats.dart'
    as _ifyzxhpy;
import 'package:fauxshield_server/src/generated/core/branding.dart'
    as _i7nf0hkx;
import 'package:fauxshield_server/src/generated/core/export_file.dart'
    as _i6jedab1;
import 'package:fauxshield_server/src/generated/core/fraud_policy.dart'
    as _il8b5wgn;
import 'package:fauxshield_server/src/generated/core/identity_generation_result.dart'
    as _i1yy58yr;
import 'package:fauxshield_server/src/generated/core/invitation.dart'
    as _i78uhtt9;
import 'package:fauxshield_server/src/generated/core/invitation_created.dart'
    as _ies6uk5i;
import 'package:fauxshield_server/src/generated/core/product.dart' as _ian4oqo2;
import 'package:fauxshield_server/src/generated/core/product_identity.dart'
    as _i2mg5i1l;
import 'package:fauxshield_server/src/generated/core/revealed_pin.dart'
    as _iclla0py;
import 'package:fauxshield_server/src/generated/core/workspace.dart'
    as _ixso1rkf;
import 'package:fauxshield_server/src/generated/core/workspace_bootstrap.dart'
    as _ivrxepu5;
import 'package:fauxshield_server/src/generated/core/workspace_member.dart'
    as _iqeq6200;
import 'package:fauxshield_server/src/generated/developer/api_key.dart'
    as _ig1utrz2;
import 'package:fauxshield_server/src/generated/developer/api_key_secret.dart'
    as _i17ag8u2;
import 'package:fauxshield_server/src/generated/enums/alert_severity.dart'
    as _ih3495d6;
import 'package:fauxshield_server/src/generated/enums/alert_status.dart'
    as _idwavwcs;
import 'package:fauxshield_server/src/generated/enums/api_scope.dart'
    as _ilmzvpi4;
import 'package:fauxshield_server/src/generated/enums/batch_status.dart'
    as _ioi4hopc;
import 'package:fauxshield_server/src/generated/enums/export_format.dart'
    as _isyhmzih;
import 'package:fauxshield_server/src/generated/enums/fake_report_status.dart'
    as _iqbe6yeb;
import 'package:fauxshield_server/src/generated/enums/identity_status.dart'
    as _iqt4cy7v;
import 'package:fauxshield_server/src/generated/enums/membership_role.dart'
    as _i5ttnrmb;
import 'package:fauxshield_server/src/generated/enums/notification_channel.dart'
    as _iuzng6z9;
import 'package:fauxshield_server/src/generated/enums/risk_score.dart'
    as _ijv8khy1;
import 'package:fauxshield_server/src/generated/enums/scan_source.dart'
    as _iccccaf9;
import 'package:fauxshield_server/src/generated/enums/signal_type.dart'
    as _iq844xv7;
import 'package:fauxshield_server/src/generated/enums/verification_outcome.dart'
    as _i0trd2wt;
import 'package:fauxshield_server/src/generated/enums/verification_state.dart'
    as _iewd06xu;
import 'package:fauxshield_server/src/generated/enums/webhook_event_type.dart'
    as _i9gqphv7;
import 'package:fauxshield_server/src/generated/future_calls.dart' as _i4legp06;
import 'package:fauxshield_server/src/generated/live/live_event.dart'
    as _i40xv4t1;
import 'package:fauxshield_server/src/generated/notifications/notification.dart'
    as _i1dqkmtk;
import 'package:fauxshield_server/src/generated/notifications/notification_preference.dart'
    as _iz5xn7se;
import 'package:fauxshield_server/src/generated/offline/offline_scan_input.dart'
    as _iilz41bh;
import 'package:fauxshield_server/src/generated/offline/offline_scan_record.dart'
    as _irnk4ro1;
import 'package:fauxshield_server/src/generated/offline/offline_scan_verdict.dart'
    as _isqommwe;
import 'package:fauxshield_server/src/generated/recall/recall_record.dart'
    as _i8526if6;
import 'package:fauxshield_server/src/generated/recall/recall_result.dart'
    as _i8h2toku;
import 'package:fauxshield_server/src/generated/simulation/attack_simulation.dart'
    as _i0v2zdo1;
import 'package:fauxshield_server/src/generated/simulation/simulation_request.dart'
    as _ipsf1cgw;
import 'package:fauxshield_server/src/generated/simulation/simulation_step_request.dart'
    as _i53ecdb0;
import 'package:fauxshield_server/src/generated/verification/fraud_alert.dart'
    as _i81fjb7d;
import 'package:fauxshield_server/src/generated/verification/fraud_signal_record.dart'
    as _ifjnoxq3;
import 'package:fauxshield_server/src/generated/verification/verification_session.dart'
    as _ism3h20n;
import 'package:fauxshield_server/src/generated/webhooks/webhook_delivery.dart'
    as _ibuewkxx;
import 'package:fauxshield_server/src/generated/webhooks/webhook_endpoint.dart'
    as _if44bvj4;
import 'package:fauxshield_server/src/generated/webhooks/webhook_endpoint_secret.dart'
    as _ihdwgycq;
import 'package:fauxshield_server/src/generated/webhooks/webhook_test_result.dart'
    as _ith836p0;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_test/serverpod_test.dart' as _ist;
import 'package:fauxshield_server/src/generated/protocol.dart';
import 'package:fauxshield_server/src/generated/endpoints.dart';
export 'package:serverpod_test/serverpod_test_public_exports.dart';

/// Creates a new test group that takes a callback that can be used to write tests.
/// The callback has two parameters: `sessionBuilder` and `endpoints`.
/// `sessionBuilder` is used to build a `Session` object that represents the server state during an endpoint call and is used to set up scenarios.
/// `endpoints` contains all your Serverpod endpoints and lets you call them:
/// ```dart
/// withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
///   test('when calling `hello` then should return greeting', () async {
///     final greeting = await endpoints.example.hello(sessionBuilder, 'Michael');
///     expect(greeting, 'Hello Michael');
///   });
/// });
/// ```
///
/// **Configuration options**
///
/// [applyMigrations] Whether pending migrations should be applied when starting Serverpod. Defaults to `true`
///
/// [enableSessionLogging] Whether session logging should be enabled. Defaults to `false`
///
/// [ephemeralDatabase] Whether this group gets its own empty database, created when the group starts and dropped when it finishes. Defaults to `true`.
/// Set this to `false` to use the database configured for [runMode], including a previously seeded database. [configOverride] can still replace that database. The configured database is not created or dropped, so groups that share it cannot run in parallel. [rollbackDatabase] still controls whether writes inside the group are rolled back.
///
/// [rollbackDatabase] Options for when to rollback the database during the test lifecycle.
/// By default `withServerpod` does all database operations inside a transaction that is rolled back after each `test` case.
/// Just like the following enum describes, the behavior of the automatic rollbacks can be configured:
/// ```dart
/// /// Options for when to rollback the database during the test lifecycle.
/// enum RollbackDatabase {
///   /// After each test. This is the default.
///   afterEach,
///
///   /// After all tests.
///   afterAll,
///
///   /// Disable rolling back the database.
///   disabled,
/// }
/// ```
///
/// [runMode] The run mode that Serverpod should be running in. Defaults to `test`.
///
/// [serverpodLoggingMode] The logging mode used when creating Serverpod. Defaults to `ServerpodLoggingMode.normal`
///
/// [serverpodStartTimeout] The timeout to use when starting Serverpod, which connects to the database among other things. Defaults to `Duration(seconds: 120)`.
///
/// [testServerOutputMode] Options for controlling test server output during test execution. Defaults to `TestServerOutputMode.normal`.
/// ```dart
/// /// Options for controlling test server output during test execution.
/// enum TestServerOutputMode {
///   /// Default mode - only stderr is printed (stdout suppressed).
///   /// This hides normal startup/shutdown logs while preserving error messages.
///   normal,
///
///   /// All logging - both stdout and stderr are printed.
///   /// Useful for debugging when you need to see all server output.
///   verbose,
///
///   /// No logging - both stdout and stderr are suppressed.
///   /// Completely silent mode, useful when you don't want any server output.
///   silent,
/// }
/// ```
///
/// [configOverride] A function to override the server configuration. This function is called with
/// the default server configuration after it is loaded from the config/ directory
/// and before it is used to start the server. Use this to override particular
/// settings in the server configuration.
///
/// [databaseInterceptor] Optional interceptor that replaces the default database for each session.
/// See [Serverpod.databaseInterceptor] for more information.
///
/// [testGroupTagsOverride] By default Serverpod test tools tags the `withServerpod` test group with `"integration"`.
/// This is to provide a simple way to only run unit or integration tests.
/// This property allows this tag to be overridden to something else. Defaults to `['integration']`.
///
/// [experimentalFeatures] Optionally specify experimental features. See [Serverpod] for more information.
///
/// [serverDirectory] The server package directory `config/<runMode>.yaml`, `config/passwords.yaml`,
/// and `migrations/<module>/...` are resolved against. Defaults to
/// [Directory.current] at the time the test boots. Pass this when the test
/// isolate's cwd is not the server package root (e.g. running tests from a
/// workspace parent directory) so config and migrations are still loaded
/// from the right place.
@_ist.isTestGroup
void withServerpod(
  String testGroupName,
  _ist.TestClosure<TestEndpoints> testClosure, {
  bool? applyMigrations,
  _is.ServerpodConfig Function(_is.ServerpodConfig)? configOverride,
  _is.DatabaseInterceptor? databaseInterceptor,
  bool? enableSessionLogging,
  bool? ephemeralDatabase,
  _is.ExperimentalFeatures? experimentalFeatures,
  _ist.RollbackDatabase? rollbackDatabase,
  String? runMode,
  _is.RuntimeParametersListBuilder? runtimeParametersBuilder,
  _idi.Directory? serverDirectory,
  _is.ServerpodLoggingMode? serverpodLoggingMode,
  Duration? serverpodStartTimeout,
  List<String>? testGroupTagsOverride,
  _ist.TestServerOutputMode? testServerOutputMode,
}) {
  _ist.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    _ist.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: applyMigrations,
      ephemeralDatabase: ephemeralDatabase,
      isDatabaseEnabled: true,
      serverpodLoggingMode: serverpodLoggingMode,
      testServerOutputMode: testServerOutputMode,
      serverDirectory: serverDirectory,
      experimentalFeatures: experimentalFeatures,
      configOverride: configOverride,
      runtimeParametersBuilder: runtimeParametersBuilder,
      databaseInterceptor: databaseInterceptor,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
    maybeTestServerOutputMode: testServerOutputMode,
  )(testClosure);
}

class TestEndpoints {
  late final futureCalls = _FutureCalls();

  late final _EmailIdpEndpoint emailIdp;

  late final _JwtRefreshEndpoint jwtRefresh;

  late final _AlertEndpoint alert;

  late final _AnalyticsEndpoint analytics;

  late final _ApiKeyEndpoint apiKey;

  late final _AuditEndpoint audit;

  late final _BatchEndpoint batch;

  late final _DemoEndpoint demo;

  late final _IdentityEndpoint identity;

  late final _NotificationEndpoint notification;

  late final _OfflineEndpoint offline;

  late final _ProductEndpoint product;

  late final _RecallEndpoint recall;

  late final _SimulationEndpoint simulation;

  late final _VerificationEndpoint verification;

  late final _WebhookAdminEndpoint webhookAdmin;

  late final _WorkspaceEndpoint workspace;
}

class _InternalTestEndpoints extends TestEndpoints
    implements _ist.InternalTestEndpoints {
  @override
  void initialize(
    _is.SerializationManager serializationManager,
    _is.EndpointDispatch endpoints,
  ) {
    emailIdp = _EmailIdpEndpoint(
      endpoints,
      serializationManager,
    );
    jwtRefresh = _JwtRefreshEndpoint(
      endpoints,
      serializationManager,
    );
    alert = _AlertEndpoint(
      endpoints,
      serializationManager,
    );
    analytics = _AnalyticsEndpoint(
      endpoints,
      serializationManager,
    );
    apiKey = _ApiKeyEndpoint(
      endpoints,
      serializationManager,
    );
    audit = _AuditEndpoint(
      endpoints,
      serializationManager,
    );
    batch = _BatchEndpoint(
      endpoints,
      serializationManager,
    );
    demo = _DemoEndpoint(
      endpoints,
      serializationManager,
    );
    identity = _IdentityEndpoint(
      endpoints,
      serializationManager,
    );
    notification = _NotificationEndpoint(
      endpoints,
      serializationManager,
    );
    offline = _OfflineEndpoint(
      endpoints,
      serializationManager,
    );
    product = _ProductEndpoint(
      endpoints,
      serializationManager,
    );
    recall = _RecallEndpoint(
      endpoints,
      serializationManager,
    );
    simulation = _SimulationEndpoint(
      endpoints,
      serializationManager,
    );
    verification = _VerificationEndpoint(
      endpoints,
      serializationManager,
    );
    webhookAdmin = _WebhookAdminEndpoint(
      endpoints,
      serializationManager,
    );
    workspace = _WorkspaceEndpoint(
      endpoints,
      serializationManager,
    );
  }
}

class _FutureCalls {
  late final dailyRollup = _DailyRollupFutureCall();

  late final maintenanceSweep = _MaintenanceSweepFutureCall();

  late final offlineScanConverter = _OfflineScanConverterFutureCall();

  late final simulationRunner = _SimulationRunnerFutureCall();

  late final webhookDrain = _WebhookDrainFutureCall();
}

class _EmailIdpEndpoint {
  _EmailIdpEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_iacs.AuthSuccess> login(
    _ist.TestSessionBuilder sessionBuilder, {
    required String email,
    required String password,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'login',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'login',
          parameters: _ist.testObjectToJson({
            'email': email,
            'password': password,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iacs.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_is.UuidValue> startRegistration(
    _ist.TestSessionBuilder sessionBuilder, {
    required String email,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'startRegistration',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'startRegistration',
          parameters: _ist.testObjectToJson({'email': email}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_is.UuidValue>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> verifyRegistrationCode(
    _ist.TestSessionBuilder sessionBuilder, {
    required _is.UuidValue accountRequestId,
    required String verificationCode,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'verifyRegistrationCode',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'verifyRegistrationCode',
          parameters: _ist.testObjectToJson({
            'accountRequestId': accountRequestId,
            'verificationCode': verificationCode,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iacs.AuthSuccess> finishRegistration(
    _ist.TestSessionBuilder sessionBuilder, {
    required String registrationToken,
    required String password,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'finishRegistration',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'finishRegistration',
          parameters: _ist.testObjectToJson({
            'registrationToken': registrationToken,
            'password': password,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iacs.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_is.UuidValue> startPasswordReset(
    _ist.TestSessionBuilder sessionBuilder, {
    required String email,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'startPasswordReset',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'startPasswordReset',
          parameters: _ist.testObjectToJson({'email': email}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_is.UuidValue>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> verifyPasswordResetCode(
    _ist.TestSessionBuilder sessionBuilder, {
    required _is.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'verifyPasswordResetCode',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'verifyPasswordResetCode',
          parameters: _ist.testObjectToJson({
            'passwordResetRequestId': passwordResetRequestId,
            'verificationCode': verificationCode,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> finishPasswordReset(
    _ist.TestSessionBuilder sessionBuilder, {
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'finishPasswordReset',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'finishPasswordReset',
          parameters: _ist.testObjectToJson({
            'finishPasswordResetToken': finishPasswordResetToken,
            'newPassword': newPassword,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> hasAccount(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'emailIdp',
            method: 'hasAccount',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'emailIdp',
          methodName: 'hasAccount',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _JwtRefreshEndpoint {
  _JwtRefreshEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_iacs.AuthSuccess> refreshAccessToken(
    _ist.TestSessionBuilder sessionBuilder, {
    String? refreshToken,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'jwtRefresh',
            method: 'refreshAccessToken',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'jwtRefresh',
          methodName: 'refreshAccessToken',
          parameters: _ist.testObjectToJson({'refreshToken': refreshToken}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iacs.AuthSuccess>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _AlertEndpoint {
  _AlertEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_i81fjb7d.FraudAlert>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    _idwavwcs.AlertStatus? status,
    _ih3495d6.AlertSeverity? severity,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'alert',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'alert',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'status': status,
            'severity': severity,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i81fjb7d.FraudAlert>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i81fjb7d.FraudAlert> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue alertId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'alert',
            method: 'get',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'alert',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'alertId': alertId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i81fjb7d.FraudAlert>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i1kwsoov.AlertEvidence> evidence(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue alertId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'alert',
            method: 'evidence',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'alert',
          methodName: 'evidence',
          parameters: _ist.testObjectToJson({'alertId': alertId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i1kwsoov.AlertEvidence>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i81fjb7d.FraudAlert> updateStatus(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue alertId,
    required _idwavwcs.AlertStatus status,
    String? note,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'alert',
            method: 'updateStatus',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'alert',
          methodName: 'updateStatus',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'alertId': alertId,
            'status': status,
            'note': note,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i81fjb7d.FraudAlert>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i81fjb7d.FraudAlert> assign(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue alertId,
    String? assignee,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'alert',
            method: 'assign',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'alert',
          methodName: 'assign',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'alertId': alertId,
            'assignee': assignee,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i81fjb7d.FraudAlert>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_ifjnoxq3.FraudSignalRecord>> signals(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    _is.UuidValue? batchId,
    _iq844xv7.SignalType? type,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'alert',
            method: 'signals',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'alert',
          methodName: 'signals',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'batchId': batchId,
            'type': type,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ifjnoxq3.FraudSignalRecord>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_ici1p2vw.FakeReport>> reports(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    _iqbe6yeb.FakeReportStatus? status,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'alert',
            method: 'reports',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'alert',
          methodName: 'reports',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'status': status,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ici1p2vw.FakeReport>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ici1p2vw.FakeReport> triageReport(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue reportId,
    required _iqbe6yeb.FakeReportStatus status,
    String? note,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'alert',
            method: 'triageReport',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'alert',
          methodName: 'triageReport',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'reportId': reportId,
            'status': status,
            'note': note,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ici1p2vw.FakeReport>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _AnalyticsEndpoint {
  _AnalyticsEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_iq89wsqa.DashboardSummary> dashboard(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required int windowDays,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'analytics',
            method: 'dashboard',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'analytics',
          methodName: 'dashboard',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'windowDays': windowDays,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iq89wsqa.DashboardSummary>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_irma5h6x.DailyWorkspaceStat> rollupNow(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    DateTime? day,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'analytics',
            method: 'rollupNow',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'analytics',
          methodName: 'rollupNow',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'day': day,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_irma5h6x.DailyWorkspaceStat>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ApiKeyEndpoint {
  _ApiKeyEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_ig1utrz2.ApiKey>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'apiKey',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'apiKey',
          methodName: 'list',
          parameters: _ist.testObjectToJson({'workspaceId': workspaceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ig1utrz2.ApiKey>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i17ag8u2.ApiKeySecret> create(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required String label,
    required List<_ilmzvpi4.ApiScope> scopes,
    required int rateLimitPerMinute,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'apiKey',
            method: 'create',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'apiKey',
          methodName: 'create',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'label': label,
            'scopes': scopes,
            'rateLimitPerMinute': rateLimitPerMinute,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i17ag8u2.ApiKeySecret>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ig1utrz2.ApiKey> revoke(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue apiKeyId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'apiKey',
            method: 'revoke',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'apiKey',
          methodName: 'revoke',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'apiKeyId': apiKeyId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ig1utrz2.ApiKey>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _AuditEndpoint {
  _AuditEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_ilhfgg14.AuditEvent>> query(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    String? action,
    String? actorIdentifier,
    String? targetType,
    _is.UuidValue? targetId,
    DateTime? from,
    DateTime? to,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'audit',
            method: 'query',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'audit',
          methodName: 'query',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'action': action,
            'actorIdentifier': actorIdentifier,
            'targetType': targetType,
            'targetId': targetId,
            'from': from,
            'to': to,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ilhfgg14.AuditEvent>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _BatchEndpoint {
  _BatchEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_iup4iqu5.Batch>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    _is.UuidValue? productId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'batch',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'batch',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'productId': productId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iup4iqu5.Batch>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iup4iqu5.Batch> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue batchId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'batch',
            method: 'get',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'batch',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'batchId': batchId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iup4iqu5.Batch>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iup4iqu5.Batch> create(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue productId,
    required String reference,
    required DateTime manufactureDate,
    DateTime? expiryDate,
    required String distributionRegion,
    required int quantity,
    String? notes,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'batch',
            method: 'create',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'batch',
          methodName: 'create',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'productId': productId,
            'reference': reference,
            'manufactureDate': manufactureDate,
            'expiryDate': expiryDate,
            'distributionRegion': distributionRegion,
            'quantity': quantity,
            'notes': notes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iup4iqu5.Batch>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iup4iqu5.Batch> update(
    _ist.TestSessionBuilder sessionBuilder, {
    required _is.UuidValue batchId,
    String? reference,
    DateTime? expiryDate,
    String? distributionRegion,
    int? quantity,
    String? notes,
    _ioi4hopc.BatchStatus? status,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'batch',
            method: 'update',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'batch',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'batchId': batchId,
            'reference': reference,
            'expiryDate': expiryDate,
            'distributionRegion': distributionRegion,
            'quantity': quantity,
            'notes': notes,
            'status': status,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iup4iqu5.Batch>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i1yy58yr.IdentityGenerationResult> generateIdentities(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue batchId,
    required int quantity,
    required String idempotencyKey,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'batch',
            method: 'generateIdentities',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'batch',
          methodName: 'generateIdentities',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'batchId': batchId,
            'quantity': quantity,
            'idempotencyKey': idempotencyKey,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i1yy58yr.IdentityGenerationResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ifyzxhpy.BatchStats> stats(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue batchId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'batch',
            method: 'stats',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'batch',
          methodName: 'stats',
          parameters: _ist.testObjectToJson({'batchId': batchId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ifyzxhpy.BatchStats>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _DemoEndpoint {
  _DemoEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_ivrxepu5.WorkspaceBootstrap> seed(
    _ist.TestSessionBuilder sessionBuilder, {
    String? email,
    String? displayName,
    String? secret,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'demo',
            method: 'seed',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'demo',
          methodName: 'seed',
          parameters: _ist.testObjectToJson({
            'email': email,
            'displayName': displayName,
            'secret': secret,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ivrxepu5.WorkspaceBootstrap>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<bool> isSeeded(_ist.TestSessionBuilder sessionBuilder) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'demo',
            method: 'isSeeded',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'demo',
          methodName: 'isSeeded',
          parameters: _ist.testObjectToJson({}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<bool>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _IdentityEndpoint {
  _IdentityEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_i2mg5i1l.ProductIdentity>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    _is.UuidValue? batchId,
    _iqt4cy7v.IdentityStatus? status,
    required bool onlyFlagged,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'identity',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'identity',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'batchId': batchId,
            'status': status,
            'onlyFlagged': onlyFlagged,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i2mg5i1l.ProductIdentity>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i2mg5i1l.ProductIdentity> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue identityId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'identity',
            method: 'get',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'identity',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'identityId': identityId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i2mg5i1l.ProductIdentity>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i6jedab1.ExportFile> export(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    _is.UuidValue? batchId,
    required _isyhmzih.ExportFormat format,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'identity',
            method: 'export',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'identity',
          methodName: 'export',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'batchId': batchId,
            'format': format,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i6jedab1.ExportFile>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iclla0py.RevealedPin> revealPin(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue identityId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'identity',
            method: 'revealPin',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'identity',
          methodName: 'revealPin',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'identityId': identityId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iclla0py.RevealedPin>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i2mg5i1l.ProductIdentity> regenerateToken(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue identityId,
    String? reason,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'identity',
            method: 'regenerateToken',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'identity',
          methodName: 'regenerateToken',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'identityId': identityId,
            'reason': reason,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i2mg5i1l.ProductIdentity>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i2mg5i1l.ProductIdentity> lock(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue identityId,
    String? reason,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'identity',
            method: 'lock',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'identity',
          methodName: 'lock',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'identityId': identityId,
            'reason': reason,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i2mg5i1l.ProductIdentity>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i2mg5i1l.ProductIdentity> unlock(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue identityId,
    String? note,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'identity',
            method: 'unlock',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'identity',
          methodName: 'unlock',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'identityId': identityId,
            'note': note,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i2mg5i1l.ProductIdentity>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i2mg5i1l.ProductIdentity> delete(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue identityId,
    String? reason,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'identity',
            method: 'delete',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'identity',
          methodName: 'delete',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'identityId': identityId,
            'reason': reason,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i2mg5i1l.ProductIdentity>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i2mg5i1l.ProductIdentity> restore(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue identityId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'identity',
            method: 'restore',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'identity',
          methodName: 'restore',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'identityId': identityId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i2mg5i1l.ProductIdentity>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _NotificationEndpoint {
  _NotificationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_i1dqkmtk.Notification>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required bool onlyUnread,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'onlyUnread': onlyUnread,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i1dqkmtk.Notification>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i1dqkmtk.Notification> markRead(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue notificationId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'markRead',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'markRead',
          parameters: _ist.testObjectToJson({'notificationId': notificationId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i1dqkmtk.Notification>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> markAllRead(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'markAllRead',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'markAllRead',
          parameters: _ist.testObjectToJson({'workspaceId': workspaceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_iz5xn7se.NotificationPreference>> preferences(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'preferences',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'preferences',
          parameters: _ist.testObjectToJson({'workspaceId': workspaceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iz5xn7se.NotificationPreference>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iz5xn7se.NotificationPreference> updatePreference(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _iuzng6z9.NotificationChannel channel,
    required bool enabled,
    required _ih3495d6.AlertSeverity minSeverity,
    String? email,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'notification',
            method: 'updatePreference',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'notification',
          methodName: 'updatePreference',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'channel': channel,
            'enabled': enabled,
            'minSeverity': minSeverity,
            'email': email,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iz5xn7se.NotificationPreference>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _OfflineEndpoint {
  _OfflineEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_isqommwe.OfflineScanVerdict>> ingest(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required String deviceId,
    required List<_iilz41bh.OfflineScanInput> scans,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'offline',
            method: 'ingest',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'offline',
          methodName: 'ingest',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'deviceId': deviceId,
            'scans': scans,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_isqommwe.OfflineScanVerdict>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_irnk4ro1.OfflineScanRecord>> records(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    String? deviceId,
    required bool onlyPending,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'offline',
            method: 'records',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'offline',
          methodName: 'records',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'deviceId': deviceId,
            'onlyPending': onlyPending,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_irnk4ro1.OfflineScanRecord>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> convertNow(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'offline',
            method: 'convertNow',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'offline',
          methodName: 'convertNow',
          parameters: _ist.testObjectToJson({'workspaceId': workspaceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _ProductEndpoint {
  _ProductEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_ian4oqo2.Product>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    String? search,
    required bool includeArchived,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'search': search,
            'includeArchived': includeArchived,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ian4oqo2.Product>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ian4oqo2.Product> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue productId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'get',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'productId': productId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ian4oqo2.Product>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<String> uploadImage(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required String fileName,
    required String data,
    _is.UuidValue? productId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'uploadImage',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'uploadImage',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'fileName': fileName,
            'data': data,
            'productId': productId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<String>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ian4oqo2.Product> create(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required String name,
    String? sku,
    String? category,
    String? description,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'create',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'create',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'name': name,
            'sku': sku,
            'category': category,
            'description': description,
            'imageUrls': imageUrls,
            'packaging': packaging,
            'shelfLife': shelfLife,
            'countryRestrictions': countryRestrictions,
            'safetyInstructions': safetyInstructions,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ian4oqo2.Product>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ian4oqo2.Product> update(
    _ist.TestSessionBuilder sessionBuilder, {
    required _is.UuidValue productId,
    String? name,
    String? sku,
    String? category,
    String? description,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'update',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'productId': productId,
            'name': name,
            'sku': sku,
            'category': category,
            'description': description,
            'imageUrls': imageUrls,
            'packaging': packaging,
            'shelfLife': shelfLife,
            'countryRestrictions': countryRestrictions,
            'safetyInstructions': safetyInstructions,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ian4oqo2.Product>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ian4oqo2.Product> archive(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue productId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'product',
            method: 'archive',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'product',
          methodName: 'archive',
          parameters: _ist.testObjectToJson({'productId': productId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ian4oqo2.Product>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _RecallEndpoint {
  _RecallEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_i8526if6.RecallRecord>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required bool includeLifted,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recall',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recall',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'includeLifted': includeLifted,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i8526if6.RecallRecord>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i8h2toku.RecallResult> recallBatch(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue batchId,
    required String reason,
    String? notes,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recall',
            method: 'recallBatch',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recall',
          methodName: 'recallBatch',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'batchId': batchId,
            'reason': reason,
            'notes': notes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i8h2toku.RecallResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i8h2toku.RecallResult> recallIdentity(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue identityId,
    required String reason,
    String? notes,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recall',
            method: 'recallIdentity',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recall',
          methodName: 'recallIdentity',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'identityId': identityId,
            'reason': reason,
            'notes': notes,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i8h2toku.RecallResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i8h2toku.RecallResult> lift(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue recallId,
    String? note,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'recall',
            method: 'lift',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'recall',
          methodName: 'lift',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'recallId': recallId,
            'note': note,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i8h2toku.RecallResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _SimulationEndpoint {
  _SimulationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_i0v2zdo1.AttackSimulation> start(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _ipsf1cgw.SimulationRequest request,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simulation',
            method: 'start',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simulation',
          methodName: 'start',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'request': request,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i0v2zdo1.AttackSimulation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i0v2zdo1.AttackSimulation>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simulation',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simulation',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i0v2zdo1.AttackSimulation>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i0v2zdo1.AttackSimulation> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue simulationId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simulation',
            method: 'get',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simulation',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'simulationId': simulationId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i0v2zdo1.AttackSimulation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i0v2zdo1.AttackSimulation> step(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue simulationId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simulation',
            method: 'step',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simulation',
          methodName: 'step',
          parameters: _ist.testObjectToJson({'simulationId': simulationId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i0v2zdo1.AttackSimulation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i0v2zdo1.AttackSimulation> run(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue simulationId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simulation',
            method: 'run',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simulation',
          methodName: 'run',
          parameters: _ist.testObjectToJson({'simulationId': simulationId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i0v2zdo1.AttackSimulation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_i0v2zdo1.AttackSimulation> cancel(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue simulationId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'simulation',
            method: 'cancel',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'simulation',
          methodName: 'cancel',
          parameters: _ist.testObjectToJson({'simulationId': simulationId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_i0v2zdo1.AttackSimulation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _VerificationEndpoint {
  _VerificationEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_igsfoz32.VerificationPresentation> start(
    _ist.TestSessionBuilder sessionBuilder,
    String token,
    String deviceFingerprint,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'verification',
            method: 'start',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'verification',
          methodName: 'start',
          parameters: _ist.testObjectToJson({
            'token': token,
            'deviceFingerprint': deviceFingerprint,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_igsfoz32.VerificationPresentation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_igsfoz32.VerificationPresentation> acknowledge(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue sessionId,
    String deviceFingerprint,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'verification',
            method: 'acknowledge',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'verification',
          methodName: 'acknowledge',
          parameters: _ist.testObjectToJson({
            'sessionId': sessionId,
            'deviceFingerprint': deviceFingerprint,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_igsfoz32.VerificationPresentation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_igsfoz32.VerificationPresentation> submitPin(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue sessionId,
    String deviceFingerprint,
    String pin,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'verification',
            method: 'submitPin',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'verification',
          methodName: 'submitPin',
          parameters: _ist.testObjectToJson({
            'sessionId': sessionId,
            'deviceFingerprint': deviceFingerprint,
            'pin': pin,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_igsfoz32.VerificationPresentation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_igsfoz32.VerificationPresentation> result(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue sessionId,
    String deviceFingerprint,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'verification',
            method: 'result',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'verification',
          methodName: 'result',
          parameters: _ist.testObjectToJson({
            'sessionId': sessionId,
            'deviceFingerprint': deviceFingerprint,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_igsfoz32.VerificationPresentation>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iyw0v2xe.ReportAcknowledgement> reportFake(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue sessionId,
    String deviceFingerprint,
    String reason, {
    String? comment,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'verification',
            method: 'reportFake',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'verification',
          methodName: 'reportFake',
          parameters: _ist.testObjectToJson({
            'sessionId': sessionId,
            'deviceFingerprint': deviceFingerprint,
            'reason': reason,
            'comment': comment,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iyw0v2xe.ReportAcknowledgement>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_ism3h20n.VerificationSession>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    _is.UuidValue? identityId,
    _is.UuidValue? batchId,
    _is.UuidValue? productId,
    _iewd06xu.VerificationState? state,
    _i0trd2wt.VerificationOutcome? outcome,
    _ijv8khy1.RiskScore? riskScore,
    _iccccaf9.ScanSource? source,
    DateTime? from,
    DateTime? to,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'verification',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'verification',
          methodName: 'list',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'identityId': identityId,
            'batchId': batchId,
            'productId': productId,
            'state': state,
            'outcome': outcome,
            'riskScore': riskScore,
            'source': source,
            'from': from,
            'to': to,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ism3h20n.VerificationSession>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ism3h20n.VerificationSession> get(
    _ist.TestSessionBuilder sessionBuilder,
    _is.UuidValue sessionId,
  ) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'verification',
            method: 'get',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'verification',
          methodName: 'get',
          parameters: _ist.testObjectToJson({'sessionId': sessionId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ism3h20n.VerificationSession>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Stream<_i40xv4t1.LiveEvent> watchWorkspace(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) {
    var _localTestStreamManager = _ist.TestStreamManager<_i40xv4t1.LiveEvent>();
    _ist.callStreamFunctionAndHandleExceptions(
      () async {
        var _localUniqueSession =
            (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
              endpoint: 'verification',
              method: 'watchWorkspace',
            );
        var _localCallContext = await _endpointDispatch
            .getMethodStreamCallContext(
              createSessionCallback: (_) => _localUniqueSession,
              endpointPath: 'verification',
              methodName: 'watchWorkspace',
              arguments: {'workspaceId': workspaceId},
              requestedInputStreams: [],
              serializationManager: _serializationManager,
            );
        await _localTestStreamManager.callStreamMethod(
          _localCallContext,
          _localUniqueSession,
          {},
        );
      },
      _localTestStreamManager.outputStreamController,
    );
    return _localTestStreamManager.outputStreamController.stream;
  }
}

class _WebhookAdminEndpoint {
  _WebhookAdminEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<List<_if44bvj4.WebhookEndpoint>> list(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'webhookAdmin',
            method: 'list',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'webhookAdmin',
          methodName: 'list',
          parameters: _ist.testObjectToJson({'workspaceId': workspaceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_if44bvj4.WebhookEndpoint>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ihdwgycq.WebhookEndpointSecret> create(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required String url,
    required List<_i9gqphv7.WebhookEventType> events,
    String? description,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'webhookAdmin',
            method: 'create',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'webhookAdmin',
          methodName: 'create',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'url': url,
            'events': events,
            'description': description,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ihdwgycq.WebhookEndpointSecret>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_if44bvj4.WebhookEndpoint> update(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue endpointId,
    String? url,
    List<_i9gqphv7.WebhookEventType>? events,
    String? description,
    bool? enabled,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'webhookAdmin',
            method: 'update',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'webhookAdmin',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'endpointId': endpointId,
            'url': url,
            'events': events,
            'description': description,
            'enabled': enabled,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_if44bvj4.WebhookEndpoint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_if44bvj4.WebhookEndpoint> delete(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue endpointId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'webhookAdmin',
            method: 'delete',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'webhookAdmin',
          methodName: 'delete',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'endpointId': endpointId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_if44bvj4.WebhookEndpoint>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ihdwgycq.WebhookEndpointSecret> rotateSecret(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue endpointId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'webhookAdmin',
            method: 'rotateSecret',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'webhookAdmin',
          methodName: 'rotateSecret',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'endpointId': endpointId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ihdwgycq.WebhookEndpointSecret>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ith836p0.WebhookTestResult> test(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue endpointId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'webhookAdmin',
            method: 'test',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'webhookAdmin',
          methodName: 'test',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'endpointId': endpointId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ith836p0.WebhookTestResult>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_ibuewkxx.WebhookDelivery>> deliveries(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue endpointId,
    required int page,
    required int pageSize,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'webhookAdmin',
            method: 'deliveries',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'webhookAdmin',
          methodName: 'deliveries',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'endpointId': endpointId,
            'page': page,
            'pageSize': pageSize,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_ibuewkxx.WebhookDelivery>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ibuewkxx.WebhookDelivery> redeliver(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue deliveryId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'webhookAdmin',
            method: 'redeliver',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'webhookAdmin',
          methodName: 'redeliver',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'deliveryId': deliveryId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ibuewkxx.WebhookDelivery>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<int> drainNow(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'webhookAdmin',
            method: 'drainNow',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'webhookAdmin',
          methodName: 'drainNow',
          parameters: _ist.testObjectToJson({'workspaceId': workspaceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<int>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _WorkspaceEndpoint {
  _WorkspaceEndpoint(
    this._endpointDispatch,
    this._serializationManager,
  );

  final _is.EndpointDispatch _endpointDispatch;

  final _is.SerializationManager _serializationManager;

  _ida.Future<_ivrxepu5.WorkspaceBootstrap?> bootstrap(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'bootstrap',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'bootstrap',
          parameters: _ist.testObjectToJson({'workspaceId': workspaceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ivrxepu5.WorkspaceBootstrap?>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ivrxepu5.WorkspaceBootstrap> create(
    _ist.TestSessionBuilder sessionBuilder,
    String name, {
    String? email,
    String? authenticMessage,
    _i7nf0hkx.Branding? branding,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'create',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'create',
          parameters: _ist.testObjectToJson({
            'name': name,
            'email': email,
            'authenticMessage': authenticMessage,
            'branding': branding,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ivrxepu5.WorkspaceBootstrap>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ivrxepu5.WorkspaceBootstrap> joinDemo(
    _ist.TestSessionBuilder sessionBuilder, {
    String? email,
    String? displayName,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'joinDemo',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'joinDemo',
          parameters: _ist.testObjectToJson({
            'email': email,
            'displayName': displayName,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ivrxepu5.WorkspaceBootstrap>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ixso1rkf.Workspace> update(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    String? name,
    _i7nf0hkx.Branding? branding,
    String? authenticMessage,
    List<String>? restrictedCountries,
    _il8b5wgn.FraudPolicy? fraudPolicy,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'update',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'update',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'name': name,
            'branding': branding,
            'authenticMessage': authenticMessage,
            'restrictedCountries': restrictedCountries,
            'fraudPolicy': fraudPolicy,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ixso1rkf.Workspace>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_iqeq6200.WorkspaceMember>> members(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'members',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'members',
          parameters: _ist.testObjectToJson({'workspaceId': workspaceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_iqeq6200.WorkspaceMember>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<List<_i78uhtt9.Invitation>> invitations(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'invitations',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'invitations',
          parameters: _ist.testObjectToJson({'workspaceId': workspaceId}),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<List<_i78uhtt9.Invitation>>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ies6uk5i.InvitationCreated> invite(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required String email,
    required _i5ttnrmb.MembershipRole role,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'invite',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'invite',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'email': email,
            'role': role,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ies6uk5i.InvitationCreated>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_ivrxepu5.WorkspaceBootstrap> acceptInvitation(
    _ist.TestSessionBuilder sessionBuilder,
    String code, {
    String? displayName,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'acceptInvitation',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'acceptInvitation',
          parameters: _ist.testObjectToJson({
            'code': code,
            'displayName': displayName,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_ivrxepu5.WorkspaceBootstrap>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<_iqeq6200.WorkspaceMember> changeRole(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue memberId,
    required _i5ttnrmb.MembershipRole role,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'changeRole',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'changeRole',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'memberId': memberId,
            'role': role,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<_iqeq6200.WorkspaceMember>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }

  _ida.Future<void> removeMember(
    _ist.TestSessionBuilder sessionBuilder, {
    _is.UuidValue? workspaceId,
    required _is.UuidValue memberId,
  }) async {
    return _ist.callAwaitableFunctionAndHandleExceptions(() async {
      var _localUniqueSession =
          (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild(
            endpoint: 'workspace',
            method: 'removeMember',
          );
      try {
        var _localCallContext = await _endpointDispatch.getMethodCallContext(
          createSessionCallback: (_) => _localUniqueSession,
          endpointPath: 'workspace',
          methodName: 'removeMember',
          parameters: _ist.testObjectToJson({
            'workspaceId': workspaceId,
            'memberId': memberId,
          }),
          serializationManager: _serializationManager,
        );
        var _localReturnValue =
            await (_localCallContext.method.call(
                  _localUniqueSession,
                  _localCallContext.arguments,
                )
                as _ida.Future<void>);
        return _localReturnValue;
      } finally {
        await _localUniqueSession.close();
      }
    });
  }
}

class _DailyRollupFutureCall {
  Future<void> rollup(_ist.TestSessionBuilder sessionBuilder) async {
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i4legp06.DailyRollupRollupFutureCall().invoke(
        _localUniqueSession,
        null,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _MaintenanceSweepFutureCall {
  Future<void> sweep(_ist.TestSessionBuilder sessionBuilder) async {
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i4legp06.MaintenanceSweepSweepFutureCall().invoke(
        _localUniqueSession,
        null,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _OfflineScanConverterFutureCall {
  Future<void> convert(_ist.TestSessionBuilder sessionBuilder) async {
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i4legp06.OfflineScanConverterConvertFutureCall().invoke(
        _localUniqueSession,
        null,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _SimulationRunnerFutureCall {
  Future<void> step(
    _ist.TestSessionBuilder sessionBuilder,
    _i53ecdb0.SimulationStepRequest request,
  ) async {
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i4legp06.SimulationRunnerStepFutureCall().invoke(
        _localUniqueSession,
        request,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}

class _WebhookDrainFutureCall {
  Future<void> drain(_ist.TestSessionBuilder sessionBuilder) async {
    var _localUniqueSession =
        (sessionBuilder as _ist.InternalTestSessionBuilder).internalBuild();
    try {
      await _i4legp06.WebhookDrainDrainFutureCall().invoke(
        _localUniqueSession,
        null,
      );
    } finally {
      await _localUniqueSession.close();
    }
  }
}
