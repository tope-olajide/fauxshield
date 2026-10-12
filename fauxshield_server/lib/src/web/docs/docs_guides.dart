/// The written pages of the portal: overview, getting started, authentication,
/// and the task guides.
///
/// Everything here is checkable against the repository: the commands, the URLs,
/// the environment variables, and the flows are the ones the server, the CLI,
/// and the SDKs implement.
library;

import 'docs_model.dart';
import 'docs_render.dart';
import '../widgets/site_chrome.dart';

/// The documentation home page.
DocsPage overviewPage() {
  return DocsPage(
    slug: '',
    title: 'Developer platform',
    description:
        'FauxShield is anti-counterfeit infrastructure: serialize a product, '
        'verify it from a shopper\'s phone, and work the fraud that shows up '
        'afterwards.',
    group: 'overview',
    sections: <DocsSection>[
      DocsSection(
        id: 'what',
        title: 'What FauxShield does',
        html: '''
<p>
  A brand registers a product, manufactures a batch, and mints one signed
  identity per physical unit: a QR token printed on the pack plus a packaging
  PIN that is hidden under a scratch panel. A shopper scans the code, enters the
  PIN, and gets an answer — authentic, already verified, recalled, or a warning.
  Every scan is recorded, and the fraud engine reads those records: a token
  scanned in two countries, a serial range that leaked, a burst of wrong PINs
  are all signals, and signals become alerts an operator works.
</p>
<p>
  This is the developer side of that: the API, the SDKs, the CLI, and the MCP
  server. The operator app and the consumer verification page are built on the
  same twelve endpoints — nothing in the product is reachable only through the
  user interface.
</p>
''',
      ),
      DocsSection(
        id: 'start-here',
        title: 'Start here',
        html: '''
<ul class="docs-link-cards">
  <li><a href="/docs/quickstart"><strong>Quickstart</strong><span>Install an SDK and make your first call in five minutes.</span></a></li>
  <li><a href="/docs/api"><strong>API reference</strong><span>All 15 endpoints and 86 methods, with request examples.</span></a></li>
  <li><a href="/docs/sdk/node"><strong>Node.js SDK</strong><span>npm install fauxshield, typed resources, ESM.</span></a></li>
  <li><a href="/docs/sdk/python"><strong>Python SDK</strong><span>pip install fauxshield-sdk, keyword arguments, no dependencies.</span></a></li>
  <li><a href="/docs/sdk/dart"><strong>Dart SDK</strong><span>The generated client the app, the CLI, and the MCP server use.</span></a></li>
  <li><a href="/docs/cli"><strong>CLI</strong><span>Eighteen commands for the catalogue, the queue, and CI.</span></a></li>
  <li><a href="/docs/mcp"><strong>MCP server</strong><span>55 tools so an agent can work the queue.</span></a></li>
  <li><a href="/docs/guides/verify-a-product"><strong>Verify a product</strong><span>The consumer flow, end to end, with real calls.</span></a></li>
</ul>
''',
      ),
      DocsSection(
        id: 'integration-methods',
        title: 'Ways to integrate',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'HTTP', type: 'JSON-RPC', required: true, defaultValue: 'POST /{endpoint}/{method}; works from any language'),
              DocsParam(name: 'Dart', type: 'fauxshield_client', defaultValue: 'generated, typed, the client the product itself uses'),
              DocsParam(name: 'Node.js', type: 'fauxshield', defaultValue: 'ESM package with type definitions, Node 20+'),
              DocsParam(name: 'Python', type: 'fauxshield-sdk', defaultValue: 'Python 3.9+, no dependencies'),
              DocsParam(name: 'CLI', type: 'fauxshield', defaultValue: 'scripts, CI, and one-off operations'),
              DocsParam(name: 'MCP', type: 'fauxshield_mcp', defaultValue: 'AI agents, over stdio'),
            ], empty: '')}
<p>
  All of them talk to the same endpoints with the same credential rules, so a
  workflow can move between them without being rewritten.
</p>
''',
      ),
      DocsSection(
        id: 'health',
        title: 'Is it live?',
        html:
            '''
<p>
  The hosted deployment answers at
  <a href="${SiteChrome.hostedApiUrl}">${SiteChrome.hostedApiUrl}</a>. A public
  endpoint answers without a credential, so it is a safe thing to call when you
  are checking that your network reaches the API:
</p>
${code('''
curl -s -X POST ${SiteChrome.hostedApiUrl}/verification/start \\\\
  -H 'Content-Type: application/json' \\\\
  -d '{"token":"<a code from a pack>","deviceFingerprint":"my-laptop"}'
''', lang: DocsLang.bash)}
<p>
  A real code answers with the product and the batch behind it; an unknown code
  answers with a typed <code>VerificationException</code> — either way, the
  connection works.
</p>
''',
      ),
    ],
  );
}

/// Core concepts.
DocsPage conceptsPage() {
  return DocsPage(
    slug: 'overview/concepts',
    title: 'Core concepts',
    description:
        'Products, batches, identities, verification sessions, signals, alerts, '
        'recalls, and workspaces — and how they fit together.',
    group: 'overview',
    sections: <DocsSection>[
      DocsSection(
        id: 'chain',
        title: 'The chain from factory to shopper',
        html:
            '''
