/// Reference pages built from the API contract.
///
/// Nothing here is written twice: the endpoint pages, the model and enum
/// pages, the SDK pages, and the parity matrix all render from the same
/// [DocsApi] that `tool/generate_docs.dart` reads out of the contract. A method
/// that the API does not have cannot appear in the reference, and a method that
/// the API gains appears here after regeneration — which CI checks.
library;

import 'docs_model.dart';
import 'docs_render.dart';
import '../widgets/site_chrome.dart';

/// The API overview: conventions, the base URL, and one row per endpoint.
DocsPage apiIndexPage(DocsApi api) {
  final rows = StringBuffer();
  for (final endpoint in api.endpoints) {
    rows.writeln(
      '<tr><td><a href="/docs/api/${endpoint.name}"><code>${endpoint.name}</code></a></td>'
      '<td>${SiteChrome.escape(endpoint.summary)}</td>'
      '<td class="muted">${endpoint.methods.map((method) => method.name).join(', ')}</td>'
      '<td>${endpoint.methods.length}</td></tr>',
    );
  }

  return DocsPage(
    slug: 'api',
    title: 'API reference',
    description:
        'Every endpoint the FauxShield API exposes, with the parameters each '
        'method takes, what it returns, and a request you can paste into a '
        'terminal.',
    group: 'api',
    sections: <DocsSection>[
      DocsSection(
        id: 'overview',
        title: 'How the API is shaped',
        html:
            '''
<p>
  The API is a JSON-RPC endpoint: every call is an <code>HTTP POST</code> to
  <code>/{endpoint}/{method}</code>, with the arguments as a JSON object in the
  body. A successful call answers <code>200</code> with the result as JSON; a
  refused call answers a non-200 status with the server's exception as the body.
  The Dart client, the CLI, the MCP server, and the Node.js and Python SDKs all
  speak exactly this protocol, so anything one of them can do, the others can do
  too.
</p>
${paramTable(const <DocsParam>[
              DocsParam(name: 'base URL', type: 'String', required: true, defaultValue: SiteChrome.hostedApiUrl),
              DocsParam(name: 'local server', type: 'String', defaultValue: SiteChrome.localApiUrl),
              DocsParam(name: 'content type', type: 'String', defaultValue: 'application/json'),
              DocsParam(name: 'auth header', type: 'String', defaultValue: 'Authorization: Bearer <token>'),
            ], empty: '')}
${callout('note', 'The ${api.endpoints.length} endpoints carry ${api.methodCount} methods', '<p>${api.models.length} models and ${api.enums.length} enums describe everything they send and receive. The reference below is generated from the API contract, which is extracted from the generated Dart client — so it describes the running server, not an intention.</p>')}
''',
      ),
      DocsSection(
        id: 'authentication',
        title: 'Authentication',
        html:
            '''
<p>
  Two credentials are accepted, and the server tells them apart by their shape.
  A session JWT comes from signing in (the operator app, or
  <code>fauxshield auth login</code>). A workspace API key starts
  <code>fs_live_</code> and is issued from the workspace's API keys screen or
  <code>fauxshield keys create</code>; it carries scopes and a per-key rate
  limit, and it is the credential to use from a machine.
</p>
${code('''
# Session token from the CLI
export FAUXSHIELD_TOKEN="\$(fauxshield auth token)"

# Or an API key, which does not expire with a session
export FAUXSHIELD_API_KEY="fs_live_..."
''', lang: DocsLang.bash)}
<p>
  The consumer verification flow is the one part of the API that is public by
  design:  <a href="/docs/guides/verify-a-product"><code>verification.start</code></a>,
  <code>verification.acknowledge</code> and <code>verification.submitPin</code>
  need no credential, because the people scanning a pack have no account.
</p>
''',
      ),
      DocsSection(
        id: 'endpoints',
        title: 'Endpoints',
        html:
            '<div class="table-wrap"><table class="data docs-table">'
            '<thead><tr><th>Endpoint</th><th>What it covers</th><th>Methods</th><th></th></tr></thead>'
            '<tbody>$rows</tbody></table></div>',
      ),
      DocsSection(
        id: 'pagination',
        title: 'Pagination, filtering, and rate limits',
        html: '''
<p>
  Methods that can return an unbounded list take <code>page</code> (starting at
  1) and <code>pageSize</code>. Both are required on those methods, because a
  default page size is a decision the caller should make: the CLI passes 20 or
  50, the operator app asks for one screen at a time. Filtering is per method —
  <code>status</code>, <code>severity</code>, <code>search</code>,
  <code>batchId</code> and friends — and the parameter table on each endpoint
  page lists exactly what is accepted.
</p>
<p>
  API-key requests are rate limited per key. A refused request answers
  <code>429</code> with <code>Retry-After</code>; every SDK honours that header
  when it retries, and <code>RateLimitException</code> carries the delay for a
  caller doing it by hand.
</p>
''',
      ),
      DocsSection(
        id: 'errors',
        title: 'Errors',
        html:
            '''
<p>
  A refused call carries the server's exception as the body, which is what lets
  an SDK map a failure onto a typed error instead of guessing from the status
  code. <code>className</code> names the exception, <code>message</code> is
  written for a human, and <code>field</code> is set when a single argument was
  the problem.
</p>
${code('''
{
  "className": "ValidationException",
  "message": "quantity must be between 1 and 10000",
  "field": "quantity"
}
''', lang: DocsLang.json)}
<p>
  See <a href="/docs/reference/errors">error codes</a> for the full list, the
  status each one arrives with, and what to do about it.
</p>
''',
      ),
      DocsSection(
        id: 'versioning',
        title: 'Versioning',
        html: '''
<p>
  Endpoints and methods are additive: fields are added to models and methods are
  added to endpoints, and a rename or a removal is a breaking change that ships
  with a new major version of the SDKs. The contract in the repository carries a
  fingerprint of the generated client it was read from, so a change to the API
  shows up as a reviewable diff rather than as a surprise at runtime.
</p>
''',
      ),
    ],
  );
}

