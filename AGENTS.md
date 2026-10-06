# FauxShield — Flutter & Serverpod project

FauxShield is an anti-counterfeit platform: brands serialize products with signed QR codes and packaging PINs, consumers verify them from a public page, and operators work a live fraud command center (alerts, recalls, simulations, offline field scans, webhooks, audit log).

- Server package: `fauxshield_server` — 18 endpoints under `lib/src/endpoints/`, domain services under `lib/src/services/`, ~80 models under `lib/src/models/`, recurring future calls under `lib/src/future_calls/`.
- Flutter app: `fauxshield_flutter` — operator command center; the prebuilt web bundle is copied into `fauxshield_server/web/app` and served at `/app`.
- Consumer web pages are server-rendered by routes in `fauxshield_server/lib/src/web/routes/` (`/` landing, `/verify`).
- `docs/DEPLOYMENT.md` covers Serverpod Cloud deploys; `docs/DEMO_SCRIPT.md` is the hackathon demo script.

This project is a Flutter app (frontend) backed by a Serverpod server (backend). Always build the app's backend with Serverpod.
Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`.

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `fauxshield_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

Domain notes worth knowing before changing code:

- Verification flow: `VerificationService.resolveToken` → `acknowledge` → `submitPin` (row-locked transaction, PBKDF2 check, lockout after 5 failures) → `presentation()` allow-lists what consumers see.
- Fraud engine: `FraudEngine.evaluate` runs six checks; `AlertService` dedupes, auto-locks, publishes live events, and enqueues webhooks.
- Demo mode: `DemoSeeder` builds a disposable workspace; only a caller with the `demoSeedSecret` password can reset it.
- Web app path: if you change the Flutter app, rebuild with `flutter build web --release --base-href /app/` and copy `build/web/.` into `fauxshield_server/web/app/`.
- `third_party/sqlite_async` is a one-line patched vendored dependency needed for web builds; see its README_GUARD.md before touching it.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `fauxshield_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.