${code('''
product   one thing a brand sells: name, SKU, packaging copy, images
  └─ batch      one manufacturing run: reference, dates, region, quantity
       └─ identity (unit)   one physical item: signed QR token + packaging PIN
            └─ verification session   one shopper's scan, with its outcome
                 └─ signal     something the fraud engine noticed
                      └─ alert     work for an operator, deduplicated and assignable
''', lang: 'Model')}
<p>
  Recalls cut across the chain: a batch or a single unit can be recalled, and
  every later scan of it answers <code>recalled</code>.
</p>
''',
      ),
      DocsSection(
        id: 'identities',
        title: 'Identities are signed, not secret',
        html: '''
<p>
  A unit's QR token is a signed value, so the server can tell a token it issued
  from one that somebody made up, without keeping a lookup for every possible
  token. The packaging PIN is the part that cannot be guessed by looking at the
  code: it is stored as a PBKDF2 hash and checked in a row-locked transaction,
  and five wrong attempts lock the session. That split is why a photograph of
  someone's pack is not enough to clone it.
</p>
''',
      ),
      DocsSection(
        id: 'signals',
        title: 'Signals and alerts',
        html: '''
<p>
  The fraud engine runs six checks on each verification — clone detection,
  geographic impossibility, distributor leakage, velocity, recall compliance,
  and PIN brute force. A hit records a signal; signals that share a cause are
  deduplicated into one alert, so an operator sees one investigation rather than
  a thousand rows. Alerts carry a severity, a status, the evidence assembled
  from the underlying sessions, and can be assigned.
</p>
''',
      ),
      DocsSection(
        id: 'tenancy',
        title: 'Workspaces and roles',
        html: '''
<p>
  Everything lives inside a workspace: one brand's products, members, keys,
  alerts, and settings. A caller is always scoped to a workspace, either by the
  credential's own workspace or by an explicit <code>workspaceId</code> when
  that credential may see more than one. Roles decide what can be done:
  viewing, editing the catalogue, working alerts, administering the workspace,
  and reading audit or webhook data are separate permissions.
</p>
''',
      ),
    ],
  );
}

/// How the pieces are deployed.
DocsPage architecturePage() {
  return DocsPage(
    slug: 'overview/architecture',
    title: 'Architecture',
    description:
        'One Serverpod server serving the API, the landing and docs pages, the '
        'consumer verification page, and the Flutter web app.',
    group: 'overview',
    sections: <DocsSection>[
      DocsSection(
        id: 'deployment',
        title: 'One server, several front doors',
        html:
            '''
${code('''
                    ┌────────────────────────────────────────────┐
 shopper  ─────────▶│  /verify      consumer verification page   │
                    │  /            landing page, live stats      │
 operator ─────────▶│  /docs        this documentation            │
                    │  /app         operator app (Flutter web)    │
 agent    ─────────▶│  /app/assets/assets/config.json             │
                    │                                            │
                    │  /{endpoint}/{method}    JSON-RPC API       │
                    └───────────────┬────────────────────────────┘
                                    │
                    PostgreSQL ─────┴──── Redis (optional), webhooks,
                                          futures (rollups, drains, sweeps)
''', lang: 'Diagram')}
<p>
  The API, the public pages, the consumer flow, and the operator app are served
  by one Serverpod process, which is what makes the deployment small: one image,
  one database, one URL to know. The Flutter app is a prebuilt bundle served
  under <code>/app</code>, and it learns its API URL from
  <code>/app/assets/assets/config.json</code>, which the server generates from
  its own configuration.
</p>
''',
      ),
      DocsSection(
        id: 'layers',
        title: 'Inside the server',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'endpoints', type: 'lib/src/endpoints/', required: true, defaultValue: '15 endpoint classes: the wire surface'),
              DocsParam(name: 'services', type: 'lib/src/services/', defaultValue: 'the domain logic: verification, fraud engine, alerts, recalls, webhooks, RBAC'),
              DocsParam(name: 'models', type: 'lib/src/models/', defaultValue: 'about 80 typed models and enums; the database schema is generated from them'),
              DocsParam(name: 'web', type: 'lib/src/web/', defaultValue: 'the public pages and the consumer flow, server-rendered'),
              DocsParam(name: 'future_calls', type: 'lib/src/future_calls/', defaultValue: 'recurring work: webhook drain, offline conversion, rollups, maintenance'),
            ], empty: '')}
<p>
  An endpoint validates, resolves the caller's workspace and permission, and
  delegates. That is why the CLI, the MCP server, and the app cannot drift apart
  in behaviour: they all land in the same service methods.
</p>
''',
      ),
      DocsSection(
        id: 'realtime',
        title: 'Live events and offline work',
        html: '''
<p>
  A verification that turns into an alert is published on a workspace stream, so
  the command center updates without polling. Field devices that lose signal
  keep scanning: the app stores those scans locally and uploads them later
  through <code>offline.ingest</code>, and a recurring job converts them into
  ordinary sessions.
</p>
''',
      ),
    ],
  );
}

