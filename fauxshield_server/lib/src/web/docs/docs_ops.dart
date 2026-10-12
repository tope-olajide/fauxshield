/// The operational pages of the portal: the CLI, the MCP server, and the
/// reference material around them.
///
/// The command and tool names here are the ones in the source. CI compares them
/// against `fauxshield_cli` and `fauxshield_mcp`, so a renamed command or a new
/// tool fails the build instead of quietly missing from the documentation.
library;

import 'docs_model.dart';
import 'docs_render.dart';
import '../widgets/site_chrome.dart';

/// The CLI reference.
DocsPage cliPage() {
  return DocsPage(
    slug: 'cli',
    title: 'CLI',
    description:
        'The fauxshield command line client: installation, authentication, the '
        'full command tree, output formats, and scripting.',
    group: 'cli',
    sections: <DocsSection>[
      DocsSection(
        id: 'install',
        title: 'Install',
        html:
            '''
<p>
  The CLI is a plain Dart console package that speaks the same JSON-RPC API as
  the operator app, so it needs no Flutter runtime and runs anywhere Dart does.
</p>
${code('''
# From this repository
dart pub global activate --source path fauxshield_cli

# Or run it without installing
dart run fauxshield_cli:main --help
''', lang: DocsLang.bash)}
<p>
  The executable is <code>fauxshield</code>. Without a running server it is
  still useful: <code>--help</code>, <code>--version</code>, and
  <code>config</code> work offline.
</p>
''',
      ),
      DocsSection(
        id: 'authenticate',
        title: 'Authenticate',
        html:
            '''
<p>
  The session is stored in <code>~/.fauxshield/config.json</code>, with the
  token file-readable by its owner only. A session is created from an email and
  password; a machine can use an API key instead, which does not expire with a
  session.
</p>
${code('''
fauxshield auth login --email you@brand.test --password '<your password>'
fauxshield auth whoami
fauxshield auth token          # the JWT, for use with curl

# Everything below can take the URL or the credential from the environment
export FAUXSHIELD_URL=${SiteChrome.hostedApiUrl}
export FAUXSHIELD_TOKEN="\$(fauxshield auth token)"
fauxshield products list
''', lang: DocsLang.bash)}
${callout('note', 'Two credential kinds', '<p><code>--token</code> (or <code>FAUXSHIELD_TOKEN</code>) is a session JWT. <code>--api-key</code> (or <code>FAUXSHIELD_API_KEY</code>) is a workspace key starting <code>fs_live_</code>, which carries scopes and its own rate limit — the right choice for CI.</p>')}
''',
      ),
      DocsSection(
        id: 'commands',
        title: 'Command reference',
        html:
            '''
<p>
  Eighteen commands, each scoped to the workspace behind the stored credential.
  Every command takes the global flags below, and every read command takes
  <code>--json</code>.
</p>
${_commandTable()}
${paramTable(const <DocsParam>[
              DocsParam(name: '--json, -j', type: 'flag', defaultValue: 'human-readable tables off, JSON on'),
              DocsParam(name: '--url', type: 'string', defaultValue: 'server to call, overriding the stored value'),
              DocsParam(name: '--token', type: 'string', defaultValue: 'session JWT to authenticate with'),
              DocsParam(name: '--api-key', type: 'string', defaultValue: 'workspace API key to authenticate with'),
              DocsParam(name: '--version, -v', type: 'flag', defaultValue: 'print the CLI version'),
            ], empty: '')}
<p>
  The flags work before or after the command, so
  <code>fauxshield --json alerts list</code> and
  <code>fauxshield alerts list --json</code> are the same call.
</p>
''',
      ),
      DocsSection(
        id: 'workflow',
        title: 'A full workflow',
        html:
            '''
<p>
  Register a product, manufacture a batch, mint the serialized units, and watch
  what shoppers do with them — the same path the operator app walks, from a
  script:
</p>
${code('''
# 1. A product to serialise
fauxshield products create --name 'Aurelia Olive Oil 1L' --sku AUR-OIL-1L

# 2. A batch. The distribution region drives leakage detection.
fauxshield batches create --product <uuid> --reference LOT-2026-04 \\
  --region NG --quantity 500

# 3. Mint 500 signed units: one QR token and packaging PIN each
fauxshield identities generate --batch <uuid> --quantity 500

# 4. Export the codes for the print run
fauxshield identities export --batch <uuid> --format csv > units.csv

# 5. Work the fraud queue
fauxshield alerts list --severity critical
fauxshield alerts show --alert <uuid>
fauxshield alerts assign --alert <uuid> --assignee you@brand.test

# 6. Reproduce a scan without a browser
fauxshield verify --token <token> --pin <pin>
''', lang: DocsLang.bash)}
''',
      ),
      DocsSection(
        id: 'scripting',
        title: 'Scripting and CI',
        html:
            '''
<p>
  <code>--json</code> prints the API's own JSON, so a pipeline can parse it
  without a second format to maintain. Exit codes follow the usual convention:
  <code>0</code> for success, a non-zero code for a failure, and the failure is
  a single readable line on stderr rather than a stack trace.
</p>
${code('''
# Fail the build when a critical alert is open
count=\$(fauxshield alerts list --severity critical --json \\
  | python -c 'import json,sys; print(len(json.load(sys.stdin)))')
if [ "\$count" -gt 0 ]; then echo "critical alerts: \$count" >&2; exit 1; fi

# Everything an unattended job needs comes from the environment
FAUXSHIELD_URL=${SiteChrome.hostedApiUrl} \\
FAUXSHIELD_API_KEY="\$FS_API_KEY" \\
  fauxshield analytics dashboard --json
''', lang: DocsLang.bash)}
''',
      ),
      DocsSection(
        id: 'troubleshooting',
        title: 'Troubleshooting',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'Not signed in', type: 'AuthenticationException', defaultValue: 'run `fauxshield auth login`, or set FAUXSHIELD_TOKEN / FAUXSHIELD_API_KEY'),
              DocsParam(name: 'Connection refused', type: 'socket error', defaultValue: 'check --url, or start the server: `serverpod start`'),
              DocsParam(name: 'Missing scope', type: 'forbidden', defaultValue: 'the API key is read-only; create one with the scope the command needs'),
              DocsParam(name: 'Empty output', type: 'no rows', defaultValue: 'the workspace has no data yet; seed the demo workspace with `fauxshield demo reset`'),
            ], empty: '')}
