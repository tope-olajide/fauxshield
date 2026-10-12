// GENERATED FILE - do not edit.
//
// Written by tool/generate_docs.dart from the API contract and the doc
// comments on the endpoint implementations. Run that tool after a model or
// endpoint change; CI fails when this file is out of date.
library;

import 'docs_model.dart';

/// Fingerprint of the generated client the contract was read from.
const String docsContractSourceHash = 'b22a41d3';

/// The API, as the documentation portal describes it.
final DocsApi docsApi = DocsApi(
  endpoints: <DocsEndpoint>[
    DocsEndpoint(
      name: 'alert',
      title: 'Alerts',
      summary:
          'Fraud alert queue, evidence assembly, and consumer report triage.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'assign',
          returns: 'FraudAlert',
          summary: 'Assigns an alert to an investigator.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'alertId', type: 'UuidValue', required: true),
            DocsParam(name: 'assignee', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'evidence',
          returns: 'AlertEvidence',
          summary:
              'Assembles everything needed to investigate one alert in a single call.',
          params: <DocsParam>[
            DocsParam(name: 'alertId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'get',
          returns: 'FraudAlert',
          summary: 'Loads one alert.',
          params: <DocsParam>[
            DocsParam(name: 'alertId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'list',
          returns: 'List<FraudAlert>',
          summary: 'Lists alerts, newest first.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'status', type: 'AlertStatus', nullable: true),
            DocsParam(name: 'severity', type: 'AlertSeverity', nullable: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'reports',
          returns: 'List<FakeReport>',
          summary: 'Lists consumer reports for triage.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'status', type: 'FakeReportStatus', nullable: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'signals',
          returns: 'List<FraudSignalRecord>',
          summary: 'Lists raw fraud signals for the intelligence feed.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'batchId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'type', type: 'SignalType', nullable: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'triageReport',
          returns: 'FakeReport',
          summary: 'Triages a consumer report.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'reportId', type: 'UuidValue', required: true),
            DocsParam(name: 'status', type: 'FakeReportStatus', required: true),
            DocsParam(name: 'note', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'updateStatus',
          returns: 'FraudAlert',
          summary: 'Moves an alert through its workflow.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'alertId', type: 'UuidValue', required: true),
            DocsParam(name: 'status', type: 'AlertStatus', required: true),
            DocsParam(name: 'note', type: 'String', nullable: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'analytics',
      title: 'Analytics',
      summary: 'Dashboard analytics for the command center.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'dashboard',
          returns: 'DashboardSummary',
          summary:
              'Builds the dashboard payload for the last [windowDays] days.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'windowDays', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'rollupNow',
          returns: 'DailyWorkspaceStat',
          summary: 'Recomputes one day\'s rollup on demand. Defaults to today.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'day', type: 'DateTime', nullable: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'apiKey',
      title: 'API keys',
      summary: 'API key management for machine access.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'create',
          returns: 'ApiKeySecret',
          summary: 'Creates a key. The secret is returned exactly once.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'label', type: 'String', required: true),
            DocsParam(name: 'scopes', type: 'List<ApiScope>', required: true),
            DocsParam(name: 'rateLimitPerMinute', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'list',
          returns: 'List<ApiKey>',
          summary: 'Lists keys without their hashes.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'revoke',
          returns: 'ApiKey',
          summary: 'Revokes a key immediately.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'apiKeyId', type: 'UuidValue', required: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'audit',
      title: 'Audits',
      summary: 'Append-only audit log access.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'query',
          returns: 'List<AuditEvent>',
          summary: 'Queries audit events with optional filters.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'action', type: 'String', nullable: true),
            DocsParam(name: 'actorIdentifier', type: 'String', nullable: true),
            DocsParam(name: 'targetType', type: 'String', nullable: true),
            DocsParam(name: 'targetId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'from', type: 'DateTime', nullable: true),
            DocsParam(name: 'to', type: 'DateTime', nullable: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'batch',
      title: 'Batchs',
      summary: 'Manufacturing batch management.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'create',
          returns: 'Batch',
          summary: 'Creates a batch for a product.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'productId', type: 'UuidValue', required: true),
            DocsParam(name: 'reference', type: 'String', required: true),
            DocsParam(
              name: 'manufactureDate',
              type: 'DateTime',
              required: true,
            ),
            DocsParam(name: 'expiryDate', type: 'DateTime', nullable: true),
            DocsParam(
              name: 'distributionRegion',
              type: 'String',
              required: true,
            ),
            DocsParam(name: 'quantity', type: 'int', required: true),
            DocsParam(name: 'notes', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'generateIdentities',
          returns: 'IdentityGenerationResult',
          summary:
              'Generates serialized identities for a batch. Safe to retry: the same idempotency key replays the original result instead of minting another run of tokens.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'batchId', type: 'UuidValue', required: true),
            DocsParam(name: 'quantity', type: 'int', required: true),
            DocsParam(name: 'idempotencyKey', type: 'String', required: true),
          ],
        ),
        DocsMethod(
          name: 'get',
          returns: 'Batch',
          summary: 'Loads one batch.',
          params: <DocsParam>[
            DocsParam(name: 'batchId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'list',
          returns: 'List<Batch>',
          summary:
              'Lists batches for the workspace, optionally for one product.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'productId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'stats',
          returns: 'BatchStats',
          summary: 'Identity level statistics for the batch detail screen.',
          params: <DocsParam>[
            DocsParam(name: 'batchId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'update',
          returns: 'Batch',
          summary: 'Updates an active batch. Recalled batches are immutable.',
          params: <DocsParam>[
            DocsParam(name: 'batchId', type: 'UuidValue', required: true),
            DocsParam(name: 'reference', type: 'String', nullable: true),
            DocsParam(name: 'expiryDate', type: 'DateTime', nullable: true),
            DocsParam(
              name: 'distributionRegion',
              type: 'String',
              nullable: true,
            ),
            DocsParam(name: 'quantity', type: 'int', nullable: true),
            DocsParam(name: 'notes', type: 'String', nullable: true),
            DocsParam(name: 'status', type: 'BatchStatus', nullable: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'demo',
      title: 'Demos',
      summary:
          'One click demo access. The first caller creates the public demo workspace; everyone after that joins it. Passing the configured `demoSeedSecret` resets the demo data, which keeps review environments clean without letting visitors wipe the workspace they are browsing.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'isSeeded',
          returns: 'bool',
          summary: 'Whether a demo workspace already exists.',
          params: <DocsParam>[],
        ),
        DocsMethod(
          name: 'seed',
          returns: 'WorkspaceBootstrap',
          summary: 'Seeds (when missing) or joins the public demo workspace.',
          params: <DocsParam>[
            DocsParam(name: 'email', type: 'String', nullable: true),
            DocsParam(name: 'displayName', type: 'String', nullable: true),
            DocsParam(name: 'secret', type: 'String', nullable: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'identity',
      title: 'Identitys',
      summary:
          'Serialized identity management: browsing, exports, PIN reveal, token regeneration, and lock state.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'delete',
          returns: 'ProductIdentity',
          summary: 'Soft deletes an identity. The QR token stops resolving.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'identityId', type: 'UuidValue', required: true),
            DocsParam(name: 'reason', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'export',
          returns: 'ExportFile',
          summary:
              'Exports identities as CSV or TSV. Bounded so a single call cannot exhaust server resources; truncated exports are flagged in the result.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'batchId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'format', type: 'ExportFormat', required: true),
          ],
        ),
        DocsMethod(
          name: 'get',
          returns: 'ProductIdentity',
          summary: 'Loads one identity.',
          params: <DocsParam>[
            DocsParam(name: 'identityId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'list',
          returns: 'List<ProductIdentity>',
          summary: 'Lists identities with filters and pagination.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'batchId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'status', type: 'IdentityStatus', nullable: true),
            DocsParam(name: 'onlyFlagged', type: 'bool', required: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'lock',
          returns: 'ProductIdentity',
          summary:
              'Locks an identity so verification reports fraud until it is unlocked.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'identityId', type: 'UuidValue', required: true),
            DocsParam(name: 'reason', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'regenerateToken',
          returns: 'ProductIdentity',
          summary:
              'Regenerates a compromised token. The old token stops resolving.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'identityId', type: 'UuidValue', required: true),
            DocsParam(name: 'reason', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'restore',
          returns: 'ProductIdentity',
          summary: 'Restores a soft deleted identity to active status.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'identityId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'revealPin',
          returns: 'RevealedPin',
          summary:
              'Reveals the packaging PIN for one identity. Owner only, always audited.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'identityId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'unlock',
          returns: 'ProductIdentity',
          summary: 'Unlocks an identity after investigation.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'identityId', type: 'UuidValue', required: true),
            DocsParam(name: 'note', type: 'String', nullable: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'notification',
      title: 'Notifications',
      summary: 'In-app notifications and per-member preferences.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'list',
          returns: 'List<Notification>',
          summary: 'Lists notifications for the signed-in member.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'onlyUnread', type: 'bool', required: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'markAllRead',
          returns: 'int',
          summary: 'Marks every unread notification for the member as read.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'markRead',
          returns: 'Notification',
          summary: 'Marks one notification as read.',
          params: <DocsParam>[
            DocsParam(
              name: 'notificationId',
              type: 'UuidValue',
              required: true,
            ),
          ],
        ),
        DocsMethod(
          name: 'preferences',
          returns: 'List<NotificationPreference>',
          summary: 'Lists the member\'s notification preferences.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'updatePreference',
          returns: 'NotificationPreference',
          summary: 'Creates or updates one channel preference.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(
              name: 'channel',
              type: 'NotificationChannel',
              required: true,
            ),
            DocsParam(name: 'enabled', type: 'bool', required: true),
            DocsParam(
              name: 'minSeverity',
              type: 'AlertSeverity',
              required: true,
            ),
            DocsParam(name: 'email', type: 'String', nullable: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'offline',
      title: 'Offlines',
      summary:
          'Offline field scan ingestion. Inspector devices queue scans locally while offline. When connectivity returns they either upload them here for immediate verdicts, or let Serverpod\'s offline sync mirror the rows and the recurring converter process them. Both paths converge on the same server side conversion.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'convertNow',
          returns: 'int',
          summary:
              'Converts pending scans immediately instead of waiting for the scheduler.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'ingest',
          returns: 'List<OfflineScanVerdict>',
          summary:
              'Uploads a batch of queued scans and returns authoritative verdicts.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'deviceId', type: 'String', required: true),
            DocsParam(
              name: 'scans',
              type: 'List<OfflineScanInput>',
              required: true,
            ),
          ],
        ),
        DocsMethod(
          name: 'records',
          returns: 'List<OfflineScanRecord>',
          summary:
              'Lists synced scans for a device, newest first, with their verdicts.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'deviceId', type: 'String', nullable: true),
            DocsParam(name: 'onlyPending', type: 'bool', required: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'product',
      title: 'Products',
      summary: 'Product catalog management.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'archive',
          returns: 'Product',
          summary: 'Archives a product. Batches and identities are preserved.',
          params: <DocsParam>[
            DocsParam(name: 'productId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'create',
          returns: 'Product',
          summary: 'Creates a product.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'name', type: 'String', required: true),
            DocsParam(name: 'sku', type: 'String', nullable: true),
            DocsParam(name: 'category', type: 'String', nullable: true),
            DocsParam(name: 'description', type: 'String', nullable: true),
            DocsParam(name: 'imageUrls', type: 'List<String>', nullable: true),
            DocsParam(name: 'packaging', type: 'String', nullable: true),
            DocsParam(name: 'shelfLife', type: 'String', nullable: true),
            DocsParam(
              name: 'countryRestrictions',
              type: 'List<String>',
              nullable: true,
            ),
            DocsParam(
              name: 'safetyInstructions',
              type: 'String',
              nullable: true,
            ),
          ],
        ),
        DocsMethod(
          name: 'delete',
          returns: 'Product',
          summary:
              'Moves a product to the recycle bin. Batches and identities stay attached and the product can be restored with [restore] until it is purged.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'productId', type: 'UuidValue', required: true),
            DocsParam(name: 'reason', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'deleteImpact',
          returns: 'ProductDeleteImpact',
          summary:
              'Counts everything a delete or purge would affect, so the confirmation dialogs can spell out exactly what is at stake.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'productId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'get',
          returns: 'Product',
          summary: 'Loads one product.',
          params: <DocsParam>[
            DocsParam(name: 'productId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'list',
          returns: 'List<Product>',
          summary: 'Lists products, optionally filtered by a search term.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'search', type: 'String', nullable: true),
            DocsParam(name: 'includeArchived', type: 'bool', required: true),
          ],
        ),
        DocsMethod(
          name: 'listDeleted',
          returns: 'List<Product>',
          summary: 'Lists the products sitting in the recycle bin.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'purge',
          returns: 'void',
          summary:
              'Permanently deletes a recycled product and everything attached to it: batches, serialized units, verification sessions, reports, and fraud evidence. Audit events and fraud alerts are kept as history. This cannot be undone.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'productId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'restore',
          returns: 'Product',
          summary: 'Restores a recycled product to the live catalog.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'productId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'update',
          returns: 'Product',
          summary: 'Updates product details. Only supplied fields change.',
          params: <DocsParam>[
            DocsParam(name: 'productId', type: 'UuidValue', required: true),
            DocsParam(name: 'name', type: 'String', nullable: true),
            DocsParam(name: 'sku', type: 'String', nullable: true),
            DocsParam(name: 'category', type: 'String', nullable: true),
            DocsParam(name: 'description', type: 'String', nullable: true),
            DocsParam(name: 'imageUrls', type: 'List<String>', nullable: true),
            DocsParam(name: 'packaging', type: 'String', nullable: true),
            DocsParam(name: 'shelfLife', type: 'String', nullable: true),
            DocsParam(
              name: 'countryRestrictions',
              type: 'List<String>',
              nullable: true,
            ),
            DocsParam(
              name: 'safetyInstructions',
              type: 'String',
              nullable: true,
            ),
          ],
        ),
        DocsMethod(
          name: 'uploadImage',
          returns: 'String',
          summary:
              'Uploads a product image and returns its public URL. Flutter web cannot post multipart forms to Serverpod endpoints, so the bytes arrive base64-encoded. The payload is validated by magic-byte sniffing and a 2 MB cap, written to the public cloud storage under `products/`, and returned as the absolute URL the storage serves it from. Storage rather than the podlet\'s disk is what makes the image survive a deploy, a restart, and a second instance. When [productId] is given the URL is appended to the product\'s `imageUrls` (capped at [_maxProductImages] images).',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'fileName', type: 'String', required: true),
            DocsParam(name: 'data', type: 'String', required: true),
            DocsParam(name: 'productId', type: 'UuidValue', nullable: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'recall',
      title: 'Recalls',
      summary:
          'Batch and identity recalls. Verification reports the recalled outcome while a recall is active, and every recall is announced through live events, notifications, and webhooks.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'lift',
          returns: 'RecallResult',
          summary: 'Lifts a recall. Units return to normal verification.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'recallId', type: 'UuidValue', required: true),
            DocsParam(name: 'note', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'list',
          returns: 'List<RecallRecord>',
          summary: 'Lists recall history.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'includeLifted', type: 'bool', required: true),
          ],
        ),
        DocsMethod(
          name: 'recallBatch',
          returns: 'RecallResult',
          summary: 'Recalls a whole batch.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'batchId', type: 'UuidValue', required: true),
            DocsParam(name: 'reason', type: 'String', required: true),
            DocsParam(name: 'notes', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'recallIdentity',
          returns: 'RecallResult',
          summary: 'Recalls one identity.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'identityId', type: 'UuidValue', required: true),
            DocsParam(name: 'reason', type: 'String', required: true),
            DocsParam(name: 'notes', type: 'String', nullable: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'simulation',
      title: 'Simulations',
      summary:
          'Attack simulation control. Simulations run realistic attack scenarios through the real fraud pipeline, so the command center can rehearse its response to clone attacks, PIN brute force, scan bursts, and grey market leaks.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'cancel',
          returns: 'AttackSimulation',
          summary: 'Cancels a queued or running simulation.',
          params: <DocsParam>[
            DocsParam(name: 'simulationId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'get',
          returns: 'AttackSimulation',
          summary: 'Loads one simulation.',
          params: <DocsParam>[
            DocsParam(name: 'simulationId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'list',
          returns: 'List<AttackSimulation>',
          summary: 'Lists recent simulations.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'run',
          returns: 'AttackSimulation',
          summary: 'Runs any remaining steps inline.',
          params: <DocsParam>[
            DocsParam(name: 'simulationId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'start',
          returns: 'AttackSimulation',
          summary: 'Starts a simulation. Zero delay runs to completion inline.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(
              name: 'request',
              type: 'SimulationRequest',
              required: true,
            ),
          ],
        ),
        DocsMethod(
          name: 'step',
          returns: 'AttackSimulation',
          summary:
              'Advances a simulation by one step immediately. Useful for tests and for walking a simulation forward by hand while watching the command center stream.',
          params: <DocsParam>[
            DocsParam(name: 'simulationId', type: 'UuidValue', required: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'verification',
      title: 'Verifications',
      summary:
          'The verification flow. Consumer calls are unauthenticated by design: a shopper scans a QR code on a product without an account. Every call after the first is addressed by a session id plus the device fingerprint that created the session, and only allow-listed `VerificationPresentation` data ever leaves the server.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'acknowledge',
          returns: 'VerificationPresentation',
          summary: '',
          params: <DocsParam>[
            DocsParam(name: 'sessionId', type: 'UuidValue', required: true),
            DocsParam(
              name: 'deviceFingerprint',
              type: 'String',
              required: true,
            ),
          ],
        ),
        DocsMethod(
          name: 'get',
          returns: 'VerificationSession',
          summary: 'Loads one verification session.',
          params: <DocsParam>[
            DocsParam(name: 'sessionId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'list',
          returns: 'List<VerificationSession>',
          summary: 'Lists verification sessions for the operator console.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'identityId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'batchId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'productId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'state', type: 'VerificationState', nullable: true),
            DocsParam(
              name: 'outcome',
              type: 'VerificationOutcome',
              nullable: true,
            ),
            DocsParam(name: 'riskScore', type: 'RiskScore', nullable: true),
            DocsParam(name: 'source', type: 'ScanSource', nullable: true),
            DocsParam(name: 'from', type: 'DateTime', nullable: true),
            DocsParam(name: 'to', type: 'DateTime', nullable: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'reportFake',
          returns: 'ReportAcknowledgement',
          summary: '',
          params: <DocsParam>[
            DocsParam(name: 'sessionId', type: 'UuidValue', required: true),
            DocsParam(
              name: 'deviceFingerprint',
              type: 'String',
              required: true,
            ),
            DocsParam(name: 'reason', type: 'String', required: true),
            DocsParam(name: 'comment', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'result',
          returns: 'VerificationPresentation',
          summary: '',
          params: <DocsParam>[
            DocsParam(name: 'sessionId', type: 'UuidValue', required: true),
            DocsParam(
              name: 'deviceFingerprint',
              type: 'String',
              required: true,
            ),
          ],
        ),
        DocsMethod(
          name: 'start',
          returns: 'VerificationPresentation',
          summary: '',
          params: <DocsParam>[
            DocsParam(name: 'token', type: 'String', required: true),
            DocsParam(
              name: 'deviceFingerprint',
              type: 'String',
              required: true,
            ),
          ],
        ),
        DocsMethod(
          name: 'submitPin',
          returns: 'VerificationPresentation',
          summary: '',
          params: <DocsParam>[
            DocsParam(name: 'sessionId', type: 'UuidValue', required: true),
            DocsParam(
              name: 'deviceFingerprint',
              type: 'String',
              required: true,
            ),
            DocsParam(name: 'pin', type: 'String', required: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'webhookAdmin',
      title: 'Webhooks',
      summary: 'Webhook endpoint administration and delivery inspection.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'create',
          returns: 'WebhookEndpointSecret',
          summary:
              'Registers a webhook endpoint. The signing secret is shown once.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'url', type: 'String', required: true),
            DocsParam(
              name: 'events',
              type: 'List<WebhookEventType>',
              required: true,
            ),
            DocsParam(name: 'description', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'delete',
          returns: 'WebhookEndpoint',
          summary: 'Soft deletes a webhook endpoint.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'endpointId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'deliveries',
          returns: 'List<WebhookDelivery>',
          summary: 'Lists recent deliveries for an endpoint.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'endpointId', type: 'UuidValue', required: true),
            DocsParam(name: 'page', type: 'int', required: true),
            DocsParam(name: 'pageSize', type: 'int', required: true),
          ],
        ),
        DocsMethod(
          name: 'drainNow',
          returns: 'int',
          summary:
              'Drains the outbox immediately instead of waiting for the scheduled task.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'list',
          returns: 'List<WebhookEndpoint>',
          summary: 'Lists active webhook endpoints.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'redeliver',
          returns: 'WebhookDelivery',
          summary: 'Requeues a delivery and attempts it immediately.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'deliveryId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'rotateSecret',
          returns: 'WebhookEndpointSecret',
          summary:
              'Rotates the signing secret. The previous secret stays valid during rotation so in-flight deliveries still verify.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'endpointId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'test',
          returns: 'WebhookTestResult',
          summary:
              'Sends a signed test delivery and reports the result inline.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'endpointId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'update',
          returns: 'WebhookEndpoint',
          summary: 'Updates a webhook endpoint.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'endpointId', type: 'UuidValue', required: true),
            DocsParam(name: 'url', type: 'String', nullable: true),
            DocsParam(
              name: 'events',
              type: 'List<WebhookEventType>',
              nullable: true,
            ),
            DocsParam(name: 'description', type: 'String', nullable: true),
            DocsParam(name: 'enabled', type: 'bool', nullable: true),
          ],
        ),
      ],
    ),
    DocsEndpoint(
      name: 'workspace',
      title: 'Workspaces',
      summary:
          'Workspace lifecycle and team management. Every operator call resolves the workspace server side from the authenticated user\'s membership; a client supplied workspace id is only ever used as a hint and is verified against that membership.',
      methods: <DocsMethod>[
        DocsMethod(
          name: 'acceptInvitation',
          returns: 'WorkspaceBootstrap',
          summary: 'Redeems an invite code and joins the workspace.',
          params: <DocsParam>[
            DocsParam(name: 'code', type: 'String', required: true),
            DocsParam(name: 'displayName', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'bootstrap',
          returns: 'WorkspaceBootstrap?',
          summary:
              'Resolves the signed-in operator\'s workspace. Returns null when the user has not joined or created a workspace yet, so the app can show onboarding instead of an error.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'changeRole',
          returns: 'WorkspaceMember',
          summary:
              'Changes a member\'s role. Requires the `teamWrite` permission.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'memberId', type: 'UuidValue', required: true),
            DocsParam(name: 'role', type: 'MembershipRole', required: true),
          ],
        ),
        DocsMethod(
          name: 'create',
          returns: 'WorkspaceBootstrap',
          summary: 'Creates a workspace owned by the signed-in operator.',
          params: <DocsParam>[
            DocsParam(name: 'name', type: 'String', required: true),
            DocsParam(name: 'email', type: 'String', nullable: true),
            DocsParam(name: 'authenticMessage', type: 'String', nullable: true),
            DocsParam(name: 'branding', type: 'Branding', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'invitations',
          returns: 'List<Invitation>',
          summary: 'Lists pending invitations.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'invite',
          returns: 'InvitationCreated',
          summary:
              'Invites a teammate. The code is returned once and stored hashed.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'email', type: 'String', required: true),
            DocsParam(name: 'role', type: 'MembershipRole', required: true),
          ],
        ),
        DocsMethod(
          name: 'joinDemo',
          returns: 'WorkspaceBootstrap',
          summary:
              'Joins the public demo workspace. Demo workspaces are explicitly marked `demoMode` and can be reset at any time, which is what makes them safe to open up. Joining grants the owner role so every feature is testable.',
          params: <DocsParam>[
            DocsParam(name: 'email', type: 'String', nullable: true),
            DocsParam(name: 'displayName', type: 'String', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'members',
          returns: 'List<WorkspaceMember>',
          summary: 'Lists workspace members.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
          ],
        ),
        DocsMethod(
          name: 'removeMember',
          returns: 'void',
          summary: 'Removes a member. Owners must transfer ownership first.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'memberId', type: 'UuidValue', required: true),
          ],
        ),
        DocsMethod(
          name: 'update',
          returns: 'Workspace',
          summary:
              'Updates workspace settings. Requires the `workspaceWrite` permission.',
          params: <DocsParam>[
            DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
            DocsParam(name: 'name', type: 'String', nullable: true),
            DocsParam(name: 'branding', type: 'Branding', nullable: true),
            DocsParam(name: 'authenticMessage', type: 'String', nullable: true),
            DocsParam(
              name: 'restrictedCountries',
              type: 'List<String>',
              nullable: true,
            ),
            DocsParam(name: 'fraudPolicy', type: 'FraudPolicy', nullable: true),
          ],
        ),
      ],
    ),
  ],
  models: <DocsModel>[
    DocsModel(
      name: 'AlertEvidence',
      fields: <DocsParam>[
        DocsParam(name: 'alert', type: 'FraudAlert'),
        DocsParam(name: 'identity', type: 'ProductIdentity', nullable: true),
        DocsParam(name: 'batch', type: 'Batch', nullable: true),
        DocsParam(name: 'product', type: 'Product', nullable: true),
        DocsParam(name: 'sessions', type: 'List<VerificationSession>'),
        DocsParam(name: 'identitySessions', type: 'List<VerificationSession>'),
        DocsParam(name: 'signals', type: 'List<FraudSignalRecord>'),
        DocsParam(name: 'reports', type: 'List<FakeReport>'),
        DocsParam(name: 'recall', type: 'RecallRecord', nullable: true),
        DocsParam(name: 'generatedAt', type: 'DateTime'),
      ],
    ),
    DocsModel(
      name: 'ApiKey',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'label', type: 'String'),
        DocsParam(name: 'keyPrefix', type: 'String'),
        DocsParam(name: 'scopes', type: 'List<ApiScope>'),
        DocsParam(name: 'rateLimitPerMinute', type: 'int', defaultValue: '120'),
        DocsParam(name: 'lastUsedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'revoked', type: 'bool', defaultValue: 'false'),
        DocsParam(name: 'createdBy', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'revokedAt', type: 'DateTime', nullable: true),
      ],
    ),
    DocsModel(
      name: 'ApiKeySecret',
      fields: <DocsParam>[
        DocsParam(name: 'apiKey', type: 'ApiKey'),
        DocsParam(name: 'secret', type: 'String'),
        DocsParam(name: 'warning', type: 'String'),
      ],
    ),
    DocsModel(
      name: 'AttackSimulation',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'type', type: 'SimulationType'),
        DocsParam(
          name: 'status',
          type: 'SimulationStatus',
          defaultValue: 'SimulationStatus.queued',
        ),
        DocsParam(name: 'label', type: 'String', nullable: true),
        DocsParam(name: 'paramsJson', type: 'String', nullable: true),
        DocsParam(name: 'progress', type: 'int', defaultValue: '0'),
        DocsParam(name: 'totalSteps', type: 'int', defaultValue: '0'),
        DocsParam(name: 'summaryJson', type: 'String', nullable: true),
        DocsParam(name: 'createdBy', type: 'String'),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'startedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'completedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'cancelledAt', type: 'DateTime', nullable: true),
      ],
    ),
    DocsModel(
      name: 'AuditEvent',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(
          name: 'actorType',
          type: 'ActorType',
          defaultValue: 'ActorType.system',
        ),
        DocsParam(name: 'actorIdentifier', type: 'String', nullable: true),
        DocsParam(name: 'apiKeyId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'action', type: 'String'),
        DocsParam(name: 'targetType', type: 'String'),
        DocsParam(name: 'targetId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'metadataJson', type: 'String', nullable: true),
        DocsParam(name: 'ipAddress', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'Batch',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'productId', type: 'UuidValue'),
        DocsParam(name: 'reference', type: 'String'),
        DocsParam(name: 'manufactureDate', type: 'DateTime'),
        DocsParam(name: 'expiryDate', type: 'DateTime', nullable: true),
        DocsParam(name: 'distributionRegion', type: 'String'),
        DocsParam(name: 'quantity', type: 'int'),
        DocsParam(
          name: 'status',
          type: 'BatchStatus',
          defaultValue: 'BatchStatus.created',
        ),
        DocsParam(name: 'notes', type: 'String', nullable: true),
        DocsParam(name: 'recallReason', type: 'String', nullable: true),
        DocsParam(name: 'recalledAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'recalledBy', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(
          name: 'updatedAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'BatchStats',
      fields: <DocsParam>[
        DocsParam(name: 'batchId', type: 'UuidValue'),
        DocsParam(name: 'totalIdentities', type: 'int'),
        DocsParam(name: 'generated', type: 'int'),
        DocsParam(name: 'active', type: 'int'),
        DocsParam(name: 'verified', type: 'int'),
        DocsParam(name: 'locked', type: 'int'),
        DocsParam(name: 'recalled', type: 'int'),
        DocsParam(name: 'deleted', type: 'int'),
        DocsParam(name: 'flagged', type: 'int'),
        DocsParam(name: 'generatedAt', type: 'DateTime'),
      ],
    ),
    DocsModel(
      name: 'Branding',
      fields: <DocsParam>[
        DocsParam(name: 'displayName', type: 'String', nullable: true),
        DocsParam(name: 'logoUrl', type: 'String', nullable: true),
        DocsParam(name: 'themeColor', type: 'String', nullable: true),
        DocsParam(name: 'tagline', type: 'String', nullable: true),
      ],
    ),
    DocsModel(
      name: 'CountryStat',
      fields: <DocsParam>[
        DocsParam(name: 'country', type: 'String'),
        DocsParam(name: 'countryCode', type: 'String', nullable: true),
        DocsParam(name: 'verifications', type: 'int'),
        DocsParam(name: 'fraud', type: 'int'),
      ],
    ),
    DocsModel(
      name: 'DailyWorkspaceStat',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'date', type: 'DateTime'),
        DocsParam(name: 'verifications', type: 'int', defaultValue: '0'),
        DocsParam(name: 'authentic', type: 'int', defaultValue: '0'),
        DocsParam(name: 'alreadyVerified', type: 'int', defaultValue: '0'),
        DocsParam(name: 'invalidPin', type: 'int', defaultValue: '0'),
        DocsParam(name: 'fraudSuspected', type: 'int', defaultValue: '0'),
        DocsParam(name: 'highRisk', type: 'int', defaultValue: '0'),
        DocsParam(name: 'recalled', type: 'int', defaultValue: '0'),
        DocsParam(name: 'alertsCreated', type: 'int', defaultValue: '0'),
        DocsParam(name: 'alertsResolved', type: 'int', defaultValue: '0'),
        DocsParam(name: 'topCountriesJson', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'DashboardSummary',
      fields: <DocsParam>[
        DocsParam(name: 'windowDays', type: 'int'),
        DocsParam(name: 'totalVerifications', type: 'int'),
        DocsParam(name: 'authentic', type: 'int'),
        DocsParam(name: 'alreadyVerified', type: 'int'),
        DocsParam(name: 'invalidPin', type: 'int'),
        DocsParam(name: 'fraudSuspected', type: 'int'),
        DocsParam(name: 'highRisk', type: 'int'),
        DocsParam(name: 'recalled', type: 'int'),
        DocsParam(name: 'openAlerts', type: 'int'),
        DocsParam(name: 'criticalAlerts', type: 'int'),
        DocsParam(name: 'identitiesTotal', type: 'int'),
        DocsParam(name: 'identitiesLocked', type: 'int'),
        DocsParam(name: 'identitiesRecalled', type: 'int'),
        DocsParam(name: 'batchesTotal', type: 'int'),
        DocsParam(name: 'productsTotal', type: 'int'),
        DocsParam(name: 'trend', type: 'List<TrendPoint>'),
        DocsParam(name: 'topCountries', type: 'List<CountryStat>'),
        DocsParam(name: 'outcomes', type: 'List<OutcomeBreakdown>'),
        DocsParam(name: 'recentAlerts', type: 'List<FraudAlert>'),
        DocsParam(name: 'generatedAt', type: 'DateTime'),
      ],
    ),
    DocsModel(
      name: 'ExportFile',
      fields: <DocsParam>[
        DocsParam(name: 'filename', type: 'String'),
        DocsParam(name: 'mimeType', type: 'String'),
        DocsParam(name: 'content', type: 'String'),
        DocsParam(name: 'rowCount', type: 'int'),
        DocsParam(name: 'truncated', type: 'bool'),
      ],
    ),
    DocsModel(
      name: 'FakeReport',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'identityId', type: 'UuidValue'),
        DocsParam(name: 'sessionId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'reason', type: 'String'),
        DocsParam(name: 'comment', type: 'String', nullable: true),
        DocsParam(name: 'photoStorageId', type: 'String', nullable: true),
        DocsParam(name: 'photoPath', type: 'String', nullable: true),
        DocsParam(name: 'deviceFingerprint', type: 'String', nullable: true),
        DocsParam(name: 'country', type: 'String', nullable: true),
        DocsParam(name: 'city', type: 'String', nullable: true),
        DocsParam(
          name: 'status',
          type: 'FakeReportStatus',
          defaultValue: 'FakeReportStatus.open',
        ),
        DocsParam(
          name: 'source',
          type: 'ScanSource',
          defaultValue: 'ScanSource.consumerWeb',
        ),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'triagedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'triagedBy', type: 'String', nullable: true),
      ],
    ),
    DocsModel(
      name: 'FraudAlert',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'identityId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'batchId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'sessionId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'severity', type: 'AlertSeverity'),
        DocsParam(
          name: 'status',
          type: 'AlertStatus',
          defaultValue: 'AlertStatus.open',
        ),
        DocsParam(name: 'title', type: 'String'),
        DocsParam(name: 'description', type: 'String'),
        DocsParam(name: 'recommendedAction', type: 'String', nullable: true),
        DocsParam(
          name: 'signalTypes',
          type: 'List<SignalType>',
          nullable: true,
        ),
        DocsParam(name: 'dedupeKey', type: 'String'),
        DocsParam(name: 'autoLocked', type: 'bool', defaultValue: 'false'),
        DocsParam(name: 'assignee', type: 'String', nullable: true),
        DocsParam(name: 'simulationId', type: 'UuidValue', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(
          name: 'updatedAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'acknowledgedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'resolvedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'resolvedBy', type: 'String', nullable: true),
        DocsParam(name: 'resolutionNote', type: 'String', nullable: true),
      ],
    ),
    DocsModel(
      name: 'FraudPolicy',
      fields: <DocsParam>[
        DocsParam(
          name: 'velocityWindowMinutes',
          type: 'int',
          defaultValue: '60',
        ),
        DocsParam(name: 'velocityThreshold', type: 'int', defaultValue: '10'),
        DocsParam(name: 'pinAttackThreshold', type: 'int', defaultValue: '5'),
        DocsParam(
          name: 'batchDuplicationThreshold',
          type: 'int',
          defaultValue: '3',
        ),
        DocsParam(name: 'cloneWindowMinutes', type: 'int', defaultValue: '60'),
        DocsParam(
          name: 'cloneDistanceThresholdKm',
          type: 'int',
          defaultValue: '100',
        ),
        DocsParam(name: 'geoIpTimeoutMs', type: 'int', defaultValue: '500'),
        DocsParam(
          name: 'evaluationBudgetMs',
          type: 'int',
          defaultValue: '2000',
        ),
        DocsParam(name: 'autoLockOnFraud', type: 'bool', defaultValue: 'true'),
        DocsParam(name: 'alertOnHigh', type: 'bool', defaultValue: 'true'),
      ],
    ),
    DocsModel(
      name: 'FraudSignalRecord',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'sessionId', type: 'UuidValue'),
        DocsParam(name: 'identityId', type: 'UuidValue'),
        DocsParam(name: 'batchId', type: 'UuidValue'),
        DocsParam(name: 'type', type: 'SignalType'),
        DocsParam(name: 'severity', type: 'RiskScore'),
        DocsParam(name: 'dataJson', type: 'String', defaultValue: '\'{}\''),
        DocsParam(
          name: 'detectedAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'GeoSummary',
      fields: <DocsParam>[
        DocsParam(name: 'country', type: 'String', nullable: true),
        DocsParam(name: 'countryCode', type: 'String', nullable: true),
        DocsParam(name: 'city', type: 'String', nullable: true),
        DocsParam(name: 'latitude', type: 'double', nullable: true),
        DocsParam(name: 'longitude', type: 'double', nullable: true),
      ],
    ),
    DocsModel(
      name: 'IdempotencyRecord',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'idempotencyKey', type: 'String'),
        DocsParam(name: 'operation', type: 'String'),
        DocsParam(name: 'requestHash', type: 'String'),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'expiresAt', type: 'DateTime'),
      ],
    ),
    DocsModel(
      name: 'IdentityGenerationResult',
      fields: <DocsParam>[
        DocsParam(name: 'batchId', type: 'UuidValue'),
        DocsParam(name: 'requested', type: 'int'),
        DocsParam(name: 'created', type: 'int'),
        DocsParam(name: 'startedAt', type: 'DateTime'),
        DocsParam(name: 'completedAt', type: 'DateTime'),
      ],
    ),
    DocsModel(
      name: 'InspectorCacheEntry',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'identityId', type: 'UuidValue'),
        DocsParam(name: 'qrToken', type: 'String'),
        DocsParam(name: 'productName', type: 'String'),
        DocsParam(name: 'sku', type: 'String', nullable: true),
        DocsParam(name: 'productDescription', type: 'String', nullable: true),
        DocsParam(name: 'imageUrlsJson', type: 'String', nullable: true),
        DocsParam(name: 'packaging', type: 'String', nullable: true),
        DocsParam(name: 'shelfLife', type: 'String', nullable: true),
        DocsParam(
          name: 'countryRestrictionsJson',
          type: 'String',
          nullable: true,
        ),
        DocsParam(name: 'safetyInstructions', type: 'String', nullable: true),
        DocsParam(name: 'batchReference', type: 'String'),
        DocsParam(name: 'batchStatus', type: 'BatchStatus'),
        DocsParam(name: 'manufactureDate', type: 'DateTime', nullable: true),
        DocsParam(name: 'distributionRegion', type: 'String'),
        DocsParam(name: 'identityStatus', type: 'IdentityStatus'),
        DocsParam(name: 'recallReason', type: 'String', nullable: true),
        DocsParam(name: 'recalledAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'refreshedAt', type: 'DateTime'),
      ],
    ),
    DocsModel(
      name: 'InspectorCatalog',
      fields: <DocsParam>[
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'generatedAt', type: 'DateTime'),
        DocsParam(name: 'entries', type: 'List<InspectorCatalogEntry>'),
      ],
    ),
    DocsModel(
      name: 'InspectorCatalogEntry',
      fields: <DocsParam>[
        DocsParam(name: 'identityId', type: 'UuidValue'),
        DocsParam(name: 'qrToken', type: 'String'),
        DocsParam(name: 'productName', type: 'String'),
        DocsParam(name: 'sku', type: 'String', nullable: true),
        DocsParam(name: 'productDescription', type: 'String', nullable: true),
        DocsParam(name: 'imageUrls', type: 'List<String>', nullable: true),
        DocsParam(name: 'packaging', type: 'String', nullable: true),
        DocsParam(name: 'shelfLife', type: 'String', nullable: true),
        DocsParam(
          name: 'countryRestrictions',
          type: 'List<String>',
          nullable: true,
        ),
        DocsParam(name: 'safetyInstructions', type: 'String', nullable: true),
        DocsParam(name: 'batchReference', type: 'String'),
        DocsParam(name: 'batchStatus', type: 'BatchStatus'),
        DocsParam(name: 'manufactureDate', type: 'DateTime', nullable: true),
        DocsParam(name: 'distributionRegion', type: 'String'),
        DocsParam(name: 'identityStatus', type: 'IdentityStatus'),
        DocsParam(name: 'recallReason', type: 'String', nullable: true),
        DocsParam(name: 'recalledAt', type: 'DateTime', nullable: true),
      ],
    ),
    DocsModel(
      name: 'Invitation',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'email', type: 'String'),
        DocsParam(
          name: 'role',
          type: 'MembershipRole',
          defaultValue: 'MembershipRole.member',
        ),
        DocsParam(name: 'codePrefix', type: 'String'),
        DocsParam(
          name: 'status',
          type: 'InvitationStatus',
          defaultValue: 'InvitationStatus.pending',
        ),
        DocsParam(name: 'invitedBy', type: 'String'),
        DocsParam(name: 'expiresAt', type: 'DateTime'),
        DocsParam(name: 'acceptedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'acceptedBy', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'InvitationCreated',
      fields: <DocsParam>[
        DocsParam(name: 'invitation', type: 'Invitation'),
        DocsParam(name: 'code', type: 'String'),
        DocsParam(name: 'warning', type: 'String'),
      ],
    ),
    DocsModel(
      name: 'LiveEvent',
      fields: <DocsParam>[
        DocsParam(name: 'type', type: 'LiveEventType'),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'occurredAt', type: 'DateTime'),
        DocsParam(name: 'title', type: 'String'),
        DocsParam(name: 'subtitle', type: 'String', nullable: true),
        DocsParam(name: 'severity', type: 'AlertSeverity', nullable: true),
        DocsParam(name: 'outcome', type: 'VerificationOutcome', nullable: true),
        DocsParam(name: 'riskScore', type: 'RiskScore', nullable: true),
        DocsParam(name: 'country', type: 'String', nullable: true),
        DocsParam(name: 'countryCode', type: 'String', nullable: true),
        DocsParam(name: 'city', type: 'String', nullable: true),
        DocsParam(name: 'latitude', type: 'double', nullable: true),
        DocsParam(name: 'longitude', type: 'double', nullable: true),
        DocsParam(name: 'identityId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'sessionId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'alertId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'batchId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'payloadJson', type: 'String', nullable: true),
      ],
    ),
    DocsModel(
      name: 'Notification',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'userIdentifier', type: 'String'),
        DocsParam(name: 'type', type: 'NotificationType'),
        DocsParam(name: 'title', type: 'String'),
        DocsParam(name: 'body', type: 'String'),
        DocsParam(name: 'targetType', type: 'String', nullable: true),
        DocsParam(name: 'targetId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'read', type: 'bool', defaultValue: 'false'),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'NotificationPreference',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'userIdentifier', type: 'String'),
        DocsParam(name: 'channel', type: 'NotificationChannel'),
        DocsParam(name: 'enabled', type: 'bool', defaultValue: 'true'),
        DocsParam(
          name: 'minSeverity',
          type: 'AlertSeverity',
          defaultValue: 'AlertSeverity.low',
        ),
        DocsParam(name: 'email', type: 'String', nullable: true),
        DocsParam(
          name: 'updatedAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'OfflineScanInput',
      fields: <DocsParam>[
        DocsParam(name: 'localId', type: 'String'),
        DocsParam(name: 'deviceId', type: 'String'),
        DocsParam(name: 'deviceFingerprint', type: 'String', nullable: true),
        DocsParam(name: 'identityId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'qrToken', type: 'String'),
        DocsParam(name: 'scannedAt', type: 'DateTime'),
        DocsParam(name: 'latitude', type: 'double', nullable: true),
        DocsParam(name: 'longitude', type: 'double', nullable: true),
        DocsParam(name: 'country', type: 'String', nullable: true),
        DocsParam(name: 'city', type: 'String', nullable: true),
        DocsParam(name: 'provisionalOutcome', type: 'String', nullable: true),
      ],
    ),
    DocsModel(
      name: 'OfflineScanRecord',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'spaceId', type: 'int', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'deviceId', type: 'String'),
        DocsParam(name: 'deviceFingerprint', type: 'String', nullable: true),
        DocsParam(name: 'identityId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'qrToken', type: 'String'),
        DocsParam(name: 'scannedAt', type: 'DateTime'),
        DocsParam(name: 'latitude', type: 'double', nullable: true),
        DocsParam(name: 'longitude', type: 'double', nullable: true),
        DocsParam(name: 'country', type: 'String', nullable: true),
        DocsParam(name: 'city', type: 'String', nullable: true),
        DocsParam(name: 'provisionalOutcome', type: 'String', nullable: true),
        DocsParam(name: 'processed', type: 'bool', defaultValue: 'false'),
        DocsParam(name: 'processedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'verdictJson', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'OfflineScanVerdict',
      fields: <DocsParam>[
        DocsParam(name: 'localId', type: 'String'),
        DocsParam(name: 'outcome', type: 'VerificationOutcome', nullable: true),
        DocsParam(name: 'riskScore', type: 'RiskScore', nullable: true),
        DocsParam(name: 'sessionId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'processedAt', type: 'DateTime'),
        DocsParam(name: 'message', type: 'String'),
      ],
    ),
    DocsModel(
      name: 'OutcomeBreakdown',
      fields: <DocsParam>[
        DocsParam(name: 'outcome', type: 'VerificationOutcome'),
        DocsParam(name: 'count', type: 'int'),
      ],
    ),
    DocsModel(
      name: 'Product',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'name', type: 'String'),
        DocsParam(name: 'sku', type: 'String', nullable: true),
        DocsParam(name: 'category', type: 'String', nullable: true),
        DocsParam(name: 'description', type: 'String', nullable: true),
        DocsParam(name: 'imageUrls', type: 'List<String>', nullable: true),
        DocsParam(name: 'packaging', type: 'String', nullable: true),
        DocsParam(name: 'shelfLife', type: 'String', nullable: true),
        DocsParam(
          name: 'countryRestrictions',
          type: 'List<String>',
          nullable: true,
        ),
        DocsParam(name: 'safetyInstructions', type: 'String', nullable: true),
        DocsParam(name: 'createdBy', type: 'String', nullable: true),
        DocsParam(name: 'archivedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'deletedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'deletedBy', type: 'String', nullable: true),
        DocsParam(name: 'deleteReason', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(
          name: 'updatedAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'ProductDeleteImpact',
      fields: <DocsParam>[
        DocsParam(name: 'productId', type: 'UuidValue'),
        DocsParam(name: 'productName', type: 'String'),
        DocsParam(name: 'batchCount', type: 'int'),
        DocsParam(name: 'identityCount', type: 'int'),
        DocsParam(name: 'verificationCount', type: 'int'),
        DocsParam(name: 'alertCount', type: 'int'),
        DocsParam(name: 'inRecycleBin', type: 'bool'),
      ],
    ),
    DocsModel(
      name: 'ProductIdentity',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'batchId', type: 'UuidValue'),
        DocsParam(name: 'qrToken', type: 'String'),
        DocsParam(name: 'hmacSignature', type: 'String'),
        DocsParam(
          name: 'status',
          type: 'IdentityStatus',
          defaultValue: 'IdentityStatus.active',
        ),
        DocsParam(name: 'failedPinAttempts', type: 'int', defaultValue: '0'),
        DocsParam(name: 'lockedUntil', type: 'DateTime', nullable: true),
        DocsParam(name: 'firstVerified', type: 'bool', defaultValue: 'false'),
        DocsParam(name: 'verificationCount', type: 'int', defaultValue: '0'),
        DocsParam(name: 'firstVerifiedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'lastVerifiedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'recallReason', type: 'String', nullable: true),
        DocsParam(name: 'recalledAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'regeneratedFromId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'deletedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'deletedBy', type: 'String', nullable: true),
        DocsParam(name: 'deleteReason', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'QueuedFakeReport',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'identityId', type: 'UuidValue'),
        DocsParam(name: 'qrToken', type: 'String'),
        DocsParam(name: 'reason', type: 'String'),
        DocsParam(name: 'comment', type: 'String', nullable: true),
        DocsParam(name: 'photoLocalPath', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'synced', type: 'bool', defaultValue: 'false'),
        DocsParam(name: 'syncedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'lastError', type: 'String', nullable: true),
      ],
    ),
    DocsModel(
      name: 'RecallRecord',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'batchId', type: 'UuidValue'),
        DocsParam(name: 'identityId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'scope', type: 'RecallScope'),
        DocsParam(name: 'reason', type: 'String'),
        DocsParam(name: 'issuedBy', type: 'String'),
        DocsParam(
          name: 'issuedAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'lifted', type: 'bool', defaultValue: 'false'),
        DocsParam(name: 'liftedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'liftedBy', type: 'String', nullable: true),
        DocsParam(name: 'notes', type: 'String', nullable: true),
      ],
    ),
    DocsModel(
      name: 'RecallResult',
      fields: <DocsParam>[
        DocsParam(name: 'recall', type: 'RecallRecord'),
        DocsParam(name: 'affected', type: 'int'),
      ],
    ),
    DocsModel(
      name: 'ReportAcknowledgement',
      fields: <DocsParam>[
        DocsParam(name: 'reportId', type: 'UuidValue'),
        DocsParam(name: 'message', type: 'String'),
        DocsParam(name: 'createdAt', type: 'DateTime'),
      ],
    ),
    DocsModel(
      name: 'RevealedPin',
      fields: <DocsParam>[
        DocsParam(name: 'identityId', type: 'UuidValue'),
        DocsParam(name: 'pin', type: 'String'),
        DocsParam(name: 'revealedAt', type: 'DateTime'),
      ],
    ),
    DocsModel(
      name: 'SimulationRequest',
      fields: <DocsParam>[
        DocsParam(name: 'type', type: 'SimulationType'),
        DocsParam(name: 'label', type: 'String', nullable: true),
        DocsParam(name: 'batchId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'steps', type: 'int', nullable: true),
        DocsParam(name: 'stepDelaySeconds', type: 'int', nullable: true),
      ],
    ),
    DocsModel(
      name: 'SimulationStepRequest',
      fields: <DocsParam>[
        DocsParam(name: 'simulationId', type: 'UuidValue'),
        DocsParam(name: 'delaySeconds', type: 'int', defaultValue: '0'),
      ],
    ),
    DocsModel(
      name: 'TrendPoint',
      fields: <DocsParam>[
        DocsParam(name: 'date', type: 'DateTime'),
        DocsParam(name: 'verifications', type: 'int'),
        DocsParam(name: 'fraud', type: 'int'),
      ],
    ),
    DocsModel(
      name: 'VerificationPresentation',
      fields: <DocsParam>[
        DocsParam(name: 'sessionId', type: 'UuidValue'),
        DocsParam(name: 'state', type: 'VerificationState'),
        DocsParam(name: 'outcome', type: 'VerificationOutcome', nullable: true),
        DocsParam(name: 'riskScore', type: 'RiskScore', nullable: true),
        DocsParam(name: 'verifiedAt', type: 'DateTime'),
        DocsParam(name: 'firstVerified', type: 'bool'),
        DocsParam(name: 'verificationCount', type: 'int'),
        DocsParam(name: 'location', type: 'GeoSummary', nullable: true),
        DocsParam(name: 'branding', type: 'Branding', nullable: true),
        DocsParam(name: 'workspaceName', type: 'String'),
        DocsParam(name: 'authenticMessage', type: 'String', nullable: true),
        DocsParam(name: 'productName', type: 'String'),
        DocsParam(name: 'description', type: 'String', nullable: true),
        DocsParam(name: 'sku', type: 'String', nullable: true),
        DocsParam(name: 'batchReference', type: 'String'),
        DocsParam(name: 'imageUrls', type: 'List<String>', nullable: true),
        DocsParam(name: 'packaging', type: 'String', nullable: true),
        DocsParam(name: 'shelfLife', type: 'String', nullable: true),
        DocsParam(
          name: 'countryRestrictions',
          type: 'List<String>',
          nullable: true,
        ),
        DocsParam(name: 'safetyInstructions', type: 'String', nullable: true),
        DocsParam(name: 'recallReason', type: 'String', nullable: true),
        DocsParam(name: 'recalledAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'recallScope', type: 'RecallScope', nullable: true),
        DocsParam(name: 'tokenMasked', type: 'String'),
        DocsParam(name: 'verifyUrl', type: 'String', nullable: true),
        DocsParam(
          name: 'verifiedByThisDevice',
          type: 'DateTime',
          nullable: true,
        ),
      ],
    ),
    DocsModel(
      name: 'VerificationSession',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'identityId', type: 'UuidValue'),
        DocsParam(name: 'qrToken', type: 'String'),
        DocsParam(name: 'deviceFingerprint', type: 'String', nullable: true),
        DocsParam(name: 'ipAddress', type: 'String', nullable: true),
        DocsParam(name: 'country', type: 'String', nullable: true),
        DocsParam(name: 'countryCode', type: 'String', nullable: true),
        DocsParam(name: 'city', type: 'String', nullable: true),
        DocsParam(name: 'latitude', type: 'double', nullable: true),
        DocsParam(name: 'longitude', type: 'double', nullable: true),
        DocsParam(
          name: 'state',
          type: 'VerificationState',
          defaultValue: 'VerificationState.tokenResolved',
        ),
        DocsParam(name: 'outcome', type: 'VerificationOutcome', nullable: true),
        DocsParam(name: 'riskScore', type: 'RiskScore', nullable: true),
        DocsParam(
          name: 'source',
          type: 'ScanSource',
          defaultValue: 'ScanSource.consumerWeb',
        ),
        DocsParam(name: 'offlineScanId', type: 'UuidValue', nullable: true),
        DocsParam(name: 'simulationId', type: 'UuidValue', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(
          name: 'lastStateChange',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'expiresAt', type: 'DateTime'),
        DocsParam(name: 'completedAt', type: 'DateTime', nullable: true),
      ],
    ),
    DocsModel(
      name: 'WebhookDelivery',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'endpointId', type: 'UuidValue'),
        DocsParam(name: 'eventType', type: 'WebhookEventType'),
        DocsParam(name: 'payloadJson', type: 'String'),
        DocsParam(
          name: 'status',
          type: 'DeliveryStatus',
          defaultValue: 'DeliveryStatus.pending',
        ),
        DocsParam(name: 'attemptCount', type: 'int', defaultValue: '0'),
        DocsParam(name: 'maxAttempts', type: 'int', defaultValue: '5'),
        DocsParam(name: 'lastAttemptAt', type: 'DateTime', nullable: true),
        DocsParam(
          name: 'nextAttemptAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'lastHttpStatus', type: 'int', nullable: true),
        DocsParam(name: 'lastError', type: 'String', nullable: true),
        DocsParam(name: 'responseTimeMs', type: 'int', nullable: true),
        DocsParam(
          name: 'processingStartedAt',
          type: 'DateTime',
          nullable: true,
        ),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(name: 'deliveredAt', type: 'DateTime', nullable: true),
      ],
    ),
    DocsModel(
      name: 'WebhookEndpoint',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'url', type: 'String'),
        DocsParam(name: 'description', type: 'String', nullable: true),
        DocsParam(name: 'subscribedEvents', type: 'List<WebhookEventType>'),
        DocsParam(name: 'enabled', type: 'bool', defaultValue: 'true'),
        DocsParam(name: 'consecutiveFailures', type: 'int', defaultValue: '0'),
        DocsParam(name: 'secretRotatedAt', type: 'DateTime', nullable: true),
        DocsParam(name: 'deletedAt', type: 'DateTime', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(
          name: 'updatedAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'WebhookEndpointSecret',
      fields: <DocsParam>[
        DocsParam(name: 'endpoint', type: 'WebhookEndpoint'),
        DocsParam(name: 'secret', type: 'String'),
        DocsParam(name: 'warning', type: 'String'),
      ],
    ),
    DocsModel(
      name: 'WebhookTestResult',
      fields: <DocsParam>[
        DocsParam(name: 'success', type: 'bool'),
        DocsParam(name: 'statusCode', type: 'int', nullable: true),
        DocsParam(name: 'responseTimeMs', type: 'int', nullable: true),
        DocsParam(name: 'error', type: 'String', nullable: true),
        DocsParam(name: 'deliveryId', type: 'UuidValue', nullable: true),
      ],
    ),
    DocsModel(
      name: 'Workspace',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'name', type: 'String'),
        DocsParam(name: 'slug', type: 'String'),
        DocsParam(name: 'branding', type: 'Branding', nullable: true),
        DocsParam(name: 'authenticMessage', type: 'String', nullable: true),
        DocsParam(
          name: 'restrictedCountries',
          type: 'List<String>',
          nullable: true,
        ),
        DocsParam(name: 'fraudPolicy', type: 'FraudPolicy', nullable: true),
        DocsParam(name: 'demoMode', type: 'bool', defaultValue: 'false'),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
        DocsParam(
          name: 'updatedAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
    DocsModel(
      name: 'WorkspaceBootstrap',
      fields: <DocsParam>[
        DocsParam(name: 'workspace', type: 'Workspace'),
        DocsParam(name: 'member', type: 'WorkspaceMember'),
        DocsParam(name: 'role', type: 'MembershipRole'),
        DocsParam(name: 'permissions', type: 'List<String>'),
        DocsParam(name: 'isDemo', type: 'bool'),
      ],
    ),
    DocsModel(
      name: 'WorkspaceMember',
      fields: <DocsParam>[
        DocsParam(name: 'id', type: 'UuidValue', nullable: true),
        DocsParam(name: 'workspaceId', type: 'UuidValue'),
        DocsParam(name: 'userIdentifier', type: 'String'),
        DocsParam(name: 'email', type: 'String'),
        DocsParam(name: 'displayName', type: 'String', nullable: true),
        DocsParam(
          name: 'role',
          type: 'MembershipRole',
          defaultValue: 'MembershipRole.member',
        ),
        DocsParam(name: 'notificationEmail', type: 'String', nullable: true),
        DocsParam(
          name: 'createdAt',
          type: 'DateTime',
          defaultValue: 'DateTime.now()',
        ),
      ],
    ),
  ],
  enums: <DocsEnum>[
    DocsEnum(
      name: 'ActorType',
      values: <String>['user', 'apiKey', 'system', 'consumer'],
    ),
    DocsEnum(
      name: 'AlertSeverity',
      values: <String>['low', 'medium', 'high', 'critical'],
    ),
    DocsEnum(
      name: 'AlertStatus',
      values: <String>['open', 'investigating', 'resolved', 'dismissed'],
    ),
    DocsEnum(
      name: 'ApiScope',
      values: <String>[
        'productsRead',
        'productsWrite',
        'batchesRead',
        'batchesWrite',
        'identitiesRead',
        'identitiesGenerate',
        'identitiesExport',
        'verificationsRead',
        'fraudRead',
        'fraudWrite',
        'auditRead',
        'analyticsRead',
        'webhooksRead',
        'webhooksWrite',
        'teamRead',
        'teamWrite',
      ],
    ),
    DocsEnum(
      name: 'BatchStatus',
      values: <String>['created', 'inProduction', 'shipped', 'recalled'],
    ),
    DocsEnum(
      name: 'DeliveryStatus',
      values: <String>[
        'pending',
        'processing',
        'retrying',
        'delivered',
        'failed',
        'disabled',
      ],
    ),
    DocsEnum(
      name: 'ExportFormat',
      values: <String>['csv', 'tsv'],
    ),
    DocsEnum(
      name: 'FakeReportStatus',
      values: <String>['open', 'triaged', 'rejected'],
    ),
    DocsEnum(
      name: 'GeoProvider',
      values: <String>['demo', 'http', 'disabled'],
    ),
    DocsEnum(
      name: 'IdentityStatus',
      values: <String>[
        'active',
        'locked',
        'recalled',
        'regenerated',
        'deleted',
      ],
    ),
    DocsEnum(
      name: 'InvitationStatus',
      values: <String>['pending', 'accepted', 'expired', 'revoked'],
    ),
    DocsEnum(
      name: 'LiveEventType',
      values: <String>[
        'verificationCompleted',
        'fraudAlertCreated',
        'fraudAlertUpdated',
        'batchRecalled',
        'identityStatusChanged',
        'offlineScanIngested',
        'simulationProgress',
        'fakeReportCreated',
      ],
    ),
    DocsEnum(
      name: 'MembershipRole',
      values: <String>['owner', 'admin', 'member', 'viewer'],
    ),
    DocsEnum(
      name: 'NotificationChannel',
      values: <String>['inApp', 'email'],
    ),
    DocsEnum(
      name: 'NotificationType',
      values: <String>['fraudAlert', 'recall', 'verificationDigest', 'system'],
    ),
    DocsEnum(
      name: 'RecallScope',
      values: <String>['batch', 'instance'],
    ),
    DocsEnum(
      name: 'RiskScore',
      values: <String>['low', 'medium', 'high', 'fraudSuspected'],
    ),
    DocsEnum(
      name: 'ScanSource',
      values: <String>[
        'consumerWeb',
        'operatorApp',
        'inspectorOffline',
        'simulation',
        'machineApi',
      ],
    ),
    DocsEnum(
      name: 'SignalType',
      values: <String>[
        'cloneDetection',
        'velocityAnomaly',
        'pinAttack',
        'batchDuplication',
        'distributorLeakage',
        'greyMarket',
        'offlineBackfill',
        'pinLockout',
      ],
    ),
    DocsEnum(
      name: 'SimulationStatus',
      values: <String>['queued', 'running', 'completed', 'cancelled', 'failed'],
    ),
    DocsEnum(
      name: 'SimulationType',
      values: <String>[
        'cloneAttack',
        'pinBruteForce',
        'scanBurst',
        'greyMarketLeak',
      ],
    ),
    DocsEnum(
      name: 'VerificationErrorReason',
      values: <String>[
        'tokenNotFound',
        'tokenInvalid',
        'sessionNotFound',
        'sessionExpired',
        'invalidState',
        'pinRequired',
        'pinLockout',
        'identityLocked',
        'identityRecalled',
        'alreadyDetermined',
        'evaluationUnavailable',
      ],
    ),
    DocsEnum(
      name: 'VerificationOutcome',
      values: <String>[
        'authentic',
        'alreadyVerified',
        'invalidPin',
        'fraudSuspected',
        'highRisk',
        'recalled',
      ],
    ),
    DocsEnum(
      name: 'VerificationState',
      values: <String>[
        'tokenResolved',
        'pinPrompted',
        'pinSubmitted',
        'resultDetermined',
      ],
    ),
    DocsEnum(
      name: 'WebhookEventType',
      values: <String>[
        'verificationCompleted',
        'fraudAlertCreated',
        'fraudAlertUpdated',
        'batchStatusChanged',
        'identityStatusChanged',
        'recallIssued',
        'fakeReportCreated',
        'testEvent',
      ],
    ),
  ],
);
