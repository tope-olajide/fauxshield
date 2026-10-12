import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:mcp_dart/mcp_dart.dart';

import '../gateway.dart';
import '../tool_support.dart';

/// The fraud queue: alerts, the evidence behind them, consumer reports, and the
/// verification sessions they were derived from.
void registerFraudTools(ToolRegistry registry, FauxShieldGateway gateway) {
  final client = gateway.client;
  final workspaceId = gateway.workspaceId;

  registry.read(
    'list_alerts',
    description:
        'List fraud alerts in the investigation queue, newest first. Filter by '
        'status or severity to work one slice at a time.',
    properties: <String, JsonSchema>{
      'status': JsonSchema.string(
        description: 'Filter by alert status.',
        enumValues: <String>[
          'open',
          'investigating',
          'resolved',
          'dismissed',
        ],
      ),
      'severity': JsonSchema.string(
        description: 'Filter by severity.',
        enumValues: <String>['low', 'medium', 'high', 'critical'],
      ),
      'page': JsonSchema.integer(description: 'Page number, starting at 1.'),
      'page_size': JsonSchema.integer(description: 'Rows per page, max 200.'),
    },
    body: (args, context) {
      final paging = args.paging();
      return client.alert.list(
        workspaceId: workspaceId,
        status: args.optionalEnum<AlertStatus>('status', AlertStatus.values),
        severity: args.optionalEnum<AlertSeverity>(
          'severity',
          AlertSeverity.values,
        ),
        page: paging.page,
        pageSize: paging.pageSize,
      );
    },
  );

  registry.read(
    'get_alert',
    description: 'Read one alert without its evidence bundle.',
    properties: <String, JsonSchema>{
      'alert_id': JsonSchema.string(description: 'Alert uuid.'),
    },
    required: <String>['alert_id'],
    body: (args, context) => client.alert.get(args.requiredUuid('alert_id')),
  );

  registry.read(
    'alert_evidence',
    description:
        'Everything behind one alert in a single call: the unit, its batch and '
        'product, every related scan session, the detected signals, consumer '
        'reports, and any recall. Start an investigation here.',
    properties: <String, JsonSchema>{
      'alert_id': JsonSchema.string(description: 'Alert uuid.'),
    },
    required: <String>['alert_id'],
    body: (args, context) =>
        client.alert.evidence(args.requiredUuid('alert_id')),
  );

  registry.write(
    'update_alert_status',
    description:
        'Move an alert through its lifecycle: investigate, resolve, or dismiss '
        'it, with an optional note recorded in the audit trail.',
    properties: <String, JsonSchema>{
      'alert_id': JsonSchema.string(description: 'Alert uuid.'),
      'status': JsonSchema.string(
        description: 'New status.',
        enumValues: <String>[
          'open',
          'investigating',
          'resolved',
          'dismissed',
        ],
      ),
      'note': JsonSchema.string(description: 'Outcome note for the audit log.'),
    },
    required: <String>['alert_id', 'status'],
    idempotent: true,
    body: (args, context) => client.alert.updateStatus(
      workspaceId: workspaceId,
      alertId: args.requiredUuid('alert_id'),
      status: args.requiredEnum<AlertStatus>('status', AlertStatus.values),
      note: args.optionalString('note'),
    ),
  );

  registry.write(
    'assign_alert',
    description: 'Assign an alert to an owner, or clear the assignment.',
    properties: <String, JsonSchema>{
      'alert_id': JsonSchema.string(description: 'Alert uuid.'),
      'assignee': JsonSchema.string(
        description: 'Who owns the investigation. Omit to unassign.',
      ),
    },
    required: <String>['alert_id'],
    idempotent: true,
    body: (args, context) => client.alert.assign(
      workspaceId: workspaceId,
      alertId: args.requiredUuid('alert_id'),
      assignee: args.optionalString('assignee'),
    ),
  );

  registry.read(
    'list_fraud_signals',
    description:
        'List the individual fraud signals the engine has recorded, optionally '
        'for one batch or of one type.',
    properties: <String, JsonSchema>{
      'batch_id': JsonSchema.string(
        description: 'Only signals for this batch.',
      ),
      'type': JsonSchema.string(description: 'Filter by signal type.'),
      'page': JsonSchema.integer(description: 'Page number, starting at 1.'),
      'page_size': JsonSchema.integer(description: 'Rows per page, max 200.'),
    },
    body: (args, context) {
      final paging = args.paging();
      return client.alert.signals(
        workspaceId: workspaceId,
        batchId: args.optionalUuid('batch_id'),
        type: args.optionalEnum<SignalType>('type', SignalType.values),
        page: paging.page,
        pageSize: paging.pageSize,
      );
    },
  );

  registry.read(
    'list_fake_reports',
    description: 'List consumer reports of suspicious or fake units.',
    properties: <String, JsonSchema>{
      'status': JsonSchema.string(
        description: 'Filter by triage status.',
        enumValues: <String>['open', 'confirmed', 'dismissed'],
      ),
      'page': JsonSchema.integer(description: 'Page number, starting at 1.'),
      'page_size': JsonSchema.integer(description: 'Rows per page, max 200.'),
    },
    body: (args, context) {
      final paging = args.paging();
      return client.alert.reports(
        workspaceId: workspaceId,
        status: args.optionalEnum<FakeReportStatus>(
          'status',
          FakeReportStatus.values,
        ),
        page: paging.page,
        pageSize: paging.pageSize,
      );
    },
  );

  registry.write(
    'triage_fake_report',
    description: 'Confirm or dismiss a consumer report.',
    properties: <String, JsonSchema>{
      'report_id': JsonSchema.string(description: 'Report uuid.'),
      'status': JsonSchema.string(
        description: 'Triage outcome.',
        enumValues: <String>['confirmed', 'dismissed'],
      ),
      'note': JsonSchema.string(description: 'Note for the audit log.'),
    },
    required: <String>['report_id', 'status'],
    idempotent: true,
    body: (args, context) => client.alert.triageReport(
      workspaceId: workspaceId,
      reportId: args.requiredUuid('report_id'),
      status: args.requiredEnum<FakeReportStatus>(
        'status',
        FakeReportStatus.values,
      ),
      note: args.optionalString('note'),
    ),
  );

  registry.read(
    'list_verifications',
    description:
        'List consumer scan sessions with their outcomes, risk scores, and '
        'locations. Filter by batch, product, unit, outcome, or time window.',
    properties: <String, JsonSchema>{
      'batch_id': JsonSchema.string(
        description: 'Only sessions for this batch.',
      ),
      'product_id': JsonSchema.string(
        description: 'Only sessions for this product.',
      ),
      'unit_id': JsonSchema.string(description: 'Only sessions for this unit.'),
      'outcome': JsonSchema.string(
        description: 'Filter by verification outcome.',
      ),
      'risk_score': JsonSchema.string(description: 'Filter by risk score.'),
      'from': JsonSchema.string(description: 'ISO 8601 lower bound.'),
      'to': JsonSchema.string(description: 'ISO 8601 upper bound.'),
      'page': JsonSchema.integer(description: 'Page number, starting at 1.'),
      'page_size': JsonSchema.integer(description: 'Rows per page, max 200.'),
    },
    body: (args, context) {
      final paging = args.paging();
      return client.verification.list(
        workspaceId: workspaceId,
        batchId: args.optionalUuid('batch_id'),
        productId: args.optionalUuid('product_id'),
        identityId: args.optionalUuid('unit_id'),
        outcome: args.optionalEnum<VerificationOutcome>(
          'outcome',
          VerificationOutcome.values,
        ),
        riskScore: args.optionalEnum<RiskScore>('risk_score', RiskScore.values),
        from: args.optionalDate('from'),
        to: args.optionalDate('to'),
        page: paging.page,
        pageSize: paging.pageSize,
      );
    },
  );

  registry.read(
    'get_verification',
    description: 'Read one scan session by id.',
    properties: <String, JsonSchema>{
      'session_id': JsonSchema.string(
        description: 'Verification session uuid.',
      ),
    },
    required: <String>['session_id'],
    body: (args, context) =>
        client.verification.get(args.requiredUuid('session_id')),
  );

  registry.read(
    'investigate_alert',
    description:
        'Investigation report for one alert: the evidence bundle plus batch '
        'unit counts and the recent audit trail for the unit. Use this before '
        'deciding to lock a unit, recall a batch, or close the alert.',
    properties: <String, JsonSchema>{
      'alert_id': JsonSchema.string(description: 'Alert uuid.'),
      'audit_limit': JsonSchema.integer(
        description: 'How many audit events to include. Defaults to 20.',
      ),
    },
    required: <String>['alert_id'],
    body: (args, context) async {
      final alertId = args.requiredUuid('alert_id');
      final auditLimit = (args.optionalInt('audit_limit') ?? 20).clamp(1, 100);
      final evidence = await client.alert.evidence(alertId);

      final batchId = evidence.batch?.id;
      final unitId = evidence.identity?.id;

      final batchStats = batchId == null
          ? null
          : await client.batch.stats(batchId);
      final auditEvents = await client.audit.query(
        workspaceId: workspaceId,
        targetType: unitId == null ? null : 'product_identity',
        targetId: unitId,
        page: 0,
        pageSize: auditLimit,
      );

      return <String, dynamic>{
        'alert': evidence.alert,
        'unit': evidence.identity,
        'batch': evidence.batch,
        'product': evidence.product,
        'batch_stats': batchStats,
        'signals': evidence.signals,
        'reports': evidence.reports,
        'recall': evidence.recall,
        'sessions': evidence.sessions,
        'unit_sessions': evidence.identitySessions,
        'unit_audit_events': auditEvents,
        'evidence_generated_at': evidence.generatedAt,
      };
    },
  );
}