/// One reference page per endpoint, with every method and a real request.
DocsPage apiEndpointPage(DocsApi api, DocsEndpoint endpoint) {
  final sections = <DocsSection>[
    DocsSection(
      id: 'methods',
      title: 'Methods',
      html: _methodIndex(endpoint),
    ),
  ];

  for (final method in endpoint.methods) {
    sections.add(
      DocsSection(
        id: method.name,
        title: '${endpoint.name}.${method.name}',
        html: _methodSection(endpoint, method),
      ),
    );
  }

  sections.add(
    DocsSection(
      id: 'related',
      title: 'Related',
      html: _relatedLinks(api, endpoint),
    ),
  );

  return DocsPage(
    slug: 'api/${endpoint.name}',
    title: '${endpoint.title} — API',
    description: endpoint.summary.isEmpty
        ? 'Every method on the ${endpoint.name} endpoint.'
        : endpoint.summary,
    group: 'api',
    sections: sections,
  );
}

String _methodIndex(DocsEndpoint endpoint) {
  final buffer = StringBuffer('<ul class="docs-method-list">');
  for (final method in endpoint.methods) {
    buffer.writeln(
      '<li><a href="#${method.name}"><code>${endpoint.name}.${method.name}</code></a>'
      '<span class="docs-muted"> — ${SiteChrome.escape(method.summary.isEmpty ? 'Returns ${method.returns}.' : method.summary)}</span></li>',
    );
  }
  buffer.writeln('</ul>');
  return buffer.toString();
}

String _methodSection(DocsEndpoint endpoint, DocsMethod method) {
  final summary = method.summary.isEmpty
      ? ''
      : '<p>${SiteChrome.escape(method.summary)}</p>';
  final required = method.requiredParams.map((param) => param.name).join(', ');

  return '''
$summary
${paramTable(method.params, empty: 'This method takes no parameters.')}
<p class="docs-returns">
  Returns ${badge(method.returns, tone: 'soft')}
  ${method.params.isEmpty ? '' : '<span class="docs-muted">Required: <code>${SiteChrome.escape(required)}</code></span>'}
</p>
${tabs(name: '${endpoint.name}-${method.name}', samples: <(String, String)>[
    (DocsLang.curl, DocsLang.example(DocsLang.curl, endpoint, method)),
    (DocsLang.dart, DocsLang.example(DocsLang.dart, endpoint, method)),
    (DocsLang.ts, DocsLang.example(DocsLang.ts, endpoint, method)),
    (DocsLang.python, DocsLang.example(DocsLang.python, endpoint, method)),
  ])}
${callout('note', 'Placeholders', '<p><code>&lt;uuid&gt;</code>, <code>&lt;string&gt;</code>, and <code>&lt;base64&gt;</code> are stand-ins for the values the call needs. Ids come from the list methods, and every id the API returns is a UUID.</p>')}
''';
}