/// How to get a credential and make a first call.
DocsPage quickstartPage() {
  return DocsPage(
    slug: 'quickstart',
    title: 'Quickstart',
    description:
        'From nothing to a first API call: a credential, a URL, and one request '
        'in your language.',
    group: 'getting-started',
    sections: <DocsSection>[
      DocsSection(
        id: 'credential',
        title: '1. Get a credential',
        html:
            '''
<p>
  Two kinds work. A session is what a person uses; an API key is what a machine
  uses. Both are bearer tokens in the <code>Authorization</code> header.
</p>
${code('''
# In the operator app: sign in, open the workspace's API keys screen.
# From the CLI, with an account already created:
fauxshield keys create --name ci --scope read
''', lang: DocsLang.bash)}
<p>
  Either way you end up with a value to put in the environment:
</p>
${code('''
export FAUXSHIELD_API_KEY="fs_live_..."
''', lang: DocsLang.bash)}
''',
      ),
      DocsSection(
        id: 'call',
        title: '2. Make a call',
        html:
            '''
<p>
  The hosted API is the default in every SDK, so there is no URL to configure.
</p>
${tabs(name: 'quickstart', samples: <(String, String)>[
              (
                DocsLang.curl,
                '''
curl -s -X POST ${SiteChrome.hostedApiUrl}/product/list \\\\
  -H 'Content-Type: application/json' \\\\
  -H "Authorization: Bearer \$FAUXSHIELD_API_KEY" \\\\
  -d '{"includeArchived":false}'
''',
              ),
              (
                DocsLang.ts,
                '''
import { FauxShieldClient } from 'fauxshield';

const client = new FauxShieldClient({
  apiKey: process.env.FAUXSHIELD_API_KEY,
});
const products = await client.product.list({ includeArchived: false });
console.log(products.length);
''',
              ),
              (
                DocsLang.python,
                '''
import os
from fauxshield import FauxShieldClient

client = FauxShieldClient(api_key=os.environ["FAUXSHIELD_API_KEY"])
products = client.product.list(include_archived=False)
print(len(products))
''',
              ),
              (
                DocsLang.dart,
                '''
import 'package:fauxshield_client/fauxshield_client.dart';

final client = Client('${SiteChrome.hostedApiUrl}')
  ..authKeyProvider = BearerTokenProvider('fs_live_...');

final products = await client.product.list(includeArchived: false);
print(products.length);
''',
              ),
            ])}
''',
      ),
      DocsSection(
        id: 'next',
        title: '3. Go further',
        html: '''
<ul>
  <li><a href="/docs/getting-started/first-request">A real workflow</a>: create a product, a batch, and 500 units.</li>
  <li><a href="/docs/guides/verify-a-product">Verify a product</a>: the consumer flow from the API side.</li>
  <li><a href="/docs/guides/webhooks">Webhooks</a>: react to fraud without polling.</li>
  <li><a href="/docs/quickstart#local">Run it locally</a> and point an SDK at your own server.</li>
</ul>
''',
      ),
      DocsSection(
        id: 'local',
        title: 'Working against a local server',
        html:
            '''
<p>
  Everything above works against a server you started yourself; only the URL
  changes. An explicit value always wins over the built-in default.
</p>
${tabs(name: 'quickstart-local', samples: <(String, String)>[
              (
                DocsLang.ts,
                '''
const client = new FauxShieldClient({
  apiKey: process.env.FAUXSHIELD_API_KEY,
  baseUrl: '${SiteChrome.localApiUrl}',
});
''',
              ),
              (
                DocsLang.python,
                '''
client = FauxShieldClient(
    api_key=os.environ["FAUXSHIELD_API_KEY"],
    base_url="${SiteChrome.localApiUrl}",
)
''',
              ),
              (
                DocsLang.cli,
                '''
fauxshield --url ${SiteChrome.localApiUrl} products list
# or once, for every later command:
fauxshield --url ${SiteChrome.localApiUrl} auth login --email you@brand.test --password '...'
''',
              ),
            ])}
''',
      ),
    ],
  );
}

/// Working with API keys.
DocsPage apiKeysPage() {
  return DocsPage(
    slug: 'getting-started/api-keys',
    title: 'Credentials and API keys',
    description:
        'Where credentials come from, what scopes a key can carry, how they are '
        'rate limited, and how to rotate them.',
    group: 'getting-started',
    sections: <DocsSection>[
      DocsSection(
        id: 'kinds',
        title: 'Two kinds of credential',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'Session JWT', type: 'eyJ...', required: true, defaultValue: 'a person; issued by signing in, expires and refreshes'),
              DocsParam(name: 'API key', type: 'fs_live_...', defaultValue: 'a machine; issued per workspace, carries scopes, revoked explicitly'),
            ], empty: '')}
<p>
  Both go in the same header, and the server works out which one it has been
  given:
</p>
${code('''
Authorization: Bearer fs_live_...
''', lang: 'HTTP')}
''',
      ),
      DocsSection(
        id: 'scopes',
        title: 'Scopes',
        html: '''
<p>
  A key is issued with scopes, and every endpoint checks the scope its work
  needs before it does anything. A read-only key is a good default for
  dashboards and CI checks; scopes that write are added only where they are
  needed. A key that lacks a scope gets a refusal that names the reason
  (<code>forbidden</code>) rather than a confusing empty result.
