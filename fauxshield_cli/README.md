# fauxshield_cli

Command line client for the FauxShield anti-counterfeit platform.

It is a plain Dart console package that speaks the same JSON-RPC API as the
operator app and the consumer web flow, so everything the command center can do
can also be scripted: products and batches, unit generation and export, the
fraud queue, recalls, webhooks, attack simulations, analytics, and the audit
log. There is no second implementation to keep in step — every command is a
thin wrapper over the generated [`fauxshield_client`](../fauxshield_client).

## Requirements

- Dart SDK 3.12 or newer.
- A FauxShield workspace: your own, or the shared demo.

## Install

```bash
# from the repository root
dart pub global activate --source path fauxshield_cli

# or run it without installing
dart run fauxshield_cli:fauxshield --help

# or build a standalone binary for a machine without Dart
dart compile exe fauxshield_cli/bin/fauxshield.dart -o fauxshield
```

## Sign in

As a person, with the account you use in the operator app:

```bash
fauxshield auth login --email you@brand.test --password '<your password>'
fauxshield auth whoami
```

As a machine, with an API key from **Settings → API keys** in the operator app:

```bash
fauxshield auth login --api-key fs_live_...
```

`fauxshield auth token` prints whichever credential is active, so it can be piped
into another tool, and `fauxshield auth logout` forgets it.

## Credentials

Resolution order is command line flag, environment variable, stored config,
default, so CI never has to write a file:

| Setting | Flag | Environment | Default |
|---------|------|-------------|---------|
| Server URL | `--url` | `FAUXSHIELD_URL` | `~/.fauxshield/config.json`, then the hosted API `https://fauxshield.api.serverpod.space` |
| API key | `--api-key` | `FAUXSHIELD_API_KEY` | stored by `auth login --api-key` |
| Session token | `--token` | `FAUXSHIELD_TOKEN` | stored by `auth login` |
| Password | `--password` | `FAUXSHIELD_PASSWORD` | — |
| Demo seed secret | `--secret` | `FAUXSHIELD_DEMO_SECRET` | — |
| Config file | — | `FAUXSHIELD_CONFIG` | `~/.fauxshield/config.json` |

An API key wins over a session token when both are present, because a key is
what automation is meant to use: it carries explicit scopes, its own rate limit,
and is attributed to the key in the audit log.

### What an API key can and cannot do

A key is a machine credential, so the server refuses it four things that belong
to a person. Those commands need `auth login` with an email and password, and a
role that allows them:

| Refused for API keys | Needs |
|----------------------|-------|
| `identities reveal-pin` | session, owner role |
| `workspace create` / `workspace update` | session, admin role |
| `simulations start\|step\|run\|cancel` | session, member role |
| `keys list\|create\|revoke` | session, admin role |

Everything else — products, batches, identities, verifications, fraud response,
recalls, webhooks, team management, notifications, offline ingest, analytics,
and the audit log — works with a scoped key. Mint the key from a session first:
`fauxshield auth login`, then `fauxshield keys create`.

## Commands

Every command takes `--json` (also accepted before the group name) for machine
readable output, and `--help`.

| Group | Commands |
|-------|----------|
| `auth` | `login`, `logout`, `whoami`, `token` |
| `products` | `list`, `show`, `create`, `update`, `archive`, `restore`, `deleted`, `delete-impact`, `delete`, `purge` |
| `batches` | `list`, `show`, `create`, `update`, `stats` |
| `identities` | `list`, `show`, `generate`, `export`, `reveal-pin`, `lock`, `unlock`, `regenerate`, `delete`, `restore` |
| `alerts` | `list`, `show`, `status`, `assign`, `signals`, `reports`, `triage` |
| `verifications` | `list`, `show` |
| `recalls` | `list`, `issue`, `lift` |
| `simulations` | `list`, `start`, `show`, `step`, `run`, `cancel` |
| `analytics` | `dashboard`, `rollup` |
| `audit` | `list` |
| `workspace` | `show`, `update`, `create` |
| `team` | `members`, `invitations`, `invite`, `accept`, `role`, `remove` |
| `keys` | `list`, `create`, `revoke` |
| `webhooks` | `list`, `create`, `test`, `deliveries`, `rotate`, `delete`, `drain` |
| `notifications` | `list`, `read`, `read-all`, `preferences`, `set` |
| `offline` | `records`, `ingest`, `convert` |
| `demo` | `status`, `reset`, `join` |
| `verify` | run the consumer flow for a token and PIN, with no account |