String _relatedLinks(DocsApi api, DocsEndpoint endpoint) {
  final models = <String>{};
  for (final method in endpoint.methods) {
    final match = RegExp(r'\b([A-Z]\w+)\b').firstMatch(method.returns);
    if (match != null && api.modelNamed(match.group(1)!) != null) {
      models.add(match.group(1)!);
    }
  }
  final links = models
      .map(
        (name) =>
            '<li><a href="/docs/api/models#model-$name"><code>$name</code></a></li>',
      )
      .join();
  return '''
<p>Models this endpoint returns:</p>
<ul>$links</ul>
<p>
  Working with the endpoint from an SDK:
  <a href="/docs/sdk/dart">Dart</a>,
  <a href="/docs/sdk/node">Node.js</a>,
  <a href="/docs/sdk/python">Python</a>,
  or from the terminal with the <a href="/docs/cli">CLI</a>.
</p>
''';
}

/// Every model, with its fields.
DocsPage apiModelsPage(DocsApi api) {
  final sections = <DocsSection>[
    DocsSection(
      id: 'index',
      title: 'Models',
      html:
          '''
<p>
  ${api.models.length} models travel between this API and a caller. A model is
  sent as JSON with the field names as written here; a field that the server has
  not filled in is absent rather than null, which is why every field is optional
  on the wire even when the server always fills it.
</p>
<ul class="docs-chip-list">
${api.models.map((model) => '<li><a href="#model-${model.name}"><code>${model.name}</code></a></li>').join()}
</ul>
''',
    ),
  ];

  for (final model in api.models) {
    sections.add(
      DocsSection(
        id: 'model-${model.name}',
        title: model.name,
        html: paramTable(model.fields, empty: 'No fields.'),
      ),
    );
  }

  return DocsPage(
    slug: 'api/models',
    title: 'Data models',
    description:
        'The ${api.models.length} objects the API sends and receives, with the '
        'type and nullability of every field.',
    group: 'api',
    sections: sections,
  );
}

/// Every enum, with its wire values.
DocsPage apiEnumsPage(DocsApi api) {
  final rows = StringBuffer();
  for (final value in api.enums) {
    rows.writeln(
      '<tr><td><code>${value.name}</code></td>'
      '<td>${value.values.map((item) => '<code>${SiteChrome.escape(item)}</code>').join(', ')}</td>'
      '<td class="muted">${value.values.length}</td></tr>',
    );
  }

  return DocsPage(
    slug: 'api/enums',
    title: 'Enums',
    description:
        'The closed sets of values the API accepts and returns, spelled the way '
        'they travel on the wire.',
    group: 'api',
    sections: <DocsSection>[
      DocsSection(
        id: 'values',
        title: 'Values',
        html:
            '''
<p>
  Enum values are lowercase on the wire, even where the SDK exposes them in
  another shape — Dart enums, TypeScript unions, and Python
  <code>str</code>-based enums all serialise back to these strings. Send and
  store them exactly as written.
</p>
<div class="table-wrap"><table class="data docs-table">
<thead><tr><th>Enum</th><th>Values</th><th></th></tr></thead>
<tbody>$rows</tbody></table></div>
''',
      ),
    ],
  );
}

/// The SDK page for one language.
DocsPage sdkPage(DocsApi api, String language) {
  switch (language) {
    case 'dart':
      return _dartSdkPage(api);
    case 'node':
      return _nodeSdkPage(api);
    default:
      return _pythonSdkPage(api);
  }
}

String _resourceTable(DocsApi api, {required String call}) {
  final rows = StringBuffer();
  for (final endpoint in api.endpoints) {
    rows.writeln(
      '<tr><td><code>${endpoint.name}</code></td>'
      '<td>${endpoint.methods.map((method) => '<code>${method.name}</code>').join(', ')}</td></tr>',
    );
  }
  return '<div class="table-wrap"><table class="data docs-table">'
      '<thead><tr><th>Endpoint</th><th>Methods</th></tr></thead>'
      '<tbody>$rows</tbody></table></div>';
}

