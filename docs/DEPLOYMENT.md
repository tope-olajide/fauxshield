# Deploying FauxShield to Serverpod Cloud

FauxShield is a normal Serverpod 4 project, so a Serverpod Cloud deployment is
one command after authentication. This guide lists what to check before you
deploy, the commands to run, and the post-deploy smoke test used for the
hackathon submission.

> Everything below assumes the repository is checked out and the `serverpod`
> CLI (4.0.3+) is on your `PATH`. The Serverpod Cloud CLI installs itself the
> first time you run `serverpod cloud`.

## Pre-flight checklist

- [ ] **Flutter web bundle is fresh.** The server serves the operator app from
      `fauxshield_server/web/app`. Rebuild it whenever the app changes:

      ```bash
      cd fauxshield_flutter
      flutter build web --release --base-href /app/
      cp -r build/web/. ../fauxshield_server/web/app/
      ```

- [ ] **Migrations are committed.** `fauxshield_server/migrations/` contains the
      schema; Serverpod Cloud applies pending migrations on boot. Run
      `serverpod create-migration` locally first if you changed a model, and
      verify with `dart test`.
- [ ] **Server analysis and tests pass.**

      ```bash
      cd fauxshield_server
      dart analyze lib
      dart test
      ```

- [ ] **Production config is sane.** `config/production.yaml` ships with
      placeholder public hosts (`api.examplepod.com`). Serverpod Cloud manages
      the actual URLs; if your deployment keeps the placeholders visible, set
      the three `publicHost` values (api, insights, web) to the domains shown in
      `serverpod cloud status`.
- [ ] **Secrets are ready.** `config/passwords.yaml` holds development values.
      For the cloud, set the same keys through the CLI so they are stored as
      managed secrets (see step 3).
- [ ] **Geo provider.** Development uses the deterministic `demo` provider so
      scans always resolve to a city. To use real IP geolocation in the cloud,
      set `geoProvider: http` and `geoLookupUrlTemplate` in
      `config/passwords.yaml` (any `{ip}`-templated JSON endpoint works); leave
      it on `demo` for the hackathon demo.
- [ ] **Outbound webhooks.** Webhook endpoints are validated against
      private/loopback ranges before delivery (SSRF guard), so only public
      HTTPS targets are accepted.

## Deploy

```bash
# from the repository root
serverpod cloud auth login          # browser-based login

cd fauxshield_server
serverpod cloud launch              # first time: creates the project, Postgres,
                                    # and deployments, then uploads this server
```

`launch` links the local server directory to a new cloud project. Subsequent
deploys are:

```bash
cd fauxshield_server
serverpod cloud deploy              # or: serverpod cloud deploy --await
```

Useful options while iterating:

```bash
serverpod cloud deploy --show-files     # preview the upload (respects .gitignore)
serverpod cloud deploy --wet-run --show-files
serverpod cloud status                  # project + deployment state
serverpod cloud log                     # stream server logs
```

Before the first real deploy, run `serverpod cloud deploy --wet-run --show-files`
and confirm the upload includes the workspace pieces the build needs:

- `fauxshield_server/` (including `web/app`, now un-ignored, and `migrations/`)
- `fauxshield_flutter/` if you want the pre-deploy `flutter_build` script to
  rebuild the web app in the cloud rather than shipping the committed bundle
- `third_party/sqlite_async/` (the root `pubspec.yaml` dependency override)
- `pubspec.lock` at the workspace root

## Secrets

Set every key the server expects as a cloud password. The values in
`config/passwords.yaml` are development values; generate fresh ones for a real
deployment (the CLI prompts for the value, keeping it out of your shell
history):

```bash
serverpod cloud password set hmacSecretKey          # signs QR tokens
serverpod cloud password set pinEncryptionKey       # AES-GCM for PIN reveals
serverpod cloud password set webhookEncryptionKey   # encrypts endpoint secrets
serverpod cloud password set demoSeedSecret         # gates demo resets
serverpod cloud password list                       # verify
```

Notes:

- `hmacSecretKey`, `pinEncryptionKey`, and `webhookEncryptionKey` must not
  change after data exists; rotating `hmacSecretKey` invalidates printed QR
  codes, and rotating `pinEncryptionKey` makes existing PINs unreadable.
- The demo workspace is created on the first authenticated call to
  `demo.seed`. Anyone signed in can join it; only a caller presenting the
  `demoSeedSecret` can reset it.

## Post-deploy smoke test

1. Open `https://<web-host>/` — the landing page shows live counters and, once
   the demo workspace exists, a demo code **and its packaging PIN**.
2. Follow **Try demo code** → `https://<web-host>/verify?t=<token>` → enter the
   PIN → expect **Authentic** (or **Already verified** after the first scan).
3. Open `https://<web-host>/app`, create an account (email + password), and
   choose **Open demo workspace**.
4. In the app: **Dashboard** shows stats; **Live** shows events; run
   **Simulations → Clone attack** and watch alerts arrive in **Alerts**.
5. Send a test webhook from **More → Webhooks** if you configured an endpoint.

## Rolling back

`serverpod cloud` keeps deployment history per project; redeploy a previous
build from the console or with `serverpod cloud deploy --redeploy` after
restoring the secrets. Database migrations are forward-only — take a snapshot
with `serverpod cloud db` before destructive model changes.