<p>
  <code>fauxshield auth logout</code> clears the stored session, and deleting
  <code>~/.fauxshield/config.json</code> clears everything.
</p>
''',
      ),
    ],
  );
}

String _commandTable() {
  final rows = StringBuffer();
  for (final (name, description, subcommands) in _cliCommands) {
    rows.writeln(
      '<tr><td><code>$name</code></td><td>${SiteChrome.escape(description)}</td>'
      '<td>${subcommands.isEmpty ? '<span class="docs-muted">—</span>' : subcommands.map((sub) => '<code>$sub</code>').join(', ')}</td></tr>',
    );
  }
  return '<div class="table-wrap"><table class="data docs-table">'
      '<thead><tr><th>Command</th><th>What it does</th><th>Subcommands</th></tr></thead>'
      '<tbody>$rows</tbody></table></div>';
}

/// The command tree, as `tools/list_platform_surface.py` reads it out of
/// `fauxshield_cli`. CI compares these names against the source.
const List<(String, String, List<String>)> _cliCommands =
    <(String, String, List<String>)>[
      (
        'auth',
        'Sign in, sign out, and inspect the session.',
        <String>['login', 'logout', 'whoami', 'token'],
      ),
      (
        'products',
        'Manage the product catalogue.',
        <String>[
          'list',
          'create',
          'show',
          'update',
          'archive',
          'restore',
          'deleted',
          'delete-impact',
          'delete',
          'purge',
        ],
      ),
      (
        'batches',
        'List, create, and inspect manufacturing batches.',
        <String>['list', 'create', 'stats', 'show', 'update'],
      ),
      (
        'identities',
        'Inspect serialized units and mint new ones.',
        <String>[
          'list',
          'generate',
          'reveal-pin',
          'show',
          'export',
          'lock',
          'unlock',
          'regenerate',
          'delete',
          'restore',
        ],
      ),
      (
        'alerts',
        'Read the fraud queue and an alert.',
        <String>[
          'list',
          'show',
          'status',
          'assign',
          'signals',
          'reports',
          'triage',
        ],
      ),
      (
        'verifications',
        'Read what shoppers scanned and what came back.',
        <String>['list', 'show'],
      ),
      (
        'recalls',
        'Issue and lift product recalls.',
        <String>['list', 'issue', 'lift'],
      ),
      (
        'simulations',
        'Rehearse attacks against a copy of the catalogue.',
        <String>['list', 'start', 'show', 'step', 'run', 'cancel'],
      ),
      (
        'analytics',
        'Read the numbers the command center shows.',
        <String>['dashboard', 'rollup'],
      ),
      (
        'audit',
        'Read the tamper-evident audit log.',
        <String>['list'],
      ),
      (
        'team',
        'Manage who can work in the workspace.',
        <String>[
          'members',
          'invitations',
          'invite',
          'accept',
          'role',
          'remove',
        ],
      ),
      (
        'keys',
        'Manage API keys for machines and CI.',
        <String>['list', 'create', 'revoke'],
      ),
      (
        'webhooks',
        'Manage signed webhook endpoints and deliveries.',
        <String>[
          'list',
          'create',
          'test',
          'deliveries',
          'rotate',
          'delete',
          'drain',
        ],
      ),
      (
        'notifications',
        'Read the inbox and set alerting preferences.',
        <String>['list', 'read', 'read-all', 'preferences', 'set'],
      ),
      (
        'offline',
        'Sync scans captured by a device with no signal.',
        <String>['records', 'ingest', 'convert'],
      ),
      (
        'workspace',
        'Read and change the workspace settings.',
        <String>['show', 'update', 'create'],
      ),
      (
        'demo',
        'Inspect and rebuild the disposable demo workspace.',
        <String>['status', 'reset', 'join'],
      ),
      (
        'verify',
        'Verify a unit as a consumer would.',
        <String>[],
      ),
    ];

/// The MCP server's page: what it is, how to run it, and its tools.
DocsPage mcpPage() {
  return DocsPage(
    slug: 'mcp',
    title: 'MCP server',
    description:
        'The Model Context Protocol server: 55 tools over the same API, so an '
        'AI agent can work a brand\'s fraud queue, catalogue, and recalls.',
    group: 'mcp',
    sections: <DocsSection>[
      DocsSection(
        id: 'what',
        title: 'What it is',
        html:
            '''