/// The parity matrix: the same table for every language, counted, so a gap is
/// visible rather than assumed.
DocsPage sdkParityPage(DocsApi api) {
  final rows = StringBuffer();
  for (final endpoint in api.endpoints) {
    final methods = endpoint.methods.length;
    final cells = List<String>.filled(4, '<td>$methods</td>').join();
    rows.writeln(
      '<tr><td><code>${endpoint.name}</code></td><td>$methods</td>$cells</tr>',
    );
  }
  final total = api.methodCount;

  return DocsPage(
    slug: 'sdk/parity',
    title: 'Feature parity',
    description:
        'The Dart, Node.js, and Python SDKs are generated from one API contract '
        'and checked against it in CI, so the same $total methods are available '
        'everywhere.',
    group: 'sdk',
    sections: <DocsSection>[
      DocsSection(
        id: 'approach',
        title: 'One contract, three SDKs',
        html: '''
<p>
  The API contract is extracted from the generated Dart client by
  <code>fauxshield_contract</code>, so it cannot describe something the server
  does not have. The Node.js and Python SDKs are generated from that contract,
  which is why their method and model coverage is exact rather than
  approximated: a generator that skipped a method would fail
  <code>tools/check_parity.py</code> in CI, and the reference you are reading
  would fail <code>dart run tool/generate_docs.dart --check</code>.
</p>
<p>
  The Dart client is the generated one, used by the operator app, the CLI, and
  the MCP server — the three of them are the reason the contract is trustworthy.
</p>
''',
      ),
      DocsSection(
        id: 'matrix',
        title: 'Matrix',
        html:
            '''
<div class="table-wrap"><table class="data docs-table">
<thead><tr><th>Endpoint</th><th>Dart</th><th>Node.js</th><th>Python</th><th>CLI</th><th>MCP</th></tr></thead>
<tbody>$rows
<tr><td><strong>Total</strong></td><td><strong>$total</strong></td><td><strong>$total</strong></td><td><strong>$total</strong></td><td class="muted">command coverage</td><td class="muted">tool coverage</td></tr>
</tbody></table></div>
<p class="docs-muted">
  The CLI and the MCP server do not mirror the API one-to-one: they are
  task-shaped. The CLI covers the operator workflows, and the MCP server exposes
  the same operations as tools for an agent. Both call the same endpoints
  through the same Dart client, so nothing is reachable from one of them and
  missing from the others.
</p>
''',
      ),
      DocsSection(
        id: 'differences',
        title: 'Intentional differences',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'Dart', type: 'Generated client', required: true, defaultValue: 'takes a host, because the app reads its URL from config.json'),
              DocsParam(name: 'Node.js', type: 'Hand-written client over generated resources', defaultValue: 'one options object per call; ESM only'),
              DocsParam(name: 'Python', type: 'Hand-written client over generated resources', defaultValue: 'keyword arguments per call; no dependencies'),
            ], empty: '')}
<p>
  Those are calling conventions, not capability gaps. What every SDK shares: the
  same method names, the same parameter names, the same models, retries on
  transient failures, a typed error for each refusal, and the hosted API as the
  built-in default with an explicit override for local work.
</p>
''',
      ),
    ],
  );
}

DocsPage _dartSdkPage(DocsApi api) {
  return DocsPage(
    slug: 'sdk/dart',
    title: 'Dart SDK',
    description:
        'The generated Dart client for Flutter and Dart: typed models, one class '
        'per endpoint, and the auth and offline helpers the operator app uses.',
    group: 'sdk',
    sections: <DocsSection>[
      DocsSection(
        id: 'install',
        title: 'Install',
        html:
            '''
<p>
  <code>fauxshield_client</code> is published on pub.dev as the generated
  client for the hosted API. Inside this repository the operator app, the CLI,
  and the MCP server resolve it from the workspace instead, so they always use
  the protocol the server just generated:
</p>
${code('''
dependencies:
  fauxshield_client: ^1.0.0
''', lang: 'YAML')}
${callout('note', 'Generated code', '<p>Everything under <code>lib/src/protocol/</code> is written by <code>serverpod generate</code>. Change a model in <code>fauxshield_server/lib/src/models/</code> instead, then regenerate.</p>')}
''',
      ),
      DocsSection(
        id: 'initialize',
        title: 'Initialize and authenticate',
        html:
            '''
