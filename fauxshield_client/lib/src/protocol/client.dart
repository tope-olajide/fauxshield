/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:fauxshield_client/src/protocol/analytics/alert_evidence.dart'
    as _ithpr71f;
import 'package:fauxshield_client/src/protocol/analytics/daily_workspace_stat.dart'
    as _ia2jrj3b;
import 'package:fauxshield_client/src/protocol/analytics/dashboard_summary.dart'
    as _iq3c741j;
import 'package:fauxshield_client/src/protocol/audit/audit_event.dart'
    as _io3c3iqw;
import 'package:fauxshield_client/src/protocol/consumer/fake_report.dart'
    as _idlr7y3f;
import 'package:fauxshield_client/src/protocol/consumer/report_acknowledgement.dart'
    as _iuqznd29;
import 'package:fauxshield_client/src/protocol/consumer/verification_presentation.dart'
    as _i1jo2s3q;
import 'package:fauxshield_client/src/protocol/core/batch.dart' as _i21v2c5t;
import 'package:fauxshield_client/src/protocol/core/batch_stats.dart'
    as _ikczdw7d;
import 'package:fauxshield_client/src/protocol/core/branding.dart' as _iugz5o62;
import 'package:fauxshield_client/src/protocol/core/export_file.dart'
    as _ir6cthc6;
import 'package:fauxshield_client/src/protocol/core/fraud_policy.dart'
    as _i9n973kk;
import 'package:fauxshield_client/src/protocol/core/identity_generation_result.dart'
    as _if4njpxh;
import 'package:fauxshield_client/src/protocol/core/invitation.dart'
    as _iqkhv8xa;
import 'package:fauxshield_client/src/protocol/core/invitation_created.dart'
    as _iw0whh34;
import 'package:fauxshield_client/src/protocol/core/product.dart' as _i1hi8dz8;
import 'package:fauxshield_client/src/protocol/core/product_identity.dart'
    as _ixvcz44n;
import 'package:fauxshield_client/src/protocol/core/revealed_pin.dart'
    as _inzcn32s;
import 'package:fauxshield_client/src/protocol/core/workspace.dart'
    as _iivwt33y;
import 'package:fauxshield_client/src/protocol/core/workspace_bootstrap.dart'
    as _ie184eo3;
import 'package:fauxshield_client/src/protocol/core/workspace_member.dart'
    as _ibftlimb;
import 'package:fauxshield_client/src/protocol/developer/api_key.dart'
    as _iwojdd5g;
import 'package:fauxshield_client/src/protocol/developer/api_key_secret.dart'
    as _iy8r3z4u;
import 'package:fauxshield_client/src/protocol/enums/alert_severity.dart'
    as _ir72lxkl;
import 'package:fauxshield_client/src/protocol/enums/alert_status.dart'
    as _ixhipq0b;
import 'package:fauxshield_client/src/protocol/enums/api_scope.dart'
    as _it7hafj0;
import 'package:fauxshield_client/src/protocol/enums/batch_status.dart'
    as _ip4vzj7f;
import 'package:fauxshield_client/src/protocol/enums/export_format.dart'
    as _itwclvp9;
import 'package:fauxshield_client/src/protocol/enums/fake_report_status.dart'
    as _igy7ghte;
import 'package:fauxshield_client/src/protocol/enums/identity_status.dart'
    as _i4fkxs5b;
import 'package:fauxshield_client/src/protocol/enums/membership_role.dart'
    as _iglbqvm2;
import 'package:fauxshield_client/src/protocol/enums/notification_channel.dart'
    as _iadbf5a4;
import 'package:fauxshield_client/src/protocol/enums/risk_score.dart'
    as _ijihw5xo;
import 'package:fauxshield_client/src/protocol/enums/scan_source.dart'
    as _i8c8lrcf;
import 'package:fauxshield_client/src/protocol/enums/signal_type.dart'
    as _iureyknh;
import 'package:fauxshield_client/src/protocol/enums/verification_outcome.dart'
    as _ikdjmowm;
import 'package:fauxshield_client/src/protocol/enums/verification_state.dart'
    as _igw875bh;
import 'package:fauxshield_client/src/protocol/enums/webhook_event_type.dart'
    as _igt5gq18;
import 'package:fauxshield_client/src/protocol/live/live_event.dart'
    as _ifhkgq4r;
import 'package:fauxshield_client/src/protocol/notifications/notification.dart'
    as _i50jj726;
import 'package:fauxshield_client/src/protocol/notifications/notification_preference.dart'
    as _i4zgz95d;
import 'package:fauxshield_client/src/protocol/offline/offline_scan_input.dart'
    as _ilt2qd01;
import 'package:fauxshield_client/src/protocol/offline/offline_scan_record.dart'
    as _itsezaya;
import 'package:fauxshield_client/src/protocol/offline/offline_scan_verdict.dart'
    as _ihel98ml;
import 'package:fauxshield_client/src/protocol/recall/recall_record.dart'
    as _iy78n2xm;
import 'package:fauxshield_client/src/protocol/recall/recall_result.dart'
    as _iaktt1xy;
import 'package:fauxshield_client/src/protocol/simulation/attack_simulation.dart'
    as _i6gmjpvp;
import 'package:fauxshield_client/src/protocol/simulation/simulation_request.dart'
    as _ieqf6sca;
import 'package:fauxshield_client/src/protocol/verification/fraud_alert.dart'
    as _ix1ezz04;
import 'package:fauxshield_client/src/protocol/verification/fraud_signal_record.dart'
    as _i8aaj59z;
import 'package:fauxshield_client/src/protocol/verification/verification_session.dart'
    as _iizmtbtb;
import 'package:fauxshield_client/src/protocol/webhooks/webhook_delivery.dart'
    as _i51qex9r;
import 'package:fauxshield_client/src/protocol/webhooks/webhook_endpoint.dart'
    as _i5zhft3t;
import 'package:fauxshield_client/src/protocol/webhooks/webhook_endpoint_secret.dart'
    as _i44q84st;