<p>
  <code>fauxshield_mcp</code> is an MCP server that exposes the FauxShield
  operations as tools. It talks to the API through the same generated Dart
  client the operator app uses, so a tool cannot do something the API does not
  allow — and every call is attributed to the credential you give it.
</p>
${callout('warning', 'It writes', '<p>Read tools are marked read-only; write tools change data (create a product, lock a unit, start a recall). Point it at a workspace whose credentials you are willing to let an agent use, and give it an API key with the narrowest scopes that make sense.</p>')}
''',
      ),
      DocsSection(
        id: 'run',
        title: 'Run it',
        html:
            '''
<p>
  The server speaks MCP over stdio, which is what an MCP client expects, and
  needs three things: the API URL, a credential, and the workspace id.
</p>
${code('''
dart run fauxshield_mcp:main
''', lang: DocsLang.bash)}
${code('''
{
  "mcpServers": {
    "fauxshield": {
      "command": "dart",
      "args": ["run", "fauxshield_mcp:main"],
      "env": {
        "FAUXSHIELD_URL": "${SiteChrome.hostedApiUrl}",
        "FAUXSHIELD_API_KEY": "fs_live_...",
        "FAUXSHIELD_WORKSPACE_ID": "<workspace uuid>",
        "FAUXSHIELD_MCP_READ_ONLY": "false"
      }
    }
  }
}
''', lang: DocsLang.json)}
${paramTable(const <DocsParam>[
              DocsParam(name: 'FAUXSHIELD_URL', type: 'String', defaultValue: 'the CLI\'s stored URL, then ${SiteChrome.hostedApiUrl}'),
              DocsParam(name: 'FAUXSHIELD_API_KEY', type: 'String', defaultValue: 'workspace key; the CLI session is used when it is absent'),
              DocsParam(name: 'FAUXSHIELD_TOKEN', type: 'String', defaultValue: 'session JWT instead of an API key'),
              DocsParam(name: 'FAUXSHIELD_WORKSPACE_ID', type: 'String', defaultValue: 'workspace every call is scoped to'),
              DocsParam(name: 'FAUXSHIELD_MCP_READ_ONLY', type: 'String', defaultValue: '"true" refuses every write tool'),
            ], empty: '')}
