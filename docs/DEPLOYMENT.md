# Deploying FauxShield to Serverpod Cloud

FauxShield is a normal Serverpod 4 project, so once the CLI is authenticated a
deployment uploads the server, builds it in the cloud, and rolls it out. This
guide records the flow that was actually used, the checks worth repeating, and
the traps that are specific to this repository.

> Requirements: the repository checked out, the `serverpod` CLI (4.0.4+) on your
> `PATH`, and a logged-in CLI (`serverpod cloud auth login`, which opens the
> browser and waits for the callback).

## URLs

The project is deployed as **`fauxshield`** on the **Starter** plan, region
Europe. Every project gets three hosts on `serverpod.space`:

| Host | URL |
| --- | --- |
| web (landing, `/verify`, `/app`) | https://fauxshield.serverpod.space/ |
| api | https://fauxshield.api.serverpod.space/ |
| insights | https://fauxshield.insights.serverpod.space/ |

The public hosts are injected by the platform. The placeholders in
`config/production.yaml` do **not** leak into the running server: the generated
`/app/assets/assets/config.json` returns the real API URL
(`{"apiUrl":"https://fauxshield.api.serverpod.space"}`), because Serverpod
Cloud sets the `SERVERPOD_*_PUBLIC_HOST` variables, which take precedence over
the YAML config files.

## Pre-flight checklist

- [ ] **Flutter web bundle is fresh.** The server serves the operator app from
      `fauxshield_server/web/app`; the cloud build does *not* rebuild it (the
      `flutter_build` pre-deploy hook is off by default). Rebuild it whenever
      the app changes:

      ```bash
      cd fauxshield_flutter
      MSYS_NO_PATHCONV=1 flutter build web --release --base-href /app/
      rm -rf ../fauxshield_server/web/app
      cp -r build/web ../fauxshield_server/web/app
      ```

      (On Windows, `MSYS_NO_PATHCONV=1` stops Git Bash from rewriting
      `--base-href /app/` into `C:/Program Files/Git/app/`.)

- [ ] **No path overrides in the workspace.** A deploy uploads only the
      workspace packages the **server** depends on, plus the root
      `pubspec.yaml`/`pubspec.lock` and `.scloud/`. `third_party/` is never
      uploaded, so a `dependency_overrides: <pkg>: path: third_party/...` makes
      the cloud build fail — first with
      `depends on <pkg> from path which doesn't exist`, and, from a workspace
      member where it resolves locally, with
      `Unable to satisfy ../pubspec.yaml using ../pubspec.lock` during
      `dart pub get --enforce-lockfile`. Keep dependencies hosted. See
      `third_party/sqlite_async/README_GUARD.md` for the case that used to
      require one.

- [ ] **Migrations are committed.** `fauxshield_server/migrations/` is uploaded
      and `applyMigrations` runs at boot; the log prints
      `Latest database migration already applied.` once the schema is current.

- [ ] **Boot code tolerates disabled future calls.** Serverpod Cloud runs the
      app podlets without a future call manager (it executes scheduled work in
      a separate role), so `pod.futureCalls` throws
      `Bad state: FutureCalls is not initialized` unless it is guarded. That
      guard lives in `_scheduleRecurringTasks` in `fauxshield_server/lib/server.dart`
      and must stay.

- [ ] **Server analysis and tests pass.**

      ```bash
      cd fauxshield_server
      dart analyze lib
      dart test
      ```

- [ ] **Secrets.** `config/passwords.yaml` *is* uploaded (the CLI's
      `.scloudignore` template lists `config/passwords.yaml`, but those patterns
      are relative to a non-workspace root and do not match
      `fauxshield_server/config/...` in this repo), so the development values
      from the repository drive the deployment. To move off them, store managed
      values — they are injected as `SERVERPOD_PASSWORD_*` and take precedence:

      ```bash
      serverpod cloud password set hmacSecretKey        # signs QR tokens
      serverpod cloud password set pinEncryptionKey     # AES-GCM for PIN reveals
      serverpod cloud password set webhookEncryptionKey # encrypts endpoint secrets
      serverpod cloud password set demoSeedSecret       # gates demo resets
      serverpod cloud password list                     # verify
      ```

      `hmacSecretKey` and `pinEncryptionKey` must not change once data exists:
      rotating them invalidates printed QR codes and stored PINs.

- [ ] **Geo provider.** Development and the cloud both run the deterministic
      `demo` provider, so scans resolve to a city without an external service.

