# FauxShield — anti-counterfeit command center

**Build Something Real: The Serverpod Hackathon** — full-stack Flutter + Serverpod 4.

FauxShield lets a brand serialize every physical unit it makes with a signed QR
code and a packaging PIN, verify those units from a public consumer page, catch
clones and grey-market leakage with a live fraud engine, recall batches, and run
field inspections that work offline. Everything runs on Serverpod: the API, the
streaming channel, the background jobs, the database, and even the web pages
that consumers and operators open.

| Entry point | What it is | URL (local dev) |
| --- | --- | --- |
| Landing page | Live platform stats + demo product code | http://localhost:8082/ |
| Consumer verification | Scan → PIN → verdict, with product reports | http://localhost:8082/verify |
| Operator app | Flutter web command center (also runs on mobile/desktop) | http://localhost:8082/app |
| API + Insights | Serverpod JSON-RPC API and Insights | http://localhost:8080 · :8081 |

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

```bash
# from the repository root
cd fauxshield_server
dart pub get
dart run bin/main.dart --mode development --apply-migrations
```

- API: http://localhost:8080
- Landing page, `/verify`, and the prebuilt operator app at `/app`:
  http://localhost:8082

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

---

## Tests

```bash
cd fauxshield_server
dart test
```

Covers the core crypto (HMAC, PBKDF2, AES-GCM), the verification pipeline
(outcomes, replay protection, PIN lockout), the fraud pipeline (clone/PIN/offline
signals and alert evidence), recalls, and the demo seeder — 24 tests, all green.
The Flutter app is analyzed clean with `flutter analyze`.

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
├── fauxshield_client/          # generated Dart client (do not edit)
├── third_party/sqlite_async/   # one-line patch for web builds (see README)
├── docs/                       # deployment guide + demo script
├── .github/workflows/          # CI: analyze, format, tests
└── AGENTS.md                   # notes for AI agents working in this repo
```

---

## AI disclosure

This project was built with **Codebuff / Freebuff**, an AI coding agent, as the
primary development tool, following the hackathon's disclosure requirement. The
agent wrote the server, the Flutter app, the web pages, migrations, and tests
under human direction, with every change reviewed and verified locally
(`dart analyze`, `flutter analyze`, `dart test`, end-to-end runs in Chrome).

## License

MIT — see [LICENSE](LICENSE).
