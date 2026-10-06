/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fauxshield_client/src/protocol/audit/audit_event.dart'
    as _io3c3iqw;
import 'package:fauxshield_client/src/protocol/consumer/fake_report.dart'
    as _idlr7y3f;
import 'package:fauxshield_client/src/protocol/core/batch.dart' as _i21v2c5t;
import 'package:fauxshield_client/src/protocol/core/invitation.dart'
    as _iqkhv8xa;
import 'package:fauxshield_client/src/protocol/core/product.dart' as _i1hi8dz8;
import 'package:fauxshield_client/src/protocol/core/product_identity.dart'
    as _ixvcz44n;
import 'package:fauxshield_client/src/protocol/core/workspace_member.dart'
    as _ibftlimb;
import 'package:fauxshield_client/src/protocol/developer/api_key.dart'
    as _iwojdd5g;
import 'package:fauxshield_client/src/protocol/enums/api_scope.dart'
    as _it7hafj0;
import 'package:fauxshield_client/src/protocol/enums/webhook_event_type.dart'
    as _igt5gq18;
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
import 'package:fauxshield_client/src/protocol/simulation/attack_simulation.dart'
    as _i6gmjpvp;
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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_offline_sync_client/serverpod_offline_sync_client.dart'
    as _ipulbpi2;
import 'analytics/alert_evidence.dart' as _i09kiuij;
import 'analytics/country_stat.dart' as _id0erzw8;
import 'analytics/daily_workspace_stat.dart' as _ir3252k5;
import 'analytics/dashboard_summary.dart' as _idkfvn2o;
import 'analytics/outcome_breakdown.dart' as _imv9g80f;
import 'analytics/trend_point.dart' as _idmb7f0s;
import 'audit/audit_event.dart' as _ijhj7cd7;
import 'consumer/fake_report.dart' as _igwpf6a9;
import 'consumer/report_acknowledgement.dart' as _iivg4vhm;
import 'consumer/verification_presentation.dart' as _ifwvtvcv;
import 'core/batch.dart' as _it6ouhsz;
import 'core/batch_stats.dart' as _icosogup;
import 'core/branding.dart' as _iu6qs3c1;
import 'core/export_file.dart' as _idher2i7;
import 'core/fraud_policy.dart' as _i9rh8zdx;
import 'core/identity_generation_result.dart' as _im6cjy38;
import 'core/invitation.dart' as _ih8fc9d7;
import 'core/invitation_created.dart' as _iq5lw9lm;
import 'core/product.dart' as _iete5svs;
import 'core/product_identity.dart' as _ikjtxbyt;
import 'core/revealed_pin.dart' as _iayv1jn2;
import 'core/workspace.dart' as _isqjmtap;
import 'core/workspace_bootstrap.dart' as _i4fe8s18;
import 'core/workspace_member.dart' as _iy9pnr9b;
import 'developer/api_key.dart' as _i8e18jmo;
import 'developer/api_key_secret.dart' as _ikfhqlb8;
import 'developer/idempotency_record.dart' as _igmv16kr;
import 'enums/actor_type.dart' as _ip5zeyz4;
import 'enums/alert_severity.dart' as _i3a9pkcg;
import 'enums/alert_status.dart' as _i1bqmbyx;
import 'enums/api_scope.dart' as _i1koc1zv;
import 'enums/batch_status.dart' as _ibyne1i7;
import 'enums/delivery_status.dart' as _iz7e19vi;
import 'enums/export_format.dart' as _ijd8w0t7;
import 'enums/fake_report_status.dart' as _i1fa3fps;
import 'enums/geo_provider.dart' as _ir9cucp3;
import 'enums/identity_status.dart' as _i179y4kh;
import 'enums/invitation_status.dart' as _ip3w1npx;
import 'enums/live_event_type.dart' as _ipzoi2qu;
import 'enums/membership_role.dart' as _il8xkfgj;
import 'enums/notification_channel.dart' as _i4t3y1v6;
import 'enums/notification_type.dart' as _ij5x7qg1;
import 'enums/recall_scope.dart' as _ilbx1l14;
import 'enums/risk_score.dart' as _i0f0rhgt;
import 'enums/scan_source.dart' as _ilzrh17n;
import 'enums/signal_type.dart' as _ic7z0e71;
import 'enums/simulation_status.dart' as _i1zs3mr7;
import 'enums/simulation_type.dart' as _ibgf5q6i;
import 'enums/verification_error_reason.dart' as _iek21z57;
import 'enums/verification_outcome.dart' as _iiagya0k;
import 'enums/verification_state.dart' as _ibg9yx9r;
import 'enums/webhook_event_type.dart' as _it82pxed;
import 'exceptions/api_exception.dart' as _izu3utj1;
import 'live/live_event.dart' as _ixdzvre4;
import 'notifications/notification.dart' as _i04nwpv1;
import 'notifications/notification_preference.dart' as _iiy1iwm4;
import 'offline/inspector_cache_entry.dart' as _iy4nxf6j;
import 'offline/inspector_catalog.dart' as _i93xvsby;
import 'offline/inspector_catalog_entry.dart' as _isczefpn;
import 'offline/offline_scan_input.dart' as _iuflj21f;
import 'offline/offline_scan_record.dart' as _iilhba84;
import 'offline/offline_scan_verdict.dart' as _ib308dyl;
import 'offline/queued_fake_report.dart' as _iuxkpdfb;
import 'recall/recall_record.dart' as _i50bgiqt;
import 'recall/recall_result.dart' as _ievmhhxi;
import 'simulation/attack_simulation.dart' as _il0a365u;
import 'simulation/simulation_request.dart' as _iuyotoq1;
import 'simulation/simulation_step_request.dart' as _ib1sdcsu;
import 'verification/fraud_alert.dart' as _ig81gt99;
import 'verification/fraud_signal_record.dart' as _isoxjppc;
import 'verification/geo_summary.dart' as _ifwruwpv;
import 'verification/verification_session.dart' as _istm7uyq;
import 'webhooks/webhook_delivery.dart' as _ihdj754n;
import 'webhooks/webhook_endpoint.dart' as _inja8klw;
import 'webhooks/webhook_endpoint_secret.dart' as _is8j7ehc;
import 'webhooks/webhook_test_result.dart' as _idplbrdl;
export 'analytics/alert_evidence.dart';
export 'analytics/country_stat.dart';
export 'analytics/daily_workspace_stat.dart';
export 'analytics/dashboard_summary.dart';
export 'analytics/outcome_breakdown.dart';
export 'analytics/trend_point.dart';
export 'audit/audit_event.dart';
export 'consumer/fake_report.dart';
export 'consumer/report_acknowledgement.dart';
export 'consumer/verification_presentation.dart';
export 'core/batch.dart';
export 'core/batch_stats.dart';
export 'core/branding.dart';
export 'core/export_file.dart';
export 'core/fraud_policy.dart';
export 'core/identity_generation_result.dart';
export 'core/invitation.dart';
export 'core/invitation_created.dart';
export 'core/product.dart';
export 'core/product_identity.dart';
export 'core/revealed_pin.dart';
export 'core/workspace.dart';
export 'core/workspace_bootstrap.dart';
export 'core/workspace_member.dart';
export 'developer/api_key.dart';
export 'developer/api_key_secret.dart';
export 'developer/idempotency_record.dart';
export 'enums/actor_type.dart';
export 'enums/alert_severity.dart';
export 'enums/alert_status.dart';
export 'enums/api_scope.dart';
export 'enums/batch_status.dart';
export 'enums/delivery_status.dart';
export 'enums/export_format.dart';
export 'enums/fake_report_status.dart';
export 'enums/geo_provider.dart';
export 'enums/identity_status.dart';
export 'enums/invitation_status.dart';
export 'enums/live_event_type.dart';
export 'enums/membership_role.dart';
export 'enums/notification_channel.dart';
export 'enums/notification_type.dart';
export 'enums/recall_scope.dart';
export 'enums/risk_score.dart';
export 'enums/scan_source.dart';
export 'enums/signal_type.dart';
export 'enums/simulation_status.dart';
export 'enums/simulation_type.dart';
export 'enums/verification_error_reason.dart';
export 'enums/verification_outcome.dart';
export 'enums/verification_state.dart';
export 'enums/webhook_event_type.dart';
export 'exceptions/api_exception.dart';
export 'live/live_event.dart';
export 'notifications/notification.dart';
export 'notifications/notification_preference.dart';
export 'offline/inspector_cache_entry.dart';
export 'offline/inspector_catalog.dart';
export 'offline/inspector_catalog_entry.dart';
export 'offline/offline_scan_input.dart';
export 'offline/offline_scan_record.dart';
export 'offline/offline_scan_verdict.dart';
export 'offline/queued_fake_report.dart';
export 'recall/recall_record.dart';
export 'recall/recall_result.dart';
export 'simulation/attack_simulation.dart';
export 'simulation/simulation_request.dart';
export 'simulation/simulation_step_request.dart';
export 'verification/fraud_alert.dart';
export 'verification/fraud_signal_record.dart';
export 'verification/geo_summary.dart';
export 'verification/verification_session.dart';
export 'webhooks/webhook_delivery.dart';
export 'webhooks/webhook_endpoint.dart';
export 'webhooks/webhook_endpoint_secret.dart';
export 'webhooks/webhook_test_result.dart';
export 'client.dart';
export 'sync_tables.dart';

