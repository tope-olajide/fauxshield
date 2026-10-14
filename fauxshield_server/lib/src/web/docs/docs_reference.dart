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

/// `alert` → `alert` (TS/Dart), `alert` → `alert`, `apiKey` → `api_key`
/// (Python). Python also suffixes `from`, which is a keyword.
String _accessor(String endpointName, String language) =>
    language == 'python' ? _snake(endpointName) : endpointName;

/// The method name as the language spells it: snake_case in Python.
String _methodName(String name, String language) =>
    language == 'python' ? _snake(name) : name;

String _snake(String name) {
  final mapped = name
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)}_${match.group(2)}',
      )
      .toLowerCase();
  return mapped == 'from' ? 'from_' : mapped;
}

/// A contract type as the generated TypeScript spells it.
String _tsType(String type) {
  final nullable = type.endsWith('?');
  final base = nullable ? type.substring(0, type.length - 1) : type;
  final mapped = switch (base) {
    'String' => 'string',
    'int' || 'double' || 'num' => 'number',
    'bool' => 'boolean',
    // Ids and timestamps travel as their JSON form.
    'UuidValue' || 'DateTime' => 'string',
    _ when base.startsWith('List<') =>
      '${_tsType(base.substring(5, base.length - 1))}[]',
    // A model or an enum: exported from the package under the same name.
    _ => base,
  };
  return nullable ? '$mapped | null' : mapped;
}

/// A contract return type as the generated TypeScript spells it.
String _tsReturn(String returns) => switch (returns) {
  'void' => 'Promise<void>',
  'int' => 'Promise<number>',
  'bool' => 'Promise<boolean>',
  'String' => 'Promise<string>',
  _ when returns.startsWith('List<') =>
    'Promise<${_tsType(returns.substring(5, returns.length - 1))}[]>',
  _ => 'Promise<${_tsType(returns)}>',
};

/// The exact signature the generated TypeScript declares for one method.
String _tsSignature(DocsEndpoint endpoint, DocsMethod method) {
  final buffer = StringBuffer('${method.name}(');
  if (method.params.isNotEmpty) {
    buffer.write('params: { ');
    for (var index = 0; index < method.params.length; index++) {
      final param = method.params[index];
      if (index > 0) buffer.write(', ');
      buffer.write('${param.name}${param.required ? '' : '?'}: ');
      buffer.write(_tsType(param.display));
    }
    buffer.write(' }');
  }
  buffer.write('): ${_tsReturn(method.returns)}');
  return buffer.toString();
}

/// A contract type as the generated Python spells it.
String _pyType(String type) {
  final nullable = type.endsWith('?');
  final base = nullable ? type.substring(0, type.length - 1) : type;
  final mapped = switch (base) {
    'String' => 'str',
    'int' => 'int',
    'double' || 'num' => 'float',
    'bool' => 'bool',
    'UuidValue' || 'DateTime' => 'str',
    _ when base.startsWith('List<') =>
      'List[${_pyType(base.substring(5, base.length - 1))}]',
    _ => base,
  };
  return nullable ? 'Optional[$mapped]' : mapped;
}

/// The exact signature the generated Python declares for one method.
///
/// Every parameter is keyword-only, which is what `tools/generate.py` emits.
String _pySignature(DocsEndpoint endpoint, DocsMethod method) {
  final buffer = StringBuffer('def ${_snake(method.name)}(self');
  if (method.params.isNotEmpty) {
    buffer.write(', *, ');
    for (var index = 0; index < method.params.length; index++) {
      final param = method.params[index];
      if (index > 0) buffer.write(', ');
      buffer.write('${_snake(param.name)}: ${_pyType(param.display)}');
      if (!param.required) buffer.write(' = None');
    }
  }
  buffer.write(')');
  return buffer.toString();
}

/// The exact signature the generated Dart client declares for one method.
///
/// A lone required parameter is positional; everything else is named, which is
/// how `serverpod generate` writes the client.
String _dartSignature(DocsEndpoint endpoint, DocsMethod method) {
  final buffer = StringBuffer('Future<${method.returns}> ${method.name}(');
  final lone = method.params.length == 1 && method.params.single.required;
  if (lone) {
    final param = method.params.single;
    buffer.write('${param.display} ${param.name}');
  } else if (method.params.isNotEmpty) {
    buffer.write('{');
    for (var index = 0; index < method.params.length; index++) {
      final param = method.params[index];
      if (index > 0) buffer.write(', ');
      if (param.required) buffer.write('required ');
      buffer.write('${param.display} ${param.name}');
    }
    buffer.write('}');
  }
  buffer.write(')');
  return buffer.toString();
}