import 'package:fauxshield_client/src/protocol/webhooks/webhook_test_result.dart'
    as _iz6svr9d;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_offline_sync_client/serverpod_offline_sync_client.dart'
    as _ipulbpi2;
import 'protocol.dart' as _il2as5qe;
import 'sync_tables.dart' as _ii3f3u05;
import 'package:fauxshield_client/migrations/migration_registry.dart';

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Fraud alert queue, evidence assembly, and consumer report triage.
/// {@category Endpoint}
class EndpointAlert extends _isc.EndpointRef {
  EndpointAlert(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'alert';

  /// Lists alerts, newest first.
  _ida.Future<List<_ix1ezz04.FraudAlert>> list({
    _isc.UuidValue? workspaceId,
    _ixhipq0b.AlertStatus? status,
    _ir72lxkl.AlertSeverity? severity,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_ix1ezz04.FraudAlert>>(
    'alert',
    'list',
    {
      'workspaceId': workspaceId,
      'status': status,
      'severity': severity,
      'page': page,
      'pageSize': pageSize,
    },
  );

  /// Loads one alert.
  _ida.Future<_ix1ezz04.FraudAlert> get(_isc.UuidValue alertId) =>
      caller.callServerEndpoint<_ix1ezz04.FraudAlert>(
        'alert',
        'get',
        {'alertId': alertId},
      );

  /// Assembles everything needed to investigate one alert in a single call.
  _ida.Future<_ithpr71f.AlertEvidence> evidence(_isc.UuidValue alertId) =>
      caller.callServerEndpoint<_ithpr71f.AlertEvidence>(
        'alert',
        'evidence',
        {'alertId': alertId},
      );

  /// Moves an alert through its workflow.
  _ida.Future<_ix1ezz04.FraudAlert> updateStatus({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue alertId,
    required _ixhipq0b.AlertStatus status,
    String? note,
  }) => caller.callServerEndpoint<_ix1ezz04.FraudAlert>(
    'alert',
    'updateStatus',
    {
      'workspaceId': workspaceId,
      'alertId': alertId,
      'status': status,
      'note': note,
    },
  );

  /// Assigns an alert to an investigator.
  _ida.Future<_ix1ezz04.FraudAlert> assign({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue alertId,
    String? assignee,
  }) => caller.callServerEndpoint<_ix1ezz04.FraudAlert>(
    'alert',
    'assign',
    {
      'workspaceId': workspaceId,
      'alertId': alertId,
      'assignee': assignee,
    },
  );

  /// Lists raw fraud signals for the intelligence feed.
  _ida.Future<List<_i8aaj59z.FraudSignalRecord>> signals({
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? batchId,
    _iureyknh.SignalType? type,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_i8aaj59z.FraudSignalRecord>>(
    'alert',
    'signals',
    {
      'workspaceId': workspaceId,
      'batchId': batchId,
      'type': type,
      'page': page,
      'pageSize': pageSize,
    },
  );

  /// Lists consumer reports for triage.
  _ida.Future<List<_idlr7y3f.FakeReport>> reports({
    _isc.UuidValue? workspaceId,
    _igy7ghte.FakeReportStatus? status,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_idlr7y3f.FakeReport>>(
    'alert',
    'reports',
    {
      'workspaceId': workspaceId,
      'status': status,
      'page': page,
      'pageSize': pageSize,
    },
  );

  /// Triages a consumer report.
  _ida.Future<_idlr7y3f.FakeReport> triageReport({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue reportId,
    required _igy7ghte.FakeReportStatus status,
    String? note,
  }) => caller.callServerEndpoint<_idlr7y3f.FakeReport>(
    'alert',
    'triageReport',
    {
      'workspaceId': workspaceId,
      'reportId': reportId,
      'status': status,
      'note': note,
    },
  );
}

/// Dashboard analytics for the command center.
/// {@category Endpoint}
class EndpointAnalytics extends _isc.EndpointRef {
  EndpointAnalytics(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'analytics';

  /// Builds the dashboard payload for the last [windowDays] days.
  _ida.Future<_iq3c741j.DashboardSummary> dashboard({
    _isc.UuidValue? workspaceId,
    required int windowDays,
  }) => caller.callServerEndpoint<_iq3c741j.DashboardSummary>(
    'analytics',
    'dashboard',
    {
      'workspaceId': workspaceId,
      'windowDays': windowDays,
    },
  );

  /// Recomputes one day's rollup on demand. Defaults to today.
  _ida.Future<_ia2jrj3b.DailyWorkspaceStat> rollupNow({
    _isc.UuidValue? workspaceId,
    DateTime? day,
  }) => caller.callServerEndpoint<_ia2jrj3b.DailyWorkspaceStat>(
    'analytics',
    'rollupNow',
    {
      'workspaceId': workspaceId,
      'day': day,
    },
  );
}

/// API key management for machine access.
/// {@category Endpoint}
class EndpointApiKey extends _isc.EndpointRef {
  EndpointApiKey(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'apiKey';

  /// Lists keys without their hashes.
  _ida.Future<List<_iwojdd5g.ApiKey>> list({_isc.UuidValue? workspaceId}) =>
      caller.callServerEndpoint<List<_iwojdd5g.ApiKey>>(
        'apiKey',
        'list',
        {'workspaceId': workspaceId},
      );

  /// Creates a key. The secret is returned exactly once.
  _ida.Future<_iy8r3z4u.ApiKeySecret> create({
    _isc.UuidValue? workspaceId,
    required String label,
    required List<_it7hafj0.ApiScope> scopes,
    required int rateLimitPerMinute,
  }) => caller.callServerEndpoint<_iy8r3z4u.ApiKeySecret>(
    'apiKey',
    'create',
    {
      'workspaceId': workspaceId,
      'label': label,
      'scopes': scopes,
      'rateLimitPerMinute': rateLimitPerMinute,
    },
  );

  /// Revokes a key immediately.
  _ida.Future<_iwojdd5g.ApiKey> revoke({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue apiKeyId,
  }) => caller.callServerEndpoint<_iwojdd5g.ApiKey>(
    'apiKey',
    'revoke',
    {
      'workspaceId': workspaceId,
      'apiKeyId': apiKeyId,
    },
  );
}

/// Append-only audit log access.
/// {@category Endpoint}
class EndpointAudit extends _isc.EndpointRef {
  EndpointAudit(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'audit';

  /// Queries audit events with optional filters.
  _ida.Future<List<_io3c3iqw.AuditEvent>> query({
    _isc.UuidValue? workspaceId,
    String? action,
    String? actorIdentifier,
    String? targetType,
    _isc.UuidValue? targetId,
    DateTime? from,
    DateTime? to,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_io3c3iqw.AuditEvent>>(
    'audit',
    'query',
    {
      'workspaceId': workspaceId,
      'action': action,
      'actorIdentifier': actorIdentifier,
      'targetType': targetType,
      'targetId': targetId,
      'from': from,
      'to': to,
      'page': page,
      'pageSize': pageSize,
    },
  );
}

/// Manufacturing batch management.
/// {@category Endpoint}
class EndpointBatch extends _isc.EndpointRef {
  EndpointBatch(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'batch';

  /// Lists batches for the workspace, optionally for one product.
  _ida.Future<List<_i21v2c5t.Batch>> list({
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? productId,
  }) => caller.callServerEndpoint<List<_i21v2c5t.Batch>>(
    'batch',
    'list',
    {
      'workspaceId': workspaceId,
      'productId': productId,
    },
  );

  /// Loads one batch.
  _ida.Future<_i21v2c5t.Batch> get(_isc.UuidValue batchId) =>
      caller.callServerEndpoint<_i21v2c5t.Batch>(
        'batch',
        'get',
        {'batchId': batchId},
      );

  /// Creates a batch for a product.
  _ida.Future<_i21v2c5t.Batch> create({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue productId,
    required String reference,
    required DateTime manufactureDate,
    DateTime? expiryDate,
    required String distributionRegion,
    required int quantity,
    String? notes,
  }) => caller.callServerEndpoint<_i21v2c5t.Batch>(
    'batch',
    'create',
    {
      'workspaceId': workspaceId,
      'productId': productId,
      'reference': reference,
      'manufactureDate': manufactureDate,
      'expiryDate': expiryDate,
      'distributionRegion': distributionRegion,
      'quantity': quantity,
      'notes': notes,
    },
  );

  /// Updates an active batch. Recalled batches are immutable.
  _ida.Future<_i21v2c5t.Batch> update({
    required _isc.UuidValue batchId,
    String? reference,
    DateTime? expiryDate,
    String? distributionRegion,
    int? quantity,
    String? notes,
    _ip4vzj7f.BatchStatus? status,
  }) => caller.callServerEndpoint<_i21v2c5t.Batch>(
    'batch',
    'update',
    {
      'batchId': batchId,
      'reference': reference,
      'expiryDate': expiryDate,
      'distributionRegion': distributionRegion,
      'quantity': quantity,
      'notes': notes,
      'status': status,
    },
  );

  /// Generates serialized identities for a batch.
  ///
  /// Safe to retry: the same idempotency key replays the original result
  /// instead of minting another run of tokens.
  _ida.Future<_if4njpxh.IdentityGenerationResult> generateIdentities({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue batchId,
    required int quantity,
    required String idempotencyKey,
  }) => caller.callServerEndpoint<_if4njpxh.IdentityGenerationResult>(
    'batch',
    'generateIdentities',
    {
      'workspaceId': workspaceId,
      'batchId': batchId,
      'quantity': quantity,
      'idempotencyKey': idempotencyKey,
    },
  );

  /// Identity level statistics for the batch detail screen.
  _ida.Future<_ikczdw7d.BatchStats> stats(_isc.UuidValue batchId) =>
      caller.callServerEndpoint<_ikczdw7d.BatchStats>(
        'batch',
        'stats',
        {'batchId': batchId},
      );
}

/// One click demo access.
///
/// The first caller creates the public demo workspace; everyone after that
/// joins it. Passing the configured `demoSeedSecret` resets the demo data,
/// which keeps review environments clean without letting visitors wipe the
/// workspace they are browsing.
/// {@category Endpoint}
class EndpointDemo extends _isc.EndpointRef {
  EndpointDemo(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'demo';

  /// Seeds (when missing) or joins the public demo workspace.
  _ida.Future<_ie184eo3.WorkspaceBootstrap> seed({
    String? email,
    String? displayName,
    String? secret,
  }) => caller.callServerEndpoint<_ie184eo3.WorkspaceBootstrap>(
    'demo',
    'seed',
    {
      'email': email,
      'displayName': displayName,
      'secret': secret,
    },
  );

  /// Whether a demo workspace already exists.
  _ida.Future<bool> isSeeded() => caller.callServerEndpoint<bool>(
    'demo',
    'isSeeded',
    {},
  );
}

/// Serialized identity management: browsing, exports, PIN reveal, token
/// regeneration, and lock state.
/// {@category Endpoint}
class EndpointIdentity extends _isc.EndpointRef {
  EndpointIdentity(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'identity';

  /// Lists identities with filters and pagination.
  _ida.Future<List<_ixvcz44n.ProductIdentity>> list({
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? batchId,
    _i4fkxs5b.IdentityStatus? status,
    required bool onlyFlagged,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_ixvcz44n.ProductIdentity>>(
    'identity',
    'list',
    {
      'workspaceId': workspaceId,
      'batchId': batchId,
      'status': status,
      'onlyFlagged': onlyFlagged,
      'page': page,
      'pageSize': pageSize,
    },
  );

  /// Loads one identity.
  _ida.Future<_ixvcz44n.ProductIdentity> get(_isc.UuidValue identityId) =>
      caller.callServerEndpoint<_ixvcz44n.ProductIdentity>(
        'identity',
        'get',
        {'identityId': identityId},
      );

  /// Exports identities as CSV or TSV.
  ///
  /// Bounded so a single call cannot exhaust server resources; truncated
  /// exports are flagged in the result.
  _ida.Future<_ir6cthc6.ExportFile> export({
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? batchId,
    required _itwclvp9.ExportFormat format,
  }) => caller.callServerEndpoint<_ir6cthc6.ExportFile>(
    'identity',
    'export',
    {
      'workspaceId': workspaceId,
      'batchId': batchId,
      'format': format,
    },
  );

  /// Reveals the packaging PIN for one identity. Owner only, always audited.
  _ida.Future<_inzcn32s.RevealedPin> revealPin({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue identityId,
  }) => caller.callServerEndpoint<_inzcn32s.RevealedPin>(
    'identity',
    'revealPin',
    {
      'workspaceId': workspaceId,
      'identityId': identityId,
    },
  );

  /// Regenerates a compromised token. The old token stops resolving.
  _ida.Future<_ixvcz44n.ProductIdentity> regenerateToken({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue identityId,
    String? reason,
  }) => caller.callServerEndpoint<_ixvcz44n.ProductIdentity>(
    'identity',
    'regenerateToken',
    {
      'workspaceId': workspaceId,
      'identityId': identityId,
      'reason': reason,
    },
  );

  /// Locks an identity so verification reports fraud until it is unlocked.
  _ida.Future<_ixvcz44n.ProductIdentity> lock({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue identityId,
    String? reason,
  }) => caller.callServerEndpoint<_ixvcz44n.ProductIdentity>(
    'identity',
    'lock',
    {
      'workspaceId': workspaceId,
      'identityId': identityId,
      'reason': reason,
    },
  );

  /// Unlocks an identity after investigation.
  _ida.Future<_ixvcz44n.ProductIdentity> unlock({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue identityId,
    String? note,
  }) => caller.callServerEndpoint<_ixvcz44n.ProductIdentity>(
    'identity',
    'unlock',
    {
      'workspaceId': workspaceId,
      'identityId': identityId,
      'note': note,
    },
  );

  /// Soft deletes an identity. The QR token stops resolving.
  _ida.Future<_ixvcz44n.ProductIdentity> delete({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue identityId,
    String? reason,
  }) => caller.callServerEndpoint<_ixvcz44n.ProductIdentity>(
    'identity',
    'delete',
    {
      'workspaceId': workspaceId,
      'identityId': identityId,
      'reason': reason,
    },
  );

  /// Restores a soft deleted identity to active status.
  _ida.Future<_ixvcz44n.ProductIdentity> restore({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue identityId,
  }) => caller.callServerEndpoint<_ixvcz44n.ProductIdentity>(
    'identity',
    'restore',
    {
      'workspaceId': workspaceId,
      'identityId': identityId,
    },
  );
}

/// In-app notifications and per-member preferences.
/// {@category Endpoint}
class EndpointNotification extends _isc.EndpointRef {
  EndpointNotification(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  /// Lists notifications for the signed-in member.
  _ida.Future<List<_i50jj726.Notification>> list({
    _isc.UuidValue? workspaceId,
    required bool onlyUnread,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_i50jj726.Notification>>(
    'notification',
    'list',
    {
      'workspaceId': workspaceId,
      'onlyUnread': onlyUnread,
      'page': page,
      'pageSize': pageSize,
    },
  );

  /// Marks one notification as read.
  _ida.Future<_i50jj726.Notification> markRead(_isc.UuidValue notificationId) =>
      caller.callServerEndpoint<_i50jj726.Notification>(
        'notification',
        'markRead',
        {'notificationId': notificationId},
      );

  /// Marks every unread notification for the member as read.
  _ida.Future<int> markAllRead({_isc.UuidValue? workspaceId}) =>
      caller.callServerEndpoint<int>(
        'notification',
        'markAllRead',
        {'workspaceId': workspaceId},
      );

  /// Lists the member's notification preferences.
  _ida.Future<List<_i4zgz95d.NotificationPreference>> preferences({
    _isc.UuidValue? workspaceId,
  }) => caller.callServerEndpoint<List<_i4zgz95d.NotificationPreference>>(
    'notification',
    'preferences',
    {'workspaceId': workspaceId},
  );

  /// Creates or updates one channel preference.
  _ida.Future<_i4zgz95d.NotificationPreference> updatePreference({
    _isc.UuidValue? workspaceId,
    required _iadbf5a4.NotificationChannel channel,
    required bool enabled,
    required _ir72lxkl.AlertSeverity minSeverity,
    String? email,
  }) => caller.callServerEndpoint<_i4zgz95d.NotificationPreference>(
    'notification',
    'updatePreference',
    {
      'workspaceId': workspaceId,
      'channel': channel,
      'enabled': enabled,
      'minSeverity': minSeverity,
      'email': email,
    },
  );
}

/// Offline field scan ingestion.
///
/// Inspector devices queue scans locally while offline. When connectivity
/// returns they either upload them here for immediate verdicts, or let
/// Serverpod's offline sync mirror the rows and the recurring converter
/// process them. Both paths converge on the same server side conversion.
/// {@category Endpoint}
class EndpointOffline extends _isc.EndpointRef {
  EndpointOffline(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'offline';

  /// Uploads a batch of queued scans and returns authoritative verdicts.
  _ida.Future<List<_ihel98ml.OfflineScanVerdict>> ingest({
    _isc.UuidValue? workspaceId,
    required String deviceId,
    required List<_ilt2qd01.OfflineScanInput> scans,
  }) => caller.callServerEndpoint<List<_ihel98ml.OfflineScanVerdict>>(
    'offline',
    'ingest',
    {
      'workspaceId': workspaceId,
      'deviceId': deviceId,
      'scans': scans,
    },
  );

  /// Lists synced scans for a device, newest first, with their verdicts.
  _ida.Future<List<_itsezaya.OfflineScanRecord>> records({
    _isc.UuidValue? workspaceId,
    String? deviceId,
    required bool onlyPending,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_itsezaya.OfflineScanRecord>>(
    'offline',
    'records',
    {
      'workspaceId': workspaceId,
      'deviceId': deviceId,
      'onlyPending': onlyPending,
      'page': page,
      'pageSize': pageSize,
    },
  );

  /// Converts pending scans immediately instead of waiting for the scheduler.
  _ida.Future<int> convertNow({_isc.UuidValue? workspaceId}) =>
      caller.callServerEndpoint<int>(
        'offline',
        'convertNow',
        {'workspaceId': workspaceId},
      );
}

/// Product catalog management.
/// {@category Endpoint}
class EndpointProduct extends _isc.EndpointRef {
  EndpointProduct(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  /// Lists products, optionally filtered by a search term.
  _ida.Future<List<_i1hi8dz8.Product>> list({
    _isc.UuidValue? workspaceId,
    String? search,
    required bool includeArchived,
  }) => caller.callServerEndpoint<List<_i1hi8dz8.Product>>(
    'product',
    'list',
    {
      'workspaceId': workspaceId,
      'search': search,
      'includeArchived': includeArchived,
    },
  );

  /// Loads one product.
  _ida.Future<_i1hi8dz8.Product> get(_isc.UuidValue productId) =>
      caller.callServerEndpoint<_i1hi8dz8.Product>(
        'product',
        'get',
        {'productId': productId},
      );

  /// Uploads a product image and returns its public URL.
  ///
  /// Flutter web cannot post multipart forms to Serverpod endpoints, so the
  /// bytes arrive base64-encoded. The payload is validated by magic-byte
  /// sniffing and a 2 MB cap, written under `web/static/media/products/`,
  /// and served by the static route at `/web/media/products/<file>`.
  ///
  /// When [productId] is given the URL is appended to the product's
  /// `imageUrls` (capped at [_maxProductImages] images).
  _ida.Future<String> uploadImage({
    _isc.UuidValue? workspaceId,
    required String fileName,
    required String data,
    _isc.UuidValue? productId,
  }) => caller.callServerEndpoint<String>(
    'product',
    'uploadImage',
    {
      'workspaceId': workspaceId,
      'fileName': fileName,
      'data': data,
      'productId': productId,
    },
  );

  /// Creates a product.
  _ida.Future<_i1hi8dz8.Product> create({
    _isc.UuidValue? workspaceId,
    required String name,
    String? sku,
    String? category,
    String? description,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
  }) => caller.callServerEndpoint<_i1hi8dz8.Product>(
    'product',
    'create',
    {
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
    },
  );

  /// Updates product details. Only supplied fields change.
  _ida.Future<_i1hi8dz8.Product> update({
    required _isc.UuidValue productId,
    String? name,
    String? sku,
    String? category,
    String? description,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
  }) => caller.callServerEndpoint<_i1hi8dz8.Product>(
    'product',
    'update',
    {
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
    },
  );

  /// Archives a product. Batches and identities are preserved.
  _ida.Future<_i1hi8dz8.Product> archive(_isc.UuidValue productId) =>
      caller.callServerEndpoint<_i1hi8dz8.Product>(
        'product',
        'archive',
        {'productId': productId},
      );
}

/// Batch and identity recalls.
///
/// Verification reports the recalled outcome while a recall is active, and
/// every recall is announced through live events, notifications, and webhooks.
/// {@category Endpoint}
class EndpointRecall extends _isc.EndpointRef {
  EndpointRecall(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recall';

  /// Lists recall history.
  _ida.Future<List<_iy78n2xm.RecallRecord>> list({
    _isc.UuidValue? workspaceId,
    required bool includeLifted,
  }) => caller.callServerEndpoint<List<_iy78n2xm.RecallRecord>>(
    'recall',
    'list',
    {
      'workspaceId': workspaceId,
      'includeLifted': includeLifted,
    },
  );

  /// Recalls a whole batch.
  _ida.Future<_iaktt1xy.RecallResult> recallBatch({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue batchId,
    required String reason,
    String? notes,
  }) => caller.callServerEndpoint<_iaktt1xy.RecallResult>(
    'recall',
    'recallBatch',
    {
      'workspaceId': workspaceId,
      'batchId': batchId,
      'reason': reason,
      'notes': notes,
    },
  );

  /// Recalls one identity.
  _ida.Future<_iaktt1xy.RecallResult> recallIdentity({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue identityId,
    required String reason,
    String? notes,
  }) => caller.callServerEndpoint<_iaktt1xy.RecallResult>(
    'recall',
    'recallIdentity',
    {
      'workspaceId': workspaceId,
      'identityId': identityId,
      'reason': reason,
      'notes': notes,
    },
  );

  /// Lifts a recall. Units return to normal verification.
  _ida.Future<_iaktt1xy.RecallResult> lift({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue recallId,
    String? note,
  }) => caller.callServerEndpoint<_iaktt1xy.RecallResult>(
    'recall',
    'lift',
    {
      'workspaceId': workspaceId,
      'recallId': recallId,
      'note': note,
    },
  );
}

/// Attack simulation control.
///
/// Simulations run realistic attack scenarios through the real fraud
/// pipeline, so the command center can rehearse its response to clone
/// attacks, PIN brute force, scan bursts, and grey market leaks.
/// {@category Endpoint}
class EndpointSimulation extends _isc.EndpointRef {
  EndpointSimulation(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'simulation';

  /// Starts a simulation. Zero delay runs to completion inline.
  _ida.Future<_i6gmjpvp.AttackSimulation> start({
    _isc.UuidValue? workspaceId,
    required _ieqf6sca.SimulationRequest request,
  }) => caller.callServerEndpoint<_i6gmjpvp.AttackSimulation>(
    'simulation',
    'start',
    {
      'workspaceId': workspaceId,
      'request': request,
    },
  );

  /// Lists recent simulations.
  _ida.Future<List<_i6gmjpvp.AttackSimulation>> list({
    _isc.UuidValue? workspaceId,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_i6gmjpvp.AttackSimulation>>(
    'simulation',
    'list',
    {
      'workspaceId': workspaceId,
      'page': page,
      'pageSize': pageSize,
    },
  );

  /// Loads one simulation.
  _ida.Future<_i6gmjpvp.AttackSimulation> get(_isc.UuidValue simulationId) =>
      caller.callServerEndpoint<_i6gmjpvp.AttackSimulation>(
        'simulation',
        'get',
        {'simulationId': simulationId},
      );

  /// Advances a simulation by one step immediately.
  ///
  /// Useful for tests and for walking a simulation forward by hand while
  /// watching the command center stream.
  _ida.Future<_i6gmjpvp.AttackSimulation> step(_isc.UuidValue simulationId) =>
      caller.callServerEndpoint<_i6gmjpvp.AttackSimulation>(
        'simulation',
        'step',
        {'simulationId': simulationId},
      );

  /// Runs any remaining steps inline.
  _ida.Future<_i6gmjpvp.AttackSimulation> run(_isc.UuidValue simulationId) =>
      caller.callServerEndpoint<_i6gmjpvp.AttackSimulation>(
        'simulation',
        'run',
        {'simulationId': simulationId},
      );

  /// Cancels a queued or running simulation.
  _ida.Future<_i6gmjpvp.AttackSimulation> cancel(_isc.UuidValue simulationId) =>
      caller.callServerEndpoint<_i6gmjpvp.AttackSimulation>(
        'simulation',
        'cancel',
        {'simulationId': simulationId},
      );
}

/// The verification flow.
///
/// Consumer calls are unauthenticated by design: a shopper scans a QR code on
/// a product without an account. Every call after the first is addressed by a
/// session id plus the device fingerprint that created the session, and only
/// allow-listed `VerificationPresentation` data ever leaves the server.
/// {@category Endpoint}
class EndpointVerification extends _isc.EndpointRef {
  EndpointVerification(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'verification';

  /// Resolves a scanned QR token and returns the consumer facing state.
  _ida.Future<_i1jo2s3q.VerificationPresentation> start(
    String token,
    String deviceFingerprint,
  ) => caller.callServerEndpoint<_i1jo2s3q.VerificationPresentation>(
    'verification',
    'start',
    {
      'token': token,
      'deviceFingerprint': deviceFingerprint,
    },
    authenticated: false,
  );

  /// Moves a resolved session to the PIN prompt.
  _ida.Future<_i1jo2s3q.VerificationPresentation> acknowledge(
    _isc.UuidValue sessionId,
    String deviceFingerprint,
  ) => caller.callServerEndpoint<_i1jo2s3q.VerificationPresentation>(
    'verification',
    'acknowledge',
    {
      'sessionId': sessionId,
      'deviceFingerprint': deviceFingerprint,
    },
    authenticated: false,
  );

  /// Submits the packaging PIN and returns the final outcome.
  _ida.Future<_i1jo2s3q.VerificationPresentation> submitPin(
    _isc.UuidValue sessionId,
    String deviceFingerprint,
    String pin,
  ) => caller.callServerEndpoint<_i1jo2s3q.VerificationPresentation>(
    'verification',
    'submitPin',
    {
      'sessionId': sessionId,
      'deviceFingerprint': deviceFingerprint,
      'pin': pin,
    },
    authenticated: false,
  );

  /// Re-reads the current state of a session, for page refreshes.
  _ida.Future<_i1jo2s3q.VerificationPresentation> result(
    _isc.UuidValue sessionId,
    String deviceFingerprint,
  ) => caller.callServerEndpoint<_i1jo2s3q.VerificationPresentation>(
    'verification',
    'result',
    {
      'sessionId': sessionId,
      'deviceFingerprint': deviceFingerprint,
    },
    authenticated: false,
  );

  /// Reports a suspicious product from the verification result screen.
  ///
  /// Reports are rate limited per device and feed the brand's triage queue.
  _ida.Future<_iuqznd29.ReportAcknowledgement> reportFake(
    _isc.UuidValue sessionId,
    String deviceFingerprint,
    String reason, {
    String? comment,
  }) => caller.callServerEndpoint<_iuqznd29.ReportAcknowledgement>(
    'verification',
    'reportFake',
    {
      'sessionId': sessionId,
      'deviceFingerprint': deviceFingerprint,
      'reason': reason,
      'comment': comment,
    },
    authenticated: false,
  );

  /// Lists verification sessions for the operator console.
  _ida.Future<List<_iizmtbtb.VerificationSession>> list({
    _isc.UuidValue? workspaceId,
    _isc.UuidValue? identityId,
    _isc.UuidValue? batchId,
    _isc.UuidValue? productId,
    _igw875bh.VerificationState? state,
    _ikdjmowm.VerificationOutcome? outcome,
    _ijihw5xo.RiskScore? riskScore,
    _i8c8lrcf.ScanSource? source,
    DateTime? from,
    DateTime? to,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_iizmtbtb.VerificationSession>>(
    'verification',
    'list',
    {
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
    },
  );

  /// Loads one verification session.
  _ida.Future<_iizmtbtb.VerificationSession> get(_isc.UuidValue sessionId) =>
      caller.callServerEndpoint<_iizmtbtb.VerificationSession>(
        'verification',
        'get',
        {'sessionId': sessionId},
      );

  /// Streams live command center events for the workspace.
  ///
  /// The stream receives verifications, alerts, recalls, offline ingest, and
  /// simulation progress as they happen.
  _ida.Stream<_ifhkgq4r.LiveEvent> watchWorkspace({
    _isc.UuidValue? workspaceId,
  }) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_ifhkgq4r.LiveEvent>,
        _ifhkgq4r.LiveEvent
      >(
        'verification',
        'watchWorkspace',
        {'workspaceId': workspaceId},
        {},
      );
}

/// Webhook endpoint administration and delivery inspection.
/// {@category Endpoint}
class EndpointWebhookAdmin extends _isc.EndpointRef {
  EndpointWebhookAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'webhookAdmin';

  /// Lists active webhook endpoints.
  _ida.Future<List<_i5zhft3t.WebhookEndpoint>> list({
    _isc.UuidValue? workspaceId,
  }) => caller.callServerEndpoint<List<_i5zhft3t.WebhookEndpoint>>(
    'webhookAdmin',
    'list',
    {'workspaceId': workspaceId},
  );

  /// Registers a webhook endpoint. The signing secret is shown once.
  _ida.Future<_i44q84st.WebhookEndpointSecret> create({
    _isc.UuidValue? workspaceId,
    required String url,
    required List<_igt5gq18.WebhookEventType> events,
    String? description,
  }) => caller.callServerEndpoint<_i44q84st.WebhookEndpointSecret>(
    'webhookAdmin',
    'create',
    {
      'workspaceId': workspaceId,
      'url': url,
      'events': events,
      'description': description,
    },
  );

  /// Updates a webhook endpoint.
  _ida.Future<_i5zhft3t.WebhookEndpoint> update({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue endpointId,
    String? url,
    List<_igt5gq18.WebhookEventType>? events,
    String? description,
    bool? enabled,
  }) => caller.callServerEndpoint<_i5zhft3t.WebhookEndpoint>(
    'webhookAdmin',
    'update',
    {
      'workspaceId': workspaceId,
      'endpointId': endpointId,
      'url': url,
      'events': events,
      'description': description,
      'enabled': enabled,
    },
  );

  /// Soft deletes a webhook endpoint.
  _ida.Future<_i5zhft3t.WebhookEndpoint> delete({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue endpointId,
  }) => caller.callServerEndpoint<_i5zhft3t.WebhookEndpoint>(
    'webhookAdmin',
    'delete',
    {
      'workspaceId': workspaceId,
      'endpointId': endpointId,
    },
  );

  /// Rotates the signing secret. The previous secret stays valid during
  /// rotation so in-flight deliveries still verify.
  _ida.Future<_i44q84st.WebhookEndpointSecret> rotateSecret({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue endpointId,
  }) => caller.callServerEndpoint<_i44q84st.WebhookEndpointSecret>(
    'webhookAdmin',
    'rotateSecret',
    {
      'workspaceId': workspaceId,
      'endpointId': endpointId,
    },
  );

  /// Sends a signed test delivery and reports the result inline.
  _ida.Future<_iz6svr9d.WebhookTestResult> test({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue endpointId,
  }) => caller.callServerEndpoint<_iz6svr9d.WebhookTestResult>(
    'webhookAdmin',
    'test',
    {
      'workspaceId': workspaceId,
      'endpointId': endpointId,
    },
  );

  /// Lists recent deliveries for an endpoint.
  _ida.Future<List<_i51qex9r.WebhookDelivery>> deliveries({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue endpointId,
    required int page,
    required int pageSize,
  }) => caller.callServerEndpoint<List<_i51qex9r.WebhookDelivery>>(
    'webhookAdmin',
    'deliveries',
    {
      'workspaceId': workspaceId,
      'endpointId': endpointId,
      'page': page,
      'pageSize': pageSize,
    },
  );

  /// Requeues a delivery and attempts it immediately.
  _ida.Future<_i51qex9r.WebhookDelivery> redeliver({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue deliveryId,
  }) => caller.callServerEndpoint<_i51qex9r.WebhookDelivery>(
    'webhookAdmin',
    'redeliver',
    {
      'workspaceId': workspaceId,
      'deliveryId': deliveryId,
    },
  );

  /// Drains the outbox immediately instead of waiting for the scheduled task.
  _ida.Future<int> drainNow({_isc.UuidValue? workspaceId}) =>
      caller.callServerEndpoint<int>(
        'webhookAdmin',
        'drainNow',
        {'workspaceId': workspaceId},
      );
}

/// Workspace lifecycle and team management.
///
/// Every operator call resolves the workspace server side from the
/// authenticated user's membership; a client supplied workspace id is only
/// ever used as a hint and is verified against that membership.
/// {@category Endpoint}
class EndpointWorkspace extends _isc.EndpointRef {
  EndpointWorkspace(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workspace';

  /// Resolves the signed-in operator's workspace.
  ///
  /// Returns null when the user has not joined or created a workspace yet, so
  /// the app can show onboarding instead of an error.
  _ida.Future<_ie184eo3.WorkspaceBootstrap?> bootstrap({
    _isc.UuidValue? workspaceId,
  }) => caller.callServerEndpoint<_ie184eo3.WorkspaceBootstrap?>(
    'workspace',
    'bootstrap',
    {'workspaceId': workspaceId},
  );

  /// Creates a workspace owned by the signed-in operator.
  _ida.Future<_ie184eo3.WorkspaceBootstrap> create(
    String name, {
    String? email,
    String? authenticMessage,
    _iugz5o62.Branding? branding,
  }) => caller.callServerEndpoint<_ie184eo3.WorkspaceBootstrap>(
    'workspace',
    'create',
    {
      'name': name,
      'email': email,
      'authenticMessage': authenticMessage,
      'branding': branding,
    },
  );

  /// Joins the public demo workspace.
  ///
  /// Demo workspaces are explicitly marked `demoMode` and can be reset at any
  /// time, which is what makes them safe to open up. Joining grants the owner
  /// role so every feature is testable.
  _ida.Future<_ie184eo3.WorkspaceBootstrap> joinDemo({
    String? email,
    String? displayName,
  }) => caller.callServerEndpoint<_ie184eo3.WorkspaceBootstrap>(
    'workspace',
    'joinDemo',
    {
      'email': email,
      'displayName': displayName,
    },
  );

  /// Updates workspace settings. Requires the `workspaceWrite` permission.
  _ida.Future<_iivwt33y.Workspace> update({
    _isc.UuidValue? workspaceId,
    String? name,
    _iugz5o62.Branding? branding,
    String? authenticMessage,
    List<String>? restrictedCountries,
    _i9n973kk.FraudPolicy? fraudPolicy,
  }) => caller.callServerEndpoint<_iivwt33y.Workspace>(
    'workspace',
    'update',
    {
      'workspaceId': workspaceId,
      'name': name,
      'branding': branding,
      'authenticMessage': authenticMessage,
      'restrictedCountries': restrictedCountries,
      'fraudPolicy': fraudPolicy,
    },
  );

  /// Lists workspace members.
  _ida.Future<List<_ibftlimb.WorkspaceMember>> members({
    _isc.UuidValue? workspaceId,
  }) => caller.callServerEndpoint<List<_ibftlimb.WorkspaceMember>>(
    'workspace',
    'members',
    {'workspaceId': workspaceId},
  );

  /// Lists pending invitations.
  _ida.Future<List<_iqkhv8xa.Invitation>> invitations({
    _isc.UuidValue? workspaceId,
  }) => caller.callServerEndpoint<List<_iqkhv8xa.Invitation>>(
    'workspace',
    'invitations',
    {'workspaceId': workspaceId},
  );

  /// Invites a teammate. The code is returned once and stored hashed.
  _ida.Future<_iw0whh34.InvitationCreated> invite({
    _isc.UuidValue? workspaceId,
    required String email,
    required _iglbqvm2.MembershipRole role,
  }) => caller.callServerEndpoint<_iw0whh34.InvitationCreated>(
    'workspace',
    'invite',
    {
      'workspaceId': workspaceId,
      'email': email,
      'role': role,
    },
  );

  /// Redeems an invite code and joins the workspace.
  _ida.Future<_ie184eo3.WorkspaceBootstrap> acceptInvitation(
    String code, {
    String? displayName,
  }) => caller.callServerEndpoint<_ie184eo3.WorkspaceBootstrap>(
    'workspace',
    'acceptInvitation',
    {
      'code': code,
      'displayName': displayName,
    },
  );

  /// Changes a member's role. Requires the `teamWrite` permission.
  _ida.Future<_ibftlimb.WorkspaceMember> changeRole({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue memberId,
    required _iglbqvm2.MembershipRole role,
  }) => caller.callServerEndpoint<_ibftlimb.WorkspaceMember>(
    'workspace',
    'changeRole',
    {
      'workspaceId': workspaceId,
      'memberId': memberId,
      'role': role,
    },
  );

  /// Removes a member. Owners must transfer ownership first.
  _ida.Future<void> removeMember({
    _isc.UuidValue? workspaceId,
    required _isc.UuidValue memberId,
  }) => caller.callServerEndpoint<void>(
    'workspace',
    'removeMember',
    {
      'workspaceId': workspaceId,
      'memberId': memberId,
    },
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    offline_sync = _ipulbpi2.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _ipulbpi2.Caller offline_sync;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    alert = EndpointAlert(this);
    analytics = EndpointAnalytics(this);
    apiKey = EndpointApiKey(this);
    audit = EndpointAudit(this);
    batch = EndpointBatch(this);
    demo = EndpointDemo(this);
    identity = EndpointIdentity(this);
    notification = EndpointNotification(this);
    offline = EndpointOffline(this);
    product = EndpointProduct(this);
    recall = EndpointRecall(this);
    simulation = EndpointSimulation(this);
    verification = EndpointVerification(this);
    webhookAdmin = EndpointWebhookAdmin(this);
    workspace = EndpointWorkspace(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAlert alert;

  late final EndpointAnalytics analytics;

  late final EndpointApiKey apiKey;

  late final EndpointAudit audit;

  late final EndpointBatch batch;

  late final EndpointDemo demo;

  late final EndpointIdentity identity;

  late final EndpointNotification notification;

  late final EndpointOffline offline;

  late final EndpointProduct product;

  late final EndpointRecall recall;

  late final EndpointSimulation simulation;

  late final EndpointVerification verification;

  late final EndpointWebhookAdmin webhookAdmin;

  late final EndpointWorkspace workspace;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'alert': alert,
    'analytics': analytics,
    'apiKey': apiKey,
    'audit': audit,
    'batch': batch,
    'demo': demo,
    'identity': identity,
    'notification': notification,
    'offline': offline,
    'product': product,
    'recall': recall,
    'simulation': simulation,
    'verification': verification,
    'webhookAdmin': webhookAdmin,
    'workspace': workspace,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'offline_sync': modules.offline_sync,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };

  /// Creates a new client-side database session for the given path.
  ///
  /// The [path] is the file path to the SQLite database file. Since SQLite uses
  /// WAL mode, note that `[path]-shm` and `[path]-wal` files might also exist
  /// transiently for the database while the session is open.
  ///
  /// If [runMigrations] is true, pending migrations will be applied when
  /// opening the database. Be careful when setting this to false, as it might
  /// lead to inconsistencies between the models and the database.
  ///
  /// If [isDebugMode] is true, the database integrity will be verified after
  /// the migrations are applied to provide feedback of possible issues. On a
  /// Flutter application, this should be set to [kDebugMode].
  _ida.Future<_isd.ClientDatabaseSession> createSession(
    String path, {
    bool runMigrations = true,
    bool isDebugMode = false,
  }) async {
    return await _isd.ClientDatabaseSession.open(
      path,
      _il2as5qe.Protocol(),
      clientMigrations: MigrationRegistry.migrations,
      runMigrations: runMigrations,
      isDebugMode: isDebugMode,
    );
  }

  /// Creates a new client-side database session for the given path, wrapped
  /// with the `serverpod_offline_sync` engine for the tables declared with
  /// `database: sync`. See [createSession] for the [path], [runMigrations] and
  /// [isDebugMode] parameters.
  ///
  /// The [persistentUserId] is the user all local operations belong to. When
  /// omitted, the user must be passed through the transaction.
  _ida.Future<_ipulbpi2.OfflineSyncDatabaseSession> createSyncSession(
    String path, {
    bool runMigrations = true,
    bool isDebugMode = false,
    _isc.UuidValue? persistentUserId,
  }) async {
    final session = _ipulbpi2.OfflineSyncDatabaseSession.wraps(
      await createSession(
        path,
        runMigrations: runMigrations,
        isDebugMode: isDebugMode,
      ),
      syncTables: _ii3f3u05.syncTables,
      persistentUserId: persistentUserId,
    );
    await session.db.initialize();
    return session;
  }
}
