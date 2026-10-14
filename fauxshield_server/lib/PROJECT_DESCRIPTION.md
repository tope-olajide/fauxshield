# FauxShield — anti-counterfeit platform

FauxShield is an anti-counterfeit platform. A brand serializes products with
signed QR codes and printed packaging PINs, consumers verify those codes from a
public web page, and brand operators work a live fraud command center that spots
bad traffic, issues recalls, rehearses attacks, ingests offline field scans, and
publishes webhook deliveries against an audit log.

The project is a Flutter operator app backed by a Serverpod server, with the
same API surface exposed to consumers through server-rendered web pages and to
automation through typed SDKs in Dart, Python, and Node. The operator app, the
CLI, the MCP server, and the SDKs all speak one API: the generated
`fauxshield_client` package.

## What the app does

A brand works in a workspace. Inside a workspace it:

- **Creates a product catalog** — name, SKU, category, description, packaging,
  shelf life, safety instructions, country restrictions, and up to five
  product images. Products can be archived or soft-deleted into a recycle bin
  and restored before purge, so operators can recover mistakes without losing
  the batches and serialized units still attached to the product.
- **Creates batches** — a batch is a production lot: reference code, manufacture
  and expiry dates, distribution region, quantity, and status.
- **Serializes units** — for each batch the server generates signed
  `product_identity` rows. Each identity gets a long random secret, a derived
  9-digit packaging PIN, a QR token, a violation token, and the validity window
  the unit is usable in. Those secrets are what PBKDF2 checks against during
  consumer verification, and what the fraud engine fingerprints when it looks
  for clones and duplicate scans.
- **Verifies codes** — from the public `/verify` page or the operator app,
  someone scans or types a QR token. The server resolves the token, prompts for
  the packaging PIN, checks it through a row-locked transaction against a PBKDF2
  derivation, locks the unit after repeated failures, and returns a consumer
  presentation that only exposes what the brand configured.
- **Watches fraud** — every verification runs through `FraudEngine.evaluate`,
  which checks velocity, PIN-attack patterns, batch duplication, clone geography,
  grey-market location drift, and recalled-unit usage. Alerts are deduped in a
  sliding window, auto-locked when the policy says so, and published live to the
  command center and to webhook endpoints. Each alert carries its signal list so
  operators see why it fired.
- **Recalls** — an operator can recall a whole batch or a single identity. While
  the recall is active, the verification flow reports the product as recalled
  instead of authentic. Recalls are announced through live events, in-app
  notifications, and webhooks.
- **Rehearses attacks** — simulations run synthetic clone attacks, PIN brute
  force, scan bursts, and grey-market leaks through the real fraud pipeline, so
  the command center can rehearse response without waiting for real traffic.
- **Ingests offline scans** — field inspectors capture scans in places with no
  connectivity. Those scans are queued on-device and converted when connectivity
  returns, either by direct upload or by Serverpod's offline sync. The converter
  runs the same fraud evaluation, alerting, and live-event pipeline as an online
  scan, and writes the verdict back to the synced row.
- **Integrates downstream** — webhook endpoints can subscribe to events such as
  `fraudAlertCreated` and `recallIssued`. Deliveries are retried on a schedule,
  recorded for inspection, and testable from the admin endpoint. API keys with
  scoped permissions and per-key rate limits give machine accounts safe access.
- **Audits everything** — workspace-scoped audit events record who did what,
  and a notification center carries unread counts and preferences.

## How Serverpod is used

Serverpod is the whole backend. The server package is
`fauxshield_server`, and `lib/server.dart` is where the pod is assembled.

### Server assembly and auth

`lib/server.dart` is the entry point. It defines the `FauxShieldServer` podlet,
registers the data sources the app depends on (a `public` storage volume for
product images and durable uploads, and an analytics `rollup` data source), and
wires up authentication. Authentication is built in through Serverpod's auth
module: the server uses `DefaultAuthenticationHandler`, and the auth endpoint
surface — session login, logout, token refresh — comes from the Serverpod auth
package rather than being hand-written in FauxShield. API-key authentication is
the same mechanism for machine clients: a presented key is hashed and looked up,
its last-used time is updated, and a per-key sliding-window rate limit is
enforced in memory.

### Endpoints: the 18-server surface

Serverpod endpoints are the callable operations. FauxShield exposes them under
`lib/src/endpoints/`. The operational surface includes:

- `verification_endpoint` — `start`, `acknowledge`, `submitPin`, `result`, `list`,
  `get`, and `reportFake`. This endpoint is the public verification API. It is
  the only part of the API consumers reach directly.
- `identity_endpoint` — create identities for a batch, list and get identities,
  reveal the packaging PIN to an operator, lock and unlock identities, regenerate
  the QR token, export, and delete/restore.
- `batch_endpoint` — create batches, generate identities for a batch, list, get,
  and batch stats.
- `product_endpoint` — create, update, archive, soft-delete/restore, purge,
  list with search and archived filters, get one, and upload an image. Image
  upload is base64 via the endpoint because Flutter web cannot post multipart,
  and the bytes are validated by magic-byte sniffing with a 2 MB cap before being
  written to durable storage, not the podlet disk.
- `alert_endpoint` — list, get, assign, update status, attach evidence, and read
  the triage and signal reports.
- `recall_endpoint` — list recalls, recall a batch or identity, and lift a recall.
- `simulation_endpoint` — start, list, get, step, run-to-completion, and cancel
  simulations.
- `workspace_endpoint` — create and update workspaces, invite members, accept
  invitations, change roles, list members, and remove members.
- `demo_endpoint` — seed and reset a disposable demo workspace. Only callers with
  the `demoSeedSecret` password can reset it.
- `offline_endpoint` — convert pending synced offline scan rows.
- `webhook_admin_endpoint` — create, list, update, delete, test, rotate secret,
  inspect deliveries, and drain the outbox.
- `api_key_endpoint` — create, list, and revoke API keys.
- `analytic_endpoint` — dashboard rollup and on-demand rollup.
- `notification_endpoint` — list, mark read, mark all read, and update preferences.
- `audit_endpoint` — query audit events.

### Domain services

The heavy logic lives in `lib/src/services/`, not in the endpoints. The endpoints
are thin auth-and-routing wrappers; the services own the rules.

- `verification_service` — the core of consumer verification. `resolveToken`
  locates the identity behind a QR token, `acknowledge` moves the session to
  the PIN prompt, `submitPin` is a row-locked transaction that derives the
  expected PIN through PBKDF2, compares it, locks after repeated failures, and
  records the result. `presentation()` is what consumers actually see: it
  allow-lists the fields returned so the public page never leaks a secret, a PIN,
  or internal state.
- `fraud_engine` — `FraudEngine.evaluate` runs the six checks (velocity, PIN
  attack, batch duplication, clone geography, grey-market location drift, and
  recalled-unit usage) and returns the signal assessments and aggregated risk
  score. The policy that tunes those thresholds is the `FraudPolicy` model.
- `fraud_rules` — shared logic that turns raw signals into assessments.
- `identity_crypto` — key generation and PBKDF2 derivation for the packaging PINs
  and API keys. Secrets are hashed before storage, so the database never holds a
  plaintext PIN secret or API key.
- `rbac` — role-based access control. Workspaces have owners, admins, members,
  and viewers; `WorkspaceService.require` enforces the permission a call needs
  before it runs.
- `workspace_service` — resolves which workspace a call belongs to, enforces
  membership, and provides the context every other service uses.
- `alert_service` — dedupes alerts in a sliding window, auto-locks when the policy
  says so, publishes live events, and enqueues webhook deliveries. This is the
  glue between fraud detection and the command center.
- `webhook_service` — serializes event payloads, schedules retries, records
  deliveries, and drains the outbox. Each delivery is retried on a schedule and
  inspectable from the admin endpoint.
- `offline_ingest_service` — converts queued field scans into authoritative
  verification sessions. Two paths funnel through one converter: a direct upload
  from the inspector app and the recurring Serverpod offline-sync conversion.
  Both claim rows with a row lock so a race cannot double-process a scan, run the
  real fraud pipeline, and write the verdict back to the synced row. A scan older
  than the backfill threshold emits an `offlineBackfill` signal so operators can
  see that the scan was recorded offline for a while before it reached the server.
- `demo_seeder` — builds the public demo workspace, “Aurelia Foods.” It creates
  products, batches, real cryptographic identities, authentic consumer
  verifications using audited PIN reveals, a real recall, fake consumer reports,
  and inline attack simulations that flow through the real fraud pipeline. The
  seeder is what makes `serverpod start` boot into a workspace that already looks
  like a brand mid-incident. The seed order is load-bearing: children are deleted
  before parents, and the sync table is deleted with raw SQL because the generated
  `deleteWhere` for a `database: sync` table needs a device node it does not have
  during a server-side reset.