/// One section per resource, listing every method with the signature the
/// language's SDK really declares, and a link to the full reference entry.
List<DocsSection> _sdkResourceSections(DocsApi api, String language) {
  final lang = switch (language) {
    'dart' => DocsLang.dart,
    'python' => DocsLang.python,
    _ => DocsLang.ts,
  };
  final sections = <DocsSection>[];
  for (final endpoint in api.endpoints) {
    final accessor = _accessor(endpoint.name, language);
    final buffer = StringBuffer()
      ..writeln('<p>${SiteChrome.escape(endpoint.summary)}</p>')
      ..writeln(
        '<p>Reached as <code>client.$accessor</code>. '
        '<a href="/docs/api/${endpoint.name}">Full reference</a> — every '
        'parameter, the return shape, the errors, and a runnable example in '
        'every language.</p>',
      );
    for (final method in endpoint.methods) {
      final signature = switch (language) {
        'dart' => _dartSignature(endpoint, method),
        'python' => _pySignature(endpoint, method),
        _ => _tsSignature(endpoint, method),
      };
      buffer
        ..writeln(
          '<p class="docs-method-name">'
          '<code>$accessor.${_methodName(method.name, language)}</code> '
          '<a href="/docs/api/${endpoint.name}#${method.name}">reference</a>'
          '</p>',
        )
        ..writeln(code(signature, lang: lang));
    }
    sections.add(
      DocsSection(
        id: 'resource-${endpoint.name}',
        title: endpoint.name,
        html: buffer.toString(),
      ),
    );
  }
  return sections;
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
        'per endpoint, the auth and offline helpers the operator app uses, and '
        'the exact signature of every method.',
    group: 'sdk',
    sections: <DocsSection>[
      DocsSection(
        id: 'install',
        title: 'Install',
        html:
            '''
<p>
  <code>fauxshield_client</code> is the generated client for the hosted API,
  published on pub.dev. Inside this repository the operator app, the CLI, and
  the MCP server resolve it from the workspace instead, so they always use the
  protocol the server just generated:
</p>
${code('''
dart pub add fauxshield_client
''', lang: DocsLang.bash)}
${code('''
dependencies:
  fauxshield_client: ^1.0.0
''', lang: 'YAML')}
${callout('note', 'Generated code', '<p>Everything under <code>lib/src/protocol/</code> is written by <code>serverpod generate</code>. Change a model in <code>fauxshield_server/lib/src/models/</code> instead, then regenerate — never edit the client by hand.</p>')}
<p>
  The client depends on <code>serverpod_client</code>, <code>http</code>, and the
  auth packages; a Flutter or Dart project picks those up transitively.
</p>
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
${paramTable(const <DocsParam>[
              DocsParam(name: 'Client(host)', type: 'constructor', required: true, defaultValue: 'the server root; ${SiteChrome.hostedApiUrl} is the production API'),
              DocsParam(name: 'authKeyProvider', type: 'property', defaultValue: 'supplies the bearer token: BearerTokenProvider, or your own implementation'),
              DocsParam(name: 'connectTimeout', type: 'Duration?', defaultValue: 'how long to wait when opening a connection; null waits indefinitely'),
            ], empty: '')}
<p>
  A Flutter app reads its URL from the server's own
  <code>config.json</code> — <code>fauxshield_flutter/lib/client.dart</code> does
  exactly that, so a deployed app always calls the server that served it — and a
  plain Dart script passes the hosted URL or a <code>--dart-define</code> value.
  Against a local server, the only thing that changes is the host:
</p>
${code('''
final local = Client('${SiteChrome.localApiUrl}')
  ..authKeyProvider = BearerTokenProvider('fs_live_...');
''', lang: DocsLang.dart)}
<p>
  The parameter tables on this page show the client's own calling convention:
  a lone required parameter is positional, and everything else is named, with
  required parameters marked <code>required</code> and optional ones nullable.
</p>
''',
      ),
      ..._sdkResourceSections(api, 'dart'),
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
import 'package:fauxshield_client/fauxshield_client.dart';

try {
  await client.identity.lock(identityId: id, reason: 'leaked code');
} on AuthenticationException {
  // Not signed in, or the key was revoked.
} on ValidationException catch (error) {
  // The server rejected a field; error.field names it.
} on NotFoundException {
  // No such unit, or it belongs to another workspace.
} on ServerpodClientException catch (error) {
  // The request never got an answer: DNS, TLS, or a dropped connection.
}
''', lang: DocsLang.dart)}
<p>
  There is no automatic retry in the generated client: a call either returns or
  throws, and the caller decides. For a bulk write, catch the failure and retry
  with the same <code>idempotencyKey</code> — the server replays the first
  result rather than doing the work twice. See
  <a href="/docs/reference/errors">error codes</a> for the full list.
</p>
''',
      ),
      DocsSection(
        id: 'realtime',
        title: 'Realtime and offline',
        html:
            '''
<p>
  <code>client.verification.watchWorkspace()</code> is a stream of command
  center events: verifications, alerts, recalls, offline ingest, and simulation
  progress. Serverpod reconnects the stream on its own, so a UI that subscribes
  once keeps receiving events across a network blip.
</p>
${code('''
client.verification.watchWorkspace().listen((event) {
  // event.type is a LiveEventType: verificationCompleted, fraudAlertCreated, …
});
''', lang: DocsLang.dart)}
<p>
  <code>lib/src/protocol/sync_tables.dart</code> describes the tables the
  operator app keeps locally, so field scans survive without a connection and
  sync when the device is back online. That is the one part of the platform
  only the Dart client has: offline sync is a Serverpod feature, and the
  Node.js and Python SDKs reach the same scans through
  <code>offline.ingest</code> instead.
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
  suite drives every endpoint through it against an embedded PostgreSQL, and
  <code>fauxshield_server/test/unit/docs_site_test.dart</code> checks that the
  signatures on this page match the contract the client was generated from.
</p>
${code('''
cd fauxshield_server
dart test
''', lang: DocsLang.bash)}
<p>
  To unit test your own code, wrap the client behind a small interface of your
  own — the generated classes are not designed to be mocked directly — or point
  a <code>Client</code> at a local <code>serverpod start</code> and use the
  disposable demo workspace.
</p>
''',
      ),
    ],
  );
}