<p>
  With no API key it reads the session the CLI stored, so
  <code>fauxshield auth login</code> once is enough to try it by hand.
</p>
''',
      ),
      DocsSection(
        id: 'tools',
        title: 'Tools',
        html:
            '''
<p>
  Fifty-five tools in four groups. Each one validates its arguments before the
  call, so an agent gets a clear message instead of a server-side refusal, and
  each returns the API's own model as JSON.
</p>
${_toolTables()}
''',
      ),
      DocsSection(
        id: 'example',
        title: 'An agent workflow',
        html:
            '''
<p>
  A realistic session: find out what is on fire, read the evidence behind it,
  then lock the units that are still active.
</p>
${code('''
1. dashboard_summary            -> alertsBySeverity, verificationsTrend
2. list_alerts { status: "open", severity: "critical" }
3. investigate_alert { alert_id }
4. get_alert { alert_id }       -> the units behind the alert
5. update_alert_status { alert_id, status: "investigating" }
6. lock_unit { unit_id, reason: "cloned code reported by three shoppers" }
''', lang: DocsLang.cli)}
''',
      ),
      DocsSection(
        id: 'security',
        title: 'Security and permissions',
        html: '''
<p>
  The tools are exactly as powerful as the credential behind them: an API key
  with read scopes can only read, and the workspace is fixed at start-up, so a
  tool cannot be talked into looking at another brand's data. Secrets are read
  from the environment and never echoed into a tool result.
</p>
''',
      ),
    ],
  );
}

String _toolTables() {
  final buffer = StringBuffer();
  for (final (group, tools) in _mcpTools) {
    buffer.writeln(
      '<p class="docs-muted">${SiteChrome.escape(group)} — ${tools.length} tools</p>'
      '<ul class="docs-chip-list docs-chip-list-tools">'
      '${tools.map((tool) => '<li><code>$tool</code></li>').join()}</ul>',
    );
  }
  return buffer.toString();
}

/// The tool inventory, as `tools/list_platform_surface.py` reads it out of
/// `fauxshield_mcp`. CI compares these names against the source.
const List<(String, List<String>)> _mcpTools = <(String, List<String>)>[
  (
    'Products, batches, and units',
    <String>[
      'list_products',
      'get_product',
      'create_product',
      'update_product',
      'archive_product',
      'restore_product',
      'product_delete_impact',
      'upload_product_image',
      'list_batches',
      'get_batch',
      'batch_stats',
      'create_batch',
      'update_batch',
      'generate_units',
      'list_units',
      'get_unit',
      'export_units',
      'lock_unit',
      'unlock_unit',
      'regenerate_unit_token',
    ],
  ),
  (
    'Fraud queue',
    <String>[
      'list_alerts',
      'get_alert',
      'alert_evidence',
      'update_alert_status',
      'assign_alert',
      'list_fraud_signals',
      'list_fake_reports',
      'triage_fake_report',
      'list_verifications',
      'get_verification',
      'investigate_alert',
    ],
  ),
  (
    'Recalls, webhooks, and simulations',
    <String>[
      'list_recalls',
      'recall_batch',
      'recall_unit',
      'lift_recall',
      'list_webhooks',
      'create_webhook',
      'update_webhook',
      'delete_webhook',
      'test_webhook',
      'list_webhook_deliveries',
      'redeliver_webhook',
      'list_simulations',
      'get_simulation',
      'start_simulation',
      'cancel_simulation',
    ],
  ),
  (
    'Platform',
    <String>[
      'get_workspace',
      'list_workspace_members',
      'list_api_keys',
      'create_api_key',
      'revoke_api_key',
      'search_audit_events',
      'dashboard_summary',
      'refresh_analytics',
      'verify_unit',
    ],
  ),
];

/// Error codes, statuses, and what to do about each one.
DocsPage errorCodesPage() {
  return DocsPage(
    slug: 'reference/errors',
    title: 'Error codes',
    description:
        'Every failure the API returns, the body it arrives in, and what a '
        'caller should do about it.',
    group: 'reference',
    sections: <DocsSection>[
      DocsSection(
        id: 'shape',
        title: 'The shape of a failure',
        html:
            '''