A guided tour of the common paths:

```bash
fauxshield products create --name "Cocoa Bar" --sku CB-70
fauxshield batches create --product <uuid> --reference L-2026-04 \
  --manufacture-date 2026-04-02 --region "West Africa" --quantity 5000
fauxshield identities generate --batch <uuid> --quantity 5000
fauxshield identities export --batch <uuid> --format csv --out codes.csv

fauxshield alerts list --severity critical
fauxshield alerts assign --alert <uuid> --assignee ops@brand.test
fauxshield alerts status --alert <uuid> --status resolved --note "batch reprinted"

fauxshield recalls issue --batch <uuid> --reason "mislabeled lot"
fauxshield recalls lift --recall <uuid>

fauxshield audit list --action identity.locked --from 2026-04-01
fauxshield analytics dashboard --window 30

fauxshield workspace show
fauxshield workspace update --countries NG,GH --message "Genuine FauxShield code"

# Field devices, and the operator's inbox
fauxshield offline records --pending
fauxshield offline ingest --device field-07 --file scans.json
fauxshield offline convert
fauxshield notifications list --unread
```

`offline ingest` reads a JSON array from `--file` (or `-` for stdin) of scans a
device captured without a connection, and hands back one verdict per scan:

```json
[
  {
    "localId": "field-07-0001",
    "qrToken": "<token printed on the pack>",
    "scannedAt": "2026-04-11T09:12:00Z",
    "latitude": 6.5244,
    "longitude": 3.3792,
    "country": "NG",
    "city": "Lagos"
  }
]
```

Identifiers are printed as bare `uuid`s in tables and JSON so they can be
pasted straight back into the next command.

## Exit codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Failure that is not a typo: unreachable server, rejected credential, refused call, failed webhook delivery |
| `64` | Usage error: unknown command, missing or malformed flag (`EX_USAGE`) |

Expected failures print one line to stderr; a stack trace means a bug.

## Destructive commands

`products delete`, `products purge`, `keys revoke`, and `webhooks delete` ask
for confirmation before they run. Pass `--yes` to skip the prompt in a script;
without a terminal on stdin the prompt cannot be shown, so the command refuses
instead of hanging. `products delete-impact` shows what a delete would cascade
to before you do it, and `products delete` only moves the product to the recycle
bin that `products restore` reads from.

## CI and automation

```bash
export FAUXSHIELD_URL=https://fauxshield.api.serverpod.space
export FAUXSHIELD_API_KEY=fs_live_...

fauxshield analytics dashboard --window 7 --json > weekly.json
fauxshield audit list --page-size 200 --json | jq '.[] | select(.action == "recall.issued")'
fauxshield identities export --batch "$BATCH" --out release.csv
```

Give the key the narrowest scopes that do the job. Reads are covered by the
`*Read` scopes; `identities generate` needs `identitiesGenerate`, `recalls issue`
needs `batchesWrite`, and so on. Minting the key itself is a session operation:
`fauxshield keys create --scopes productsRead,batchesRead` prints the secret
exactly once, and only a signed-in admin can run it.

## Testing

```bash
cd fauxshield_cli
dart analyze
dart test
```

The suite covers version parity with `pubspec.yaml`, usage exit codes, the
prompt-free API key path, secret masking, and the failure mode when the server
is unreachable.

## Related packages

- [`fauxshield_client`](../fauxshield_client) — the generated SDK this wraps.
- [`fauxshield_mcp`](../fauxshield_mcp) — the same API exposed as MCP tools for
  an AI agent.
- [`fauxshield_server`](../fauxshield_server) — the server both talk to.