</p>
''',
      ),
      DocsSection(
        id: 'limits',
        title: 'Rate limits',
        html: '''
<p>
  Limits are per key, so one noisy integration cannot exhaust another's budget.
  A refused request answers <code>429</code> with <code>Retry-After</code> (and
  the SDKs surface it as <code>retryAfterSeconds</code>), which is the signal to
  back off rather than to retry immediately.
</p>
''',
      ),
      DocsSection(
        id: 'rotate',
        title: 'Rotation and revoking',
        html:
            '''
${code('''
fauxshield keys list                 # names, scopes, and last use
fauxshield keys create --name ci --scope read
fauxshield keys revoke --key <uuid>  # immediate; the secret stops working
''', lang: DocsLang.cli)}
<p>
  A key's secret is shown once, when it is created. If it is lost, revoke the
  key and create another: there is no way to read it back, which is the point.
</p>
''',
      ),
    ],
  );
}

/// A first real workflow, in one language of the reader's choosing.
DocsPage firstRequestPage() {
  return DocsPage(
    slug: 'getting-started/first-request',
    title: 'Your first workflow',
    description:
        'Register a product, manufacture a batch, mint serialized units, and '
        'verify one of them — the whole chain in four calls.',
    group: 'getting-started',
    sections: <DocsSection>[
      DocsSection(
        id: 'chain',
        title: 'The four calls',
        html:
            '''
${tabs(name: 'workflow', samples: <(String, String)>[
              (
                DocsLang.ts,
                '''
import { FauxShieldClient } from 'fauxshield';

const client = new FauxShieldClient({ apiKey: process.env.FAUXSHIELD_API_KEY! });

const product = await client.product.create({
  name: 'Aurelia Olive Oil 1L',
  sku: 'AUR-OIL-1L',
});

const batch = await client.batch.create({
  productId: product.id!,
  reference: 'LOT-2026-04',
  manufactureDate: new Date().toISOString(),
  distributionRegion: 'NG',
  quantity: 500,
});

const units = await client.batch.generateIdentities({
  batchId: batch.id!,
  quantity: 500,
  idempotencyKey: 'lot-2026-04-500',
});

const stats = await client.batch.stats({ batchId: batch.id! });
console.log(units.generated, stats.verified);
''',
              ),
              (
                DocsLang.python,
                '''
from fauxshield import FauxShieldClient

client = FauxShieldClient(api_key=os.environ["FAUXSHIELD_API_KEY"])

product = client.product.create(name="Aurelia Olive Oil 1L", sku="AUR-OIL-1L")

batch = client.batch.create(
    product_id=product["id"],
    reference="LOT-2026-04",
    manufacture_date="2026-04-01T00:00:00Z",
    distribution_region="NG",
    quantity=500,
)

units = client.batch.generate_identities(
    batch_id=batch["id"],
    quantity=500,
    idempotency_key="lot-2026-04-500",
)

stats = client.batch.stats(batch_id=batch["id"])
print(units["generated"], stats["verified"])
''',
              ),
              (
                DocsLang.cli,
                '''
fauxshield products create --name 'Aurelia Olive Oil 1L' --sku AUR-OIL-1L
fauxshield batches create --product <uuid> --reference LOT-2026-04 \\
  --region NG --quantity 500
fauxshield identities generate --batch <uuid> --quantity 500
fauxshield batches stats --batch <uuid>
''',
              ),
            ])}
''',
      ),
      DocsSection(
        id: 'idempotency',
        title: 'Why the unit generation carries a key',
        html: '''
<p>
  Minting units writes thousands of rows. If the connection drops halfway, you
  want to repeat the call rather than guess how far it got, so
  <code>generateIdentities</code> takes an <code>idempotencyKey</code>: the same
  key returns the first result instead of minting twice. Use one key per
  intended operation — a batch reference and quantity is a natural choice — and
  a new key when you genuinely mean to mint more.
</p>
''',
      ),
      DocsSection(
        id: 'verify-one',
        title: 'Verify one of them',
        html:
            '''
<p>
  The units you just minted are real: a QR token and a packaging PIN each. The
  consumer flow is public, so you can run it from a terminal.
</p>
${code('''
# 1. Resolve a token
curl -s -X POST ${SiteChrome.hostedApiUrl}/verification/start \\\\
  -H 'Content-Type: application/json' \\\\
  -d '{"token":"<token from the export>","deviceFingerprint":"my-laptop"}'

# 2. Submit the PIN for the session that comes back
curl -s -X POST ${SiteChrome.hostedApiUrl}/verification/submitPin \\\\
  -H 'Content-Type: application/json' \\\\
  -d '{"sessionId":"<session uuid>","deviceFingerprint":"my-laptop","pin":"<pin>"}'
''', lang: DocsLang.bash)}
<p>
  Read <a href="/docs/guides/verify-a-product">Verify a product</a> for what
  each outcome means, including the ones the operator should look at.
