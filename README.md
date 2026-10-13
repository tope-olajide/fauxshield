# FauxShield — anti-counterfeit command center

Every physical unit a brand makes gets a signed QR code and a packaging PIN. A
shopper scans the pack and gets an authoritative verdict in seconds — no app
install, no account, no special hardware. Behind that answer the brand gets
something a printed code has never given them: unit-level identity, live fraud
intelligence, evidence attached to every suspicious event, and a way to act on
it. One server does all of it — the API, the streaming channel, the background
jobs, the database, and the web pages — built end to end on **Serverpod 4** and
**Flutter**.

**[Live platform](https://fauxshield.serverpod.space/)**
· [consumer verification](https://fauxshield.serverpod.space/verify)
· [operator app](https://fauxshield.serverpod.space/app)
· [developer documentation](https://fauxshield.serverpod.space/docs)
· API `https://fauxshield.api.serverpod.space`

### Three things to try in two minutes

1. **Open the command center.**
   [/app](https://fauxshield.serverpod.space/app) → create an account →
   **Open demo workspace**. You land in a complete brand: products, batches,
   serialized units, a recall, consumer reports, a populated fraud queue, and
   two attack investigations already in progress.
2. **Verify a pack like a shopper.**
   Open **Verify a product** in the app and press **Demo unit** (or take a
   token and packaging PIN from any unit in the catalogue). That is the real
   pipeline: token resolution, device binding, a row-locked PIN check, a
   verdict, and a fraud evaluation. The identical flow is public at
   [/verify](https://fauxshield.serverpod.space/verify) for a pack in a
   shopper's hand — no account, no app.
3. **Run an attack and watch it land.**
   **More → Simulations → Clone attack**, then open **Live**. Scans stream in,
   the fraud engine fires, and an alert opens with its evidence, risk score,
   and map. Nothing is scripted for the demo: the simulation goes through the
   same verification and fraud code path as a real scan.

## The problem

Counterfeiting is not a branding inconvenience. It kills people, it destroys
livelihoods, and it scales because nothing in a physical supply chain can
currently prove that one specific pack is genuine.

- **1 in 10 medical products** in low- and middle-income countries is
  substandard or falsified. A fake antimalarial is not a wasted purchase: it is
  an untreated infection, a preventable death, and one more contribution to
  antimicrobial resistance. The same holds for vaccines and for the antibiotics
  people take instead of seeing a doctor.
- **30–60% of seeds and pesticides** in some regions are reported counterfeit.
  For a smallholder, one fake bag of seed erases an entire season of income —
  and the forgery is indistinguishable at the point of sale, when the decision
  is actually made.
- **40% of products** in some African markets are estimated to be counterfeit
  or substandard, across cosmetics, food, drinks, electronics, and auto parts
  where a fake can mean a chemical burn, a fire, or a crash.
- **$500B+** is lost every year to counterfeiting and piracy. Brands absorb
  lost revenue and the reputational cost of fakes wearing their name; consumers
  absorb the harm with no way to check anything.

**The missing layer is evidence at the unit level.** Regulators and regional
programmes — NAFDAC in Nigeria, the Lomé Initiative, INTERPOL's pharmaceutical
operations — act on seizures, and they act well, but a seizure is a snapshot
after the fact. Enforcement cannot see which factory run a suspected pack came
from, whether the same code was scanned in two countries last night, or whether
a recalled batch is still being verified. Brands cannot see it either.

The existing answers to that gap each stop too early:

| Approach | Where it breaks |
| --- | --- |
| **Static QR code** | Trivially copied. The fake pack resolves exactly like the real one, and the brand learns nothing. |
| **SMS verification** | A message per scan: expensive at millions of units, friction for the shopper, and no record left behind for the brand. |
| **Holograms, NFC tags, scanners** | Special materials or a device on every inspection, which prices out most manufacturers — and still produces no data. |

None of them connect a pack to its manufacturing batch, notice when a code
reappears somewhere impossible, or give a brand and a regulator a defensible
record of what happened. That is the gap FauxShield fills: **identity you can
prove, evidence you can act on.** The printed code is the entry point; the
product is the identity, the fraud intelligence, and the response behind it.

## What it does

### Serialize a brand's physical units
- **Products → batches → units.** Every unit gets a random 128-bit QR token, an
  HMAC-SHA256 signature over the token, and a unique 6-digit packaging PIN.
- PINs are stored as PBKDF2 hashes for verification and AES-GCM ciphertext for
  retrievable reveals — a PIN reveal is always written to the audit log.
- Idempotent generation: retried `generateIdentities` calls return the original
  result instead of duplicating 50,000 units.
- CSV/TSV export for print houses, operation-scoped API keys for machine access.

### Verify a unit like a consumer
- Public `/verify` page (no account) with token entry, PIN entry, verdict, and a
  "report this product" form.
- The Flutter app has the same flow built in for operators, including one-tap
  "demo unit" loading.
- Session replay protection: sessions are bound to a device fingerprint, expire
  on a sliding 15-minute window, and only an allow-listed presentation ever
  leaves the server.

### Catch fraud in real time
- The fraud engine evaluates six checks on every scan — clone detection (same
  token in distant places), velocity anomalies, PIN attacks, batch duplication,
  distributor leakage, and grey-market scans from restricted countries — inside
  a bounded time budget, against a per-workspace policy. Two more protections
  run in the write path: PIN lockout after repeated failures, and
  offline-backfill reconciliation. Eight in total, and the reason a *copy*
  becomes a detectable event instead of a free win.
- Alerts are deduplicated, scored, and auto-lock units when policy says so.
- Every event — scans, alerts, recalls, offline ingest, simulation progress — is
  published to a Serverpod **streaming** channel and appears in the operator
  app's live feed instantly.
- Signed webhooks (`t=…,v1=…` HMAC scheme) push the same events to customer
  systems, with retries, backoff, delivery inspection, and manual redelivery.

### Rehearse attacks
- Four scripted simulations — clone attack, PIN brute force, scan burst, grey
  market leak — run **through the real pipeline**. They produce real sessions,
  real signals, and real alerts, so the team can practise its response with the
  live feed open.
- Simulations can run inline, step by step, or paced over time as a background
  future call.

### Work offline
- Inspectors queue scans on device. Serverpod's **offline sync** mirrors synced
  rows, a recurring future call converts them into authoritative verification
  sessions, and verdicts are written back to the device rows.
- There is also a direct batch-ingest endpoint for devices that reconnect and
  want immediate verdicts.

### Run the command center
- Analytics dashboard with verification trends, outcome mix, top countries, alert
  counts, and a daily rollup job.
- Full team management (owner/admin/member/viewer roles with 22 permissions),
  invitations with one-time codes, audit log, notification preferences, webhook
  and API-key administration.
- A **one-click demo workspace** with real seeded data: brand, products, batches,
  240 serialized units, authentic verifications, a recall, consumer reports, and
  two simulations — so reviewers can explore every screen immediately.

---

## Architecture

```
┌──────────────────────────────┐     ┌─────────────────────────────────────┐
│  Flutter operator app        │     │  Serverpod server (Dart)            │
│  (web served at /app,        │     │                                     │
│   mobile & desktop)          │◄───►│  • 15 endpoint classes              │
│  • dashboard, live feed      │ JSON│  • verification pipeline            │
│  • alerts, catalog, scans    │ RPC │  • fraud engine → alerts → webhooks │
│  • simulations, team, audit  │     │  • streaming channel (live events)  │
└──────────────────────────────┘     │  • future calls: webhook drain,     │
                                     │    offline conversion, rollups,     │
┌──────────────────────────────┐     │    maintenance sweep                │
│  Consumer web (server-side   │     │  • web routes: landing, /verify     │
│  rendered, no account)       │◄───►│  • embedded PostgreSQL (dev)        │
│  • /verify?t=<token> + PIN   │     └─────────────────────────────────────┘
└──────────────────────────────┘
```

The server registers **17 routes**: the 15 endpoint classes in
`lib/src/endpoints/` plus the two that Serverpod's authentication module
contributes (`emailIdp`, `jwtRefresh`). The generated client, the SDKs, and the
API reference cover the 15 platform endpoints — the auth routes are Serverpod's
own, so they are documented by Serverpod.

## How Serverpod is used

This is not a Dart app with a database bolted on; the framework is doing the
work a smaller project would have hand-rolled. Each row names the Serverpod
capability, what FauxShield does with it, and where to read it.

| Serverpod capability | What FauxShield does with it | Where to look |
| --- | --- | --- |
| **Endpoints & the generated protocol** | 15 endpoint classes with typed parameters, typed exceptions, and an allow-listed presentation. Every client — the Flutter app, the Dart package, the Node.js and Python SDKs, the CLI, and the MCP server — is generated from the same definitions, so none of them can drift from the server. | `lib/src/endpoints/`, `fauxshield_client/` |
| **Models as the schema** | 84 `.spy.yaml` models and enums generate the server classes, the Dart client, the documentation reference, and the PostgreSQL schema. A model change produces one migration to review; nothing is maintained in two places. | `lib/src/models/`, `migrations/` |
| **Authentication** | Serverpod's email identity provider handles registration, verification codes, password resets, and refresh tokens. In development the code is printed to the console instead of emailed; in production it goes out through the Serverpod Cloud email service configured in `lib/server.dart`. Sessions are Serverpod JWTs; `@unauthenticatedClientCall` marks the consumer endpoints that must work without one. | `lib/server.dart`, `lib/src/endpoints/verification_endpoint.dart` |
| **Authorization over those sessions** | Callers are resolved to a workspace and one of four roles (22 permissions) inside the server on every call — never from the client. API keys are a second credential type with their own scopes and rate limits. | `lib/src/services/rbac.dart`, `api_key_service.dart` |
| **Streaming** | `watchWorkspace` opens a Serverpod method stream per workspace (`workspace:<id>`). Scans, signals, alerts, recalls, and simulation progress are pushed as they happen; the app reconnects automatically and falls back to polling if the socket dies. | `verification_endpoint.dart`, `fauxshield_flutter/lib/screens/live_feed_screen.dart` |
| **Future calls** | Four recurring jobs keep the system converging without a cron box: `webhook-drain` (30s), `offline-scan-converter` (45s), `daily-rollup` (15m), and `maintenance-sweep` (30m). A one-off future call also drives paced attack simulations step by step, which is how the demo shows an investigation unfolding over time. | `lib/src/future_calls/` |
| **Offline sync** | `OfflineScanRecord` is declared `database: sync`, so field devices converge through Serverpod's sync layer and the converter turns each synced row into a real, policy-evaluated verification session, writing the authoritative verdict back to the device row. | `lib/src/models/`, `lib/src/services/offline_ingest_service.dart` |
| **The database layer** | Row-locked transactions (`LockMode.forUpdate`) on PIN submission and unit minting so concurrent scans cannot double-count; `updateWhere`/`deleteWhere` for bulk operations; pagination and aggregates for the analytics rollups. | `lib/src/services/verification_service.dart`, `identity_service.dart` |
| **The web server** | The landing page, `/features`, `/pricing`, `/about`, the 42-page `/docs` portal, and the consumer `/verify` flow are server-rendered WidgetRoutes with Mustache templates, static assets, and cache-busted URLs — served by the same process as the API, with no second front end to deploy. | `lib/src/web/`, `web/templates/` |
| **Project structure & configuration** | The repository *is* a Serverpod workspace: server, generated client, Flutter app, migrations, and Dockerfile side by side, with per-environment config (`development`, `test`, `production`) and secret files that never enter Git history in production. | `pubspec.yaml`, `config/`, `Dockerfile` |
| **Testing** | The suite runs against `serverpod_test`'s session builder and an embedded PostgreSQL that Serverpod starts itself — no Docker, no external database, `dart test` and done. | `test/`, `config/test.yaml` |
| **Deployment** | Serverpod Cloud builds the server from this repository, provisions PostgreSQL, applies the migrations, and serves the API and the web pages under one URL. The same Dockerfile also runs anywhere. | `docs/DEPLOYMENT.md` |

Two consequences are worth calling out, because they are the reason the product
is as coherent as it is:

- **The API is the product.** The operator app, the consumer page, the CLI, the
  SDKs, and the MCP server all call the same endpoints, so nothing is reachable
  only through a user interface and nothing is reimplemented per client.
- **Domain logic lives in one place.** Endpoints validate, resolve the caller's
  workspace and permission, and delegate to services (`verification_service`,
  `fraud_engine`, `alert_service`, `recall`, `webhooks`, `demo_seeder`). That is
  why a simulation produces the same alerts as a real attack.

---

## Getting started

### Prerequisites
- Dart SDK 3.12.2+ (bundled with Flutter 3.32+; this repo was built with
  Flutter 3.47.6 / Dart 3.13.5)
- Flutter SDK (only needed to rebuild the app; a prebuilt web bundle lives in
  `fauxshield_server/web/app`)
- No Docker required — development uses Serverpod's embedded PostgreSQL.

### 1. Run the server

The recommended way to run the project is the Serverpod CLI, which boots the
embedded PostgreSQL, applies pending migrations, and watches for changes with
hot reload:

```bash
# from the repository root
cd fauxshield_server
serverpod start
```

Press `Q` to shut down. First startup creates the data directory under
`.serverpod/development/pgdata` and applies the migrations in the repository.

- API: http://localhost:8080
- Landing page, `/verify`, and the prebuilt operator app at `/app`:
  http://localhost:8082

Prefer a plain foreground run (CI, headless environments) instead?

```bash
cd fauxshield_server
dart pub get
dart run bin/main.dart --mode development --apply-migrations
```

`--apply-migrations` is only needed on the first run (or after a model change).
Secrets live in `config/passwords.yaml` (dev-only values checked in on purpose
for the hackathon; rotate them for any real deployment).

### 2. Open the operator app

Use the served build at http://localhost:8082/app, or run it with hot reload:

```bash
cd fauxshield_flutter
flutter pub get
flutter run -d chrome
# or: flutter run             # mobile / desktop targets
```

Create an account with any email + password, then choose **Open demo workspace**
on the onboarding screen. The demo seeds a complete brand (products, batches,
units, verifications, a recall, alerts, simulations) so every screen has data.

> **Where's my email verification code?** No email is sent in development.
> The code is written to the server console right after you sign up, as a line
> like `Registration code for you@brand.test: <a1b2c3d4>` — copy it into the
> app's verification step. Starting the server with the `serverpod` CLI shows
> the same line as a popup alert and copies the code to your clipboard.
> Password-reset codes work the same way. Real emails are only sent in
> `staging`/`production` run modes, through the Serverpod Cloud email service
> configured in `fauxshield_server/lib/server.dart`.

### 3. Try the consumer flow

In the app, open **Verify a product** and press **Demo unit** to load a signed
token from the demo workspace, then enter its packaging PIN. You get a real
verdict from the same code path a shopper hits. To see the shopper's own view,
take a unit's token and PIN from the catalogue, open
http://localhost:8082/verify?t=<token>, and enter the PIN there — then flip to
the app's live feed and watch the scan arrive.

### 4. Rebuild the web app (optional)

```bash
cd fauxshield_flutter
flutter build web --release --base-href /app/
cp -r build/web/. ../fauxshield_server/web/app/
```

> Note: the workspace pins a one-line patched copy of `sqlite_async` under
> `third_party/` so `dart2js` can compile the client-side database dependency.
> See `third_party/sqlite_async/README_GUARD.md`.

### 5. Use the command line client

`fauxshield_cli` is a plain Dart console package over the same JSON-RPC API, so
it needs no Flutter runtime and no browser. It is the third client of the same
server, alongside the operator app and the consumer web flow.

```bash
dart pub global activate fauxshield_cli

fauxshield auth login --email you@brand.test --password '<your password>'
fauxshield auth whoami
fauxshield products list
fauxshield batches list
fauxshield identities list --page-size 10
fauxshield alerts list --severity critical
fauxshield alerts show --alert <uuid>

# Run the consumer flow without a browser
fauxshield verify --token <token> --pin <pin>
```

Command groups: `auth`, `workspace`, `products`, `batches`, `identities`,
`alerts`, `verifications`, `recalls`, `simulations`, `analytics`, `audit`,
`team`, `keys`, `webhooks`, `notifications`, `offline`, `demo`, and `verify` —
the whole API, not just the read paths.
Every command takes `--json` for scripting. Automation should sign in with an
API key, which carries its own scopes and rate limit:

```bash
fauxshield keys create --label ci --scopes productsRead,batchesRead,analyticsRead
fauxshield auth login --api-key fs_live_...      # or export FAUXSHIELD_API_KEY
```

Minting a key is a session operation, and a few operations are reserved for a
signed-in person rather than a key — revealing PINs, changing workspace
settings, running simulations, and managing keys. Everything else runs happily
off a scoped key.

`FAUXSHIELD_URL`, `FAUXSHIELD_API_KEY`, `FAUXSHIELD_TOKEN`, and
`FAUXSHIELD_PASSWORD` override the stored config, so it runs unattended in CI.
`fauxshield --help` lists everything, and
[`fauxshield_cli/README.md`](fauxshield_cli/README.md) documents each group.

### 6. Use it from an AI agent

`fauxshield_mcp` exposes the same API as Model Context Protocol tools, so an
agent (Claude Desktop, Cursor, or anything else that speaks MCP) can read the
fraud queue, pull evidence, and — with a key that has write scopes — work
alerts and recalls, always attributed in the audit log.

```bash
dart pub global activate fauxshield_mcp
```

```json
{
  "mcpServers": {
    "fauxshield": {
      "command": "fauxshield-mcp",
      "env": {
        "FAUXSHIELD_URL": "https://fauxshield.api.serverpod.space",
        "FAUXSHIELD_API_KEY": "fs_live_...",
        "FAUXSHIELD_READ_ONLY": "true"
      }
    }
  }
}
```

The tool surface and the client snippets are documented in
[`fauxshield_mcp/README.md`](fauxshield_mcp/README.md).

---

## Tests

```bash
cd fauxshield_server
dart test
```

Covers the core crypto (HMAC, PBKDF2, AES-GCM), the verification pipeline
(outcomes, replay protection, PIN lockout), the fraud pipeline (clone/PIN/offline
signals and alert evidence), recalls, API key authentication, the product
recycle bin, product image storage, and the demo seeder — 70 tests, all green.

The clients are tested on their own terms, because they are what operators and
agents actually drive the API with:

```bash
cd fauxshield_cli && dart test    # 13 tests: version parity, exit codes, API key
cd fauxshield_mcp && dart test    # 26 tests: config, tool surface, read-only guard, stdio handshake
```

The Flutter app is analyzed clean with `flutter analyze`, and every package
(`fauxshield_server`, `fauxshield_cli`, `fauxshield_mcp`, `fauxshield_client`)
is analyzed clean with `dart analyze`. CI runs all of it on every push:
`.github/workflows/tests.yml`, and pushing a version tag publishes the SDKs to
PyPI and npm from `.github/workflows/release-python.yml` and
`.github/workflows/release-npm.yml`. The three Dart packages are on pub.dev
(`fauxshield_client`, `fauxshield_cli`, `fauxshield_mcp`), published with
`dart pub publish`.

---

## Deploy to Serverpod Cloud

The repository is deployment-ready: Dockerfile, production config, prebuilt
Flutter web bundle, and migration files are all in `fauxshield_server/`.

```bash
# 1. Install/auth with the Serverpod Cloud CLI (from the repository root)
serverpod cloud auth login

# 2. Link this server to a new cloud project and deploy
cd fauxshield_server
serverpod cloud launch          # follow the prompts; creates Postgres + URLs

# 3. Later deploys
serverpod cloud deploy

# 4. Provide the app secrets (values from config/passwords.yaml)
serverpod cloud password set hmacSecretKey
serverpod cloud password set pinEncryptionKey
serverpod cloud password set webhookEncryptionKey
serverpod cloud password set demoSeedSecret

# 5. Useful commands
serverpod cloud status
serverpod cloud log
```

Serverpod Cloud builds the server from this repository, provisions PostgreSQL,
applies the migrations, and serves the same three entry points (landing,
`/verify`, `/app`). See `docs/DEPLOYMENT.md` for details and a pre-flight
checklist.

---

## Developer platform

The same server hosts the developer documentation at `/docs`: 42 pages with a
persistent sidebar, full-text search, an API reference generated from the
machine-readable contract in `fauxshield_contract/`, SDK pages for Dart, Node.js,
and Python, a CLI reference, an MCP reference, and task guides. Every endpoint,
model, and enum page is generated, so the reference cannot describe an API the
server does not have — CI fails when it is out of date.

Clients published against the same API:

| Client | Install | Default API |
| --- | --- | --- |
| Dart ([`fauxshield_client`](https://pub.dev/packages/fauxshield_client)) | `dart pub add fauxshield_client` | host supplied by the caller; the app reads it from `config.json` |
| Node.js ([`fauxshield`](https://www.npmjs.com/package/fauxshield)) | `npm install fauxshield` | `https://fauxshield.api.serverpod.space` |
| Python ([`fauxshield-sdk`](https://pypi.org/project/fauxshield-sdk/)) | `pip install fauxshield-sdk` | `https://fauxshield.api.serverpod.space` |
| CLI ([`fauxshield_cli`](https://pub.dev/packages/fauxshield_cli)) | `dart pub global activate fauxshield_cli` | `https://fauxshield.api.serverpod.space` |
| MCP ([`fauxshield_mcp`](https://pub.dev/packages/fauxshield_mcp)) | `dart pub global activate fauxshield_mcp` | `https://fauxshield.api.serverpod.space` |

`python tools/check_parity.py` compares all of them against the contract and
reports the coverage — currently 86 of 86 methods, 76 of 76 models and enums —
and fails if any client stops defaulting to the hosted API.

See `docs/DEVELOPER_PLATFORM.md` for the audit, the architecture decision, the
verification results, and what still needs authorization.

### Entry points

| Entry point | What it is | URL (local dev) |
| --- | --- | --- |
| Landing page | Live platform stats + demo product code | http://localhost:8082/ |
| Features | What each module does, in detail | http://localhost:8082/features |
| Pricing | The three supported deployment options | http://localhost:8082/pricing |
| About | Why it exists and how it was built | http://localhost:8082/about |
| Documentation | Developer portal: setup, concepts, generated API reference, SDK, CLI, and MCP guides | http://localhost:8082/docs |
| Consumer verification | Scan → PIN → verdict, with product reports | http://localhost:8082/verify |
| Operator app | Flutter web command center (also runs on mobile/desktop) | http://localhost:8082/app |
| Command line | Products, batches, units, and alerts from a terminal | `fauxshield` (step 5) |
| API + Insights | Serverpod JSON-RPC API and Insights | http://localhost:8080 · :8081 |

Every public page — the landing page, features, pricing, about, and the
documentation — offers a single **Dashboard** action that opens `/app`, rather
than a sign in / sign up pair: the operator app already routes a visitor without
a session to its own sign in screen. The consumer `/verify` page has its own
header and offers no operator path, so a shopper scanning a pack never gets an
invitation to sign in.

---

## Repository layout

The repository root is the Dart workspace: the Serverpod server, the generated
client, and the Flutter app sit side by side.

```
fauxshield/                      # repository root
├── fauxshield_server/          # Serverpod 4 server (the product)
│   ├── lib/
│   │   ├── server.dart         # boot: auth, web routes, recurring tasks
│   │   └── src/
│   │       ├── models/         # 84 .spy.yaml models
│   │       ├── core/           # crypto, constants, geo, webhook signing
│   │       ├── services/       # verification, fraud, alerts, recall, demo…
│   │       ├── endpoints/      # 15 endpoint classes
│   │       ├── future_calls/   # recurring background jobs
│   │       └── web/            # landing, docs, and consumer verification pages
│   ├── web/                    # templates, css, prebuilt Flutter app
│   ├── migrations/             # database migrations
│   └── test/                   # unit + integration tests
├── fauxshield_flutter/         # Flutter operator command center
│   └── lib/
│       ├── screens/            # dashboard, live feed, alerts, catalog…
│       ├── app/                # theme + workspace state
│       ├── widgets/ utils/     # shared UI
│       └── main.dart
├── fauxshield_cli/             # Dart console client for operators and scripts
│   ├── bin/fauxshield.dart     # entry point
│   ├── lib/src/commands/       # one file per command group
│   └── README.md               # install, credentials, every command
├── fauxshield_mcp/             # MCP server so an agent can drive the API
│   ├── bin/fauxshield_mcp.dart # stdio entry point
│   ├── lib/src/tools/          # catalog, operations, response tools
│   └── README.md               # client setup and the tool surface
├── fauxshield_client/          # generated Dart client (do not edit)
├── third_party/sqlite_async/   # one-line patch for web builds (see README)
├── docs/                       # deployment guide + demo script
├── .github/workflows/          # CI: analyze, format, tests, npm + PyPI releases
└── AGENTS.md                   # notes for AI agents working in this repo
```

---

## License

MIT — see [LICENSE](LICENSE).
