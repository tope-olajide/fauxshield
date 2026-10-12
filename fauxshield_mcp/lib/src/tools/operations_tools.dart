import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:mcp_dart/mcp_dart.dart';

import '../gateway.dart';
import '../tool_support.dart';

/// Response operations: recalls, outbound webhooks, and attack simulations.
void registerOperationsTools(ToolRegistry registry, FauxShieldGateway gateway) {
  final client = gateway.client;
  final workspaceId = gateway.workspaceId;

  // ---------------------------------------------------------------- recalls

  registry.read(
    'list_recalls',
    description: 'List recall records for the workspace.',
    properties: <String, JsonSchema>{
      'include_lifted': JsonSchema.boolean(
        description: 'Include recalls that were lifted. Defaults to true.',
      ),
    },
    body: (args, context) => client.recall.list(
      workspaceId: workspaceId,
      includeLifted: args.optionalBool('include_lifted', fallback: true),
    ),
  );

  registry.write(
    'recall_batch',
    description:
        'Recall every unit of a batch. Scans of those units report the recall '
        'and the reason, and the batch stops accepting new units.',
    properties: <String, JsonSchema>{
      'batch_id': JsonSchema.string(description: 'Batch uuid.'),
      'reason': JsonSchema.string(
        description: 'Consumer facing reason for the recall.',
      ),
      'notes': JsonSchema.string(description: 'Internal notes.'),
    },
    required: <String>['batch_id', 'reason'],
    destructive: true,
    body: (args, context) => client.recall.recallBatch(
      workspaceId: workspaceId,
      batchId: args.requiredUuid('batch_id'),
      reason: args.requiredString('reason'),
      notes: args.optionalString('notes'),
    ),
  );

  registry.write(
    'recall_unit',
    description: 'Recall one unit without touching the rest of its batch.',
    properties: <String, JsonSchema>{
      'unit_id': JsonSchema.string(description: 'Unit uuid.'),
      'reason': JsonSchema.string(
        description: 'Consumer facing reason for the recall.',
      ),
      'notes': JsonSchema.string(description: 'Internal notes.'),
    },
    required: <String>['unit_id', 'reason'],
    destructive: true,
    body: (args, context) => client.recall.recallIdentity(
      workspaceId: workspaceId,
      identityId: args.requiredUuid('unit_id'),
      reason: args.requiredString('reason'),
      notes: args.optionalString('notes'),
    ),
  );

  registry.write(
    'lift_recall',
    description:
        'Lift a recall once the affected stock is cleared, restoring normal '
        'verification outcomes.',
    properties: <String, JsonSchema>{
      'recall_id': JsonSchema.string(description: 'Recall uuid.'),
      'note': JsonSchema.string(description: 'Why the recall is lifted.'),
    },
    required: <String>['recall_id'],
    idempotent: true,
    body: (args, context) => client.recall.lift(
      workspaceId: workspaceId,
      recallId: args.requiredUuid('recall_id'),
      note: args.optionalString('note'),
    ),
  );

  // --------------------------------------------------------------- webhooks

  registry.read(
    'list_webhooks',
    description:
        'List the webhook endpoints this workspace delivers events to.',
    body: (args, context) => client.webhookAdmin.list(workspaceId: workspaceId),
  );

  registry.write(
    'create_webhook',
    description:
        'Register a webhook endpoint. The signing secret is returned once, so '
        'it has to be stored by the receiver immediately.',
    properties: <String, JsonSchema>{
      'url': JsonSchema.string(description: 'HTTPS URL to deliver to.'),
      'events': JsonSchema.array(
        items: JsonSchema.string(),
        description: 'Event names to subscribe to.',
      ),
      'description': JsonSchema.string(
        description: 'What this endpoint is for.',
      ),
    },
    required: <String>['url', 'events'],
    body: (args, context) => client.webhookAdmin.create(
      workspaceId: workspaceId,
      url: args.requiredString('url'),
      events: _events(args),
      description: args.optionalString('description'),
    ),
  );

  registry.write(
    'update_webhook',
    description: 'Change a webhook URL, event subscriptions, or enabled state.',
    properties: <String, JsonSchema>{
      'endpoint_id': JsonSchema.string(description: 'Webhook endpoint uuid.'),
      'url': JsonSchema.string(description: 'New URL.'),
      'events': JsonSchema.array(
        items: JsonSchema.string(),
        description: 'New event subscription list.',
      ),
      'description': JsonSchema.string(description: 'New description.'),
      'enabled': JsonSchema.boolean(description: 'Pause or resume delivery.'),
    },
    required: <String>['endpoint_id'],
    idempotent: true,
    body: (args, context) => client.webhookAdmin.update(
      workspaceId: workspaceId,
      endpointId: args.requiredUuid('endpoint_id'),
      url: args.optionalString('url'),
      events: args.raw.containsKey('events') ? _events(args) : null,
      description: args.optionalString('description'),
      enabled: args.raw.containsKey('enabled')
          ? args.optionalBool('enabled')
          : null,
    ),
  );

  registry.write(
    'delete_webhook',
    description: 'Stop delivering to a webhook endpoint.',
    properties: <String, JsonSchema>{
      'endpoint_id': JsonSchema.string(description: 'Webhook endpoint uuid.'),
    },
    required: <String>['endpoint_id'],
    destructive: true,
    idempotent: true,
    body: (args, context) => client.webhookAdmin.delete(
      workspaceId: workspaceId,
      endpointId: args.requiredUuid('endpoint_id'),
    ),
  );

  registry.read(
    'test_webhook',
    description:
        'Send a test event to a webhook endpoint and report the response, so '
        'you can verify a receiver works before relying on it.',
    properties: <String, JsonSchema>{
      'endpoint_id': JsonSchema.string(description: 'Webhook endpoint uuid.'),
    },
    required: <String>['endpoint_id'],
    body: (args, context) => client.webhookAdmin.test(
      workspaceId: workspaceId,
      endpointId: args.requiredUuid('endpoint_id'),
    ),
  );

  registry.read(
    'list_webhook_deliveries',
    description:
        'List recent webhook delivery attempts with their status and response '
        'codes.',
    properties: <String, JsonSchema>{
      'endpoint_id': JsonSchema.string(
        description: 'Only deliveries for this endpoint.',
      ),
      'page': JsonSchema.integer(description: 'Page number, starting at 1.'),
      'page_size': JsonSchema.integer(description: 'Rows per page, max 200.'),
    },
    required: <String>['endpoint_id'],
    body: (args, context) {
      final paging = args.paging();
      return client.webhookAdmin.deliveries(
        workspaceId: workspaceId,
        endpointId: args.requiredUuid('endpoint_id'),
        page: paging.page,
        pageSize: paging.pageSize,
      );
    },
  );

  registry.write(
    'redeliver_webhook',
    description: 'Replay one failed webhook delivery.',
    properties: <String, JsonSchema>{
      'delivery_id': JsonSchema.string(description: 'Delivery uuid.'),
    },
    required: <String>['delivery_id'],
    idempotent: true,
    body: (args, context) => client.webhookAdmin.redeliver(
      workspaceId: workspaceId,
      deliveryId: args.requiredUuid('delivery_id'),
    ),
  );

  // ------------------------------------------------------------ simulations

  registry.read(
    'list_simulations',
    description:
        'List attack simulations. These replay realistic counterfeiting '
        'scenarios against the fraud engine.',
    properties: <String, JsonSchema>{
      'page': JsonSchema.integer(description: 'Page number, starting at 1.'),
      'page_size': JsonSchema.integer(description: 'Rows per page, max 200.'),
    },
    body: (args, context) {
      final paging = args.paging();
      return client.simulation.list(
        workspaceId: workspaceId,
        page: paging.page,
        pageSize: paging.pageSize,
      );
    },
  );

  registry.read(
    'get_simulation',
    description: 'Read one simulation by id, with its progress.',
    properties: <String, JsonSchema>{
      'simulation_id': JsonSchema.string(description: 'Simulation uuid.'),
    },
    required: <String>['simulation_id'],
    body: (args, context) =>
        client.simulation.get(args.requiredUuid('simulation_id')),
  );

  registry.write(
    'start_simulation',
    description:
        'Start an attack simulation to exercise the fraud engine. Running a '
        'simulation writes real scans and alerts into this workspace.',
    properties: <String, JsonSchema>{
      'type': JsonSchema.string(
        description: 'Scenario to run.',
        enumValues: <String>[
          'greyMarket',
          'cloneFactory',
          'pinBruteForce',
          'falsePositive',
        ],
      ),
      'batch_id': JsonSchema.string(
        description: 'Batch to target. One is chosen automatically if omitted.',
      ),
      'label': JsonSchema.string(description: 'Label shown in the console.'),
      'steps': JsonSchema.integer(description: 'Number of scan steps.'),
      'step_delay_seconds': JsonSchema.integer(
        description: 'Seconds between steps.',
      ),
    },
    required: <String>['type'],
    destructive: true,
    body: (args, context) => client.simulation.start(
      workspaceId: workspaceId,
      request: SimulationRequest(
        type: args.requiredEnum<SimulationType>(
          'type',
          SimulationType.values,
        ),
        batchId: args.optionalUuid('batch_id'),
        label: args.optionalString('label'),
        steps: args.optionalInt('steps'),
        stepDelaySeconds: args.optionalInt('step_delay_seconds'),
      ),
    ),
  );

  registry.write(
    'cancel_simulation',
    description: 'Stop a running simulation.',
    properties: <String, JsonSchema>{
      'simulation_id': JsonSchema.string(description: 'Simulation uuid.'),
    },
    required: <String>['simulation_id'],
    idempotent: true,
    body: (args, context) =>
        client.simulation.cancel(args.requiredUuid('simulation_id')),
  );
}

/// Parses the `events` argument into webhook event types.
List<WebhookEventType> _events(ToolArgs args) {
  final names = args.optionalStringList('events');
  if (names == null || names.isEmpty) {
    throw ToolError(
      'Provide at least one event name.',
      hint:
          'Valid events: '
          '${WebhookEventType.values.map((value) => value.name).join(', ')}.',
    );
  }
  return names
      .map((name) {
        final normalized = name.toLowerCase();
        for (final value in WebhookEventType.values) {
          if (value.name.toLowerCase() == normalized) return value;
        }
        throw ToolError(
          'Unknown webhook event "$name".',
          hint:
              'Valid events: '
              '${WebhookEventType.values.map((value) => value.name).join(', ')}.',
        );
      })
      .toList(growable: false);
}