DocsPage _nodeSdkPage(DocsApi api) {
  final totalMethods = api.methodCount;
  return DocsPage(
    slug: 'sdk/node',
    title: 'Node.js and TypeScript SDK',
    description:
        'The npm package fauxshield: installation, configuration, every '
        'resource and method with real signatures, the error model, retries, '
        'and how to test an integration without a network.',
    group: 'sdk',
    sections: <DocsSection>[
      DocsSection(
        id: 'install',
        title: 'Install',
        html:
            '''
<p>
  Node.js 20 or newer (<code>AbortSignal.timeout</code> and
  <code>fetch</code> are used unconditionally). The package is ESM-only
  (<code>"type": "module"</code>) and ships its own type definitions, so no
  <code>@types</code> package is needed and nothing has to be configured for a
  bundler.
</p>
${code('''
npm install fauxshield
''', lang: DocsLang.bash)}
${code('''
// ESM — the only module system the package declares
import { FauxShieldClient } from 'fauxshield';
''', lang: 'JavaScript')}
${callout('note', 'CommonJS', '''<p>The package exports ESM only. From a CommonJS project, load it with dynamic <code>await import(&#39;fauxshield&#39;)</code> rather than <code>require()</code>, which throws.</p>''')}
<p>
  The package name is <code>fauxshield</code>, version
  <code>0.1.0</code>, MIT licensed. What it exports:
</p>
${paramTable(<DocsParam>[
              DocsParam(name: 'FauxShieldClient', type: 'class', required: true, defaultValue: 'the client; one property per resource'),
              DocsParam(name: '*Error classes', type: '11 classes', defaultValue: 'FauxShieldError and its subclasses, plus FauxShieldConfigError'),
              DocsParam(name: 'FauxShieldConfig', type: 'interface', defaultValue: 'constructor options; see Configuration'),
              DocsParam(name: 'Transport / HttpTransport', type: 'interface / class', defaultValue: 'the seam a test replaces'),
              DocsParam(name: 'Models and enums', type: '${api.models.length} interfaces, ${api.enums.length} unions', defaultValue: 'Product, Batch, AlertStatus, ApiScope, … — see Types'),
              DocsParam(name: 'Helpers', type: 'functions', defaultValue: 'resolveConfig, validateBaseUrl, isRetryable, errorFromResponse, codeForStatus, redact, parseJson'),
            ], empty: '')}
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
  make a request against production. Every method takes one options object;
  parameters that are optional on the wire are optional properties on that
  object, and required parameters are required properties — TypeScript tells
  you at compile time when a call is incomplete.
</p>
${callout('note', 'Responses are the API\'s own models', '<p>A call returns the same object the HTTP API returns, typed by the generated interfaces: <code>Product</code>, <code>Batch</code>, <code>VerificationPresentation</code>. There is no client-side reshaping to learn.</p>')}
''',
      ),
      DocsSection(
        id: 'configuration',
        title: 'Configuration',
        html:
            '''
<p>
  Everything is optional. The resolution order is explicit value, then
  environment, then built-in default — verified in
  <code>src/config.ts</code>:
</p>
${paramTable(const <DocsParam>[
              DocsParam(name: 'apiKey', type: 'string', defaultValue: 'falls back to FAUXSHIELD_API_KEY; an fs_live_ key or a session JWT'),
              DocsParam(name: 'baseUrl', type: 'string', defaultValue: 'falls back to FAUXSHIELD_URL, then ${SiteChrome.hostedApiUrl}'),
              DocsParam(name: 'timeoutMs', type: 'number', defaultValue: '30000; must be a positive whole number of milliseconds'),
              DocsParam(name: 'maxRetries', type: 'number', defaultValue: '2, so a call is attempted at most 3 times; 0 disables retries'),
              DocsParam(name: 'fetch', type: 'typeof fetch', defaultValue: 'globalThis.fetch; replace it to test or to run on a non-standard runtime'),
              DocsParam(name: 'environment', type: 'Record<string, string | undefined>', defaultValue: 'process.env; pass a map in tests so they do not read the real environment'),
            ], empty: '')}
<p>
  <code>client.baseUrl</code> is a read-only property holding the resolved URL,
  which is the value to log when a call goes somewhere unexpected.
</p>
${tabs(name: 'node-config', samples: <(String, String)>[
              (
                'Production',
                '''
// The hosted API is the default; only the key is needed.
const client = new FauxShieldClient({
  apiKey: process.env.FAUXSHIELD_API_KEY,
});
console.log(client.baseUrl); // ${SiteChrome.hostedApiUrl}
''',
              ),
              (
                'Localhost',
                '''
const client = new FauxShieldClient({
  apiKey: process.env.FAUXSHIELD_API_KEY,
  baseUrl: '${SiteChrome.localApiUrl}',
});
// Or once, for every script: export FAUXSHIELD_URL=${SiteChrome.localApiUrl}
''',
              ),
              (
                'Staging',
                '''
const client = new FauxShieldClient({
  apiKey: process.env.STAGING_KEY,
  baseUrl: 'https://staging.example.com',   // any http(s) server root
  timeoutMs: 45_000,                        // bulk writes need more headroom
});
''',
              ),
              (
                'Tests',
                '''
const client = new FauxShieldClient({
  apiKey: 'fs_live_test',
  environment: { FAUXSHIELD_URL: 'https://example.test' }, // no real env read
  maxRetries: 0,                             // fail fast, do not back off
  fetch: async () => new Response('[]'),
});
''',
              ),
            ])}
${callout('warning', 'A custom baseUrl always wins', '<p>An explicit <code>baseUrl</code> overrides the built-in production URL, and so does <code>FAUXSHIELD_URL</code>. No published SDK defaults to localhost: a developer who installed the package and set only a key talks to the hosted API.</p>')}
<p>
  Invalid configuration throws <code>FauxShieldConfigError</code> from the
  constructor, before any request is made: a URL that does not parse, a
  non-http(s) scheme, a query string or fragment on the base URL, a
  non-positive <code>timeoutMs</code>, or a negative
  <code>maxRetries</code>. Error messages run through <code>redact()</code>,
  which masks <code>fs_live_</code>/<code>fs_test_</code> keys and JWTs so a
  mistyped URL cannot leak a credential into a log.
</p>
''',
      ),
      ..._sdkResourceSections(api, 'node'),
      DocsSection(
        id: 'errors',
        title: 'Errors',
        html:
            '''
<p>
  Every failure is a <code>FauxShieldError</code>, so one <code>catch</code>
  covers all of them, and the subclass (or <code>error.code</code>) says which
  one it was. A typed refusal arrives as HTTP <code>400</code> carrying the
  exception as the body, so the mapping reads <code>className</code> first and
  falls back to the status code only when the body names nothing.
</p>
${paramTable(const <DocsParam>[
              DocsParam(name: 'AuthenticationError', type: 'code: authentication', defaultValue: 'missing, expired, or under-scoped credential; 401/403'),
              DocsParam(name: 'NotFoundError', type: 'code: not_found', defaultValue: 'no such resource, or not visible to this credential'),
              DocsParam(name: 'ValidationError', type: 'code: validation', defaultValue: 'arguments rejected; error.field names the offender'),
              DocsParam(name: 'ConflictError', type: 'code: conflict', defaultValue: 'the change conflicts with current state, e.g. a duplicate SKU'),
              DocsParam(name: 'RateLimitError', type: 'code: rate_limit', defaultValue: 'over the key\'s limit; error.retryAfterSeconds says how long'),
              DocsParam(name: 'ServiceUnavailableError', type: 'code: service_unavailable', defaultValue: 'a dependency is down or unset; 502/503/504'),
              DocsParam(name: 'VerificationError', type: 'code: verification', defaultValue: 'the consumer flow refused: wrong PIN, locked unit, expired session'),
              DocsParam(name: 'ApiError', type: 'code: api_error', defaultValue: 'anything else the server answered with, including 500'),
              DocsParam(name: 'ConnectionError', type: 'code: connection', defaultValue: 'the request never reached the API: DNS, TLS, socket'),
              DocsParam(name: 'TimeoutError', type: 'code: timeout', defaultValue: 'the request ran past timeoutMs'),
              DocsParam(name: 'FauxShieldConfigError', type: 'extends Error', defaultValue: 'unusable configuration, thrown by the constructor — not a FauxShieldError'),
            ], empty: '')}
<p>
  Every <code>FauxShieldError</code> carries
  <code>code</code>, <code>status</code>, <code>field</code>,
  <code>retryAfterSeconds</code>, <code>request</code> (for example
  <code>product.list</code>), and the raw <code>body</code> for debugging.
  <code>toJSON()</code> returns a plain object for logs and deliberately leaves
  the body out.
</p>
${code('''
import { FauxShieldError, NotFoundError, RateLimitError, ValidationError } from 'fauxshield';

try {
  await client.identity.lock({ identityId, reason: 'cloned code' });
} catch (error) {
  if (error instanceof NotFoundError) {
    // No such unit, or it belongs to another workspace.
  } else if (error instanceof ValidationError) {
    console.error('rejected field:', error.field);
  } else if (error instanceof RateLimitError) {
    await new Promise((r) => setTimeout(r, (error.retryAfterSeconds ?? 1) * 1000));
  } else if (error instanceof FauxShieldError) {
    // Unmapped failure: the request that failed is on error.request.
    console.error(error.code, error.request, error.message);
  } else {
    throw error; // a programming error, not an API failure
  }
}
''', lang: DocsLang.ts)}
<p>
  The full list, with the HTTP status each one arrives with and what to do
  about it, is in <a href="/docs/reference/errors">error codes</a>.
</p>
''',
      ),
      DocsSection(
        id: 'reliability',
        title: 'Timeouts, retries, and rate limits',
        html:
            '''
<p>
  <code>HttpTransport</code> is the only thing that talks to the network, and
  its policy is small enough to state exactly:
</p>
${paramTable(const <DocsParam>[
              DocsParam(name: 'Timeout', type: 'per attempt', required: true, defaultValue: 'timeoutMs (30s default), enforced with AbortSignal.timeout'),
              DocsParam(name: 'Retried', type: 'failure', required: true, defaultValue: 'connection, timeout, 429, 502/503/504, and 500 — and nothing else'),
              DocsParam(name: 'Attempts', type: 'count', required: true, defaultValue: 'maxRetries + 1, so 3 by default and 1 with maxRetries: 0'),
              DocsParam(name: 'Delay', type: 'backoff', required: true, defaultValue: 'Retry-After capped at 30s when the server sent one; otherwise 200ms doubling, capped at 4s'),
            ], empty: '')}
${callout('warning', 'Retrying a write can duplicate work', '''<p>The transport retries by status, and it cannot tell a read from a write. Every retryable status it acts on (429, 5xx, connection, timeout) can in principle arrive after the server has already started doing something. For bulk writes, pass an <code>idempotencyKey</code> — <code>batch.generateIdentities</code> takes one and replays the first result instead of minting twice — or set <code>maxRetries: 0</code> and decide yourself. Read methods and single-row writes are safe to let the transport retry.</p>''')}
<p>
  Rate limits are per API key, and a refused request answers
  <code>429</code> with <code>Retry-After</code> — or with
  <code>retryAfterSeconds</code> on the exception. The transport honours both,
  and <code>RateLimitError.retryAfterSeconds</code> carries the same number for
  a caller doing its own backoff.
</p>
<p>
  Nothing is retried that a retry cannot fix: a validation, authentication,
  not-found, or conflict failure throws on the first attempt.
</p>
''',
      ),
      DocsSection(
        id: 'types',
        title: 'Types',
        html:
            '''
<p>
  All ${api.models.length} models and ${api.enums.length} enums the API sends
  are exported from the package root, generated from the same contract as the
  resources, so a type used in a parameter position is the type the server
  deserialises. The full field lists are on the
  <a href="/docs/api/models">models</a> and
  <a href="/docs/api/enums">enums</a> pages.
</p>
${code('''
import type { Product, Batch, AlertStatus, ApiScope } from 'fauxshield';
import { AlertStatus as AlertStatusValues } from 'fauxshield';

// A union for typing, and a const object of the same name for the values:
const open: AlertStatus = AlertStatusValues.open; // 'open'

async function load(id: string): Promise<Product> {
  return client.product.get({ productId: id });
}
''', lang: DocsLang.ts)}
${paramTable(const <DocsParam>[
              DocsParam(name: 'Enums', type: 'union + const', defaultValue: 'AlertStatus is both a string union and a const object with the same values'),
              DocsParam(name: 'Dates', type: 'string', defaultValue: 'DateTime parameters and fields are ISO 8601 strings, as the API sends them'),
              DocsParam(name: 'Ids', type: 'string', defaultValue: 'UuidValue is a string; every id the API returns is a UUID'),
              DocsParam(name: 'Nullable', type: 'T | null', defaultValue: 'a field the server may not have filled in; absent on the wire, null in the type'),
              DocsParam(name: 'Optional', type: 'field?', defaultValue: 'a parameter you may omit; the server applies its documented default'),
              DocsParam(name: 'Exception bodies', type: '*ExceptionBody', defaultValue: 'the JSON shape of each refusal, if you parse bodies yourself'),
            ], empty: '')}
''',
      ),
      DocsSection(
        id: 'testing',
        title: 'Testing',
        html:
            '''
<p>
  Two seams, both first class: a <code>fetch</code> implementation answers
  without a socket, and a <code>Transport</code> replaces the HTTP layer
  entirely. The SDK's own suite uses them, so they cannot rot.
</p>
${code('''
import assert from 'node:assert/strict';
import test from 'node:test';
import { FauxShieldClient, NotFoundError } from 'fauxshield';

const answering = (status: number, body: unknown) => async () =>
  new Response(JSON.stringify(body), { status });

test('a missing product raises NotFoundError', async () => {
  const client = new FauxShieldClient({
    apiKey: 'fs_live_test',
    environment: {},                       // ignore the real environment
    maxRetries: 0,
    fetch: answering(400, {
      className: 'NotFoundException',
      data: { message: 'No product with that id.' },
    }),
  });

  await assert.rejects(
    () => client.product.get({ productId: '00000000-0000-0000-0000-000000000000' }),
    NotFoundError,
  );
});

// Or replace the transport wholesale:
const stubbed = new FauxShieldClient({ apiKey: 'fs_live_test' }, {
  call: async (endpoint, method, params) => [{ id: '…', name: 'Coffee' }],
});
''', lang: DocsLang.ts)}
${code('''
cd fauxshield_node
npm test        # builds, then runs node --test over test/**/*.test.mjs
''', lang: DocsLang.bash)}
<p>
  Each of the $totalMethods methods is one
  <code>transport.call(endpoint, method, params)</code> with the parameters
  passed through unchanged, so a stub can assert on the exact endpoint,
  method, and parameter names a call produced.
</p>
''',
      ),
      DocsSection(
        id: 'workflows',
        title: 'Where to go next',
        html: '''
<ul class="docs-link-cards">
  <li><a href="/docs/getting-started/first-request"><strong>Serialise a product</strong><span>Create a product, a batch, and 500 units.</span></a></li>
  <li><a href="/docs/guides/verify-a-product"><strong>Verify a product</strong><span>The public consumer flow from the API side.</span></a></li>
  <li><a href="/docs/guides/webhooks"><strong>Webhooks</strong><span>Signed deliveries, retries, and redelivery.</span></a></li>
  <li><a href="/docs/guides/offline-scans"><strong>Offline scans</strong><span>Queue in the field, ingest when back online.</span></a></li>
  <li><a href="/docs/guides/error-handling"><strong>Error handling</strong><span>Which failures to retry, and how to recover.</span></a></li>
  <li><a href="/docs/sdk/parity"><strong>Feature parity</strong><span>The same methods in Dart and Python.</span></a></li>
</ul>
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
        'typed errors, no dependencies, and the exact signature of every '
        'method.',
    group: 'sdk',
    sections: <DocsSection>[
      DocsSection(
        id: 'install',
        title: 'Install',
        html:
            '''
<p>
  Python 3.9 or newer. The SDK talks to the API with
  <code>urllib</code> from the standard library, so installing it pulls in
  nothing else — no <code>requests</code>, no <code>httpx</code>, no transitive
  dependency tree to audit.
</p>
${code('''
pip install fauxshield-sdk
''', lang: DocsLang.bash)}
${code('''
from fauxshield import FauxShieldClient
''', lang: DocsLang.python)}
<p>
  The package name on PyPI is <code>fauxshield-sdk</code>; the import name is
  <code>fauxshield</code>. Version <code>0.1.0</code>, MIT licensed.
</p>
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
  Every parameter is keyword-only, named in snake_case, and mapped onto the
  API's camelCase on the wire — <code>include_archived</code> becomes
  <code>includeArchived</code> without the caller caring. Results are plain
  <code>dict</code>s and <code>list</code>s exactly as the API sent them, so
  they pickle, log, and feed straight into a JSON response of your own.
</p>
${callout('note', 'Keyword-only on purpose', '<p>Every generated method starts its signature with <code>*</code>, so a call like <code>client.product.get(product_id)</code> is a <code>TypeError</code> rather than a silently swapped argument.</p>')}
''',
      ),
      DocsSection(
        id: 'configuration',
        title: 'Configuration',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'api_key', type: 'str | None', defaultValue: 'falls back to FAUXSHIELD_API_KEY; an fs_live_ key or a session JWT'),
              DocsParam(name: 'base_url', type: 'str | None', defaultValue: 'falls back to FAUXSHIELD_URL, then ${SiteChrome.hostedApiUrl}'),
              DocsParam(name: 'timeout', type: 'float', defaultValue: '30.0 seconds; must be positive'),
              DocsParam(name: 'max_retries', type: 'int', defaultValue: '2, so a call is attempted at most 3 times; 0 disables retries'),
              DocsParam(name: 'transport', type: 'Transport | None', defaultValue: 'the default HTTP transport; pass your own in tests'),
              DocsParam(name: 'environment', type: 'Mapping[str, str] | None', defaultValue: 'os.environ; pass a dict in tests so they do not read the real environment'),
            ], empty: '')}
${tabs(name: 'python-config', samples: <(String, String)>[
              (
                'Production',
                '''
# The hosted API is the default; only the key is needed.
client = FauxShieldClient(api_key=os.environ["FAUXSHIELD_API_KEY"])
assert client.base_url == "${SiteChrome.hostedApiUrl}"
''',
              ),
              (
                'Localhost',
                '''
client = FauxShieldClient(
    api_key=os.environ["FAUXSHIELD_API_KEY"],
    base_url="${SiteChrome.localApiUrl}",
)
# Or once, for every script: export FAUXSHIELD_URL=${SiteChrome.localApiUrl}
''',
              ),
              (
                'Tests',
                '''
class FakeTransport:
    def call(self, endpoint, method, params):
        assert (endpoint, method) == ("product", "list")
        return [{"id": "…", "name": "Coffee"}]

client = FauxShieldClient(
    api_key="fs_live_test",
    environment={},          # no real environment is read
    max_retries=0,           # fail fast, do not back off
    transport=FakeTransport(),
)
''',
              ),
            ])}
<p>
  Invalid configuration raises <code>FauxShieldConfigError</code> from the
  constructor, before any request: a URL that is not http(s), a query string or
  fragment on <code>base_url</code>, a non-positive <code>timeout</code>, or a
  negative <code>max_retries</code>. Messages run through
  <code>redact()</code>, which masks <code>fs_live_</code> keys and JWTs so a
  mistyped URL cannot leak a credential into a log.
</p>
${callout('warning', 'A custom base_url always wins', '<p>Explicit <code>base_url</code> beats <code>FAUXSHIELD_URL</code>, which beats the built-in default. The default is the hosted API, never localhost.</p>')}
''',
      ),
      ..._sdkResourceSections(api, 'python'),
      DocsSection(
        id: 'errors',
        title: 'Errors',
        html:
            '''
<p>
  Everything raised derives from <code>FauxShieldError</code>, so one
  <code>except</code> catches all API failures and the subclass says which one
  it was. A typed refusal arrives as HTTP <code>400</code> carrying the
  exception as the body, so the mapping reads <code>className</code> first and
  falls back to the status code only when the body names nothing.
</p>
${paramTable(const <DocsParam>[
              DocsParam(name: 'AuthenticationError', type: 'code: authentication', defaultValue: 'missing, expired, or under-scoped credential; 401/403'),
              DocsParam(name: 'NotFoundError', type: 'code: not_found', defaultValue: 'no such resource, or not visible to this credential'),
              DocsParam(name: 'ValidationError', type: 'code: validation', defaultValue: 'arguments rejected; error.field names the offender'),
              DocsParam(name: 'ConflictError', type: 'code: conflict', defaultValue: 'the change conflicts with current state, e.g. a duplicate SKU'),
              DocsParam(name: 'RateLimitError', type: 'code: rate_limit', defaultValue: 'over the key\'s limit; error.retry_after says how long'),
              DocsParam(name: 'ServiceUnavailableError', type: 'code: service_unavailable', defaultValue: 'a dependency is down or unset; 502/503/504'),
              DocsParam(name: 'VerificationError', type: 'code: verification', defaultValue: 'the consumer flow refused: wrong PIN, locked unit, expired session'),
              DocsParam(name: 'ApiError', type: 'code: api_error', defaultValue: 'anything else the server answered with, including 500'),
              DocsParam(name: 'ConnectionError', type: 'code: connection', defaultValue: 'the request never reached the API: DNS, TLS, socket'),
              DocsParam(name: 'TimeoutError', type: 'code: timeout', defaultValue: 'the request ran past timeout'),
              DocsParam(name: 'FauxShieldConfigError', type: 'extends Exception', defaultValue: 'unusable configuration, thrown by the constructor — not a FauxShieldError'),
            ], empty: '')}
<p>
  Each error carries <code>status</code>, <code>field</code>,
  <code>retry_after</code>, <code>request</code> (for example
  <code>product.list</code>), and the raw <code>body</code>.
  <code>to_dict()</code> returns a plain dictionary for logs and deliberately
  leaves the body out.
</p>
${code('''
from fauxshield import (
    FauxShieldClient,
    FauxShieldError,
    NotFoundError,
    RateLimitError,
    ValidationError,
)

try:
    client.identity.lock(identity_id=unit_id, reason="cloned code")
except NotFoundError:
    pass                      # no such unit, or another workspace
except ValidationError as error:
    print("rejected field:", error.field)
except RateLimitError as error:
    time.sleep(error.retry_after or 1)
except FauxShieldError as error:
    log.error(error.to_dict())   # safe to log: no body, no credentials
    raise
''', lang: DocsLang.python)}
<p>
  The full list, with the HTTP status each one arrives with and what to do
  about it, is in <a href="/docs/reference/errors">error codes</a>.
</p>
''',
      ),
      DocsSection(
        id: 'reliability',
        title: 'Timeouts, retries, and rate limits',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'Timeout', type: 'per attempt', required: true, defaultValue: 'timeout (30.0s default), enforced by urlopen'),
              DocsParam(name: 'Retried', type: 'failure', required: true, defaultValue: 'connection, timeout, 429, 502/503/504, and 500 — and nothing else'),
              DocsParam(name: 'Attempts', type: 'count', required: true, defaultValue: 'max_retries + 1, so 3 by default and 1 with max_retries=0'),
              DocsParam(name: 'Delay', type: 'backoff', required: true, defaultValue: 'retry_after capped at 30s when the server sent one, else exponential from 200ms capped at 4s'),
            ], empty: '')}
${callout('warning', 'Retrying a write can duplicate work', '''<p>The transport retries by status, and it cannot tell a read from a write. For bulk writes, pass an <code>idempotency_key</code> — <code>batch.generate_identities</code> takes one and replays the first result instead of minting twice — or set <code>max_retries=0</code> and decide yourself. Read methods and single-row writes are safe to let the transport retry.</p>''')}
${code('''
from fauxshield import FauxShieldError, is_retryable

def call_with_policy(fn, attempts=3):
    for attempt in range(attempts):
        try:
            return fn()
        except FauxShieldError as error:
            if not is_retryable(error) or attempt == attempts - 1:
                raise
            time.sleep(error.retry_after or 0.2 * (2 ** attempt))
''', lang: DocsLang.python)}
<p>
  <code>is_retryable</code> is the same predicate the transport uses, exported
  so an application that wraps calls applies the identical policy.
</p>
''',
      ),
      DocsSection(
        id: 'testing',
        title: 'Testing',
        html:
            '''
<p>
  A <code>Transport</code> is any object with a
  <code>call(endpoint, method, params)</code> method, so a test double is three
  lines and needs no network, no mocking library, and no monkeypatching:
</p>
${code('''
import unittest

from fauxshield import FauxShieldClient, NotFoundError


class ProductTest(unittest.TestCase):
    def test_missing_product_raises(self):
        class Refusing:
            def call(self, endpoint, method, params):
                raise NotFoundError(
                    "No product with that id.",
                    status=400,
                    request="product.get",
                )

        client = FauxShieldClient(
            api_key="fs_live_test", environment={}, transport=Refusing()
        )
        with self.assertRaises(NotFoundError):
            client.product.get(product_id="00000000-0000-0000-0000-000000000000")


class Recording:
    """Assert on the exact endpoint, method, and params a call produced."""

    def __init__(self):
        self.calls = []

    def call(self, endpoint, method, params):
        self.calls.append((endpoint, method, params))
        return []
''', lang: DocsLang.python)}
${code('''
cd fauxshield_python
PYTHONPATH=src python -m unittest discover -s tests
''', lang: DocsLang.bash)}
<p>
  Each of the ${api.methodCount} methods is one
  <code>transport.call(endpoint, method, params)</code> with the parameters
  mapped onto the API's camelCase, so a recording transport asserts on the
  exact wire shape without a server.
</p>
''',
      ),
    ],
  );
}