class Protocol extends _isd.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isd.TableDefinition> get targetTableDefinitions => [
    _isd.TableDefinition(
      name: 'inspector_cache_entry',
      dartName: 'InspectorCacheEntry',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isd.ColumnDefinition(
          name: 'identityId',
          columnType: _isd.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isd.ColumnDefinition(
          name: 'qrToken',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'productName',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'sku',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'productDescription',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'imageUrlsJson',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'packaging',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'shelfLife',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'countryRestrictionsJson',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'safetyInstructions',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'batchReference',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'batchStatus',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BatchStatus',
        ),
        _isd.ColumnDefinition(
          name: 'manufactureDate',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isd.ColumnDefinition(
          name: 'distributionRegion',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'identityStatus',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:IdentityStatus',
        ),
        _isd.ColumnDefinition(
          name: 'recallReason',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'recalledAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isd.ColumnDefinition(
          name: 'refreshedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'inspector_cache_entry__identityId__unique_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'identityId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'offline_scan_record',
      dartName: 'OfflineScanRecord',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isd.ColumnDefinition(
          name: 'spaceId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isd.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isd.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isd.ColumnDefinition(
          name: 'deviceId',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'deviceFingerprint',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'identityId',
          columnType: _isd.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isd.ColumnDefinition(
          name: 'qrToken',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'scannedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isd.ColumnDefinition(
          name: 'latitude',
          columnType: _isd.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isd.ColumnDefinition(
          name: 'longitude',
          columnType: _isd.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isd.ColumnDefinition(
          name: 'country',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'city',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'provisionalOutcome',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'processed',
          columnType: _isd.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isd.ColumnDefinition(
          name: 'processedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isd.ColumnDefinition(
          name: 'verdictJson',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'createdAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'offline_scan_record_fk_0',
          columns: ['spaceId'],
          referenceTable: 'offline_sync_spaces',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'offline_scan_processed_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'processed',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'queued_fake_report',
      dartName: 'QueuedFakeReport',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isd.ColumnDefinition(
          name: 'identityId',
          columnType: _isd.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isd.ColumnDefinition(
          name: 'qrToken',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'reason',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'comment',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'photoLocalPath',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'createdAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isd.ColumnDefinition(
          name: 'synced',
          columnType: _isd.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isd.ColumnDefinition(
          name: 'syncedAt',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isd.ColumnDefinition(
          name: 'lastError',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    ..._iaic.Protocol() is _isd.DatabaseSerializationManager
        ? (_iaic.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._ipulbpi2.Protocol() is _isd.DatabaseSerializationManager
        ? (_ipulbpi2.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._iacc.Protocol() is _isd.DatabaseSerializationManager
        ? (_iacc.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i09kiuij.AlertEvidence) {
      return _i09kiuij.AlertEvidence.fromJson(data) as T;
    }
    if (t == _id0erzw8.CountryStat) {
      return _id0erzw8.CountryStat.fromJson(data) as T;
    }
    if (t == _ir3252k5.DailyWorkspaceStat) {
      return _ir3252k5.DailyWorkspaceStat.fromJson(data) as T;
    }
    if (t == _idkfvn2o.DashboardSummary) {
      return _idkfvn2o.DashboardSummary.fromJson(data) as T;
    }
    if (t == _imv9g80f.OutcomeBreakdown) {
      return _imv9g80f.OutcomeBreakdown.fromJson(data) as T;
    }
    if (t == _idmb7f0s.TrendPoint) {
      return _idmb7f0s.TrendPoint.fromJson(data) as T;
    }
    if (t == _ijhj7cd7.AuditEvent) {
      return _ijhj7cd7.AuditEvent.fromJson(data) as T;
    }
    if (t == _igwpf6a9.FakeReport) {
      return _igwpf6a9.FakeReport.fromJson(data) as T;
    }
    if (t == _iivg4vhm.ReportAcknowledgement) {
      return _iivg4vhm.ReportAcknowledgement.fromJson(data) as T;
    }
    if (t == _ifwvtvcv.VerificationPresentation) {
      return _ifwvtvcv.VerificationPresentation.fromJson(data) as T;
    }
    if (t == _it6ouhsz.Batch) {
      return _it6ouhsz.Batch.fromJson(data) as T;
    }
    if (t == _icosogup.BatchStats) {
      return _icosogup.BatchStats.fromJson(data) as T;
    }
    if (t == _iu6qs3c1.Branding) {
      return _iu6qs3c1.Branding.fromJson(data) as T;
    }
    if (t == _idher2i7.ExportFile) {
      return _idher2i7.ExportFile.fromJson(data) as T;
    }
    if (t == _i9rh8zdx.FraudPolicy) {
      return _i9rh8zdx.FraudPolicy.fromJson(data) as T;
    }
    if (t == _im6cjy38.IdentityGenerationResult) {
      return _im6cjy38.IdentityGenerationResult.fromJson(data) as T;
    }
    if (t == _ih8fc9d7.Invitation) {
      return _ih8fc9d7.Invitation.fromJson(data) as T;
    }
    if (t == _iq5lw9lm.InvitationCreated) {
      return _iq5lw9lm.InvitationCreated.fromJson(data) as T;
    }
    if (t == _iete5svs.Product) {
      return _iete5svs.Product.fromJson(data) as T;
    }
    if (t == _ikjtxbyt.ProductIdentity) {
      return _ikjtxbyt.ProductIdentity.fromJson(data) as T;
    }
    if (t == _iayv1jn2.RevealedPin) {
      return _iayv1jn2.RevealedPin.fromJson(data) as T;
    }
    if (t == _isqjmtap.Workspace) {
      return _isqjmtap.Workspace.fromJson(data) as T;
    }
    if (t == _i4fe8s18.WorkspaceBootstrap) {
      return _i4fe8s18.WorkspaceBootstrap.fromJson(data) as T;
    }
    if (t == _iy9pnr9b.WorkspaceMember) {
      return _iy9pnr9b.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i8e18jmo.ApiKey) {
      return _i8e18jmo.ApiKey.fromJson(data) as T;
    }
    if (t == _ikfhqlb8.ApiKeySecret) {
      return _ikfhqlb8.ApiKeySecret.fromJson(data) as T;
    }
    if (t == _igmv16kr.IdempotencyRecord) {
      return _igmv16kr.IdempotencyRecord.fromJson(data) as T;
    }
    if (t == _ip5zeyz4.ActorType) {
      return _ip5zeyz4.ActorType.fromJson(data) as T;
    }
    if (t == _i3a9pkcg.AlertSeverity) {
      return _i3a9pkcg.AlertSeverity.fromJson(data) as T;
    }
    if (t == _i1bqmbyx.AlertStatus) {
      return _i1bqmbyx.AlertStatus.fromJson(data) as T;
    }
    if (t == _i1koc1zv.ApiScope) {
      return _i1koc1zv.ApiScope.fromJson(data) as T;
    }
    if (t == _ibyne1i7.BatchStatus) {
      return _ibyne1i7.BatchStatus.fromJson(data) as T;
    }
    if (t == _iz7e19vi.DeliveryStatus) {
      return _iz7e19vi.DeliveryStatus.fromJson(data) as T;
    }
    if (t == _ijd8w0t7.ExportFormat) {
      return _ijd8w0t7.ExportFormat.fromJson(data) as T;
    }
    if (t == _i1fa3fps.FakeReportStatus) {
      return _i1fa3fps.FakeReportStatus.fromJson(data) as T;
    }
    if (t == _ir9cucp3.GeoProvider) {
      return _ir9cucp3.GeoProvider.fromJson(data) as T;
    }
    if (t == _i179y4kh.IdentityStatus) {
      return _i179y4kh.IdentityStatus.fromJson(data) as T;
    }
    if (t == _ip3w1npx.InvitationStatus) {
      return _ip3w1npx.InvitationStatus.fromJson(data) as T;
    }
    if (t == _ipzoi2qu.LiveEventType) {
      return _ipzoi2qu.LiveEventType.fromJson(data) as T;
    }
    if (t == _il8xkfgj.MembershipRole) {
      return _il8xkfgj.MembershipRole.fromJson(data) as T;
    }
    if (t == _i4t3y1v6.NotificationChannel) {
      return _i4t3y1v6.NotificationChannel.fromJson(data) as T;
    }
    if (t == _ij5x7qg1.NotificationType) {
      return _ij5x7qg1.NotificationType.fromJson(data) as T;
    }
    if (t == _ilbx1l14.RecallScope) {
      return _ilbx1l14.RecallScope.fromJson(data) as T;
    }
    if (t == _i0f0rhgt.RiskScore) {
      return _i0f0rhgt.RiskScore.fromJson(data) as T;
    }
    if (t == _ilzrh17n.ScanSource) {
      return _ilzrh17n.ScanSource.fromJson(data) as T;
    }
    if (t == _ic7z0e71.SignalType) {
      return _ic7z0e71.SignalType.fromJson(data) as T;
    }
    if (t == _i1zs3mr7.SimulationStatus) {
      return _i1zs3mr7.SimulationStatus.fromJson(data) as T;
    }
    if (t == _ibgf5q6i.SimulationType) {
      return _ibgf5q6i.SimulationType.fromJson(data) as T;
    }
    if (t == _iek21z57.VerificationErrorReason) {
      return _iek21z57.VerificationErrorReason.fromJson(data) as T;
    }
    if (t == _iiagya0k.VerificationOutcome) {
      return _iiagya0k.VerificationOutcome.fromJson(data) as T;
    }
    if (t == _ibg9yx9r.VerificationState) {
      return _ibg9yx9r.VerificationState.fromJson(data) as T;
    }
    if (t == _it82pxed.WebhookEventType) {
      return _it82pxed.WebhookEventType.fromJson(data) as T;
    }
    if (t == _izu3utj1.AuthenticationException) {
      return _izu3utj1.AuthenticationException.fromJson(data) as T;
    }
    if (t == _izu3utj1.ConflictException) {
      return _izu3utj1.ConflictException.fromJson(data) as T;
    }
    if (t == _izu3utj1.NotFoundException) {
      return _izu3utj1.NotFoundException.fromJson(data) as T;
    }
    if (t == _izu3utj1.RateLimitException) {
      return _izu3utj1.RateLimitException.fromJson(data) as T;
    }
    if (t == _izu3utj1.ServiceUnavailableException) {
      return _izu3utj1.ServiceUnavailableException.fromJson(data) as T;
    }
    if (t == _izu3utj1.ValidationException) {
      return _izu3utj1.ValidationException.fromJson(data) as T;
    }
    if (t == _izu3utj1.VerificationException) {
      return _izu3utj1.VerificationException.fromJson(data) as T;
    }
    if (t == _ixdzvre4.LiveEvent) {
      return _ixdzvre4.LiveEvent.fromJson(data) as T;
    }
    if (t == _i04nwpv1.Notification) {
      return _i04nwpv1.Notification.fromJson(data) as T;
    }
    if (t == _iiy1iwm4.NotificationPreference) {
      return _iiy1iwm4.NotificationPreference.fromJson(data) as T;
    }
    if (t == _iy4nxf6j.InspectorCacheEntry) {
      return _iy4nxf6j.InspectorCacheEntry.fromJson(data) as T;
    }
    if (t == _i93xvsby.InspectorCatalog) {
      return _i93xvsby.InspectorCatalog.fromJson(data) as T;
    }
    if (t == _isczefpn.InspectorCatalogEntry) {
      return _isczefpn.InspectorCatalogEntry.fromJson(data) as T;
    }
    if (t == _iuflj21f.OfflineScanInput) {
      return _iuflj21f.OfflineScanInput.fromJson(data) as T;
    }
    if (t == _iilhba84.OfflineScanRecord) {
      return _iilhba84.OfflineScanRecord.fromJson(data) as T;
    }
    if (t == _ib308dyl.OfflineScanVerdict) {
      return _ib308dyl.OfflineScanVerdict.fromJson(data) as T;
    }
    if (t == _iuxkpdfb.QueuedFakeReport) {
      return _iuxkpdfb.QueuedFakeReport.fromJson(data) as T;
    }
    if (t == _i50bgiqt.RecallRecord) {
      return _i50bgiqt.RecallRecord.fromJson(data) as T;
    }
    if (t == _ievmhhxi.RecallResult) {
      return _ievmhhxi.RecallResult.fromJson(data) as T;
    }
    if (t == _il0a365u.AttackSimulation) {
      return _il0a365u.AttackSimulation.fromJson(data) as T;
    }
    if (t == _iuyotoq1.SimulationRequest) {
      return _iuyotoq1.SimulationRequest.fromJson(data) as T;
    }
    if (t == _ib1sdcsu.SimulationStepRequest) {
      return _ib1sdcsu.SimulationStepRequest.fromJson(data) as T;
    }
    if (t == _ig81gt99.FraudAlert) {
      return _ig81gt99.FraudAlert.fromJson(data) as T;
    }
    if (t == _isoxjppc.FraudSignalRecord) {
      return _isoxjppc.FraudSignalRecord.fromJson(data) as T;
    }
    if (t == _ifwruwpv.GeoSummary) {
      return _ifwruwpv.GeoSummary.fromJson(data) as T;
    }
    if (t == _istm7uyq.VerificationSession) {
      return _istm7uyq.VerificationSession.fromJson(data) as T;
    }
    if (t == _ihdj754n.WebhookDelivery) {
      return _ihdj754n.WebhookDelivery.fromJson(data) as T;
    }
    if (t == _inja8klw.WebhookEndpoint) {
      return _inja8klw.WebhookEndpoint.fromJson(data) as T;
    }
    if (t == _is8j7ehc.WebhookEndpointSecret) {
      return _is8j7ehc.WebhookEndpointSecret.fromJson(data) as T;
    }
    if (t == _idplbrdl.WebhookTestResult) {
      return _idplbrdl.WebhookTestResult.fromJson(data) as T;
    }
    if (t == _isc.getType<_i09kiuij.AlertEvidence?>()) {
      return (data != null ? _i09kiuij.AlertEvidence.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_id0erzw8.CountryStat?>()) {
      return (data != null ? _id0erzw8.CountryStat.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ir3252k5.DailyWorkspaceStat?>()) {
      return (data != null ? _ir3252k5.DailyWorkspaceStat.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idkfvn2o.DashboardSummary?>()) {
      return (data != null ? _idkfvn2o.DashboardSummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_imv9g80f.OutcomeBreakdown?>()) {
      return (data != null ? _imv9g80f.OutcomeBreakdown.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idmb7f0s.TrendPoint?>()) {
      return (data != null ? _idmb7f0s.TrendPoint.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ijhj7cd7.AuditEvent?>()) {
      return (data != null ? _ijhj7cd7.AuditEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igwpf6a9.FakeReport?>()) {
      return (data != null ? _igwpf6a9.FakeReport.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iivg4vhm.ReportAcknowledgement?>()) {
      return (data != null
              ? _iivg4vhm.ReportAcknowledgement.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ifwvtvcv.VerificationPresentation?>()) {
      return (data != null
              ? _ifwvtvcv.VerificationPresentation.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_it6ouhsz.Batch?>()) {
      return (data != null ? _it6ouhsz.Batch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_icosogup.BatchStats?>()) {
      return (data != null ? _icosogup.BatchStats.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iu6qs3c1.Branding?>()) {
      return (data != null ? _iu6qs3c1.Branding.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idher2i7.ExportFile?>()) {
      return (data != null ? _idher2i7.ExportFile.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i9rh8zdx.FraudPolicy?>()) {
      return (data != null ? _i9rh8zdx.FraudPolicy.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_im6cjy38.IdentityGenerationResult?>()) {
      return (data != null
              ? _im6cjy38.IdentityGenerationResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ih8fc9d7.Invitation?>()) {
      return (data != null ? _ih8fc9d7.Invitation.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iq5lw9lm.InvitationCreated?>()) {
      return (data != null ? _iq5lw9lm.InvitationCreated.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iete5svs.Product?>()) {
      return (data != null ? _iete5svs.Product.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikjtxbyt.ProductIdentity?>()) {
      return (data != null ? _ikjtxbyt.ProductIdentity.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iayv1jn2.RevealedPin?>()) {
      return (data != null ? _iayv1jn2.RevealedPin.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isqjmtap.Workspace?>()) {
      return (data != null ? _isqjmtap.Workspace.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4fe8s18.WorkspaceBootstrap?>()) {
      return (data != null ? _i4fe8s18.WorkspaceBootstrap.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iy9pnr9b.WorkspaceMember?>()) {
      return (data != null ? _iy9pnr9b.WorkspaceMember.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8e18jmo.ApiKey?>()) {
      return (data != null ? _i8e18jmo.ApiKey.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikfhqlb8.ApiKeySecret?>()) {
      return (data != null ? _ikfhqlb8.ApiKeySecret.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igmv16kr.IdempotencyRecord?>()) {
      return (data != null ? _igmv16kr.IdempotencyRecord.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ip5zeyz4.ActorType?>()) {
      return (data != null ? _ip5zeyz4.ActorType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3a9pkcg.AlertSeverity?>()) {
      return (data != null ? _i3a9pkcg.AlertSeverity.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1bqmbyx.AlertStatus?>()) {
      return (data != null ? _i1bqmbyx.AlertStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1koc1zv.ApiScope?>()) {
      return (data != null ? _i1koc1zv.ApiScope.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibyne1i7.BatchStatus?>()) {
      return (data != null ? _ibyne1i7.BatchStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iz7e19vi.DeliveryStatus?>()) {
      return (data != null ? _iz7e19vi.DeliveryStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijd8w0t7.ExportFormat?>()) {
      return (data != null ? _ijd8w0t7.ExportFormat.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1fa3fps.FakeReportStatus?>()) {
      return (data != null ? _i1fa3fps.FakeReportStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ir9cucp3.GeoProvider?>()) {
      return (data != null ? _ir9cucp3.GeoProvider.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i179y4kh.IdentityStatus?>()) {
      return (data != null ? _i179y4kh.IdentityStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ip3w1npx.InvitationStatus?>()) {
      return (data != null ? _ip3w1npx.InvitationStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ipzoi2qu.LiveEventType?>()) {
      return (data != null ? _ipzoi2qu.LiveEventType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_il8xkfgj.MembershipRole?>()) {
      return (data != null ? _il8xkfgj.MembershipRole.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4t3y1v6.NotificationChannel?>()) {
      return (data != null
              ? _i4t3y1v6.NotificationChannel.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ij5x7qg1.NotificationType?>()) {
      return (data != null ? _ij5x7qg1.NotificationType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ilbx1l14.RecallScope?>()) {
      return (data != null ? _ilbx1l14.RecallScope.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0f0rhgt.RiskScore?>()) {
      return (data != null ? _i0f0rhgt.RiskScore.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ilzrh17n.ScanSource?>()) {
      return (data != null ? _ilzrh17n.ScanSource.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ic7z0e71.SignalType?>()) {
      return (data != null ? _ic7z0e71.SignalType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1zs3mr7.SimulationStatus?>()) {
      return (data != null ? _i1zs3mr7.SimulationStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibgf5q6i.SimulationType?>()) {
      return (data != null ? _ibgf5q6i.SimulationType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iek21z57.VerificationErrorReason?>()) {
      return (data != null
              ? _iek21z57.VerificationErrorReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iiagya0k.VerificationOutcome?>()) {
      return (data != null
              ? _iiagya0k.VerificationOutcome.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ibg9yx9r.VerificationState?>()) {
      return (data != null ? _ibg9yx9r.VerificationState.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_it82pxed.WebhookEventType?>()) {
      return (data != null ? _it82pxed.WebhookEventType.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izu3utj1.AuthenticationException?>()) {
      return (data != null
              ? _izu3utj1.AuthenticationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_izu3utj1.ConflictException?>()) {
      return (data != null ? _izu3utj1.ConflictException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izu3utj1.NotFoundException?>()) {
      return (data != null ? _izu3utj1.NotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izu3utj1.RateLimitException?>()) {
      return (data != null ? _izu3utj1.RateLimitException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izu3utj1.ServiceUnavailableException?>()) {
      return (data != null
              ? _izu3utj1.ServiceUnavailableException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_izu3utj1.ValidationException?>()) {
      return (data != null
              ? _izu3utj1.ValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_izu3utj1.VerificationException?>()) {
      return (data != null
              ? _izu3utj1.VerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ixdzvre4.LiveEvent?>()) {
      return (data != null ? _ixdzvre4.LiveEvent.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i04nwpv1.Notification?>()) {
      return (data != null ? _i04nwpv1.Notification.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iiy1iwm4.NotificationPreference?>()) {
      return (data != null
              ? _iiy1iwm4.NotificationPreference.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iy4nxf6j.InspectorCacheEntry?>()) {
      return (data != null
              ? _iy4nxf6j.InspectorCacheEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i93xvsby.InspectorCatalog?>()) {
      return (data != null ? _i93xvsby.InspectorCatalog.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_isczefpn.InspectorCatalogEntry?>()) {
      return (data != null
              ? _isczefpn.InspectorCatalogEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iuflj21f.OfflineScanInput?>()) {
      return (data != null ? _iuflj21f.OfflineScanInput.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iilhba84.OfflineScanRecord?>()) {
      return (data != null ? _iilhba84.OfflineScanRecord.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ib308dyl.OfflineScanVerdict?>()) {
      return (data != null ? _ib308dyl.OfflineScanVerdict.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iuxkpdfb.QueuedFakeReport?>()) {
      return (data != null ? _iuxkpdfb.QueuedFakeReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i50bgiqt.RecallRecord?>()) {
      return (data != null ? _i50bgiqt.RecallRecord.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ievmhhxi.RecallResult?>()) {
      return (data != null ? _ievmhhxi.RecallResult.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_il0a365u.AttackSimulation?>()) {
      return (data != null ? _il0a365u.AttackSimulation.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iuyotoq1.SimulationRequest?>()) {
      return (data != null ? _iuyotoq1.SimulationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ib1sdcsu.SimulationStepRequest?>()) {
      return (data != null
              ? _ib1sdcsu.SimulationStepRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ig81gt99.FraudAlert?>()) {
      return (data != null ? _ig81gt99.FraudAlert.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isoxjppc.FraudSignalRecord?>()) {
      return (data != null ? _isoxjppc.FraudSignalRecord.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ifwruwpv.GeoSummary?>()) {
      return (data != null ? _ifwruwpv.GeoSummary.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_istm7uyq.VerificationSession?>()) {
      return (data != null
              ? _istm7uyq.VerificationSession.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihdj754n.WebhookDelivery?>()) {
      return (data != null ? _ihdj754n.WebhookDelivery.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_inja8klw.WebhookEndpoint?>()) {
      return (data != null ? _inja8klw.WebhookEndpoint.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_is8j7ehc.WebhookEndpointSecret?>()) {
      return (data != null
              ? _is8j7ehc.WebhookEndpointSecret.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_idplbrdl.WebhookTestResult?>()) {
      return (data != null ? _idplbrdl.WebhookTestResult.fromJson(data) : null)
          as T;
    }
    if (t == List<_istm7uyq.VerificationSession>) {
      return (data as List)
              .map((e) => deserialize<_istm7uyq.VerificationSession>(e))
              .toList()
          as T;
    }
    if (t == List<_isoxjppc.FraudSignalRecord>) {
      return (data as List)
              .map((e) => deserialize<_isoxjppc.FraudSignalRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_igwpf6a9.FakeReport>) {
      return (data as List)
              .map((e) => deserialize<_igwpf6a9.FakeReport>(e))
              .toList()
          as T;
    }
    if (t == List<_idmb7f0s.TrendPoint>) {
      return (data as List)
              .map((e) => deserialize<_idmb7f0s.TrendPoint>(e))
              .toList()
          as T;
    }
    if (t == List<_id0erzw8.CountryStat>) {
      return (data as List)
              .map((e) => deserialize<_id0erzw8.CountryStat>(e))
              .toList()
          as T;
    }
    if (t == List<_imv9g80f.OutcomeBreakdown>) {
      return (data as List)
              .map((e) => deserialize<_imv9g80f.OutcomeBreakdown>(e))
              .toList()
          as T;
    }
    if (t == List<_ig81gt99.FraudAlert>) {
      return (data as List)
              .map((e) => deserialize<_ig81gt99.FraudAlert>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i1koc1zv.ApiScope>) {
      return (data as List)
              .map((e) => deserialize<_i1koc1zv.ApiScope>(e))
              .toList()
          as T;
    }
    if (t == List<_isczefpn.InspectorCatalogEntry>) {
      return (data as List)
              .map((e) => deserialize<_isczefpn.InspectorCatalogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_ic7z0e71.SignalType>) {
      return (data as List)
              .map((e) => deserialize<_ic7z0e71.SignalType>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_ic7z0e71.SignalType>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ic7z0e71.SignalType>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_it82pxed.WebhookEventType>) {
      return (data as List)
              .map((e) => deserialize<_it82pxed.WebhookEventType>(e))
              .toList()
          as T;
    }
    if (t == List<_ix1ezz04.FraudAlert>) {
      return (data as List)
              .map((e) => deserialize<_ix1ezz04.FraudAlert>(e))
              .toList()
          as T;
    }
    if (t == List<_i8aaj59z.FraudSignalRecord>) {
      return (data as List)
              .map((e) => deserialize<_i8aaj59z.FraudSignalRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_idlr7y3f.FakeReport>) {
      return (data as List)
              .map((e) => deserialize<_idlr7y3f.FakeReport>(e))
              .toList()
          as T;
    }
    if (t == List<_iwojdd5g.ApiKey>) {
      return (data as List)
              .map((e) => deserialize<_iwojdd5g.ApiKey>(e))
              .toList()
          as T;
    }
    if (t == List<_it7hafj0.ApiScope>) {
      return (data as List)
              .map((e) => deserialize<_it7hafj0.ApiScope>(e))
              .toList()
          as T;
    }
    if (t == List<_io3c3iqw.AuditEvent>) {
      return (data as List)
              .map((e) => deserialize<_io3c3iqw.AuditEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i21v2c5t.Batch>) {
      return (data as List).map((e) => deserialize<_i21v2c5t.Batch>(e)).toList()
          as T;
    }
    if (t == List<_ixvcz44n.ProductIdentity>) {
      return (data as List)
              .map((e) => deserialize<_ixvcz44n.ProductIdentity>(e))
              .toList()
          as T;
    }
    if (t == List<_i50jj726.Notification>) {
      return (data as List)
              .map((e) => deserialize<_i50jj726.Notification>(e))
              .toList()
          as T;
    }
    if (t == List<_i4zgz95d.NotificationPreference>) {
      return (data as List)
              .map((e) => deserialize<_i4zgz95d.NotificationPreference>(e))
              .toList()
          as T;
    }
    if (t == List<_ihel98ml.OfflineScanVerdict>) {
      return (data as List)
              .map((e) => deserialize<_ihel98ml.OfflineScanVerdict>(e))
              .toList()
          as T;
    }
    if (t == List<_ilt2qd01.OfflineScanInput>) {
      return (data as List)
              .map((e) => deserialize<_ilt2qd01.OfflineScanInput>(e))
              .toList()
          as T;
    }
    if (t == List<_itsezaya.OfflineScanRecord>) {
      return (data as List)
              .map((e) => deserialize<_itsezaya.OfflineScanRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_i1hi8dz8.Product>) {
      return (data as List)
              .map((e) => deserialize<_i1hi8dz8.Product>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _isc.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_iy78n2xm.RecallRecord>) {
      return (data as List)
              .map((e) => deserialize<_iy78n2xm.RecallRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_i6gmjpvp.AttackSimulation>) {
      return (data as List)
              .map((e) => deserialize<_i6gmjpvp.AttackSimulation>(e))
              .toList()
          as T;
    }
    if (t == List<_iizmtbtb.VerificationSession>) {
      return (data as List)
              .map((e) => deserialize<_iizmtbtb.VerificationSession>(e))
              .toList()
          as T;
    }
    if (t == List<_i5zhft3t.WebhookEndpoint>) {
      return (data as List)
              .map((e) => deserialize<_i5zhft3t.WebhookEndpoint>(e))
              .toList()
          as T;
    }
    if (t == List<_igt5gq18.WebhookEventType>) {
      return (data as List)
              .map((e) => deserialize<_igt5gq18.WebhookEventType>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_igt5gq18.WebhookEventType>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_igt5gq18.WebhookEventType>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i51qex9r.WebhookDelivery>) {
      return (data as List)
              .map((e) => deserialize<_i51qex9r.WebhookDelivery>(e))
              .toList()
          as T;
    }
    if (t == List<_ibftlimb.WorkspaceMember>) {
      return (data as List)
              .map((e) => deserialize<_ibftlimb.WorkspaceMember>(e))
              .toList()
          as T;
    }
    if (t == List<_iqkhv8xa.Invitation>) {
      return (data as List)
              .map((e) => deserialize<_iqkhv8xa.Invitation>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _ipulbpi2.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i09kiuij.AlertEvidence => 'AlertEvidence',
      _id0erzw8.CountryStat => 'CountryStat',
      _ir3252k5.DailyWorkspaceStat => 'DailyWorkspaceStat',
      _idkfvn2o.DashboardSummary => 'DashboardSummary',
      _imv9g80f.OutcomeBreakdown => 'OutcomeBreakdown',
      _idmb7f0s.TrendPoint => 'TrendPoint',
      _ijhj7cd7.AuditEvent => 'AuditEvent',
      _igwpf6a9.FakeReport => 'FakeReport',
      _iivg4vhm.ReportAcknowledgement => 'ReportAcknowledgement',
      _ifwvtvcv.VerificationPresentation => 'VerificationPresentation',
      _it6ouhsz.Batch => 'Batch',
      _icosogup.BatchStats => 'BatchStats',
      _iu6qs3c1.Branding => 'Branding',
      _idher2i7.ExportFile => 'ExportFile',
      _i9rh8zdx.FraudPolicy => 'FraudPolicy',
      _im6cjy38.IdentityGenerationResult => 'IdentityGenerationResult',
      _ih8fc9d7.Invitation => 'Invitation',
      _iq5lw9lm.InvitationCreated => 'InvitationCreated',
      _iete5svs.Product => 'Product',
      _ikjtxbyt.ProductIdentity => 'ProductIdentity',
      _iayv1jn2.RevealedPin => 'RevealedPin',
      _isqjmtap.Workspace => 'Workspace',
      _i4fe8s18.WorkspaceBootstrap => 'WorkspaceBootstrap',
      _iy9pnr9b.WorkspaceMember => 'WorkspaceMember',
      _i8e18jmo.ApiKey => 'ApiKey',
      _ikfhqlb8.ApiKeySecret => 'ApiKeySecret',
      _igmv16kr.IdempotencyRecord => 'IdempotencyRecord',
      _ip5zeyz4.ActorType => 'ActorType',
      _i3a9pkcg.AlertSeverity => 'AlertSeverity',
      _i1bqmbyx.AlertStatus => 'AlertStatus',
      _i1koc1zv.ApiScope => 'ApiScope',
      _ibyne1i7.BatchStatus => 'BatchStatus',
      _iz7e19vi.DeliveryStatus => 'DeliveryStatus',
      _ijd8w0t7.ExportFormat => 'ExportFormat',
      _i1fa3fps.FakeReportStatus => 'FakeReportStatus',
      _ir9cucp3.GeoProvider => 'GeoProvider',
      _i179y4kh.IdentityStatus => 'IdentityStatus',
      _ip3w1npx.InvitationStatus => 'InvitationStatus',
      _ipzoi2qu.LiveEventType => 'LiveEventType',
      _il8xkfgj.MembershipRole => 'MembershipRole',
      _i4t3y1v6.NotificationChannel => 'NotificationChannel',
      _ij5x7qg1.NotificationType => 'NotificationType',
      _ilbx1l14.RecallScope => 'RecallScope',
      _i0f0rhgt.RiskScore => 'RiskScore',
      _ilzrh17n.ScanSource => 'ScanSource',
      _ic7z0e71.SignalType => 'SignalType',
      _i1zs3mr7.SimulationStatus => 'SimulationStatus',
      _ibgf5q6i.SimulationType => 'SimulationType',
      _iek21z57.VerificationErrorReason => 'VerificationErrorReason',
      _iiagya0k.VerificationOutcome => 'VerificationOutcome',
      _ibg9yx9r.VerificationState => 'VerificationState',
      _it82pxed.WebhookEventType => 'WebhookEventType',
      _izu3utj1.AuthenticationException => 'AuthenticationException',
      _izu3utj1.ConflictException => 'ConflictException',
      _izu3utj1.NotFoundException => 'NotFoundException',
      _izu3utj1.RateLimitException => 'RateLimitException',
      _izu3utj1.ServiceUnavailableException => 'ServiceUnavailableException',
      _izu3utj1.ValidationException => 'ValidationException',
      _izu3utj1.VerificationException => 'VerificationException',
      _ixdzvre4.LiveEvent => 'LiveEvent',
      _i04nwpv1.Notification => 'Notification',
      _iiy1iwm4.NotificationPreference => 'NotificationPreference',
      _iy4nxf6j.InspectorCacheEntry => 'InspectorCacheEntry',
      _i93xvsby.InspectorCatalog => 'InspectorCatalog',
      _isczefpn.InspectorCatalogEntry => 'InspectorCatalogEntry',
      _iuflj21f.OfflineScanInput => 'OfflineScanInput',
      _iilhba84.OfflineScanRecord => 'OfflineScanRecord',
      _ib308dyl.OfflineScanVerdict => 'OfflineScanVerdict',
      _iuxkpdfb.QueuedFakeReport => 'QueuedFakeReport',
      _i50bgiqt.RecallRecord => 'RecallRecord',
      _ievmhhxi.RecallResult => 'RecallResult',
      _il0a365u.AttackSimulation => 'AttackSimulation',
      _iuyotoq1.SimulationRequest => 'SimulationRequest',
      _ib1sdcsu.SimulationStepRequest => 'SimulationStepRequest',
      _ig81gt99.FraudAlert => 'FraudAlert',
      _isoxjppc.FraudSignalRecord => 'FraudSignalRecord',
      _ifwruwpv.GeoSummary => 'GeoSummary',
      _istm7uyq.VerificationSession => 'VerificationSession',
      _ihdj754n.WebhookDelivery => 'WebhookDelivery',
      _inja8klw.WebhookEndpoint => 'WebhookEndpoint',
      _is8j7ehc.WebhookEndpointSecret => 'WebhookEndpointSecret',
      _idplbrdl.WebhookTestResult => 'WebhookTestResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('fauxshield.', '');
    }

    switch (data) {
      case _i09kiuij.AlertEvidence():
        return 'AlertEvidence';
      case _id0erzw8.CountryStat():
        return 'CountryStat';
      case _ir3252k5.DailyWorkspaceStat():
        return 'DailyWorkspaceStat';
      case _idkfvn2o.DashboardSummary():
        return 'DashboardSummary';
      case _imv9g80f.OutcomeBreakdown():
        return 'OutcomeBreakdown';
      case _idmb7f0s.TrendPoint():
        return 'TrendPoint';
      case _ijhj7cd7.AuditEvent():
        return 'AuditEvent';
      case _igwpf6a9.FakeReport():
        return 'FakeReport';
      case _iivg4vhm.ReportAcknowledgement():
        return 'ReportAcknowledgement';
      case _ifwvtvcv.VerificationPresentation():
        return 'VerificationPresentation';
      case _it6ouhsz.Batch():
        return 'Batch';
      case _icosogup.BatchStats():
        return 'BatchStats';
      case _iu6qs3c1.Branding():
        return 'Branding';
      case _idher2i7.ExportFile():
        return 'ExportFile';
      case _i9rh8zdx.FraudPolicy():
        return 'FraudPolicy';
      case _im6cjy38.IdentityGenerationResult():
        return 'IdentityGenerationResult';
      case _ih8fc9d7.Invitation():
        return 'Invitation';
      case _iq5lw9lm.InvitationCreated():
        return 'InvitationCreated';
      case _iete5svs.Product():
        return 'Product';
      case _ikjtxbyt.ProductIdentity():
        return 'ProductIdentity';
      case _iayv1jn2.RevealedPin():
        return 'RevealedPin';
      case _isqjmtap.Workspace():
        return 'Workspace';
      case _i4fe8s18.WorkspaceBootstrap():
        return 'WorkspaceBootstrap';
      case _iy9pnr9b.WorkspaceMember():
        return 'WorkspaceMember';
      case _i8e18jmo.ApiKey():
        return 'ApiKey';
      case _ikfhqlb8.ApiKeySecret():
        return 'ApiKeySecret';
      case _igmv16kr.IdempotencyRecord():
        return 'IdempotencyRecord';
      case _ip5zeyz4.ActorType():
        return 'ActorType';
      case _i3a9pkcg.AlertSeverity():
        return 'AlertSeverity';
      case _i1bqmbyx.AlertStatus():
        return 'AlertStatus';
      case _i1koc1zv.ApiScope():
        return 'ApiScope';
      case _ibyne1i7.BatchStatus():
        return 'BatchStatus';
      case _iz7e19vi.DeliveryStatus():
        return 'DeliveryStatus';
      case _ijd8w0t7.ExportFormat():
        return 'ExportFormat';
      case _i1fa3fps.FakeReportStatus():
        return 'FakeReportStatus';
      case _ir9cucp3.GeoProvider():
        return 'GeoProvider';
      case _i179y4kh.IdentityStatus():
        return 'IdentityStatus';
      case _ip3w1npx.InvitationStatus():
        return 'InvitationStatus';
      case _ipzoi2qu.LiveEventType():
        return 'LiveEventType';
      case _il8xkfgj.MembershipRole():
        return 'MembershipRole';
      case _i4t3y1v6.NotificationChannel():
        return 'NotificationChannel';
      case _ij5x7qg1.NotificationType():
        return 'NotificationType';
      case _ilbx1l14.RecallScope():
        return 'RecallScope';
      case _i0f0rhgt.RiskScore():
        return 'RiskScore';
      case _ilzrh17n.ScanSource():
        return 'ScanSource';
      case _ic7z0e71.SignalType():
        return 'SignalType';
      case _i1zs3mr7.SimulationStatus():
        return 'SimulationStatus';
      case _ibgf5q6i.SimulationType():
        return 'SimulationType';
      case _iek21z57.VerificationErrorReason():
        return 'VerificationErrorReason';
      case _iiagya0k.VerificationOutcome():
        return 'VerificationOutcome';
      case _ibg9yx9r.VerificationState():
        return 'VerificationState';
      case _it82pxed.WebhookEventType():
        return 'WebhookEventType';
      case _izu3utj1.AuthenticationException():
        return 'AuthenticationException';
      case _izu3utj1.ConflictException():
        return 'ConflictException';
      case _izu3utj1.NotFoundException():
        return 'NotFoundException';
      case _izu3utj1.RateLimitException():
        return 'RateLimitException';
      case _izu3utj1.ServiceUnavailableException():
        return 'ServiceUnavailableException';
      case _izu3utj1.ValidationException():
        return 'ValidationException';
      case _izu3utj1.VerificationException():
        return 'VerificationException';
      case _ixdzvre4.LiveEvent():
        return 'LiveEvent';
      case _i04nwpv1.Notification():
        return 'Notification';
      case _iiy1iwm4.NotificationPreference():
        return 'NotificationPreference';
      case _iy4nxf6j.InspectorCacheEntry():
        return 'InspectorCacheEntry';
      case _i93xvsby.InspectorCatalog():
        return 'InspectorCatalog';
      case _isczefpn.InspectorCatalogEntry():
        return 'InspectorCatalogEntry';
      case _iuflj21f.OfflineScanInput():
        return 'OfflineScanInput';
      case _iilhba84.OfflineScanRecord():
        return 'OfflineScanRecord';
      case _ib308dyl.OfflineScanVerdict():
        return 'OfflineScanVerdict';
      case _iuxkpdfb.QueuedFakeReport():
        return 'QueuedFakeReport';
      case _i50bgiqt.RecallRecord():
        return 'RecallRecord';
      case _ievmhhxi.RecallResult():
        return 'RecallResult';
      case _il0a365u.AttackSimulation():
        return 'AttackSimulation';
      case _iuyotoq1.SimulationRequest():
        return 'SimulationRequest';
      case _ib1sdcsu.SimulationStepRequest():
        return 'SimulationStepRequest';
      case _ig81gt99.FraudAlert():
        return 'FraudAlert';
      case _isoxjppc.FraudSignalRecord():
        return 'FraudSignalRecord';
      case _ifwruwpv.GeoSummary():
        return 'GeoSummary';
      case _istm7uyq.VerificationSession():
        return 'VerificationSession';
      case _ihdj754n.WebhookDelivery():
        return 'WebhookDelivery';
      case _inja8klw.WebhookEndpoint():
        return 'WebhookEndpoint';
      case _is8j7ehc.WebhookEndpointSecret():
        return 'WebhookEndpointSecret';
      case _idplbrdl.WebhookTestResult():
        return 'WebhookTestResult';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _ipulbpi2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_offline_sync.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AlertEvidence') {
      return deserialize<_i09kiuij.AlertEvidence>(data['data']);
    }
    if (dataClassName == 'CountryStat') {
      return deserialize<_id0erzw8.CountryStat>(data['data']);
    }
    if (dataClassName == 'DailyWorkspaceStat') {
      return deserialize<_ir3252k5.DailyWorkspaceStat>(data['data']);
    }
    if (dataClassName == 'DashboardSummary') {
      return deserialize<_idkfvn2o.DashboardSummary>(data['data']);
    }
    if (dataClassName == 'OutcomeBreakdown') {
      return deserialize<_imv9g80f.OutcomeBreakdown>(data['data']);
    }
    if (dataClassName == 'TrendPoint') {
      return deserialize<_idmb7f0s.TrendPoint>(data['data']);
    }
    if (dataClassName == 'AuditEvent') {
      return deserialize<_ijhj7cd7.AuditEvent>(data['data']);
    }
    if (dataClassName == 'FakeReport') {
      return deserialize<_igwpf6a9.FakeReport>(data['data']);
    }
    if (dataClassName == 'ReportAcknowledgement') {
      return deserialize<_iivg4vhm.ReportAcknowledgement>(data['data']);
    }
    if (dataClassName == 'VerificationPresentation') {
      return deserialize<_ifwvtvcv.VerificationPresentation>(data['data']);
    }
    if (dataClassName == 'Batch') {
      return deserialize<_it6ouhsz.Batch>(data['data']);
    }
    if (dataClassName == 'BatchStats') {
      return deserialize<_icosogup.BatchStats>(data['data']);
    }
    if (dataClassName == 'Branding') {
      return deserialize<_iu6qs3c1.Branding>(data['data']);
    }
    if (dataClassName == 'ExportFile') {
      return deserialize<_idher2i7.ExportFile>(data['data']);
    }
    if (dataClassName == 'FraudPolicy') {
      return deserialize<_i9rh8zdx.FraudPolicy>(data['data']);
    }
    if (dataClassName == 'IdentityGenerationResult') {
      return deserialize<_im6cjy38.IdentityGenerationResult>(data['data']);
    }
    if (dataClassName == 'Invitation') {
      return deserialize<_ih8fc9d7.Invitation>(data['data']);
    }
    if (dataClassName == 'InvitationCreated') {
      return deserialize<_iq5lw9lm.InvitationCreated>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_iete5svs.Product>(data['data']);
    }
    if (dataClassName == 'ProductIdentity') {
      return deserialize<_ikjtxbyt.ProductIdentity>(data['data']);
    }
    if (dataClassName == 'RevealedPin') {
      return deserialize<_iayv1jn2.RevealedPin>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_isqjmtap.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceBootstrap') {
      return deserialize<_i4fe8s18.WorkspaceBootstrap>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_iy9pnr9b.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'ApiKey') {
      return deserialize<_i8e18jmo.ApiKey>(data['data']);
    }
    if (dataClassName == 'ApiKeySecret') {
      return deserialize<_ikfhqlb8.ApiKeySecret>(data['data']);
    }
    if (dataClassName == 'IdempotencyRecord') {
      return deserialize<_igmv16kr.IdempotencyRecord>(data['data']);
    }
    if (dataClassName == 'ActorType') {
      return deserialize<_ip5zeyz4.ActorType>(data['data']);
    }
    if (dataClassName == 'AlertSeverity') {
      return deserialize<_i3a9pkcg.AlertSeverity>(data['data']);
    }
    if (dataClassName == 'AlertStatus') {
      return deserialize<_i1bqmbyx.AlertStatus>(data['data']);
    }
    if (dataClassName == 'ApiScope') {
      return deserialize<_i1koc1zv.ApiScope>(data['data']);
    }
    if (dataClassName == 'BatchStatus') {
      return deserialize<_ibyne1i7.BatchStatus>(data['data']);
    }
    if (dataClassName == 'DeliveryStatus') {
      return deserialize<_iz7e19vi.DeliveryStatus>(data['data']);
    }
    if (dataClassName == 'ExportFormat') {
      return deserialize<_ijd8w0t7.ExportFormat>(data['data']);
    }
    if (dataClassName == 'FakeReportStatus') {
      return deserialize<_i1fa3fps.FakeReportStatus>(data['data']);
    }
    if (dataClassName == 'GeoProvider') {
      return deserialize<_ir9cucp3.GeoProvider>(data['data']);
    }
    if (dataClassName == 'IdentityStatus') {
      return deserialize<_i179y4kh.IdentityStatus>(data['data']);
    }
    if (dataClassName == 'InvitationStatus') {
      return deserialize<_ip3w1npx.InvitationStatus>(data['data']);
    }
    if (dataClassName == 'LiveEventType') {
      return deserialize<_ipzoi2qu.LiveEventType>(data['data']);
    }
    if (dataClassName == 'MembershipRole') {
      return deserialize<_il8xkfgj.MembershipRole>(data['data']);
    }
    if (dataClassName == 'NotificationChannel') {
      return deserialize<_i4t3y1v6.NotificationChannel>(data['data']);
    }
    if (dataClassName == 'NotificationType') {
      return deserialize<_ij5x7qg1.NotificationType>(data['data']);
    }
    if (dataClassName == 'RecallScope') {
      return deserialize<_ilbx1l14.RecallScope>(data['data']);
    }
    if (dataClassName == 'RiskScore') {
      return deserialize<_i0f0rhgt.RiskScore>(data['data']);
    }
    if (dataClassName == 'ScanSource') {
      return deserialize<_ilzrh17n.ScanSource>(data['data']);
    }
    if (dataClassName == 'SignalType') {
      return deserialize<_ic7z0e71.SignalType>(data['data']);
    }
    if (dataClassName == 'SimulationStatus') {
      return deserialize<_i1zs3mr7.SimulationStatus>(data['data']);
    }
    if (dataClassName == 'SimulationType') {
      return deserialize<_ibgf5q6i.SimulationType>(data['data']);
    }
    if (dataClassName == 'VerificationErrorReason') {
      return deserialize<_iek21z57.VerificationErrorReason>(data['data']);
    }
    if (dataClassName == 'VerificationOutcome') {
      return deserialize<_iiagya0k.VerificationOutcome>(data['data']);
    }
    if (dataClassName == 'VerificationState') {
      return deserialize<_ibg9yx9r.VerificationState>(data['data']);
    }
    if (dataClassName == 'WebhookEventType') {
      return deserialize<_it82pxed.WebhookEventType>(data['data']);
    }
    if (dataClassName == 'AuthenticationException') {
      return deserialize<_izu3utj1.AuthenticationException>(data['data']);
    }
    if (dataClassName == 'ConflictException') {
      return deserialize<_izu3utj1.ConflictException>(data['data']);
    }
    if (dataClassName == 'NotFoundException') {
      return deserialize<_izu3utj1.NotFoundException>(data['data']);
    }
    if (dataClassName == 'RateLimitException') {
      return deserialize<_izu3utj1.RateLimitException>(data['data']);
    }
    if (dataClassName == 'ServiceUnavailableException') {
      return deserialize<_izu3utj1.ServiceUnavailableException>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_izu3utj1.ValidationException>(data['data']);
    }
    if (dataClassName == 'VerificationException') {
      return deserialize<_izu3utj1.VerificationException>(data['data']);
    }
    if (dataClassName == 'LiveEvent') {
      return deserialize<_ixdzvre4.LiveEvent>(data['data']);
    }
    if (dataClassName == 'Notification') {
      return deserialize<_i04nwpv1.Notification>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_iiy1iwm4.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'InspectorCacheEntry') {
      return deserialize<_iy4nxf6j.InspectorCacheEntry>(data['data']);
    }
    if (dataClassName == 'InspectorCatalog') {
      return deserialize<_i93xvsby.InspectorCatalog>(data['data']);
    }
    if (dataClassName == 'InspectorCatalogEntry') {
      return deserialize<_isczefpn.InspectorCatalogEntry>(data['data']);
    }
    if (dataClassName == 'OfflineScanInput') {
      return deserialize<_iuflj21f.OfflineScanInput>(data['data']);
    }
    if (dataClassName == 'OfflineScanRecord') {
      return deserialize<_iilhba84.OfflineScanRecord>(data['data']);
    }
    if (dataClassName == 'OfflineScanVerdict') {
      return deserialize<_ib308dyl.OfflineScanVerdict>(data['data']);
    }
    if (dataClassName == 'QueuedFakeReport') {
      return deserialize<_iuxkpdfb.QueuedFakeReport>(data['data']);
    }
    if (dataClassName == 'RecallRecord') {
      return deserialize<_i50bgiqt.RecallRecord>(data['data']);
    }
    if (dataClassName == 'RecallResult') {
      return deserialize<_ievmhhxi.RecallResult>(data['data']);
    }
    if (dataClassName == 'AttackSimulation') {
      return deserialize<_il0a365u.AttackSimulation>(data['data']);
    }
    if (dataClassName == 'SimulationRequest') {
      return deserialize<_iuyotoq1.SimulationRequest>(data['data']);
    }
    if (dataClassName == 'SimulationStepRequest') {
      return deserialize<_ib1sdcsu.SimulationStepRequest>(data['data']);
    }
    if (dataClassName == 'FraudAlert') {
      return deserialize<_ig81gt99.FraudAlert>(data['data']);
    }
    if (dataClassName == 'FraudSignalRecord') {
      return deserialize<_isoxjppc.FraudSignalRecord>(data['data']);
    }
    if (dataClassName == 'GeoSummary') {
      return deserialize<_ifwruwpv.GeoSummary>(data['data']);
    }
    if (dataClassName == 'VerificationSession') {
      return deserialize<_istm7uyq.VerificationSession>(data['data']);
    }
    if (dataClassName == 'WebhookDelivery') {
      return deserialize<_ihdj754n.WebhookDelivery>(data['data']);
    }
    if (dataClassName == 'WebhookEndpoint') {
      return deserialize<_inja8klw.WebhookEndpoint>(data['data']);
    }
    if (dataClassName == 'WebhookEndpointSecret') {
      return deserialize<_is8j7ehc.WebhookEndpointSecret>(data['data']);
    }
    if (dataClassName == 'WebhookTestResult') {
      return deserialize<_idplbrdl.WebhookTestResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_offline_sync.')) {
      data['className'] = dataClassName.substring(23);
      return _ipulbpi2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('fauxshield', this);
    _ipulbpi2.Protocol().registerHostProtocol('fauxshield', this);
    _iacc.Protocol().registerHostProtocol('fauxshield', this);
  }

  @override
  _isd.Table? getTableForType(Type t) {
    {
      var protocol = _iaic.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _ipulbpi2.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _iacc.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iy4nxf6j.InspectorCacheEntry:
        return _iy4nxf6j.InspectorCacheEntry.t;
      case _iilhba84.OfflineScanRecord:
        return _iilhba84.OfflineScanRecord.t;
      case _iuxkpdfb.QueuedFakeReport:
        return _iuxkpdfb.QueuedFakeReport.t;
    }
    return null;
  }

  @override
  List<_isd.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'fauxshield';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _ipulbpi2.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