<p>
  A refused call answers a non-<code>200</code> status with a body that names its
  exception. That is deliberate: an SDK can map the failure onto a typed error
  from the body rather than inferring it from a status code, which keeps the
  meaning stable even when the status is a generic <code>400</code>.
</p>
${code('''
{
  "className": "ValidationException",
  "data": {
    "__className__": "ValidationException",
    "message": "quantity must be between 1 and 10000",
    "code": "api_error",
    "field": "quantity"
  }
}
''', lang: DocsLang.json)}
<p>
  This is the body the hosted API returns today, verified against
  <code>${SiteChrome.hostedApiUrl}</code>: a typed refusal arrives as HTTP
  <code>400</code> with the exception as JSON. The framework's own answers use
  the status instead — <code>401</code> and <code>403</code> when a credential
  is missing or lacks a scope, <code>500</code> when the server itself fails —
  and an SDK falls back to the status when the body names nothing.
</p>
''',
      ),
      DocsSection(
        id: 'types',
        title: 'Types',
        html:
            '''
<div class="table-wrap"><table class="data docs-table">
<thead><tr><th>Exception</th><th>Status</th><th>When</th><th>What to do</th></tr></thead>
<tbody>
${_errorRows()}
</tbody></table></div>
''',
      ),
      DocsSection(
        id: 'retries',
        title: 'Retrying',
        html: '''
<p>
  Retry what a retry can fix: <code>RateLimitException</code>,
  <code>ServiceUnavailableException</code>, a timeout, a dropped connection, and
  a bare <code>5xx</code>. Every SDK does that by default and honours
  <code>Retry-After</code> or <code>retryAfterSeconds</code> when the server
  sends a delay. Do not retry a validation, authentication, or not-found
  failure: repeating the same request produces the same answer.
</p>
''',
      ),
      DocsSection(
        id: 'verification',
        title: 'Verification reasons',
        html: '''
<p>
  The consumer flow answers with a reason rather than a message, so a client can
  react without parsing prose. <code>verification.submitPin</code> returns one of
  <code>authentic</code>, <code>alreadyVerified</code>,
  <code>invalidPin</code>, <code>highRisk</code>,
  <code>fraudSuspected</code>, or <code>recalled</code>; a refusal before that
  point raises <code>VerificationException</code> with a reason such as
  <code>tokenNotFound</code>, <code>locked</code>, or
  <code>tooManyAttempts</code>. Five wrong PINs lock the session.
