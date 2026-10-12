## 1.0.0

First published version of the FauxShield command line client.

- One command group per API area: `auth`, `workspace`, `products`, `batches`,
  `identities`, `alerts`, `verifications`, `recalls`, `simulations`,
  `analytics`, `audit`, `team`, `keys`, `webhooks`, `notifications`, `offline`,
  `demo`, and `verify` — the whole API, not just the read paths.
- Table output for people and `--json` for scripts, with a non-zero exit code
  when a command fails.
- Credentials resolve flag → environment → config file → hosted default, so the
  same binary works interactively and unattended in CI: sign in with an email
  and password, or with an API key that carries its own scopes and rate limit.
- Talks to `https://fauxshield.api.serverpod.space` by default; `FAUXSHIELD_URL`
  points it at a local or staging server.