- `idempotency_service` — Postgres-backed idempotency for create-style calls.
  The first request executes and its response is stored; replays return the stored
  response; concurrent duplicates get a typed conflict. The key is composed from
  workspace + operation + client key, the request payload is hashed so a reused key
  with a different body is rejected, and failed attempts are cleaned up so a retry
  is safe. This is what makes identity generation, recalls, and webhook test
  deliveries safe to retry from flaky field connections.
- `api_key_service` — creates scoped API keys whose secrets are stored only as
  SHA-256 hashes, enforces per-key rate limits in a sliding window, and revokes
  immediately.
- `recall_service` — issues and lifts recalls on batches or identities.
- `simulation_service` — runs simulations as scheduled steps through the fraud
  pipeline, with inline execution when the delay is zero.
- `audit_service` — records workspace-scoped audit events.
- `analytics_service` — maintains the daily rollup so the dashboard has a series.
- `notification_service` — creates and updates in-app notifications and preferences.

### Data model

The schema is defined in Serverpod `.spy.yaml` model files under
`lib/src/models/`. The models cover products, batches, product identities,
verification sessions, fraud alerts and signal records, recalls, fake consumer
reports, attack simulations, offline scan records, webhook endpoints and
deliveries, API keys, workspaces and members, invitations, notifications, audit
events, analytics rollups, and the idempotency record. The models with a `table:`
go into the database; the ones used only for API shapes stay as serializable
objects. The generated Dart classes under `lib/src/generated/` are rewritten by
the code generator from these models and from the endpoints, so hand-written code
never touches them. The `fraud_policy.spy.yaml` / `fraud_policy.dart` model is the
concrete example of a policy object that tunes the fraud engine.

### Future calls and recurring work

Beyond endpoint calls, the server has recurring work under
`lib/src/future_calls/`. The simulation runner and the offline/analytics
maintenance jobs are the main examples: they run on a schedule and do not arrive
as a single HTTP request.

### Consumer web: server-rendered routes

The public face is server-rendered by routes in `lib/src/web/routes/` and widgets
in `lib/src/web/widgets/`. The landing page lives at `/` and the verification
flow lives at `/verify`. The verify route is the consumer entry point: it renders
the page, accepts the QR token or code, drives the verification session through
the same `VerificationService` the API uses, and only shows the consumer what
`presentation()` allows. The rest of the marketing site — features, about, docs,
pricing — is server-rendered too, through `marketing_routes.dart` and the docs
site under `lib/src/web/docs/`. Product images served by the storage layer are
published as absolute URLs so the web page and the Flutter app see the same
asset.

### Storage and durability

Product images are written to the `public` cloud storage volume registered in
`server.dart`, not to the podlet's own disk. That is what makes an uploaded image
survive a deploy, a restart, and a second instance. Locally the storage backs to
the database, and in production it is a Serverpod Cloud bucket. This is exactly
why the image-upload endpoint refuses to write under `web/static`.

### Config

The server is configured per environment through `config/*.yaml`:
`development.yaml`, `test.yaml`, and `production.yaml`. The test config points
`database.dataPath` at an embedded PostgreSQL, so the test suite runs with no
Docker and the project's `docker-compose.yaml` is not used for tests.

## How Flutter is used

Flutter is the operator command center. The app lives in
`fauxshield_flutter`.

### Bootstrap and client

`lib/main.dart` boots the app. `lib/client.dart` is the app's single
`FauxShieldClient` wrapper: it points the generated Dart client at the server,
wraps token refresh, and queues writes when the device is offline. The app does
not talk to the server through hand-written HTTP; it uses the same generated
`fauxshield_client` package the CLI and the MCP server use. That is the “one wire
format” the README keeps emphasizing.

### Auth and shell

The operator app signs in with the Serverpod auth module. After sign-in, the app
renders through `lib/app/app_state.dart` and `lib/screens/home_shell.dart`, which
is the authenticated shell that holds the main navigation: dashboard, verifications,
alerts, catalog, the scan/button entry points, the recycle bin, and the “more”
screen for workspace, settings, team, API keys, notifications, and the demo entry.

### Command center screens