</p>
''',
      ),
    ],
  );
}

String _errorRows() {
  const rows = <(String, String, String, String)>[
    (
      'ValidationException',
      '400',
      'The arguments were rejected; field names the offender when there is one.',
      'Fix the request. Never retry.',
    ),
    (
      'AuthenticationException',
      '400, 401, 403',
      'No credential, an expired one, or one that lacks the scope; reason is notAuthenticated or forbidden.',
      'Sign in again, or use a key with the scope.',
    ),
    (
      'NotFoundException',
      '400, 404',
      'No such resource, or it is not visible to this credential.',
      'Check the id and the workspace.',
    ),
    (
      'ConflictException',
      '400, 409',
      'The change conflicts with current state — a duplicate SKU, an already-generated batch.',
      'Re-read the resource, then decide.',
    ),
    (
      'RateLimitException',
      '400, 429',
      'The key is over its rate limit; retryAfterSeconds says how long to wait.',
      'Wait, then retry. SDKs do it for you.',
    ),
    (
      'ServiceUnavailableException',
      '400, 502, 503, 504',
      'A dependency is down or unset — storage, the geolocation provider.',
      'Retry with backoff.',
    ),
    (
      'VerificationException',
      '400',
      'A consumer verification was refused; reason says why.',
      'Show the reason to the shopper.',
    ),
    (
      'ApiException',
      '400, 500',
      'Anything else, including a server fault.',
      'Retry a 5xx; report a 400 that keeps happening.',
    ),
  ];

  return rows
      .map(
        (row) =>
            '<tr><td><code>${row.$1}</code></td><td>${row.$2}</td>'
            '<td>${SiteChrome.escape(row.$3)}</td><td>${SiteChrome.escape(row.$4)}</td></tr>',
      )
      .join();
}

/// Environment variables, grouped by the tool that reads them.
DocsPage environmentPage() {
  return DocsPage(
    slug: 'reference/environment',
    title: 'Environment variables',
    description:
        'Every variable the SDKs, the CLI, and the MCP server read, and what it '
        'overrides.',
    group: 'reference',
    sections: <DocsSection>[
      DocsSection(
        id: 'sdk',
        title: 'SDKs',
        html: paramTable(const <DocsParam>[
          DocsParam(
            name: 'FAUXSHIELD_API_KEY',
            type: 'String',
            defaultValue: 'the API key a client authenticates with',
          ),
          DocsParam(
            name: 'FAUXSHIELD_URL',
            type: 'String',
            defaultValue:
                'base URL; loses to an explicit one, wins over the hosted default',
          ),
        ]),
      ),
      DocsSection(
        id: 'cli',
        title: 'CLI',
        html: paramTable(const <DocsParam>[
          DocsParam(
            name: 'FAUXSHIELD_URL',
            type: 'String',
            defaultValue:
                'overrides the URL stored in ~/.fauxshield/config.json',
          ),
          DocsParam(
            name: 'FAUXSHIELD_TOKEN',
            type: 'String',
            defaultValue: 'session JWT, instead of the stored one',
          ),
          DocsParam(
            name: 'FAUXSHIELD_API_KEY',
            type: 'String',
            defaultValue: 'API key, instead of the stored session',
          ),
        ]),
      ),
      DocsSection(
        id: 'mcp',
        title: 'MCP server',
        html: paramTable(const <DocsParam>[
          DocsParam(
            name: 'FAUXSHIELD_URL',
            type: 'String',
            defaultValue: 'the CLI\'s stored URL, then the hosted API',
          ),
          DocsParam(
            name: 'FAUXSHIELD_API_KEY',
            type: 'String',
            defaultValue: 'workspace key for every tool call',
          ),
          DocsParam(
            name: 'FAUXSHIELD_TOKEN',
            type: 'String',
            defaultValue: 'session JWT instead of a key',
          ),
          DocsParam(
            name: 'FAUXSHIELD_WORKSPACE_ID',
            type: 'String',
            defaultValue: 'the workspace every tool is scoped to',
          ),
          DocsParam(
            name: 'FAUXSHIELD_MCP_READ_ONLY',
            type: 'String',
            defaultValue: '"true" refuses every write tool',
          ),
        ]),
      ),
      DocsSection(
        id: 'server',
        title: 'Server',
        html: '''
<p>
  The server reads its own configuration from <code>config/</code> —
  <code>development.yaml</code>, <code>staging.yaml</code>,
  <code>production.yaml</code> — and the passwords from
  <code>config/passwords.yaml</code> or, in a deployment, from the environment
  Serverpod injects (<code>SERVERPOD_PASSWORD_*</code>). A deployment sets its
  public hosts there, which is what makes <code>/app/assets/assets/config.json</code>
  hand the Flutter app the API URL it should call.