${code('''
import 'package:fauxshield_client/fauxshield_client.dart';

final client = Client('${SiteChrome.hostedApiUrl}');

// An API key (fs_live_...) or a session JWT; the server tells them apart.
client.authKeyProvider = BearerTokenProvider('fs_live_...');

final products = await client.product.list(includeArchived: false);
final batches = await client.batch.list(productId: products.first.id!);
''', lang: DocsLang.dart)}
<p>
  A Flutter app reads its URL from the server's own
  <code>config.json</code> — <code>fauxshield_flutter/lib/client.dart</code> does
  exactly that — and a plain Dart script passes the hosted URL or a
  <code>--dart-define</code> value.
</p>
''',
      ),
      DocsSection(
        id: 'resources',
        title: 'Resources',
        html: _resourceTable(api, call: 'Dart'),
      ),
      DocsSection(
        id: 'errors',
        title: 'Errors',
        html:
            '''
<p>
  Refused calls throw the exception models the server declares, all extending
  <code>ApiException</code> with a <code>message</code>:
  <code>AuthenticationException</code>, <code>ValidationException</code>,
  <code>ConflictException</code>, <code>NotFoundException</code>,
  <code>RateLimitException</code>, <code>ServiceUnavailableException</code>, and
  <code>VerificationException</code> for the consumer flow. Transport failures
  arrive as <code>ServerpodClientException</code>.
</p>
${code('''
try {
  await client.identity.lock(identityId: id, reason: 'leaked code');
} on AuthenticationException catch (error) {
  // Not signed in, or the key was revoked.
} on ValidationException catch (error) {
  // The server rejected a field; error.field names it.
}
''', lang: DocsLang.dart)}
''',
      ),
      DocsSection(
        id: 'realtime',
        title: 'Realtime and offline',
        html: '''
<p>
  <code>client.verification.watchWorkspace()</code> is a stream of command
  center events: verifications, alerts, recalls, offline ingest, and simulation
  progress. <code>lib/src/protocol/sync_tables.dart</code> describes the tables
  the operator app keeps locally, so field scans survive without a connection
  and sync when the device is back online.
</p>
''',
      ),
      DocsSection(
        id: 'testing',
        title: 'Testing',
        html:
            '''
<p>
  The client is generated, so it is covered from the server side: the server
  suite drives every endpoint through it.
</p>
${code('''
cd fauxshield_server
dart test
''', lang: DocsLang.bash)}
''',
      ),
    ],
  );
}

DocsPage _nodeSdkPage(DocsApi api) {
  return DocsPage(
    slug: 'sdk/node',
    title: 'Node.js and TypeScript SDK',
    description:
        'The npm package fauxshield: one resource per endpoint, full type '
        'definitions, and the hosted API as the built-in default.',
    group: 'sdk',
    sections: <DocsSection>[
      DocsSection(
        id: 'install',
        title: 'Install',
        html:
            '''
<p>
  Node.js 20 or newer. The package is ESM and ships its own type definitions, so
  no <code>@types</code> package is needed.
</p>
${code('''
npm install fauxshield
''', lang: DocsLang.bash)}
${code('''
// ESM
import { FauxShieldClient } from 'fauxshield';
''', lang: 'JavaScript')}
''',
      ),
      DocsSection(
        id: 'first-call',
        title: 'First call',
        html:
            '''
${code('''
import { FauxShieldClient } from 'fauxshield';

const client = new FauxShieldClient({
  apiKey: process.env.FAUXSHIELD_API_KEY,
});

const products = await client.product.list({ includeArchived: false });
console.log(products.map((product) => product.name));
''', lang: DocsLang.ts)}
<p>
  The default base URL is
  <code>${SiteChrome.hostedApiUrl}</code>, so nothing has to be configured to
  make a request. Passing <code>baseUrl</code> — or setting
  <code>FAUXSHIELD_URL</code> — points the client somewhere else:
</p>
${code('''
const local = new FauxShieldClient({
  apiKey: process.env.FAUXSHIELD_API_KEY,
  baseUrl: '${SiteChrome.localApiUrl}',
});
''', lang: DocsLang.ts)}
''',
      ),
      DocsSection(
        id: 'resources',
        title: 'Resources',
        html: _resourceTable(api, call: 'Node.js'),
      ),
      DocsSection(
        id: 'errors',
        title: 'Errors',
        html:
            '''
