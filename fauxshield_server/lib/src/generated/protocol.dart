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
import 'package:fauxshield_server/src/generated/audit/audit_event.dart'
    as _ilhfgg14;
import 'package:fauxshield_server/src/generated/consumer/fake_report.dart'
    as _ici1p2vw;
import 'package:fauxshield_server/src/generated/core/batch.dart' as _iup4iqu5;
import 'package:fauxshield_server/src/generated/core/invitation.dart'
    as _i78uhtt9;
import 'package:fauxshield_server/src/generated/core/product.dart' as _ian4oqo2;
import 'package:fauxshield_server/src/generated/core/product_identity.dart'
    as _i2mg5i1l;
import 'package:fauxshield_server/src/generated/core/workspace_member.dart'
    as _iqeq6200;
import 'package:fauxshield_server/src/generated/developer/api_key.dart'
    as _ig1utrz2;
import 'package:fauxshield_server/src/generated/enums/api_scope.dart'
    as _ilmzvpi4;
import 'package:fauxshield_server/src/generated/enums/webhook_event_type.dart'
    as _i9gqphv7;
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
import 'package:fauxshield_server/src/generated/simulation/attack_simulation.dart'
    as _i0v2zdo1;
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
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:serverpod_offline_sync_server/serverpod_offline_sync_server.dart'
    as _izehhkf5;
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
import 'core/product_delete_impact.dart' as _ioyinfq8;
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
export 'core/product_delete_impact.dart';
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
export 'sync_tables.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'api_key',
      dartName: 'ApiKey',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'label',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'keyHash',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'keyPrefix',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'scopes',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:ApiScope>',
        ),
        _isp.ColumnDefinition(
          name: 'rateLimitPerMinute',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '120',
        ),
        _isp.ColumnDefinition(
          name: 'lastUsedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'revoked',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'revokedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'api_key_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'api_key_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'api_key_prefix_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'keyPrefix',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'attack_simulation',
      dartName: 'AttackSimulation',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SimulationType',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SimulationStatus',
          columnDefault: '\'queued\'',
        ),
        _isp.ColumnDefinition(
          name: 'label',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'paramsJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'progress',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'totalSteps',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'summaryJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'startedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'completedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'cancelledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'attack_simulation_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'attack_simulation_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'audit_event',
      dartName: 'AuditEvent',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'actorType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ActorType',
          columnDefault: '\'system\'',
        ),
        _isp.ColumnDefinition(
          name: 'actorIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'apiKeyId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'targetType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'targetId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'metadataJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'ipAddress',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'audit_event_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'audit_event_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'audit_event_action_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'action',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'batch',
      dartName: 'Batch',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'productId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'reference',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'manufactureDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'expiryDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'distributionRegion',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'quantity',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:BatchStatus',
          columnDefault: '\'created\'',
        ),
        _isp.ColumnDefinition(
          name: 'notes',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'recallReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'recalledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'recalledBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'batch_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'batch_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'batch_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'batch_product_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'daily_workspace_stat',
      dartName: 'DailyWorkspaceStat',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'date',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'verifications',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'authentic',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'alreadyVerified',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'invalidPin',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'fraudSuspected',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'highRisk',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'recalled',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'alertsCreated',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'alertsResolved',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'topCountriesJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'daily_workspace_stat_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'daily_workspace_stat_key_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'date',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'fake_report',
      dartName: 'FakeReport',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'identityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'reason',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'comment',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'photoStorageId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'photoPath',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'deviceFingerprint',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'country',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'city',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:FakeReportStatus',
          columnDefault: '\'open\'',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ScanSource',
          columnDefault: '\'consumerWeb\'',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'triagedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'triagedBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'fake_report_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'fake_report_fk_1',
          columns: ['identityId'],
          referenceTable: 'product_identity',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'fake_report_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'fake_report_identity_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'identityId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'fraud_alert',
      dartName: 'FraudAlert',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'identityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'batchId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'severity',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AlertSeverity',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AlertStatus',
          columnDefault: '\'open\'',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'recommendedAction',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'signalTypes',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:SignalType>?',
        ),
        _isp.ColumnDefinition(
          name: 'dedupeKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'autoLocked',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'assignee',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'simulationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'acknowledgedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'resolvedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'resolvedBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'resolutionNote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'fraud_alert_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'fraud_alert__dedupeKey__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'dedupeKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'fraud_alert_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'fraud_alert_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'fraud_signal_record',
      dartName: 'FraudSignalRecord',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'sessionId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'identityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'batchId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:SignalType',
        ),
        _isp.ColumnDefinition(
          name: 'severity',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RiskScore',
        ),
        _isp.ColumnDefinition(
          name: 'dataJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'{}\'',
        ),
        _isp.ColumnDefinition(
          name: 'detectedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'fraud_signal_record_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'fraud_signal_record_fk_1',
          columns: ['sessionId'],
          referenceTable: 'verification_session',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'fraud_signal_record_session_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sessionId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'fraud_signal_record_batch_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'batchId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'fraud_signal_record_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'idempotency_record',
      dartName: 'IdempotencyRecord',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'idempotencyKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'operation',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'requestHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'responseJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'statusCode',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'idempotency_record__idempotencyKey__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'idempotencyKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'idempotency_record_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'invitation',
      dartName: 'Invitation',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MembershipRole',
          columnDefault: '\'member\'',
        ),
        _isp.ColumnDefinition(
          name: 'codeHash',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'codePrefix',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:InvitationStatus',
          columnDefault: '\'pending\'',
        ),
        _isp.ColumnDefinition(
          name: 'invitedBy',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'acceptedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'acceptedBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'invitation_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'invitation_code_prefix_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'codePrefix',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'notification',
      dartName: 'Notification',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:NotificationType',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'body',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'targetType',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'targetId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'read',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'notification_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'notification_recipient_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'notification_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'notification_preference',
      dartName: 'NotificationPreference',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'channel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:NotificationChannel',
        ),
        _isp.ColumnDefinition(
          name: 'enabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'minSeverity',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AlertSeverity',
          columnDefault: '\'low\'',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'notification_preference_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'notification_preference_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'channel',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'offline_scan_record',
      dartName: 'OfflineScanRecord',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'spaceId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'deviceId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'deviceFingerprint',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'identityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'qrToken',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'scannedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'country',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'city',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'provisionalOutcome',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'processed',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'processedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'verdictJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'offline_scan_record_fk_0',
          columns: ['spaceId'],
          referenceTable: 'offline_sync_spaces',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'offline_scan_processed_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'product',
      dartName: 'Product',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sku',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'imageUrls',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _isp.ColumnDefinition(
          name: 'packaging',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'shelfLife',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'countryRestrictions',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _isp.ColumnDefinition(
          name: 'safetyInstructions',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'archivedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'deleteReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'product_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'product_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'product_identity',
      dartName: 'ProductIdentity',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'batchId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'qrToken',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'hmacSignature',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'pinHash',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'pinCiphertext',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:IdentityStatus',
          columnDefault: '\'active\'',
        ),
        _isp.ColumnDefinition(
          name: 'failedPinAttempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'lockedUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'firstVerified',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'verificationCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'firstVerifiedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'lastVerifiedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'recallReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'recalledAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'regeneratedFromId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'deleteReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'product_identity_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'product_identity_fk_1',
          columns: ['batchId'],
          referenceTable: 'batch',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'product_identity__qrToken__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'qrToken',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'product_identity_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'product_identity_batch_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'batchId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'recall_record',
      dartName: 'RecallRecord',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'batchId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'identityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'scope',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RecallScope',
        ),
        _isp.ColumnDefinition(
          name: 'reason',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'issuedBy',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'issuedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'lifted',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'liftedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'liftedBy',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'notes',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'recall_record_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'recall_record_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'recall_record_batch_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'batchId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'verification_session',
      dartName: 'VerificationSession',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'identityId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'qrToken',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'deviceFingerprint',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'ipAddress',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'country',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'countryCode',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'city',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:VerificationState',
          columnDefault: '\'tokenResolved\'',
        ),
        _isp.ColumnDefinition(
          name: 'outcome',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:VerificationOutcome?',
        ),
        _isp.ColumnDefinition(
          name: 'riskScore',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:RiskScore?',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ScanSource',
          columnDefault: '\'consumerWeb\'',
        ),
        _isp.ColumnDefinition(
          name: 'offlineScanId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'simulationId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'lastStateChange',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'completedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'verification_session_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'verification_session_fk_1',
          columns: ['identityId'],
          referenceTable: 'product_identity',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'verification_session_identity_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'identityId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'verification_session_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'verification_session_token_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'qrToken',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'webhook_delivery',
      dartName: 'WebhookDelivery',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'endpointId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'eventType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:WebhookEventType',
        ),
        _isp.ColumnDefinition(
          name: 'payloadJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DeliveryStatus',
          columnDefault: '\'pending\'',
        ),
        _isp.ColumnDefinition(
          name: 'attemptCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'maxAttempts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '5',
        ),
        _isp.ColumnDefinition(
          name: 'lastAttemptAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'nextAttemptAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'lastHttpStatus',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'lastError',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'responseTimeMs',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'processingStartedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'deliveredAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'webhook_delivery_fk_0',
          columns: ['endpointId'],
          referenceTable: 'webhook_endpoint',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'webhook_delivery_endpoint_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'endpointId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'webhook_delivery_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'webhook_delivery_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'webhook_endpoint',
      dartName: 'WebhookEndpoint',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'url',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'subscribedEvents',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:WebhookEventType>',
        ),
        _isp.ColumnDefinition(
          name: 'enabled',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'consecutiveFailures',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'encryptedSecret',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'previousEncryptedSecret',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'secretRotatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'webhook_endpoint_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'webhook_endpoint_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'workspace',
      dartName: 'Workspace',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'slug',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'branding',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:Branding?',
        ),
        _isp.ColumnDefinition(
          name: 'authenticMessage',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'restrictedCountries',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _isp.ColumnDefinition(
          name: 'fraudPolicy',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:FraudPolicy?',
        ),
        _isp.ColumnDefinition(
          name: 'demoMode',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'workspace_slug_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'workspace_member',
      dartName: 'WorkspaceMember',
      schema: 'public',
      module: 'fauxshield',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'workspaceId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'displayName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MembershipRole',
          columnDefault: '\'member\'',
        ),
        _isp.ColumnDefinition(
          name: 'notificationEmail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'workspace_member_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName:
              'workspace_member__workspaceId__userIdentifier__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'workspace_member_workspace_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._izehhkf5.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _ioyinfq8.ProductDeleteImpact) {
      return _ioyinfq8.ProductDeleteImpact.fromJson(data) as T;
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
    if (t == _is.getType<_i09kiuij.AlertEvidence?>()) {
      return (data != null ? _i09kiuij.AlertEvidence.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_id0erzw8.CountryStat?>()) {
      return (data != null ? _id0erzw8.CountryStat.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ir3252k5.DailyWorkspaceStat?>()) {
      return (data != null ? _ir3252k5.DailyWorkspaceStat.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idkfvn2o.DashboardSummary?>()) {
      return (data != null ? _idkfvn2o.DashboardSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imv9g80f.OutcomeBreakdown?>()) {
      return (data != null ? _imv9g80f.OutcomeBreakdown.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idmb7f0s.TrendPoint?>()) {
      return (data != null ? _idmb7f0s.TrendPoint.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijhj7cd7.AuditEvent?>()) {
      return (data != null ? _ijhj7cd7.AuditEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igwpf6a9.FakeReport?>()) {
      return (data != null ? _igwpf6a9.FakeReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iivg4vhm.ReportAcknowledgement?>()) {
      return (data != null
              ? _iivg4vhm.ReportAcknowledgement.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ifwvtvcv.VerificationPresentation?>()) {
      return (data != null
              ? _ifwvtvcv.VerificationPresentation.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_it6ouhsz.Batch?>()) {
      return (data != null ? _it6ouhsz.Batch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icosogup.BatchStats?>()) {
      return (data != null ? _icosogup.BatchStats.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iu6qs3c1.Branding?>()) {
      return (data != null ? _iu6qs3c1.Branding.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idher2i7.ExportFile?>()) {
      return (data != null ? _idher2i7.ExportFile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9rh8zdx.FraudPolicy?>()) {
      return (data != null ? _i9rh8zdx.FraudPolicy.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_im6cjy38.IdentityGenerationResult?>()) {
      return (data != null
              ? _im6cjy38.IdentityGenerationResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ih8fc9d7.Invitation?>()) {
      return (data != null ? _ih8fc9d7.Invitation.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iq5lw9lm.InvitationCreated?>()) {
      return (data != null ? _iq5lw9lm.InvitationCreated.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iete5svs.Product?>()) {
      return (data != null ? _iete5svs.Product.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ioyinfq8.ProductDeleteImpact?>()) {
      return (data != null
              ? _ioyinfq8.ProductDeleteImpact.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ikjtxbyt.ProductIdentity?>()) {
      return (data != null ? _ikjtxbyt.ProductIdentity.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iayv1jn2.RevealedPin?>()) {
      return (data != null ? _iayv1jn2.RevealedPin.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_isqjmtap.Workspace?>()) {
      return (data != null ? _isqjmtap.Workspace.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4fe8s18.WorkspaceBootstrap?>()) {
      return (data != null ? _i4fe8s18.WorkspaceBootstrap.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iy9pnr9b.WorkspaceMember?>()) {
      return (data != null ? _iy9pnr9b.WorkspaceMember.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8e18jmo.ApiKey?>()) {
      return (data != null ? _i8e18jmo.ApiKey.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikfhqlb8.ApiKeySecret?>()) {
      return (data != null ? _ikfhqlb8.ApiKeySecret.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igmv16kr.IdempotencyRecord?>()) {
      return (data != null ? _igmv16kr.IdempotencyRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ip5zeyz4.ActorType?>()) {
      return (data != null ? _ip5zeyz4.ActorType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3a9pkcg.AlertSeverity?>()) {
      return (data != null ? _i3a9pkcg.AlertSeverity.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1bqmbyx.AlertStatus?>()) {
      return (data != null ? _i1bqmbyx.AlertStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1koc1zv.ApiScope?>()) {
      return (data != null ? _i1koc1zv.ApiScope.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibyne1i7.BatchStatus?>()) {
      return (data != null ? _ibyne1i7.BatchStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz7e19vi.DeliveryStatus?>()) {
      return (data != null ? _iz7e19vi.DeliveryStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijd8w0t7.ExportFormat?>()) {
      return (data != null ? _ijd8w0t7.ExportFormat.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1fa3fps.FakeReportStatus?>()) {
      return (data != null ? _i1fa3fps.FakeReportStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ir9cucp3.GeoProvider?>()) {
      return (data != null ? _ir9cucp3.GeoProvider.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i179y4kh.IdentityStatus?>()) {
      return (data != null ? _i179y4kh.IdentityStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ip3w1npx.InvitationStatus?>()) {
      return (data != null ? _ip3w1npx.InvitationStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ipzoi2qu.LiveEventType?>()) {
      return (data != null ? _ipzoi2qu.LiveEventType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_il8xkfgj.MembershipRole?>()) {
      return (data != null ? _il8xkfgj.MembershipRole.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i4t3y1v6.NotificationChannel?>()) {
      return (data != null
              ? _i4t3y1v6.NotificationChannel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ij5x7qg1.NotificationType?>()) {
      return (data != null ? _ij5x7qg1.NotificationType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ilbx1l14.RecallScope?>()) {
      return (data != null ? _ilbx1l14.RecallScope.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0f0rhgt.RiskScore?>()) {
      return (data != null ? _i0f0rhgt.RiskScore.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilzrh17n.ScanSource?>()) {
      return (data != null ? _ilzrh17n.ScanSource.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ic7z0e71.SignalType?>()) {
      return (data != null ? _ic7z0e71.SignalType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1zs3mr7.SimulationStatus?>()) {
      return (data != null ? _i1zs3mr7.SimulationStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibgf5q6i.SimulationType?>()) {
      return (data != null ? _ibgf5q6i.SimulationType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iek21z57.VerificationErrorReason?>()) {
      return (data != null
              ? _iek21z57.VerificationErrorReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iiagya0k.VerificationOutcome?>()) {
      return (data != null
              ? _iiagya0k.VerificationOutcome.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ibg9yx9r.VerificationState?>()) {
      return (data != null ? _ibg9yx9r.VerificationState.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_it82pxed.WebhookEventType?>()) {
      return (data != null ? _it82pxed.WebhookEventType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izu3utj1.AuthenticationException?>()) {
      return (data != null
              ? _izu3utj1.AuthenticationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izu3utj1.ConflictException?>()) {
      return (data != null ? _izu3utj1.ConflictException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izu3utj1.NotFoundException?>()) {
      return (data != null ? _izu3utj1.NotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izu3utj1.RateLimitException?>()) {
      return (data != null ? _izu3utj1.RateLimitException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izu3utj1.ServiceUnavailableException?>()) {
      return (data != null
              ? _izu3utj1.ServiceUnavailableException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izu3utj1.ValidationException?>()) {
      return (data != null
              ? _izu3utj1.ValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izu3utj1.VerificationException?>()) {
      return (data != null
              ? _izu3utj1.VerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ixdzvre4.LiveEvent?>()) {
      return (data != null ? _ixdzvre4.LiveEvent.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i04nwpv1.Notification?>()) {
      return (data != null ? _i04nwpv1.Notification.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iiy1iwm4.NotificationPreference?>()) {
      return (data != null
              ? _iiy1iwm4.NotificationPreference.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iy4nxf6j.InspectorCacheEntry?>()) {
      return (data != null
              ? _iy4nxf6j.InspectorCacheEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i93xvsby.InspectorCatalog?>()) {
      return (data != null ? _i93xvsby.InspectorCatalog.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_isczefpn.InspectorCatalogEntry?>()) {
      return (data != null
              ? _isczefpn.InspectorCatalogEntry.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iuflj21f.OfflineScanInput?>()) {
      return (data != null ? _iuflj21f.OfflineScanInput.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iilhba84.OfflineScanRecord?>()) {
      return (data != null ? _iilhba84.OfflineScanRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ib308dyl.OfflineScanVerdict?>()) {
      return (data != null ? _ib308dyl.OfflineScanVerdict.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iuxkpdfb.QueuedFakeReport?>()) {
      return (data != null ? _iuxkpdfb.QueuedFakeReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i50bgiqt.RecallRecord?>()) {
      return (data != null ? _i50bgiqt.RecallRecord.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ievmhhxi.RecallResult?>()) {
      return (data != null ? _ievmhhxi.RecallResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_il0a365u.AttackSimulation?>()) {
      return (data != null ? _il0a365u.AttackSimulation.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iuyotoq1.SimulationRequest?>()) {
      return (data != null ? _iuyotoq1.SimulationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ib1sdcsu.SimulationStepRequest?>()) {
      return (data != null
              ? _ib1sdcsu.SimulationStepRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ig81gt99.FraudAlert?>()) {
      return (data != null ? _ig81gt99.FraudAlert.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_isoxjppc.FraudSignalRecord?>()) {
      return (data != null ? _isoxjppc.FraudSignalRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ifwruwpv.GeoSummary?>()) {
      return (data != null ? _ifwruwpv.GeoSummary.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_istm7uyq.VerificationSession?>()) {
      return (data != null
              ? _istm7uyq.VerificationSession.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihdj754n.WebhookDelivery?>()) {
      return (data != null ? _ihdj754n.WebhookDelivery.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_inja8klw.WebhookEndpoint?>()) {
      return (data != null ? _inja8klw.WebhookEndpoint.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_is8j7ehc.WebhookEndpointSecret?>()) {
      return (data != null
              ? _is8j7ehc.WebhookEndpointSecret.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_idplbrdl.WebhookTestResult?>()) {
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
    if (t == _is.getType<List<String>?>()) {
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
    if (t == _is.getType<List<_ic7z0e71.SignalType>?>()) {
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
    if (t == List<_i81fjb7d.FraudAlert>) {
      return (data as List)
              .map((e) => deserialize<_i81fjb7d.FraudAlert>(e))
              .toList()
          as T;
    }
    if (t == List<_ifjnoxq3.FraudSignalRecord>) {
      return (data as List)
              .map((e) => deserialize<_ifjnoxq3.FraudSignalRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_ici1p2vw.FakeReport>) {
      return (data as List)
              .map((e) => deserialize<_ici1p2vw.FakeReport>(e))
              .toList()
          as T;
    }
    if (t == List<_ig1utrz2.ApiKey>) {
      return (data as List)
              .map((e) => deserialize<_ig1utrz2.ApiKey>(e))
              .toList()
          as T;
    }
    if (t == List<_ilmzvpi4.ApiScope>) {
      return (data as List)
              .map((e) => deserialize<_ilmzvpi4.ApiScope>(e))
              .toList()
          as T;
    }
    if (t == List<_ilhfgg14.AuditEvent>) {
      return (data as List)
              .map((e) => deserialize<_ilhfgg14.AuditEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_iup4iqu5.Batch>) {
      return (data as List).map((e) => deserialize<_iup4iqu5.Batch>(e)).toList()
          as T;
    }
    if (t == List<_i2mg5i1l.ProductIdentity>) {
      return (data as List)
              .map((e) => deserialize<_i2mg5i1l.ProductIdentity>(e))
              .toList()
          as T;
    }
    if (t == List<_i1dqkmtk.Notification>) {
      return (data as List)
              .map((e) => deserialize<_i1dqkmtk.Notification>(e))
              .toList()
          as T;
    }
    if (t == List<_iz5xn7se.NotificationPreference>) {
      return (data as List)
              .map((e) => deserialize<_iz5xn7se.NotificationPreference>(e))
              .toList()
          as T;
    }
    if (t == List<_isqommwe.OfflineScanVerdict>) {
      return (data as List)
              .map((e) => deserialize<_isqommwe.OfflineScanVerdict>(e))
              .toList()
          as T;
    }
    if (t == List<_iilz41bh.OfflineScanInput>) {
      return (data as List)
              .map((e) => deserialize<_iilz41bh.OfflineScanInput>(e))
              .toList()
          as T;
    }
    if (t == List<_irnk4ro1.OfflineScanRecord>) {
      return (data as List)
              .map((e) => deserialize<_irnk4ro1.OfflineScanRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_ian4oqo2.Product>) {
      return (data as List)
              .map((e) => deserialize<_ian4oqo2.Product>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _is.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i8526if6.RecallRecord>) {
      return (data as List)
              .map((e) => deserialize<_i8526if6.RecallRecord>(e))
              .toList()
          as T;
    }
    if (t == List<_i0v2zdo1.AttackSimulation>) {
      return (data as List)
              .map((e) => deserialize<_i0v2zdo1.AttackSimulation>(e))
              .toList()
          as T;
    }
    if (t == List<_ism3h20n.VerificationSession>) {
      return (data as List)
              .map((e) => deserialize<_ism3h20n.VerificationSession>(e))
              .toList()
          as T;
    }
    if (t == List<_if44bvj4.WebhookEndpoint>) {
      return (data as List)
              .map((e) => deserialize<_if44bvj4.WebhookEndpoint>(e))
              .toList()
          as T;
    }
    if (t == List<_i9gqphv7.WebhookEventType>) {
      return (data as List)
              .map((e) => deserialize<_i9gqphv7.WebhookEventType>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i9gqphv7.WebhookEventType>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i9gqphv7.WebhookEventType>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ibuewkxx.WebhookDelivery>) {
      return (data as List)
              .map((e) => deserialize<_ibuewkxx.WebhookDelivery>(e))
              .toList()
          as T;
    }
    if (t == List<_iqeq6200.WorkspaceMember>) {
      return (data as List)
              .map((e) => deserialize<_iqeq6200.WorkspaceMember>(e))
              .toList()
          as T;
    }
    if (t == List<_i78uhtt9.Invitation>) {
      return (data as List)
              .map((e) => deserialize<_i78uhtt9.Invitation>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _izehhkf5.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
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
      _ioyinfq8.ProductDeleteImpact => 'ProductDeleteImpact',
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
      case _ioyinfq8.ProductDeleteImpact():
        return 'ProductDeleteImpact';
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
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _izehhkf5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_offline_sync.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
    if (dataClassName == 'ProductDeleteImpact') {
      return deserialize<_ioyinfq8.ProductDeleteImpact>(data['data']);
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
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_offline_sync.')) {
      data['className'] = dataClassName.substring(23);
      return _izehhkf5.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('fauxshield', this);
    _izehhkf5.Protocol().registerHostProtocol('fauxshield', this);
    _iacs.Protocol().registerHostProtocol('fauxshield', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _izehhkf5.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ir3252k5.DailyWorkspaceStat:
        return _ir3252k5.DailyWorkspaceStat.t;
      case _ijhj7cd7.AuditEvent:
        return _ijhj7cd7.AuditEvent.t;
      case _igwpf6a9.FakeReport:
        return _igwpf6a9.FakeReport.t;
      case _it6ouhsz.Batch:
        return _it6ouhsz.Batch.t;
      case _ih8fc9d7.Invitation:
        return _ih8fc9d7.Invitation.t;
      case _iete5svs.Product:
        return _iete5svs.Product.t;
      case _ikjtxbyt.ProductIdentity:
        return _ikjtxbyt.ProductIdentity.t;
      case _isqjmtap.Workspace:
        return _isqjmtap.Workspace.t;
      case _iy9pnr9b.WorkspaceMember:
        return _iy9pnr9b.WorkspaceMember.t;
      case _i8e18jmo.ApiKey:
        return _i8e18jmo.ApiKey.t;
      case _igmv16kr.IdempotencyRecord:
        return _igmv16kr.IdempotencyRecord.t;
      case _i04nwpv1.Notification:
        return _i04nwpv1.Notification.t;
      case _iiy1iwm4.NotificationPreference:
        return _iiy1iwm4.NotificationPreference.t;
      case _iilhba84.OfflineScanRecord:
        return _iilhba84.OfflineScanRecord.t;
      case _i50bgiqt.RecallRecord:
        return _i50bgiqt.RecallRecord.t;
      case _il0a365u.AttackSimulation:
        return _il0a365u.AttackSimulation.t;
      case _ig81gt99.FraudAlert:
        return _ig81gt99.FraudAlert.t;
      case _isoxjppc.FraudSignalRecord:
        return _isoxjppc.FraudSignalRecord.t;
      case _istm7uyq.VerificationSession:
        return _istm7uyq.VerificationSession.t;
      case _ihdj754n.WebhookDelivery:
        return _ihdj754n.WebhookDelivery.t;
      case _inja8klw.WebhookEndpoint:
        return _inja8klw.WebhookEndpoint.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _izehhkf5.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