</p>
''',
      ),
    ],
  );
}

/// A short glossary of the product's own words.
DocsPage glossaryPage() {
  return DocsPage(
    slug: 'reference/glossary',
    title: 'Glossary',
    description:
        'The vocabulary of the platform: products, batches, identities, sessions, '
        'signals, alerts, and recalls.',
    group: 'reference',
    sections: <DocsSection>[
      DocsSection(
        id: 'terms',
        title: 'Terms',
        html:
            '''
${_term('Product', 'What a brand makes. A product carries the packaging copy, images, and the shelf-life and safety text shown to a shopper.')}
${_term('Batch', 'One manufacturing run of a product: a reference, a manufacture date, a distribution region, and a declared quantity.')}
${_term('Identity (unit)', 'One serialized physical item: a signed QR token, a packaging PIN, and a status that moves from active to locked, recalled, or deleted.')}
${_term('Verification session', 'One shopper\'s scan. It starts when a token is resolved, continues when the PIN is submitted, and records the outcome, the device fingerprint, and the approximate location.')}
${_term('Fraud signal', 'One thing the fraud engine noticed: a cloned token, a scan from an unexpected region, a velocity spike. Signals are stored whether or not they raise an alert.')}
${_term('Alert', 'A deduplicated, assignable piece of work created from one or more signals, with a severity, a status, and the evidence behind it.')}
${_term('Recall', 'A decision to withdraw a batch or a single unit, which makes every further scan of it answer recalled.')}
${_term('Offline scan', 'A verification captured by a device with no connection, synced later and converted into a normal session.')}
${_term('Simulation', 'A rehearsal of an attack — cloning, leakage, brute force — run against a copy of the catalogue to see what the engine would catch.')}
${_term('Webhook', 'A signed HTTP delivery of an event, with retries, backoff, and a tamper-evident audit trail.')}
${_term('Workspace', 'One brand\'s tenancy: its members, roles, products, alerts, API keys, and settings.')}
${_term('API key', 'A machine credential starting fs_live_, carrying scopes and its own rate limit.')}
${_term('Demo workspace', 'A disposable workspace with seeded products, units, alerts, and a recall, used for showing the platform.')}
''',
      ),
    ],
  );
}

String _term(String name, String body) =>
    '<p><strong>${SiteChrome.escape(name)}</strong> — ${SiteChrome.escape(body)}</p>';

/// Release notes, kept honest: what a version of the SDKs contains.
DocsPage changelogPage() {
  return DocsPage(
    slug: 'reference/changelog',
    title: 'Changelog',
    description:
        'What shipped in each version of the SDKs, the CLI, and the API, and '
        'what a caller has to do about it.',
    group: 'reference',
    sections: <DocsSection>[
      DocsSection(
        id: 'sdk-0-1-0',
        title: '0.1.0 — first release of the Node.js and Python SDKs',
        html: '''
<p>
  Generated from the API contract, which describes 15 endpoints and 86 methods.
</p>
<ul>
  <li>Node.js: <code>fauxshield</code> on npm, ESM with type definitions, Node 20 and newer.</li>
  <li>Python: <code>fauxshield-sdk</code> on PyPI, Python 3.9 and newer, no dependencies.</li>
  <li>The hosted API is the built-in default; <code>baseUrl</code> / <code>base_url</code> overrides it.</li>
  <li>Typed errors, retries with backoff, timeouts, and an injectable transport for tests.</li>
</ul>
''',
      ),
      DocsSection(
        id: 'cli-1-0-0',
        title: 'CLI 1.0.0',
        html: '''
<p>
  Eighteen commands across the catalogue, the fraud queue, recalls, webhooks,
  team and keys, offline sync, analytics, audit, and the consumer verification
  path, with <code>--json</code> on every read.
</p>
''',
      ),
      DocsSection(
        id: 'api',
        title: 'API',
        html: '''
<p>
  The API is additive. A method or a field appears with a minor version of the
  SDKs; a rename or a removal is a major version. The contract's fingerprint
  changes with the generated client, so a review of a dependency bump shows the
  API change itself.
</p>
''',
      ),
    ],
  );
}