</p>
''',
      ),
    ],
  );
}

/// Local development.
DocsPage localDevelopmentPage() {
  return DocsPage(
    slug: 'getting-started/local-development',
    title: 'Local development',
    description:
        'Run the server, the operator app, and the consumer page on your own '
        'machine, and point the SDKs at it.',
    group: 'getting-started',
    sections: <DocsSection>[
      DocsSection(
        id: 'server',
        title: 'Start the server',
        html:
            '''
${code('''
# One command starts the server and the Flutter app, applies migrations,
# watches for changes, and regenerates code.
serverpod start
''', lang: DocsLang.bash)}
<p>
  The server serves the API on <code>${SiteChrome.localApiUrl}</code>, the
  landing page and the consumer flow on port 8082, and the prebuilt operator app
  at <code>http://localhost:8082/app</code>. In development the email
  verification code for registration is written to the server log, so you do not
  need an email provider to create an account.
</p>
${paramTable(const <DocsParam>[
              DocsParam(name: '/', type: 'page', defaultValue: 'landing page with live counts and a demo code'),
              DocsParam(name: '/verify', type: 'page', defaultValue: 'the consumer flow, the same one a QR code points at'),
              DocsParam(name: '/app', type: 'app', defaultValue: 'the operator app'),
              DocsParam(name: '/docs', type: 'page', defaultValue: 'this documentation'),
              DocsParam(name: SiteChrome.localApiUrl, type: 'api', defaultValue: 'the JSON-RPC API'),
            ], empty: '')}
''',
      ),
      DocsSection(
        id: 'seed',
        title: 'A workspace with data in it',
        html:
            '''
${code('''
fauxshield --url ${SiteChrome.localApiUrl} demo reset --secret <demo seed secret>
''', lang: DocsLang.cli)}
<p>
  The demo workspace is disposable by design: it is reseeded rather than
  migrated, and it is the fastest way to have products, units, alerts, and a
  recall to work with. Only a caller with the seed secret can reset it.
</p>
''',
      ),
      DocsSection(
        id: 'talking-to-it',
        title: 'Pointing your code at it',
        html:
            '''
<p>
  The precedence is the same everywhere: an explicit base URL wins, then
  <code>FAUXSHIELD_URL</code>, then the hosted API. That last part matters —
  a checked-in example cannot accidentally talk to production.
</p>
${code('''
export FAUXSHIELD_URL=${SiteChrome.localApiUrl}
export FAUXSHIELD_API_KEY="<key from the local operator app>"
''', lang: DocsLang.bash)}
${callout('warning', 'Never a localhost default', '<p>No published SDK defaults to localhost. Examples in this documentation use the hosted URL; the local URL appears only where local development is the subject, as here.</p>')}
''',
      ),
    ],
  );
}

/// Authentication and configuration, in prose.
DocsPage authenticationPage() {
  return DocsPage(
    slug: 'authentication',
    title: 'Authentication',
    description:
        'How a caller proves who it is, how a workspace is chosen, and how to '
        'debug a refusal.',
    group: 'authentication',
    sections: <DocsSection>[
      DocsSection(
        id: 'model',
        title: 'The model',
        html:
            '''
<p>
  A request carries one bearer credential. The server tries an API key first
  (they are prefixed and easy to recognise) and hands anything else to the
  session handler, which validates the JWT. Behind that, every endpoint resolves
  a workspace and a permission before doing any work.
</p>
${paramTable(const <DocsParam>[
              DocsParam(name: 'Authorization', type: 'header', required: true, defaultValue: 'Bearer <session JWT or fs_live_ key>'),
              DocsParam(name: 'workspaceId', type: 'body field', defaultValue: 'explicit workspace, when the credential may see more than one'),
              DocsParam(name: 'X-Forwarded-For', type: 'header', defaultValue: 'trusted for the location of a scan, for fraud checks'),
            ], empty: '')}
''',
      ),
      DocsSection(
        id: 'sign-in',
        title: 'Signing in as a person',
        html:
            '''
<p>
  Email and password, through the same identity provider the app uses. The
  first sign-in on a fresh server asks for an email verification code; in
  development it is printed to the server log.
</p>
${code('''
fauxshield auth login --email you@brand.test --password '<your password>'
fauxshield auth whoami
fauxshield auth token     # for curl or another SDK
''', lang: DocsLang.bash)}
''',
      ),
      DocsSection(
        id: 'choose-workspace',
        title: 'Choosing a workspace',
        html:
            '''
<p>
  Most callers have exactly one workspace and never think about it: the
  credential decides. When a caller can reach more than one, the call says so
  explicitly:
</p>
${code('''
client.product.list(workspaceId: '...', includeArchived: false);
''', lang: DocsLang.dart)}
<p>
  The MCP server takes a single workspace at start-up, so an agent cannot be
  talked into reading another brand's data.
</p>
''',
      ),
      DocsSection(
        id: 'failures',
        title: 'When it goes wrong',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'notAuthenticated', type: 'reason', defaultValue: 'no credential, or an expired session: sign in again'),
              DocsParam(name: 'forbidden', type: 'reason', defaultValue: 'the credential is valid but lacks the scope or role for this call'),
              DocsParam(name: 'tokenNotFound', type: 'reason', defaultValue: 'a consumer scan of a code no brand registered'),
              DocsParam(name: 'tooManyAttempts', type: 'reason', defaultValue: 'five wrong PINs on one session; the session is locked'),
            ], empty: '')}
<p>
  Full detail, with the status each arrives with, is in
  <a href="/docs/reference/errors">error codes</a>.
</p>
''',
      ),
    ],
  );
}

