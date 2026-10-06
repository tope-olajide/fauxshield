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
import 'package:fauxshield_server/src/generated/core/branding.dart'
    as _i7nf0hkx;
import 'package:fauxshield_server/src/generated/core/fraud_policy.dart'
    as _il8b5wgn;
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
import 'package:fauxshield_server/src/generated/offline/offline_scan_input.dart'
    as _iilz41bh;
import 'package:fauxshield_server/src/generated/simulation/simulation_request.dart'
    as _ipsf1cgw;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart'
    as _izehhkf5;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/alert_endpoint.dart' as _i7qz57d6;
import '../endpoints/analytics_endpoint.dart' as _ibbhv9ku;
import '../endpoints/api_key_endpoint.dart' as _id3f7tn2;
import '../endpoints/audit_endpoint.dart' as _irhfmlkv;
import '../endpoints/batch_endpoint.dart' as _ibztaxq8;
import '../endpoints/demo_endpoint.dart' as _irow5ity;
import '../endpoints/identity_endpoint.dart' as _iginsxee;
import '../endpoints/notification_endpoint.dart' as _ihb11yhk;
import '../endpoints/offline_endpoint.dart' as _ijohsxga;
import '../endpoints/product_endpoint.dart' as _im5j1753;
import '../endpoints/recall_endpoint.dart' as _i1x4z1h3;
import '../endpoints/simulation_endpoint.dart' as _i0zgu2b0;
import '../endpoints/verification_endpoint.dart' as _ie4zs15l;
import '../endpoints/webhook_admin_endpoint.dart' as _iuee9j31;
import '../endpoints/workspace_endpoint.dart' as _i9dwb32i;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'alert': _i7qz57d6.AlertEndpoint()
        ..initialize(
          server,
          'alert',
          null,
        ),
      'analytics': _ibbhv9ku.AnalyticsEndpoint()
        ..initialize(
          server,
          'analytics',
          null,
        ),
      'apiKey': _id3f7tn2.ApiKeyEndpoint()
        ..initialize(
          server,
          'apiKey',
          null,
        ),
      'audit': _irhfmlkv.AuditEndpoint()
        ..initialize(
          server,
          'audit',
          null,
        ),
      'batch': _ibztaxq8.BatchEndpoint()
        ..initialize(
          server,
          'batch',
          null,
        ),
      'demo': _irow5ity.DemoEndpoint()
        ..initialize(
          server,
          'demo',
          null,
        ),
      'identity': _iginsxee.IdentityEndpoint()
        ..initialize(
          server,
          'identity',
          null,
        ),
      'notification': _ihb11yhk.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'offline': _ijohsxga.OfflineEndpoint()
        ..initialize(
          server,
          'offline',
          null,
        ),
      'product': _im5j1753.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'recall': _i1x4z1h3.RecallEndpoint()
        ..initialize(
          server,
          'recall',
          null,
        ),
      'simulation': _i0zgu2b0.SimulationEndpoint()
        ..initialize(
          server,
          'simulation',
          null,
        ),
      'verification': _ie4zs15l.VerificationEndpoint()
        ..initialize(
          server,
          'verification',
          null,
        ),
      'webhookAdmin': _iuee9j31.WebhookAdminEndpoint()
        ..initialize(
          server,
          'webhookAdmin',
          null,
        ),
      'workspace': _i9dwb32i.WorkspaceEndpoint()
        ..initialize(
          server,
          'workspace',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['alert'] = _is.EndpointConnector(
      name: 'alert',
      endpoint: endpoints['alert']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_idwavwcs.AlertStatus?>(),
              nullable: true,
            ),
            'severity': _is.ParameterDescription(
              name: 'severity',
              type: _is.getType<_ih3495d6.AlertSeverity?>(),
              nullable: true,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i7qz57d6.AlertEndpoint).list(
                session,
                workspaceId: params['workspaceId'],
                status: params['status'],
                severity: params['severity'],
                page: params['page'],
                pageSize: params['pageSize'],
              ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'alertId': _is.ParameterDescription(
              name: 'alertId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i7qz57d6.AlertEndpoint).get(
                session,
                params['alertId'],
              ),
        ),
        'evidence': _is.MethodConnector(
          name: 'evidence',
          params: {
            'alertId': _is.ParameterDescription(
              name: 'alertId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i7qz57d6.AlertEndpoint).evidence(
                    session,
                    params['alertId'],
                  ),
        ),
        'updateStatus': _is.MethodConnector(
          name: 'updateStatus',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'alertId': _is.ParameterDescription(
              name: 'alertId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_idwavwcs.AlertStatus>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i7qz57d6.AlertEndpoint).updateStatus(
                    session,
                    workspaceId: params['workspaceId'],
                    alertId: params['alertId'],
                    status: params['status'],
                    note: params['note'],
                  ),
        ),
        'assign': _is.MethodConnector(
          name: 'assign',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'alertId': _is.ParameterDescription(
              name: 'alertId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'assignee': _is.ParameterDescription(
              name: 'assignee',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['alert'] as _i7qz57d6.AlertEndpoint).assign(
                session,
                workspaceId: params['workspaceId'],
                alertId: params['alertId'],
                assignee: params['assignee'],
              ),
        ),
        'signals': _is.MethodConnector(
          name: 'signals',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'type': _is.ParameterDescription(
              name: 'type',
              type: _is.getType<_iq844xv7.SignalType?>(),
              nullable: true,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i7qz57d6.AlertEndpoint).signals(
                    session,
                    workspaceId: params['workspaceId'],
                    batchId: params['batchId'],
                    type: params['type'],
                    page: params['page'],
                    pageSize: params['pageSize'],
                  ),
        ),
        'reports': _is.MethodConnector(
          name: 'reports',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_iqbe6yeb.FakeReportStatus?>(),
              nullable: true,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i7qz57d6.AlertEndpoint).reports(
                    session,
                    workspaceId: params['workspaceId'],
                    status: params['status'],
                    page: params['page'],
                    pageSize: params['pageSize'],
                  ),
        ),
        'triageReport': _is.MethodConnector(
          name: 'triageReport',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_iqbe6yeb.FakeReportStatus>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i7qz57d6.AlertEndpoint).triageReport(
                    session,
                    workspaceId: params['workspaceId'],
                    reportId: params['reportId'],
                    status: params['status'],
                    note: params['note'],
                  ),
        ),
      },
    );
    connectors['analytics'] = _is.EndpointConnector(
      name: 'analytics',
      endpoint: endpoints['analytics']!,
      methodConnectors: {
        'dashboard': _is.MethodConnector(
          name: 'dashboard',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'windowDays': _is.ParameterDescription(
              name: 'windowDays',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analytics'] as _ibbhv9ku.AnalyticsEndpoint)
                  .dashboard(
                    session,
                    workspaceId: params['workspaceId'],
                    windowDays: params['windowDays'],
                  ),
        ),
        'rollupNow': _is.MethodConnector(
          name: 'rollupNow',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'day': _is.ParameterDescription(
              name: 'day',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analytics'] as _ibbhv9ku.AnalyticsEndpoint)
                  .rollupNow(
                    session,
                    workspaceId: params['workspaceId'],
                    day: params['day'],
                  ),
        ),
      },
    );
    connectors['apiKey'] = _is.EndpointConnector(
      name: 'apiKey',
      endpoint: endpoints['apiKey']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['apiKey'] as _id3f7tn2.ApiKeyEndpoint).list(
                session,
                workspaceId: params['workspaceId'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'label': _is.ParameterDescription(
              name: 'label',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'scopes': _is.ParameterDescription(
              name: 'scopes',
              type: _is.getType<List<_ilmzvpi4.ApiScope>>(),
              nullable: false,
            ),
            'rateLimitPerMinute': _is.ParameterDescription(
              name: 'rateLimitPerMinute',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['apiKey'] as _id3f7tn2.ApiKeyEndpoint).create(
                    session,
                    workspaceId: params['workspaceId'],
                    label: params['label'],
                    scopes: params['scopes'],
                    rateLimitPerMinute: params['rateLimitPerMinute'],
                  ),
        ),
        'revoke': _is.MethodConnector(
          name: 'revoke',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'apiKeyId': _is.ParameterDescription(
              name: 'apiKeyId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['apiKey'] as _id3f7tn2.ApiKeyEndpoint).revoke(
                    session,
                    workspaceId: params['workspaceId'],
                    apiKeyId: params['apiKeyId'],
                  ),
        ),
      },
    );
    connectors['audit'] = _is.EndpointConnector(
      name: 'audit',
      endpoint: endpoints['audit']!,
      methodConnectors: {
        'query': _is.MethodConnector(
          name: 'query',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'action': _is.ParameterDescription(
              name: 'action',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'actorIdentifier': _is.ParameterDescription(
              name: 'actorIdentifier',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'targetType': _is.ParameterDescription(
              name: 'targetType',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'targetId': _is.ParameterDescription(
              name: 'targetId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['audit'] as _irhfmlkv.AuditEndpoint).query(
                session,
                workspaceId: params['workspaceId'],
                action: params['action'],
                actorIdentifier: params['actorIdentifier'],
                targetType: params['targetType'],
                targetId: params['targetId'],
                from: params['from'],
                to: params['to'],
                page: params['page'],
                pageSize: params['pageSize'],
              ),
        ),
      },
    );
    connectors['batch'] = _is.EndpointConnector(
      name: 'batch',
      endpoint: endpoints['batch']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'productId': _is.ParameterDescription(
              name: 'productId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['batch'] as _ibztaxq8.BatchEndpoint).list(
                session,
                workspaceId: params['workspaceId'],
                productId: params['productId'],
              ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['batch'] as _ibztaxq8.BatchEndpoint).get(
                session,
                params['batchId'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'productId': _is.ParameterDescription(
              name: 'productId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reference': _is.ParameterDescription(
              name: 'reference',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'manufactureDate': _is.ParameterDescription(
              name: 'manufactureDate',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'expiryDate': _is.ParameterDescription(
              name: 'expiryDate',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'distributionRegion': _is.ParameterDescription(
              name: 'distributionRegion',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'quantity': _is.ParameterDescription(
              name: 'quantity',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'notes': _is.ParameterDescription(
              name: 'notes',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['batch'] as _ibztaxq8.BatchEndpoint).create(
                session,
                workspaceId: params['workspaceId'],
                productId: params['productId'],
                reference: params['reference'],
                manufactureDate: params['manufactureDate'],
                expiryDate: params['expiryDate'],
                distributionRegion: params['distributionRegion'],
                quantity: params['quantity'],
                notes: params['notes'],
              ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reference': _is.ParameterDescription(
              name: 'reference',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'expiryDate': _is.ParameterDescription(
              name: 'expiryDate',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'distributionRegion': _is.ParameterDescription(
              name: 'distributionRegion',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'quantity': _is.ParameterDescription(
              name: 'quantity',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'notes': _is.ParameterDescription(
              name: 'notes',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_ioi4hopc.BatchStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['batch'] as _ibztaxq8.BatchEndpoint).update(
                session,
                batchId: params['batchId'],
                reference: params['reference'],
                expiryDate: params['expiryDate'],
                distributionRegion: params['distributionRegion'],
                quantity: params['quantity'],
                notes: params['notes'],
                status: params['status'],
              ),
        ),
        'generateIdentities': _is.MethodConnector(
          name: 'generateIdentities',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'quantity': _is.ParameterDescription(
              name: 'quantity',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'idempotencyKey': _is.ParameterDescription(
              name: 'idempotencyKey',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['batch'] as _ibztaxq8.BatchEndpoint)
                  .generateIdentities(
                    session,
                    workspaceId: params['workspaceId'],
                    batchId: params['batchId'],
                    quantity: params['quantity'],
                    idempotencyKey: params['idempotencyKey'],
                  ),
        ),
        'stats': _is.MethodConnector(
          name: 'stats',
          params: {
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['batch'] as _ibztaxq8.BatchEndpoint).stats(
                session,
                params['batchId'],
              ),
        ),
      },
    );
    connectors['demo'] = _is.EndpointConnector(
      name: 'demo',
      endpoint: endpoints['demo']!,
      methodConnectors: {
        'seed': _is.MethodConnector(
          name: 'seed',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'secret': _is.ParameterDescription(
              name: 'secret',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['demo'] as _irow5ity.DemoEndpoint).seed(
                session,
                email: params['email'],
                displayName: params['displayName'],
                secret: params['secret'],
              ),
        ),
        'isSeeded': _is.MethodConnector(
          name: 'isSeeded',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['demo'] as _irow5ity.DemoEndpoint).isSeeded(
                session,
              ),
        ),
      },
    );
    connectors['identity'] = _is.EndpointConnector(
      name: 'identity',
      endpoint: endpoints['identity']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_iqt4cy7v.IdentityStatus?>(),
              nullable: true,
            ),
            'onlyFlagged': _is.ParameterDescription(
              name: 'onlyFlagged',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['identity'] as _iginsxee.IdentityEndpoint).list(
                    session,
                    workspaceId: params['workspaceId'],
                    batchId: params['batchId'],
                    status: params['status'],
                    onlyFlagged: params['onlyFlagged'],
                    page: params['page'],
                    pageSize: params['pageSize'],
                  ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'identityId': _is.ParameterDescription(
              name: 'identityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['identity'] as _iginsxee.IdentityEndpoint).get(
                    session,
                    params['identityId'],
                  ),
        ),
        'export': _is.MethodConnector(
          name: 'export',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'format': _is.ParameterDescription(
              name: 'format',
              type: _is.getType<_isyhmzih.ExportFormat>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['identity'] as _iginsxee.IdentityEndpoint).export(
                    session,
                    workspaceId: params['workspaceId'],
                    batchId: params['batchId'],
                    format: params['format'],
                  ),
        ),
        'revealPin': _is.MethodConnector(
          name: 'revealPin',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'identityId': _is.ParameterDescription(
              name: 'identityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['identity'] as _iginsxee.IdentityEndpoint)
                  .revealPin(
                    session,
                    workspaceId: params['workspaceId'],
                    identityId: params['identityId'],
                  ),
        ),
        'regenerateToken': _is.MethodConnector(
          name: 'regenerateToken',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'identityId': _is.ParameterDescription(
              name: 'identityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['identity'] as _iginsxee.IdentityEndpoint)
                  .regenerateToken(
                    session,
                    workspaceId: params['workspaceId'],
                    identityId: params['identityId'],
                    reason: params['reason'],
                  ),
        ),
        'lock': _is.MethodConnector(
          name: 'lock',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'identityId': _is.ParameterDescription(
              name: 'identityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['identity'] as _iginsxee.IdentityEndpoint).lock(
                    session,
                    workspaceId: params['workspaceId'],
                    identityId: params['identityId'],
                    reason: params['reason'],
                  ),
        ),
        'unlock': _is.MethodConnector(
          name: 'unlock',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'identityId': _is.ParameterDescription(
              name: 'identityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['identity'] as _iginsxee.IdentityEndpoint).unlock(
                    session,
                    workspaceId: params['workspaceId'],
                    identityId: params['identityId'],
                    note: params['note'],
                  ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'identityId': _is.ParameterDescription(
              name: 'identityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['identity'] as _iginsxee.IdentityEndpoint).delete(
                    session,
                    workspaceId: params['workspaceId'],
                    identityId: params['identityId'],
                    reason: params['reason'],
                  ),
        ),
        'restore': _is.MethodConnector(
          name: 'restore',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'identityId': _is.ParameterDescription(
              name: 'identityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['identity'] as _iginsxee.IdentityEndpoint).restore(
                    session,
                    workspaceId: params['workspaceId'],
                    identityId: params['identityId'],
                  ),
        ),
      },
    );
    connectors['notification'] = _is.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'onlyUnread': _is.ParameterDescription(
              name: 'onlyUnread',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .list(
                        session,
                        workspaceId: params['workspaceId'],
                        onlyUnread: params['onlyUnread'],
                        page: params['page'],
                        pageSize: params['pageSize'],
                      ),
        ),
        'markRead': _is.MethodConnector(
          name: 'markRead',
          params: {
            'notificationId': _is.ParameterDescription(
              name: 'notificationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .markRead(
                        session,
                        params['notificationId'],
                      ),
        ),
        'markAllRead': _is.MethodConnector(
          name: 'markAllRead',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .markAllRead(
                        session,
                        workspaceId: params['workspaceId'],
                      ),
        ),
        'preferences': _is.MethodConnector(
          name: 'preferences',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .preferences(
                        session,
                        workspaceId: params['workspaceId'],
                      ),
        ),
        'updatePreference': _is.MethodConnector(
          name: 'updatePreference',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'channel': _is.ParameterDescription(
              name: 'channel',
              type: _is.getType<_iuzng6z9.NotificationChannel>(),
              nullable: false,
            ),
            'enabled': _is.ParameterDescription(
              name: 'enabled',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'minSeverity': _is.ParameterDescription(
              name: 'minSeverity',
              type: _is.getType<_ih3495d6.AlertSeverity>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _ihb11yhk.NotificationEndpoint)
                      .updatePreference(
                        session,
                        workspaceId: params['workspaceId'],
                        channel: params['channel'],
                        enabled: params['enabled'],
                        minSeverity: params['minSeverity'],
                        email: params['email'],
                      ),
        ),
      },
    );
    connectors['offline'] = _is.EndpointConnector(
      name: 'offline',
      endpoint: endpoints['offline']!,
      methodConnectors: {
        'ingest': _is.MethodConnector(
          name: 'ingest',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'scans': _is.ParameterDescription(
              name: 'scans',
              type: _is.getType<List<_iilz41bh.OfflineScanInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['offline'] as _ijohsxga.OfflineEndpoint).ingest(
                    session,
                    workspaceId: params['workspaceId'],
                    deviceId: params['deviceId'],
                    scans: params['scans'],
                  ),
        ),
        'records': _is.MethodConnector(
          name: 'records',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'onlyPending': _is.ParameterDescription(
              name: 'onlyPending',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['offline'] as _ijohsxga.OfflineEndpoint).records(
                    session,
                    workspaceId: params['workspaceId'],
                    deviceId: params['deviceId'],
                    onlyPending: params['onlyPending'],
                    page: params['page'],
                    pageSize: params['pageSize'],
                  ),
        ),
        'convertNow': _is.MethodConnector(
          name: 'convertNow',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['offline'] as _ijohsxga.OfflineEndpoint)
                  .convertNow(
                    session,
                    workspaceId: params['workspaceId'],
                  ),
        ),
      },
    );
    connectors['product'] = _is.EndpointConnector(
      name: 'product',
      endpoint: endpoints['product']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'search': _is.ParameterDescription(
              name: 'search',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'includeArchived': _is.ParameterDescription(
              name: 'includeArchived',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _im5j1753.ProductEndpoint).list(
                    session,
                    workspaceId: params['workspaceId'],
                    search: params['search'],
                    includeArchived: params['includeArchived'],
                  ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'productId': _is.ParameterDescription(
              name: 'productId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _im5j1753.ProductEndpoint).get(
                    session,
                    params['productId'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'sku': _is.ParameterDescription(
              name: 'sku',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'imageUrls': _is.ParameterDescription(
              name: 'imageUrls',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
            'packaging': _is.ParameterDescription(
              name: 'packaging',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'shelfLife': _is.ParameterDescription(
              name: 'shelfLife',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'countryRestrictions': _is.ParameterDescription(
              name: 'countryRestrictions',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
            'safetyInstructions': _is.ParameterDescription(
              name: 'safetyInstructions',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _im5j1753.ProductEndpoint).create(
                    session,
                    workspaceId: params['workspaceId'],
                    name: params['name'],
                    sku: params['sku'],
                    category: params['category'],
                    description: params['description'],
                    imageUrls: params['imageUrls'],
                    packaging: params['packaging'],
                    shelfLife: params['shelfLife'],
                    countryRestrictions: params['countryRestrictions'],
                    safetyInstructions: params['safetyInstructions'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'productId': _is.ParameterDescription(
              name: 'productId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'sku': _is.ParameterDescription(
              name: 'sku',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'imageUrls': _is.ParameterDescription(
              name: 'imageUrls',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
            'packaging': _is.ParameterDescription(
              name: 'packaging',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'shelfLife': _is.ParameterDescription(
              name: 'shelfLife',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'countryRestrictions': _is.ParameterDescription(
              name: 'countryRestrictions',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
            'safetyInstructions': _is.ParameterDescription(
              name: 'safetyInstructions',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _im5j1753.ProductEndpoint).update(
                    session,
                    productId: params['productId'],
                    name: params['name'],
                    sku: params['sku'],
                    category: params['category'],
                    description: params['description'],
                    imageUrls: params['imageUrls'],
                    packaging: params['packaging'],
                    shelfLife: params['shelfLife'],
                    countryRestrictions: params['countryRestrictions'],
                    safetyInstructions: params['safetyInstructions'],
                  ),
        ),
        'archive': _is.MethodConnector(
          name: 'archive',
          params: {
            'productId': _is.ParameterDescription(
              name: 'productId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _im5j1753.ProductEndpoint).archive(
                    session,
                    params['productId'],
                  ),
        ),
      },
    );
    connectors['recall'] = _is.EndpointConnector(
      name: 'recall',
      endpoint: endpoints['recall']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'includeLifted': _is.ParameterDescription(
              name: 'includeLifted',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recall'] as _i1x4z1h3.RecallEndpoint).list(
                session,
                workspaceId: params['workspaceId'],
                includeLifted: params['includeLifted'],
              ),
        ),
        'recallBatch': _is.MethodConnector(
          name: 'recallBatch',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'notes': _is.ParameterDescription(
              name: 'notes',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['recall'] as _i1x4z1h3.RecallEndpoint).recallBatch(
                    session,
                    workspaceId: params['workspaceId'],
                    batchId: params['batchId'],
                    reason: params['reason'],
                    notes: params['notes'],
                  ),
        ),
        'recallIdentity': _is.MethodConnector(
          name: 'recallIdentity',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'identityId': _is.ParameterDescription(
              name: 'identityId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'notes': _is.ParameterDescription(
              name: 'notes',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recall'] as _i1x4z1h3.RecallEndpoint)
                  .recallIdentity(
                    session,
                    workspaceId: params['workspaceId'],
                    identityId: params['identityId'],
                    reason: params['reason'],
                    notes: params['notes'],
                  ),
        ),
        'lift': _is.MethodConnector(
          name: 'lift',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'recallId': _is.ParameterDescription(
              name: 'recallId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['recall'] as _i1x4z1h3.RecallEndpoint).lift(
                session,
                workspaceId: params['workspaceId'],
                recallId: params['recallId'],
                note: params['note'],
              ),
        ),
      },
    );
    connectors['simulation'] = _is.EndpointConnector(
      name: 'simulation',
      endpoint: endpoints['simulation']!,
      methodConnectors: {
        'start': _is.MethodConnector(
          name: 'start',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_ipsf1cgw.SimulationRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint)
                      .start(
                        session,
                        workspaceId: params['workspaceId'],
                        request: params['request'],
                      ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint)
                      .list(
                        session,
                        workspaceId: params['workspaceId'],
                        page: params['page'],
                        pageSize: params['pageSize'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'simulationId': _is.ParameterDescription(
              name: 'simulationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint).get(
                    session,
                    params['simulationId'],
                  ),
        ),
        'step': _is.MethodConnector(
          name: 'step',
          params: {
            'simulationId': _is.ParameterDescription(
              name: 'simulationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint)
                      .step(
                        session,
                        params['simulationId'],
                      ),
        ),
        'run': _is.MethodConnector(
          name: 'run',
          params: {
            'simulationId': _is.ParameterDescription(
              name: 'simulationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint).run(
                    session,
                    params['simulationId'],
                  ),
        ),
        'cancel': _is.MethodConnector(
          name: 'cancel',
          params: {
            'simulationId': _is.ParameterDescription(
              name: 'simulationId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['simulation'] as _i0zgu2b0.SimulationEndpoint)
                      .cancel(
                        session,
                        params['simulationId'],
                      ),
        ),
      },
    );
    connectors['verification'] = _is.EndpointConnector(
      name: 'verification',
      endpoint: endpoints['verification']!,
      methodConnectors: {
        'start': _is.MethodConnector(
          name: 'start',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'deviceFingerprint': _is.ParameterDescription(
              name: 'deviceFingerprint',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                      .start(
                        session,
                        params['token'],
                        params['deviceFingerprint'],
                      ),
        ),
        'acknowledge': _is.MethodConnector(
          name: 'acknowledge',
          params: {
            'sessionId': _is.ParameterDescription(
              name: 'sessionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'deviceFingerprint': _is.ParameterDescription(
              name: 'deviceFingerprint',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                      .acknowledge(
                        session,
                        params['sessionId'],
                        params['deviceFingerprint'],
                      ),
        ),
        'submitPin': _is.MethodConnector(
          name: 'submitPin',
          params: {
            'sessionId': _is.ParameterDescription(
              name: 'sessionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'deviceFingerprint': _is.ParameterDescription(
              name: 'deviceFingerprint',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'pin': _is.ParameterDescription(
              name: 'pin',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                      .submitPin(
                        session,
                        params['sessionId'],
                        params['deviceFingerprint'],
                        params['pin'],
                      ),
        ),
        'result': _is.MethodConnector(
          name: 'result',
          params: {
            'sessionId': _is.ParameterDescription(
              name: 'sessionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'deviceFingerprint': _is.ParameterDescription(
              name: 'deviceFingerprint',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                      .result(
                        session,
                        params['sessionId'],
                        params['deviceFingerprint'],
                      ),
        ),
        'reportFake': _is.MethodConnector(
          name: 'reportFake',
          params: {
            'sessionId': _is.ParameterDescription(
              name: 'sessionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'deviceFingerprint': _is.ParameterDescription(
              name: 'deviceFingerprint',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'comment': _is.ParameterDescription(
              name: 'comment',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                      .reportFake(
                        session,
                        params['sessionId'],
                        params['deviceFingerprint'],
                        params['reason'],
                        comment: params['comment'],
                      ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'identityId': _is.ParameterDescription(
              name: 'identityId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'state': _is.ParameterDescription(
              name: 'state',
              type: _is.getType<_iewd06xu.VerificationState?>(),
              nullable: true,
            ),
            'outcome': _is.ParameterDescription(
              name: 'outcome',
              type: _is.getType<_i0trd2wt.VerificationOutcome?>(),
              nullable: true,
            ),
            'riskScore': _is.ParameterDescription(
              name: 'riskScore',
              type: _is.getType<_ijv8khy1.RiskScore?>(),
              nullable: true,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<_iccccaf9.ScanSource?>(),
              nullable: true,
            ),
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                      .list(
                        session,
                        workspaceId: params['workspaceId'],
                        identityId: params['identityId'],
                        batchId: params['batchId'],
                        state: params['state'],
                        outcome: params['outcome'],
                        riskScore: params['riskScore'],
                        source: params['source'],
                        from: params['from'],
                        to: params['to'],
                        page: params['page'],
                        pageSize: params['pageSize'],
                      ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'sessionId': _is.ParameterDescription(
              name: 'sessionId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                      .get(
                        session,
                        params['sessionId'],
                      ),
        ),
        'watchWorkspace': _is.MethodStreamConnector(
          name: 'watchWorkspace',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                  .watchWorkspace(
                    session,
                    workspaceId: params['workspaceId'],
                  ),
        ),
      },
    );
    connectors['webhookAdmin'] = _is.EndpointConnector(
      name: 'webhookAdmin',
      endpoint: endpoints['webhookAdmin']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhookAdmin'] as _iuee9j31.WebhookAdminEndpoint)
                      .list(
                        session,
                        workspaceId: params['workspaceId'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'url': _is.ParameterDescription(
              name: 'url',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'events': _is.ParameterDescription(
              name: 'events',
              type: _is.getType<List<_i9gqphv7.WebhookEventType>>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhookAdmin'] as _iuee9j31.WebhookAdminEndpoint)
                      .create(
                        session,
                        workspaceId: params['workspaceId'],
                        url: params['url'],
                        events: params['events'],
                        description: params['description'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'endpointId': _is.ParameterDescription(
              name: 'endpointId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'url': _is.ParameterDescription(
              name: 'url',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'events': _is.ParameterDescription(
              name: 'events',
              type: _is.getType<List<_i9gqphv7.WebhookEventType>?>(),
              nullable: true,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'enabled': _is.ParameterDescription(
              name: 'enabled',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhookAdmin'] as _iuee9j31.WebhookAdminEndpoint)
                      .update(
                        session,
                        workspaceId: params['workspaceId'],
                        endpointId: params['endpointId'],
                        url: params['url'],
                        events: params['events'],
                        description: params['description'],
                        enabled: params['enabled'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'endpointId': _is.ParameterDescription(
              name: 'endpointId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhookAdmin'] as _iuee9j31.WebhookAdminEndpoint)
                      .delete(
                        session,
                        workspaceId: params['workspaceId'],
                        endpointId: params['endpointId'],
                      ),
        ),
        'rotateSecret': _is.MethodConnector(
          name: 'rotateSecret',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'endpointId': _is.ParameterDescription(
              name: 'endpointId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhookAdmin'] as _iuee9j31.WebhookAdminEndpoint)
                      .rotateSecret(
                        session,
                        workspaceId: params['workspaceId'],
                        endpointId: params['endpointId'],
                      ),
        ),
        'test': _is.MethodConnector(
          name: 'test',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'endpointId': _is.ParameterDescription(
              name: 'endpointId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhookAdmin'] as _iuee9j31.WebhookAdminEndpoint)
                      .test(
                        session,
                        workspaceId: params['workspaceId'],
                        endpointId: params['endpointId'],
                      ),
        ),
        'deliveries': _is.MethodConnector(
          name: 'deliveries',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'endpointId': _is.ParameterDescription(
              name: 'endpointId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'pageSize': _is.ParameterDescription(
              name: 'pageSize',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhookAdmin'] as _iuee9j31.WebhookAdminEndpoint)
                      .deliveries(
                        session,
                        workspaceId: params['workspaceId'],
                        endpointId: params['endpointId'],
                        page: params['page'],
                        pageSize: params['pageSize'],
                      ),
        ),
        'redeliver': _is.MethodConnector(
          name: 'redeliver',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'deliveryId': _is.ParameterDescription(
              name: 'deliveryId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhookAdmin'] as _iuee9j31.WebhookAdminEndpoint)
                      .redeliver(
                        session,
                        workspaceId: params['workspaceId'],
                        deliveryId: params['deliveryId'],
                      ),
        ),
        'drainNow': _is.MethodConnector(
          name: 'drainNow',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['webhookAdmin'] as _iuee9j31.WebhookAdminEndpoint)
                      .drainNow(
                        session,
                        workspaceId: params['workspaceId'],
                      ),
        ),
      },
    );
    connectors['workspace'] = _is.EndpointConnector(
      name: 'workspace',
      endpoint: endpoints['workspace']!,
      methodConnectors: {
        'bootstrap': _is.MethodConnector(
          name: 'bootstrap',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .bootstrap(
                    session,
                    workspaceId: params['workspaceId'],
                  ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'authenticMessage': _is.ParameterDescription(
              name: 'authenticMessage',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'branding': _is.ParameterDescription(
              name: 'branding',
              type: _is.getType<_i7nf0hkx.Branding?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .create(
                    session,
                    params['name'],
                    email: params['email'],
                    authenticMessage: params['authenticMessage'],
                    branding: params['branding'],
                  ),
        ),
        'joinDemo': _is.MethodConnector(
          name: 'joinDemo',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .joinDemo(
                    session,
                    email: params['email'],
                    displayName: params['displayName'],
                  ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'branding': _is.ParameterDescription(
              name: 'branding',
              type: _is.getType<_i7nf0hkx.Branding?>(),
              nullable: true,
            ),
            'authenticMessage': _is.ParameterDescription(
              name: 'authenticMessage',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'restrictedCountries': _is.ParameterDescription(
              name: 'restrictedCountries',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
            'fraudPolicy': _is.ParameterDescription(
              name: 'fraudPolicy',
              type: _is.getType<_il8b5wgn.FraudPolicy?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .update(
                    session,
                    workspaceId: params['workspaceId'],
                    name: params['name'],
                    branding: params['branding'],
                    authenticMessage: params['authenticMessage'],
                    restrictedCountries: params['restrictedCountries'],
                    fraudPolicy: params['fraudPolicy'],
                  ),
        ),
        'members': _is.MethodConnector(
          name: 'members',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .members(
                    session,
                    workspaceId: params['workspaceId'],
                  ),
        ),
        'invitations': _is.MethodConnector(
          name: 'invitations',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .invitations(
                    session,
                    workspaceId: params['workspaceId'],
                  ),
        ),
        'invite': _is.MethodConnector(
          name: 'invite',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<_i5ttnrmb.MembershipRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .invite(
                    session,
                    workspaceId: params['workspaceId'],
                    email: params['email'],
                    role: params['role'],
                  ),
        ),
        'acceptInvitation': _is.MethodConnector(
          name: 'acceptInvitation',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'displayName': _is.ParameterDescription(
              name: 'displayName',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .acceptInvitation(
                    session,
                    params['code'],
                    displayName: params['displayName'],
                  ),
        ),
        'changeRole': _is.MethodConnector(
          name: 'changeRole',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'memberId': _is.ParameterDescription(
              name: 'memberId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<_i5ttnrmb.MembershipRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .changeRole(
                    session,
                    workspaceId: params['workspaceId'],
                    memberId: params['memberId'],
                    role: params['role'],
                  ),
        ),
        'removeMember': _is.MethodConnector(
          name: 'removeMember',
          params: {
            'workspaceId': _is.ParameterDescription(
              name: 'workspaceId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'memberId': _is.ParameterDescription(
              name: 'memberId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workspace'] as _i9dwb32i.WorkspaceEndpoint)
                  .removeMember(
                    session,
                    workspaceId: params['workspaceId'],
                    memberId: params['memberId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_offline_sync'] = _izehhkf5.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _i4legp06.FutureCalls();
  }
}
