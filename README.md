# FauxShield — anti-counterfeit command center


FauxShield lets a brand serialize every physical unit it makes with a signed QR
code and a packaging PIN, verify those units from a public consumer page, catch
clones and grey-market leakage with a live fraud engine, recall batches, and run
field inspections that work offline. Everything runs on Serverpod: the API, the
streaming channel, the background jobs, the database, and even the web pages
that consumers and operators open.

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

The marketing pages are server-rendered by Serverpod from Mustache templates in
`fauxshield_server/web/templates/` with shared chrome built in
`lib/src/web/widgets/site_chrome.dart`, and the design tokens in
`web/static/css/public.css` match the reference design system.

Every public page — the landing page, features, pricing, about, and the
documentation — offers a single **Dashboard** action that opens `/app`, rather
than a sign in / sign up pair: the operator app already routes a visitor without
a session to its own sign in screen. The consumer `/verify` page has its own
header and offers no operator path, so a shopper scanning a pack never gets an
invitation to sign in.

### Developer platform

The same server hosts the developer documentation at `/docs`: 42 pages with a
persistent sidebar, full-text search, an API reference generated from the
machine-readable contract in `fauxshield_contract/`, SDK pages for Dart, Node.js,
and Python, a CLI reference, an MCP reference, and task guides. Every endpoint,
model, and enum page is generated, so the reference cannot describe an API the
server does not have — CI fails when it is out of date.

Clients published against the same API:

| Client | Install | Default API |
| --- | --- | --- |
| Dart (`fauxshield_client`) | `dart pub add fauxshield_client` | host supplied by the caller; the app reads it from `config.json` |
| Node.js (`fauxshield`) | `npm install fauxshield` | `https://fauxshield.api.serverpod.space` |
| Python (`fauxshield-sdk`) | `pip install fauxshield-sdk` | `https://fauxshield.api.serverpod.space` |
| CLI (`fauxshield`) | `dart pub global activate --source path fauxshield_cli` | `https://fauxshield.api.serverpod.space` |
| MCP (`fauxshield_mcp`) | `dart run fauxshield_mcp:main` | `https://fauxshield.api.serverpod.space` |

`python tools/check_parity.py` compares all of them against the contract and
reports the coverage — currently 86 of 86 methods, 76 of 76 models and enums —
and fails if any client stops defaulting to the hosted API.

See `docs/DEVELOPER_PLATFORM.md` for the audit, the architecture decision, the
verification results, and what still needs authorization.

---

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
- A fraud engine evaluates every scan against **six signals**: clone detection
  (same token in distant places), velocity anomalies, PIN attacks, batch
  duplication, distributor leakage, and grey-market scans from restricted
  countries.
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
│   mobile & desktop)          │◄───►│  • 18 endpoints (auth + RBAC)       │
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

### Serverpod features used
- **Endpoints & models** — 18 endpoints, ~80 models generated from `.spy.yaml`,
  typed exceptions, sealed `ApiException` hierarchy.
- **Authentication** — Serverpod's email IDP with JWT and refresh tokens;
  unauthenticated consumer calls are marked `@unauthenticatedClientCall`.
- **Streaming** — `watchWorkspace` streams `LiveEvent`s over Serverpod's
  message channel (`workspace:<id>`), with automatic reconnection in the app.
- **Future calls** — `webhook-drain` (30s), `offline-scan-converter` (45s),
  `daily-rollup` (15m), `maintenance-sweep` (30m), plus one-off simulation steps.
- **Offline sync** — `OfflineScanRecord` is declared `database: sync` and
  processed by the converter so field devices converge automatically.
- **Database** — transactions with `LockMode.forUpdate` on PIN submission and
  identity generation, `updateWhere`/`deleteWhere`, pagination, and rollups.
- **Web server** — server-rendered landing and verification pages with
  cache-busted assets, served by the same Serverpod process.
- **Cloud** — deployment prep with the Serverpod Cloud CLI (`serverpod cloud`).

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

Open http://localhost:8082/, take the demo product code, then enter its
packaging PIN (both are shown on the landing page) on the `/verify` page. You
will get a real verdict, and if you flip to the app's live feed you can watch it
arrive.

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
# from the repository root
dart pub global activate --source path fauxshield_cli

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
dart pub global activate --source path fauxshield_mcp
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
recycle bin, product image storage, and the demo seeder — 40 tests, all green.

The clients are tested on their own terms, because they are what operators and
agents actually drive the API with:

```bash
cd fauxshield_cli && dart test    # 10 tests: version parity, exit codes, API key
cd fauxshield_mcp && dart test    # 21 tests: config, tool surface, read-only guard, stdio handshake
```

The Flutter app is analyzed clean with `flutter analyze`, and every package
(`fauxshield_server`, `fauxshield_cli`, `fauxshield_mcp`, `fauxshield_client`)
is analyzed clean with `dart analyze`. CI runs all of it on every push:
`.github/workflows/tests.yml`, and pushing a version tag publishes the SDKs to
PyPI and npm from `.github/workflows/release-python.yml` and
`.github/workflows/release-npm.yml`.

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

## Repository layout

The repository root is the Dart workspace: the Serverpod server, the generated
client, and the Flutter app sit side by side.

```
fauxshield/                      # repository root
├── fauxshield_server/          # Serverpod 4 server (the product)
│   ├── lib/
│   │   ├── server.dart         # boot: auth, web routes, recurring tasks
│   │   └── src/
│   │       ├── models/         # ~80 .spy.yaml models
│   │       ├── core/           # crypto, constants, geo, webhook signing
│   │       ├── services/       # verification, fraud, alerts, recall, demo…
│   │       ├── endpoints/      # 18 endpoints
│   │       ├── future_calls/   # recurring background jobs
│   │       └── web/            # landing + consumer verification pages
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