/// The consumer verification flow, from the API side.
DocsPage verificationFlowPage() {
  return DocsPage(
    slug: 'guides/verify-a-product',
    title: 'The verification flow',
    description:
        'Three public calls, one shopper, and six possible outcomes — the exact '
        'sequence the consumer page and the mobile app run.',
    group: 'guides',
    sections: <DocsSection>[
      DocsSection(
        id: 'sequence',
        title: 'The sequence',
        html:
            '''
${code('''
GET  /verify?t=<token>            the page a QR code points at
  │
  ├─ verification.start           token + device fingerprint
  │     → the product, the batch, a session id, and what to show the shopper
  │
  ├─ verification.acknowledge     optional: the shopper saw the summary
  │
  ├─ verification.submitPin       the packaging PIN
  │     → authentic | alreadyVerified | invalidPin | highRisk |
  │       fraudSuspected | recalled
  │
  └─ verification.reportFake      optional: "this pack looks copied"
        → a consumer report, which an operator triages
''', lang: 'Diagram')}
<p>
  None of these three calls needs a credential: the people scanning a pack have
  no account, and asking them to make one is how a brand loses the scan. The
  token is the thing being checked, and the rate limiting, the device
  fingerprint, and the fraud checks are what keep the flow honest.
</p>
''',
      ),
      DocsSection(
        id: 'outcomes',
        title: 'What the outcomes mean',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'authentic', type: 'outcome', defaultValue: 'the code is genuine and this is its first verification'),
              DocsParam(name: 'alreadyVerified', type: 'outcome', defaultValue: 'genuine, but somebody scanned it before: a reseller, a gift, or a clone'),
              DocsParam(name: 'invalidPin', type: 'outcome', defaultValue: 'the PIN did not match; five of these lock the unit'),
              DocsParam(name: 'highRisk', type: 'outcome', defaultValue: 'the code checks out but the context is suspicious: geography, velocity'),
              DocsParam(name: 'fraudSuspected', type: 'outcome', defaultValue: 'the engine believes this unit is a copy or has leaked'),
              DocsParam(name: 'recalled', type: 'outcome', defaultValue: 'the batch or the unit was recalled; do not use the product'),
            ], empty: '')}
''',
      ),
      DocsSection(
        id: 'integration',
        title: 'Integrating it yourself',
        html:
            '''
<p>
  If you are building your own verification page, this is the whole
  implementation:
</p>
${tabs(name: 'verify', samples: <(String, String)>[
              (
                DocsLang.ts,
                '''
const started = await client.verification.start({
  token: scannedCode,
  deviceFingerprint,
});

// Show the product from `started`, then collect the PIN.
const result = await client.verification.submitPin({
  sessionId: started.sessionId,
  deviceFingerprint,
  pin: enteredPin,
});

if (result.outcome !== 'authentic') {
  // Every other outcome has something for the shopper to do.
}
''',
              ),
              (
                DocsLang.python,
                '''
started = client.verification.start(
    token=scanned_code,
    device_fingerprint=device_fingerprint,
)

result = client.verification.submit_pin(
    session_id=started["sessionId"],
    device_fingerprint=device_fingerprint,
    pin=entered_pin,
)
''',
              ),
              (
                DocsLang.curl,
                '''
curl -s -X POST ${SiteChrome.hostedApiUrl}/verification/start \\\\
  -H 'Content-Type: application/json' \\\\
  -d '{"token":"<token>","deviceFingerprint":"<device>"}'
''',
              ),
            ])}
<p>
  Answers are allow-listed before they leave the server: a verification
  presentation carries the product, the batch, and the brand's own copy, and
  never an internal id, another shopper's data, or a fraud signal detail that
  would help somebody probing for a real code.
</p>
''',
      ),
    ],
  );
}

/// Reacting to events instead of polling.
DocsPage webhooksGuidePage() {
  return DocsPage(
    slug: 'guides/webhooks',
    title: 'Webhooks',
    description:
        'Signed deliveries, retries with backoff, and the events worth waking a '
        'service up for.',
    group: 'guides',
    sections: <DocsSection>[
      DocsSection(
        id: 'create',
        title: 'Create an endpoint',
        html:
            '''
${code('''
fauxshield webhooks create --url https://ops.example.com/fauxshield \\
  --event fraudAlertCreated --event recallIssued
''', lang: DocsLang.cli)}
<p>
  The secret is returned once. Store it where your service can read it, and use
  it to verify every delivery.
</p>
''',
      ),
      DocsSection(
        id: 'verify',
        title: 'Verify a delivery',
        html:
            '''
<p>
  Each delivery is signed over the timestamp and the raw body, so a captured
  request cannot be replayed later. Compare in constant time, and treat a stale
  timestamp as a failure.
