import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:mcp_dart/mcp_dart.dart';

import '../gateway.dart';
import '../tool_support.dart';

/// Workspace context, team and keys, the audit trail, analytics, and the
/// public consumer verification flow.
void registerPlatformTools(ToolRegistry registry, FauxShieldGateway gateway) {
  final client = gateway.client;
  final workspaceId = gateway.workspaceId;

  registry.read(
    'get_workspace',
    description:
        'Read the workspace this server is acting on: name, slug, role, and '
        'the permissions of the current credential.',
    body: (args, context) async {
      final bootstrap = await client.workspace.bootstrap();
      if (bootstrap != null) return bootstrap;
      // An API key has no operator membership record, so there is nothing to
      // bootstrap. Report what the credential is instead of pretending there
      // is no workspace.
      return <String, dynamic>{
        'workspace': null,
        'workspace_id': gateway.workspaceId?.uuid,
        'credential': gateway.config.usesApiKey ? 'api-key' : 'session',
        'server': gateway.config.serverUrl,
        'read_only': gateway.readOnly,
        'note':
            'An API key acts on exactly one workspace and carries its own '
            'scopes, so there is no membership to report. Calls that need more '
            'than the key scopes will be refused with the missing scope name.',
      };
    },
  );

  registry.read(
    'list_workspace_members',
    description: 'List the people in this workspace with their roles.',
    body: (args, context) => client.workspace.members(workspaceId: workspaceId),
  );

  registry.read(
    'list_api_keys',
    description:
        'List the API keys issued for this workspace, with their scopes, last '
        'use, and revocation state. Key secrets are never returned.',
    body: (args, context) => client.apiKey.list(workspaceId: workspaceId),
  );

  registry.write(
    'create_api_key',
    description:
        'Issue an API key for machine access. The secret is returned once and '
        'cannot be read again.',
    properties: <String, JsonSchema>{
      'label': JsonSchema.string(description: 'What the key is for.'),
      'scopes': JsonSchema.array(
        items: JsonSchema.string(),
        description: 'Scopes the key may use.',
      ),
      'rate_limit_per_minute': JsonSchema.integer(
        description: 'Requests per minute before the key is throttled.',
      ),
    },
    required: <String>['label', 'scopes'],
    body: (args, context) => client.apiKey.create(
      workspaceId: workspaceId,
      label: args.requiredString('label'),
      scopes: _scopes(args),
      rateLimitPerMinute: args.optionalInt('rate_limit_per_minute') ?? 120,
    ),
  );

  registry.write(
    'revoke_api_key',
    description: 'Revoke an API key. Revocation takes effect immediately.',
    properties: <String, JsonSchema>{
      'api_key_id': JsonSchema.string(description: 'API key uuid.'),
    },
    required: <String>['api_key_id'],
    destructive: true,
    idempotent: true,
    body: (args, context) => client.apiKey.revoke(
      workspaceId: workspaceId,
      apiKeyId: args.requiredUuid('api_key_id'),
    ),
  );

  registry.read(
    'search_audit_events',
    description:
        'Search the workspace audit trail: who did what, to which record, and '
        'when. Every mutating call made through this server is recorded here.',
    properties: <String, JsonSchema>{
      'action': JsonSchema.string(
        description: 'Exact action name, for example identity.generated.',
      ),
      'actor_identifier': JsonSchema.string(
        description: 'Only events by this actor.',
      ),
      'target_type': JsonSchema.string(
        description: 'Only events about this kind of record.',
      ),
      'target_id': JsonSchema.string(
        description: 'Only events about this record.',
      ),
      'from': JsonSchema.string(description: 'ISO 8601 lower bound.'),
      'to': JsonSchema.string(description: 'ISO 8601 upper bound.'),
      'page': JsonSchema.integer(description: 'Page number, starting at 1.'),
      'page_size': JsonSchema.integer(description: 'Rows per page, max 200.'),
    },
    body: (args, context) {
      final paging = args.paging(defaultPageSize: 50);
      return client.audit.query(
        workspaceId: workspaceId,
        action: args.optionalString('action'),
        actorIdentifier: args.optionalString('actor_identifier'),
        targetType: args.optionalString('target_type'),
        targetId: args.optionalUuid('target_id'),
        from: args.optionalDate('from'),
        to: args.optionalDate('to'),
        page: paging.page,
        pageSize: paging.pageSize,
      );
    },
  );

  registry.read(
    'dashboard_summary',
    description:
        'The command center summary: verification volume, outcome mix, risk '
        'breakdown, open alerts, and the trend over the last days.',
    properties: <String, JsonSchema>{
      'window_days': JsonSchema.integer(
        description: 'How many days of trend to include. Defaults to 14.',
      ),
    },
    body: (args, context) => client.analytics.dashboard(
      workspaceId: workspaceId,
      windowDays: (args.optionalInt('window_days') ?? 14).clamp(1, 90),
    ),
  );

  registry.write(
    'refresh_analytics',
    description:
        'Recompute the daily rollup for a workspace and return the refreshed '
        'row. Use after a burst of activity if the summary looks stale.',
    properties: <String, JsonSchema>{
      'day': JsonSchema.string(
        description: 'ISO 8601 day to recompute. Defaults to today.',
      ),
    },
    idempotent: true,
    body: (args, context) => client.analytics.rollupNow(
      workspaceId: workspaceId,
      day: args.optionalDate('day'),
    ),
  );

  registry.read(
    'verify_unit',
    description:
        'Run the consumer verification flow for a QR token, optionally with '
        'the packaging PIN, and report the outcome exactly as a consumer sees '
        'it. This is the public path: use it to check what a scan will say.',
    properties: <String, JsonSchema>{
      'token': JsonSchema.string(description: 'QR token printed on the unit.'),
      'pin': JsonSchema.string(
        description: 'Packaging PIN. Omit to see the pre-PIN state.',
      ),
      'fingerprint': JsonSchema.string(
        description: 'Device fingerprint. A random one is used when omitted.',
      ),
    },
    required: <String>['token'],
    body: (args, context) async {
      final token = args.requiredString('token');
      final fingerprint =
          args.optionalString('fingerprint') ??
          FauxShieldGateway.newFingerprint();
      var presentation = await client.verification.start(token, fingerprint);

      final pin = args.optionalString('pin');
      final awaitingPin =
          presentation.state == VerificationState.tokenResolved ||
          presentation.state == VerificationState.pinPrompted;
      if (pin != null && awaitingPin) {
        presentation = await client.verification.submitPin(
          presentation.sessionId,
          fingerprint,
          pin,
        );
      }
      return presentation;
    },
  );
}

/// Parses the `scopes` argument into API scopes.
List<ApiScope> _scopes(ToolArgs args) {
  final names = args.optionalStringList('scopes');
  if (names == null || names.isEmpty) {
    throw ToolError('Provide at least one scope.');
  }
  return names
      .map((name) {
        final normalized = name
            .toLowerCase()
            .replaceAll('_', '')
            .replaceAll(':', '');
        for (final scope in ApiScope.values) {
          if (scope.name.toLowerCase() == normalized) return scope;
        }
        throw ToolError(
          'Unknown API scope "$name".',
          hint:
              'Valid scopes: '
              '${ApiScope.values.map((scope) => scope.name).join(', ')}.',
        );
      })
      .toList(growable: false);
}