- [ ] **Product images are in object storage.** Uploaded images go through
      `pod.storage['public']`, which `server.dart` wires with
      `ServerpodCloudProvider.public` and falls back to `DatabaseCloudStorage`.
      Serverpod Cloud buckets back it in production, so an image survives a
      deploy, a restart, and a second podlet; the same code works locally
      against the database. List what the project has:

      ```bash
      serverpod cloud storage list -p fauxshield      # the public and private buckets
      serverpod cloud storage file list public -p fauxshield
      ```

      To point the same calls at another provider instead, register it in
      `server.dart` — `serverpod_cloud_storage_s3_compat` covers AWS S3,
      Cloudflare R2, MinIO, and anything else that speaks S3, and
      `serverpod_cloud_storage_gcp` covers Google Cloud Storage. No call site
      changes, because endpoints only ever use `pod.storage`.

      Earlier builds wrote images under `fauxshield_server/web/static/media/`,
      which is gitignored and lives on the podlet's own disk: those files are
      gone once the container is replaced, and the products that referenced
      them show the placeholder image until someone re-uploads.

## Deploy

`serverpod cloud launch` is convenient by hand but **interactive-only** (it
opens a TUI and refuses to run non-interactively). For scripted or agent-driven
deploys, use the two non-interactive commands instead:

```bash
# once, per project
serverpod cloud project create -p fauxshield --plan=starter --enable-db

# every deploy (from the repository root or the server directory)
cd fauxshield_server
serverpod cloud deploy -p fauxshield --await
```

Useful options:

```bash
serverpod cloud deploy -p fauxshield --wet-run --show-files   # preview the payload
serverpod cloud deploy -p fauxshield --wet-run --output proof.zip
serverpod cloud status live -p fauxshield                     # podlet health
serverpod cloud status deployment show -p fauxshield          # latest deployment
serverpod cloud log -p fauxshield                             # stream server logs
```

Before a first or risky deploy, confirm the zip contains what the build needs
(`fauxshield_server/**` including `web/app` and `migrations/`, the regenerated
root `pubspec.yaml`, `pubspec.lock`) and that the regenerated pubspec has no
`dependency_overrides`. Running `dart pub get` inside the extracted zip
reproduces the first build step.

## Post-deploy smoke test

Verified against the live deployment:

1. `serverpod cloud status live -p fauxshield` → `Status ● Running`,
   `Podlets 1/1 ready`; `serverpod cloud log` shows
   `WebServer: Webserver listening on http://fauxshield.serverpod.space:8082`
   with no unhandled exceptions.
2. `curl https://fauxshield.serverpod.space/` → 200 with the landing page.
3. `curl "https://fauxshield.serverpod.space/verify?t=<unknown token>"` →
   200 and `This code is not registered by any brand on FauxShield.`, which
   exercises the database lookup and the scan logging.
4. `curl https://fauxshield.serverpod.space/app/assets/assets/config.json` →
   `{"apiUrl":"https://fauxshield.api.serverpod.space"}`, plus 200s for
   `/app/index.html`, `/app/main.dart.js`, `/app/flutter_bootstrap.js` and the
   cache-busted `/web/css/...` asset.
5. In a browser: follow **Try demo code** from the landing page. The demo
   workspace is seeded on the first authenticated call to `demo.seed`, so the
   landing page only shows a demo code and PIN after someone signs in to
   `/app` once and chooses **Open demo workspace**.
6. In the app: **Dashboard** shows stats, **Live** shows events, and
   **Simulations → Clone attack** produces alerts in **Alerts**.

## Point the clients at the deployment

Everything a signed-in operator can do in the app is also available from the
CLI and from the MCP server, both of which take a base URL and a credential.

```bash
# 1. Sign in against the live API (needs an account created in /app first).
export FAUXSHIELD_URL=https://fauxshield.api.serverpod.space
fauxshield auth login --email you@brand.test --password '<password>'
fauxshield auth whoami          # prints workspace, role, and demo mode

# 2. Headless smoke test of the consumer flow, with a token from the catalogue.
fauxshield identities list --page-size 1
fauxshield verify --token <qr token> --pin <pin>

# 3. Issue a scoped key for automation and CI.
fauxshield keys create --label github-actions \
  --scopes analyticsRead,fraudRead,auditRead
```

For an AI agent, give the MCP server the URL and that key, keeping it read-only
unless the agent is meant to change data:

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

`--json` on any CLI command makes it scriptable, and every mutating call made
through either client lands in the workspace audit log attributed to the key,
so `fauxshield audit list --actor api-key:<id>` shows what an agent did.

## Rolling back

`serverpod cloud` keeps deployment history per project; redeploy a previous
build from the console or with `serverpod cloud deploy --redeploy`. Database
migrations are forward-only — take a snapshot with `serverpod cloud db` before
destructive model changes.