</p>
${code('''
X-FauxShield-Signature: t=1791296579,v1=6f3c...9ad2
X-FauxShield-Event: fraudAlertCreated

signature = hmac_sha256(secret, f"{t}.{raw_body}")
''', lang: 'HTTP')}
${callout('warning', 'Verify against the raw body', '<p>Parse after verifying, not before: re-serialising JSON changes the bytes and the signature stops matching.</p>')}
''',
      ),
      DocsSection(
        id: 'retries',
        title: 'Retries and inspection',
        html:
            '''
<p>
  A non-2xx answer, or a timeout, is a failed delivery. Failed deliveries are
  retried with backoff by a recurring job, and every attempt is recorded, so you
  can see exactly what happened instead of guessing.
</p>
${code('''
fauxshield webhooks deliveries --endpoint <uuid>
fauxshield webhooks redeliver --delivery <uuid>
fauxshield webhooks test --endpoint <uuid>
fauxshield webhooks drain          # attempt everything that is due now
''', lang: DocsLang.cli)}
<p>
  Endpoints on private or loopback addresses are rejected before anything is
  sent, so a webhook cannot be pointed at your internal network.
</p>
''',
      ),
    ],
  );
}

/// Capturing scans with no connection.
DocsPage offlineGuidePage() {
  return DocsPage(
    slug: 'guides/offline-scans',
    title: 'Offline scans',
    description:
        'Field devices keep verifying without signal, and the scans count once '
        'they are synced.',
    group: 'guides',
    sections: <DocsSection>[
      DocsSection(
        id: 'flow',
        title: 'How it works',
        html:
            '''
${code('''
device (no signal)          server
  scan ─▶ local queue   ──▶ offline.ingest      records accepted, with their own ids
                              │
                              └─ recurring job ─▶ verification session
                                                   (fraud checks run, alerts can raise)
''', lang: 'Diagram')}
<p>
  The device stores what it saw: the code, the PIN the operator entered, the
  time, and the location. On the next connection the queue is uploaded in one
  call, and the server converts each record into an ordinary verification
  session — which means the fraud engine sees them like any other scan instead
  of a special case.
</p>
''',
      ),
      DocsSection(
        id: 'ingest',
        title: 'Ingesting a batch of scans',
        html:
            '''
${code('''
curl -s -X POST ${SiteChrome.hostedApiUrl}/offline/ingest \\\\
  -H 'Content-Type: application/json' \\\\
  -H "Authorization: Bearer \$FAUXSHIELD_API_KEY" \\\\
  -d '{"scans":[{"code":"<token>","pin":"<pin>",
        "capturedAt":"2026-04-01T09:12:00Z","latitude":6.5,"longitude":3.4}]}'
''', lang: DocsLang.bash)}
${code('''
fauxshield offline records            # what is waiting
fauxshield offline convert            # convert now instead of waiting
''', lang: DocsLang.cli)}
''',
      ),
      DocsSection(
        id: 'semantics',
        title: 'What is deliberately different',
        html: '''
<p>
  A synced scan is recorded with the time it was captured, not the time it
  arrived, because that is when the shopper was standing in front of the pack.
  Duplicate uploads are ignored by record id, so a device that reconnects twice
  does not double-count a scan.
</p>
''',
      ),
    ],
  );
}

/// Handling failures.
DocsPage errorHandlingGuidePage() {
  return DocsPage(
    slug: 'guides/error-handling',
    title: 'Handling failures',
    description:
        'Which failures to retry, which to surface, and how to write a '
        'resilience policy that matches this API.',
    group: 'guides',
    sections: <DocsSection>[
      DocsSection(
        id: 'decide',
        title: 'Decide by meaning, not by status',
        html:
            '''
<p>
  A typed failure names itself in the body, so branch on that: validation,
  authentication, not-found and conflict failures are the caller's problem, and
  a retry will not fix them. Rate limits, unavailable dependencies, timeouts,
  and dropped connections are worth retrying with backoff.
</p>
${tabs(name: 'errors', samples: <(String, String)>[
              (
                DocsLang.ts,
                '''
import { FauxShieldError, RateLimitError, ValidationError } from 'fauxshield';

try {
  await client.product.create({ name, sku });
} catch (error) {
  if (error instanceof ValidationError) return { field: error.field };
  if (error instanceof RateLimitError) {
    await sleep(error.retryAfterSeconds! * 1000);
    return retry();
  }
  if (error instanceof FauxShieldError && error.code === 'service_unavailable') {
    return retry();
  }
  throw error;
}
''',
              ),
              (
                DocsLang.python,
                '''
from fauxshield import FauxShieldClient, RateLimitError, ValidationError, is_retryable

try:
    client.product.create(name=name, sku=sku)
except ValidationError as error:
    return {"field": error.field}
except RateLimitError as error:
    time.sleep(error.retry_after or 1)
    return retry()
except Exception as error:
    if is_retryable(error):
        return retry()
    raise
''',
              ),
            ])}
''',
      ),
      DocsSection(
        id: 'timeouts',
        title: 'Timeouts and long calls',
        html: '''
<p>
  Minting thousands of units takes time. Each SDK lets the timeout be raised,
  and the operator app sets 45 seconds for exactly this reason. Prefer a larger
  timeout over a blind retry for a call that writes a lot: the work may have
  started.
</p>
''',
      ),
      DocsSection(
        id: 'idempotency',
        title: 'Make retries safe',
        html: '''