- **Dashboard** — `lib/screens/dashboard_screen.dart` shows the workspace summary,
  open alerts, recent verifications, and the analytics rollup the server
  maintains.
- **Live feed** — `lib/screens/live_feed_screen.dart` renders the live command
  center stream from `client.verification.watchWorkspace()`. The stream carries
  verifications, alerts, recalls, offline ingest, and simulation progress, so the
  operator sees fraud activity as it happens instead of polling.
- **Scan entry** — `lib/screens/scan_screen.dart` is the operator-side scan flow.
  It can scan a code or enter it by hand, drive the verification session, and show
  the result. The identity QR dialog (`lib/widgets/identity_qr_dialog.dart`) is
  where operators reveal and work with an identity's tokens and packaging PIN.
- **Catalog and product editor** — the catalog screen lists products and the
  product editor screen creates and updates them, including image upload through
  the endpoint.
- **Alerts** — `lib/screens/alerts_screen.dart` lists fraud alerts; the alert
  detail screen shows the signals, evidence, and triage state.
- **Verifications** — `lib/screens/verifications_screen.dart` lists recent
  verification sessions.
- **Recycle bin and more** — `lib/screens/recycle_bin_screen.dart` and
  `lib/screens/more_screen.dart` cover soft-deleted products and workspace/settings
  concerns.

### Offline field scans on the device

The Flutter app keeps local copies of the tables Serverpod's offline sync mirrors,
described in `lib/src/protocol/sync_tables.dart` of the client package. Field scans
survive a lost connection and reconcile when the device is back online. That is the
Flutter side of the offline-ingest story: the server converts the synced rows, and
the app sees the authoritative verdict written back.

### Styling and utilities

The app has a theme in `lib/app/app_theme.dart`, shared widgets in
`lib/widgets/common.dart`, and helper utilities for device fingerprinting
(`lib/utils/device_fingerprint.dart`), formatting, request recovery, and product
images. The device fingerprint is what ties a verification to a device across the
fraud signals.

### Deployment to the web app path

When the Flutter app changes, the project rebuilds it with
`flutter build web --release --base-href /app/` and copies the result into
`fauxshield_server/web/app/`. That is how the operator app becomes the `/app`
page served by the server.

## Consumer web and public pages

Consumers never log in. The public flow is:

- `/` — the landing page, server-rendered.
- `/verify` — the verification page. A consumer enters or scans a QR token, is
  prompted for the packaging PIN, and sees the brand's configured message on a
  genuine unit or a refusal on a bad one.

The consumer route uses the same `VerificationService` as the API endpoint, so the
public page and the operator app are verified by identical logic. The public page is
deliberately restricted to what `presentation()` returns: no secrets, no PINs, no
internal session state.

## SDKs and other clients

The API is not only for the Flutter app.

- **Dart/Flutter client** — `fauxshield_client`. Generated package with one typed
  endpoint class per server endpoint and one model per API shape. The operator app,
  the CLI, and the MCP server all depend on it. Auth is through
  `BearerTokenProvider` for either an API key or a session token. The consumer flow
  is reachable without a credential; everything else needs one.
- **Python SDK** — `fauxshield-sdk` on PyPI, standard-library only, with one
  attribute per endpoint, keyword-only arguments, generated typed dicts, full error
  classes, retries with exponential backoff and `Retry-After` respect, and a
  transport seam for tests.
- **Node SDK** — `fauxshield-node`, generated from the same contract so the Node
  surface matches the others.
- **CLI** — `fauxshield_cli` gives terminal access to products, batches, identities,
  alerts, verification, auth, and the demo flow.
- **MCP server** — `fauxshield_mcp` exposes the same operations as MCP tools, so an
  AI agent can drive the command center through the same API the app uses.

All of them are generated or contract-driven from the same shared API contract, so
there is exactly one description of the wire format.

## How the pieces fit together

A consumer scan hits `/verify`, which calls `VerificationService.resolveToken` and
then `submitPin` inside a row-locked transaction. `submitPin` derives the expected
PIN with PBKDF2, compares it, locks after failures, and records the result.
`presentation()` then decides what the consumer sees.

Every verification session then flows through `FraudEngine.evaluate`, which runs the
six checks and returns signal assessments and a risk score. If fraud is suspected,
`AlertService` dedups the alert in a sliding window, auto-locks the unit when the
policy says so, publishes a live event, and enqueues webhook deliveries. The live
event is what the Flutter command center renders through
`client.verification.watchWorkspace()`.