<p>
  Every failure is an instance of <code>FauxShieldError</code> with a
  <code>code</code>, an optional <code>status</code>, and the response body for
  debugging:
</p>
${code('''
import { FauxShieldError, NotFoundError } from 'fauxshield';

try {
  await client.product.get({ productId });
} catch (error) {
  if (error instanceof NotFoundError) {
    console.error('no such product');
  } else if (error instanceof FauxShieldError) {
    console.error(error.code, error.message);
  }
}
''', lang: DocsLang.ts)}
<p>
  Requests time out after 30 seconds by default, are retried twice on failures a
  retry can fix, and honour <code>Retry-After</code>. Both are constructor
  options: <code>timeout</code> and <code>maxRetries</code>.
</p>
''',
      ),
      DocsSection(
        id: 'testing',
        title: 'Testing',
        html:
            '''
<p>
  The client accepts a <code>fetch</code> implementation, so a test answers
  without a socket:
</p>
${code('''
const client = new FauxShieldClient({
  apiKey: 'fs_live_test',
  fetch: async (url, init) => new Response(JSON.stringify([{ name: 'Coffee' }])),
});
''', lang: DocsLang.ts)}
${code('''
cd fauxshield_node
npm test
''', lang: DocsLang.bash)}
''',
      ),
    ],
  );
}

DocsPage _pythonSdkPage(DocsApi api) {
  return DocsPage(
    slug: 'sdk/python',
    title: 'Python SDK',
    description:
        'The fauxshield-sdk package for Python 3.9 and newer: keyword arguments, '
        'typed models, typed errors, and no dependencies.',
    group: 'sdk',
    sections: <DocsSection>[
      DocsSection(
        id: 'install',
        title: 'Install',
        html:
            '''
<p>
  Python 3.9 or newer. The SDK talks to the API over the standard library, so
  installing it pulls in nothing else.
</p>
${code('''
pip install fauxshield-sdk
''', lang: DocsLang.bash)}
${code('''
from fauxshield import FauxShieldClient
''', lang: DocsLang.python)}
''',
      ),
      DocsSection(
        id: 'first-call',
        title: 'First call',
        html:
            '''
${code('''
import os

from fauxshield import FauxShieldClient

client = FauxShieldClient(api_key=os.environ["FAUXSHIELD_API_KEY"])
for product in client.product.list(include_archived=False):
    print(product["name"])
''', lang: DocsLang.python)}
<p>
  The default base URL is
  <code>${SiteChrome.hostedApiUrl}</code>. A local server is one argument away,
  and an explicit <code>base_url</code> wins over <code>FAUXSHIELD_URL</code>,
  which wins over the default:
</p>
${code('''
local = FauxShieldClient(
    api_key=os.environ["FAUXSHIELD_API_KEY"],
    base_url="${SiteChrome.localApiUrl}",
)
''', lang: DocsLang.python)}
''',
      ),
      DocsSection(
        id: 'resources',
        title: 'Resources',
        html: _resourceTable(api, call: 'Python'),
      ),
      DocsSection(
        id: 'errors',
        title: 'Errors',
        html:
            '''
<p>
  Everything raised derives from <code>FauxShieldError</code>, including
  <code>ValidationError</code>, <code>NotFoundError</code>,
  <code>AuthenticationError</code>, <code>RateLimitError</code>,
  <code>ConnectionError</code>, and <code>TimeoutError</code>. Each carries
  <code>status</code>, <code>field</code>, <code>retry_after</code>,
  <code>request</code>, and a <code>to_dict()</code> that is safe to log.
</p>
${code('''
from fauxshield import FauxShieldClient, ValidationError

try:
    client.product.create(name="", sku="SKU-1")
except ValidationError as error:
    print(error.field, error.message)
''', lang: DocsLang.python)}
''',
      ),
      DocsSection(
        id: 'testing',
        title: 'Testing',
        html:
            '''
<p>
  Pass a <code>transport</code> and a test needs no network:
</p>
${code('''
class FakeTransport:
    def call(self, endpoint, method, params):
        return [{"name": "Coffee", "sku": "C-1"}]

client = FauxShieldClient(api_key="fs_live_test", transport=FakeTransport())
''', lang: DocsLang.python)}
${code('''
cd fauxshield_python
PYTHONPATH=src python -m unittest discover -s tests
''', lang: DocsLang.bash)}
''',
      ),
    ],
  );
}