<p>
  Where a call writes in bulk, pass an idempotency key. The server keeps the
  first result against that key, so repeating the call returns it instead of
  doing the work twice — which is what makes an automatic retry safe.
</p>
''',
      ),
    ],
  );
}

/// Testing a FauxShield integration.
DocsPage testingGuidePage() {
  return DocsPage(
    slug: 'guides/testing',
    title: 'Testing an integration',
    description:
        'Every SDK can be driven without a network, and the server suite is the '
        'reference for what the API does.',
    group: 'guides',
    sections: <DocsSection>[
      DocsSection(
        id: 'seams',
        title: 'The seams the SDKs give you',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'Node.js', type: 'fetch', defaultValue: 'pass a fetch implementation to the constructor'),
              DocsParam(name: 'Python', type: 'transport', defaultValue: 'pass an object with call(endpoint, method, params)'),
              DocsParam(name: 'Dart', type: 'Client', defaultValue: 'the generated client takes a host; wrap it in your own interface'),
              DocsParam(name: 'CLI', type: '--url', defaultValue: 'point it at a local server instead of production'),
            ], empty: '')}
''',
      ),
      DocsSection(
        id: 'example',
        title: 'A table-driven test',
        html:
            '''
${code('''
// node --test
import assert from 'node:assert/strict';
import test from 'node:test';
import { FauxShieldClient, NotFoundError } from 'fauxshield';

const answering = (status, body) => async () =>
  new Response(JSON.stringify(body), { status, headers: { 'content-type': 'application/json' } });

test('a missing product raises NotFoundError', async () => {
  const client = new FauxShieldClient({
    apiKey: 'fs_live_test',
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
''', lang: DocsLang.ts)}
''',
      ),
      DocsSection(
        id: 'server-side',
        title: 'Testing against a real server',
        html:
            '''
<p>
  A local server is the honest test: migrations, the fraud engine, and the
  consumer flow all run. The server's own suite starts an embedded PostgreSQL,
  so it needs no Docker.
</p>
${code('''
cd fauxshield_server && dart test
cd fauxshield_node && npm test
cd fauxshield_python && PYTHONPATH=src python -m unittest discover -s tests
''', lang: DocsLang.bash)}
''',
      ),
    ],
  );
}

/// Going to production.
DocsPage productionGuidePage() {
  return DocsPage(
    slug: 'guides/production',
    title: 'Going to production',
    description:
        'From a local server to a deployment: configuration, migrations, '
        'credentials, and the checks that tell you it worked.',
    group: 'guides',
    sections: <DocsSection>[
      DocsSection(
        id: 'checklist',
        title: 'Checklist',
        html:
            '''
${paramTable(const <DocsParam>[
              DocsParam(name: 'Deploy the server', type: 'step', required: true, defaultValue: 'one image, one database; Serverpod Cloud fills in the URLs'),
              DocsParam(name: 'Run migrations', type: 'step', required: true, defaultValue: 'the deploy applies them; never edit a model and skip this'),
              DocsParam(name: 'Set the public hosts', type: 'step', required: true, defaultValue: 'what /app/assets/assets/config.json tells the app to call'),
              DocsParam(name: 'Create a machine credential', type: 'step', required: true, defaultValue: 'an API key with the scopes the job needs'),
              DocsParam(name: 'Point your code at it', type: 'step', required: false, defaultValue: 'nothing to do: the hosted URL is the SDK default'),
              DocsParam(name: 'Watch with webhooks', type: 'step', required: false, defaultValue: 'deliveries and failures are recorded and retried'),
            ], empty: '')}
''',
      ),
      DocsSection(
        id: 'smoke',
        title: 'A smoke test after deploy',
        html:
            '''
${code('''
# 1. The web pages answer
curl -s -o /dev/null -w '%{http_code}\\\\n' ${SiteChrome.hostedApiUrl.replaceAll('api.', '')}/
curl -s -o /dev/null -w '%{http_code}\\\\n' "${SiteChrome.hostedApiUrl.replaceAll('api.', '')}/verify?t=unknown"

# 2. The app learns its API URL from the server, not from the bundle
curl -s -o /dev/null -w '%{http_code}\\\\n' ${SiteChrome.hostedApiUrl.replaceAll('api.', '')}/app/assets/assets/config.json

# 3. The public API answers with a typed refusal for an unknown code
curl -s -X POST ${SiteChrome.hostedApiUrl}/verification/start \\\\
  -H 'Content-Type: application/json' \\\\
  -d '{"token":"unknown","deviceFingerprint":"smoke-test"}'
''', lang: DocsLang.bash)}
''',
      ),
      DocsSection(
        id: 'notes',
        title: 'Notes that save time',
        html: '''
<ul>
  <li>The API URL a Flutter build calls comes from <code>config.json</code> on the server, so a rebuilt bundle does not need a rebuild to change environments.</li>
  <li>Migrations are applied by the deployment; a model change without a migration is a schema that does not exist.</li>
  <li>Webhooks are the cheapest early-warning system: a failed delivery is recorded, so an outage is visible rather than silent.</li>
</ul>
''',
      ),
    ],
  );
}