An operator can respond by locking or unlocking the identity, revealing the PIN to
inspect it, or recalling a batch or identity through `RecallService`. A recall
changes the consumer outcome to “recalled” and is announced through live events,
notifications, and webhooks.

Field inspectors capture scans offline. When the device returns to connectivity, the
`OfflineIngestService` converts the queued scans, either by direct upload or by the
recurring Serverpod offline-sync task. Both paths claim scanned rows with a row lock,
run the same fraud pipeline, and write the verdict back to the synced row so the
inspector sees the authoritative result.

Attacks can be rehearsed with `SimulationService`, which steps synthetic attacks
through the real fraud pipeline and emits the same alerts the command center would
see in production. The demo seeder builds a workspace that already contains this
kind of activity, so `serverpod start` boots into a believable incident.

Machine access and automation go through scoped API keys with per-key rate limits,
idempotency on create-style calls, and the webhook outbox that retries deliveries and
records them. Everything that happens is written to the audit log.

## Testability

The server package is tested with `dart test` and needs no Docker because the test
config uses an embedded PostgreSQL. The suite includes integration tests that exercise
the real pipelines end to end:

- `verification_pipeline_test.dart` — the consumer verification flow through the
  API and the public route, including PIN handling, lockout, and presentation.
- `fraud_pipeline_test.dart` — the fraud engine checks, alert deduping, auto-lock,
  live events, and webhook enqueueing.
- `recall_and_demo_test.dart` — recalls and the demo seeder/reset flow.
- `product_image_storage_test.dart` and `product_recycle_bin_test.dart` — image
  upload durability and product lifecycle.

The CLI has its own tests, and the generated client package is covered from the
server side: the server's suite exercises every endpoint through this client, so the
generated SDK does not need its own independent endpoint tests to be confident it
matches the server.

## Why it is complete and functional

- **One backend, one data model, one generated client.** Serverpod generates the
  models and the endpoint classes from the `.spy.yaml` models and the endpoint files,
  so the server, the Dart client, and anything else generated from the contract stay
  in sync by construction.
- **Auth is real and built in.** The server uses Serverpod's auth module in
  `lib/server.dart`, so sign-in, session refresh, API-key auth, and role-based
  permissions are not simulated.
- **The public flow is real.** The `/verify` route and the verification endpoint both
  go through the same `VerificationService`, with PBKDF2 PIN checks, row-locked
  transactions, lockout, and a consumer presentation that only exposes what the brand
  configured.
- **The fraud story is real.** The fraud engine, alert deduping, auto-lock, live
  events, webhook delivery, and recalls are all implemented services, not stubs, and
  they are covered by integration tests.
- **Offline is real.** Field scans are queued on-device, synced through Serverpod's
  offline sync, and converted by a service that claims rows with a row lock, runs the
  same fraud pipeline, and writes the verdict back.
- **The demo boots usable.** The demo seeder builds a workspace with real
  cryptographic identities, authentic verifications, a real recall, fake reports, and
  inline simulations, so a fresh `serverpod start` is immediately a believable
  command center.
- **The operator app is real.** The Flutter app is a full command center with
  dashboard, live feed, scan, catalog, alerts, verifications, recycle bin, workspace
  and settings, offline sync, image upload, and a client wrapper that handles token
  refresh and the offline queue.
- **Multiple clients, one surface.** Dart, Python, Node, CLI, MCP, and the Flutter
  app all speak the same API through the generated client, and the same contract
  drives the Python and Node SDKs.

## What would make the docs stronger

The code and the running system are complete. The remaining doc gaps are mostly about
making the existing surface easier to trust and easier to run:

- **State clearly what is deployed versus local.** The hosted API URL,
  the MCP server's current run mode, and whether the consumer web pages are published
  are not stated in one place.
- **One run/verify checklist.** A short “clone, `serverpod start`, which URL is the
  app, which URL is verify, how to sign in or use the demo” would remove most of the
  ambiguity.
- **Package parity notes.** The Dart, Python, and Node SDKs are generated from the same
  contract, but that relationship and the release paths are easier to see if they are
  stated outright rather than inferred.
- **One-line architecture map.** A brief diagram-like description of
  consumer web → verification endpoint/service → fraud engine → alert/live event/webhook
  → command center would help a reader orient before diving into files.

Those are documentation improvements, not gaps in the application itself.
