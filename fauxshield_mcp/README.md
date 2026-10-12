# fauxshield_mcp

Model Context Protocol server for the FauxShield anti-counterfeit platform.

It is a thin wrapper over the generated [`fauxshield_client`](../fauxshield_client)
SDK: every tool is one API call, authorized with the credential you give it. An
agent can therefore never do more than that credential allows, and every
mutating call lands in the workspace audit trail.

## Requirements

- Dart SDK 3.12 or newer (only to build or run it; the MCP client just starts a
  process).
- A FauxShield workspace and an API key, or a session token.

## Install

From pub.dev:

```bash
# Install the `fauxshield-mcp` command on your PATH
dart pub global activate fauxshield_mcp

# Or, in a checkout of this repository, run it straight from source
dart run fauxshield_mcp:fauxshield_mcp

# Or build a standalone binary to ship to a machine without Dart
dart compile exe fauxshield_mcp/bin/fauxshield_mcp.dart -o fauxshield-mcp
```

## Credentials

Create an API key in the operator app under **Settings → API keys**, choosing
the narrowest scopes the agent needs, then pass it in the environment:

| Variable | Required | Description |
|----------|----------|-------------|
| `FAUXSHIELD_API_KEY` | one of these | API key, `fs_live_...` |
| `FAUXSHIELD_TOKEN` | one of these | Session JWT, for a human's own session |
| `FAUXSHIELD_URL` | no | API base URL. Defaults to the URL stored by the CLI, then the hosted API `https://fauxshield.api.serverpod.space` |
| `FAUXSHIELD_WORKSPACE_ID` | no | Pin the workspace. Omit to use the key's workspace or the user's first |
| `FAUXSHIELD_READ_ONLY` | no | `true` disables every mutating tool |
| `FAUXSHIELD_CONFIG` | no | Path to the CLI's session file, if not `~/.fauxshield/config.json` |

If none of the key/token variables are set, the server falls back to the session
the CLI stored with `fauxshield auth login`, so a developer's machine works with
no extra configuration.

The server exits with code 78 and a one line explanation when it is
misconfigured, rather than advertising an empty tool list.

## Client configuration

### Claude Desktop

`~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or
`%APPDATA%\Claude\claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "fauxshield": {
      "command": "fauxshield-mcp",
      "env": {
        "FAUXSHIELD_URL": "https://fauxshield.api.serverpod.space",
        "FAUXSHIELD_API_KEY": "fs_live_..."
      }
    }
  }
}
```

### Cursor, Windsurf, Kiro, VS Code

Any client that reads a `mcpServers` block works the same way. To run from a
checkout instead of a global install:

```json
{
  "mcpServers": {
    "fauxshield": {
      "command": "dart",
      "args": ["run", "/absolute/path/to/fauxshield_mcp/bin/fauxshield_mcp.dart"],
      "env": {
        "FAUXSHIELD_URL": "https://fauxshield.api.serverpod.space",
        "FAUXSHIELD_API_KEY": "fs_live_...",
        "FAUXSHIELD_READ_ONLY": "true"
      }
    }
  }
}
```

## Tools

Read tools are safe to call at any time. Write tools change data and are refused
when `FAUXSHIELD_READ_ONLY=true`.

### Catalog

| Tool | Kind | What it does |
|------|------|--------------|
| `list_products` / `get_product` | read | Browse products by name or SKU |
| `create_product` / `update_product` | write | Register or amend a product |
| `upload_product_image` | write | Attach a product image from a file path or base64 |
| `archive_product` / `restore_product` | write | Move a product in or out of the archive |
| `product_delete_impact` | read | Report what deleting a product would remove |
| `list_batches` / `get_batch` / `batch_stats` | read | Batches and their unit counts by state |
| `create_batch` / `update_batch` | write | Create or amend a batch |
| `generate_units` | write | Mint signed QR tokens and packaging PINs |
| `list_units` / `get_unit` | read | Inspect serialized units |
| `export_units` | read | Export a batch as CSV or JSON for a print partner |
| `lock_unit` / `unlock_unit` | write | Freeze or release one unit |
| `regenerate_unit_token` | write | Replace a compromised unit's token |

### Fraud

| Tool | Kind | What it does |
|------|------|--------------|
| `list_alerts` / `get_alert` | read | The investigation queue |
| `alert_evidence` | read | One alert with every related record |
| `investigate_alert` | read | Evidence plus batch counts plus the unit's audit trail |
| `update_alert_status` / `assign_alert` | write | Work an alert to a resolution |
| `list_fraud_signals` | read | The raw signals the engine recorded |
| `list_fake_reports` / `triage_fake_report` | read / write | Consumer reports of fake units |
| `list_verifications` / `get_verification` | read | Consumer scan sessions and outcomes |

### Response and platform

| Tool | Kind | What it does |
|------|------|--------------|
| `list_recalls` · `recall_batch` · `recall_unit` · `lift_recall` | read / write | Issue and lift recalls |
| `list_webhooks` · `create_webhook` · `update_webhook` · `delete_webhook` | read / write | Manage outbound event delivery |
| `test_webhook` / `list_webhook_deliveries` / `redeliver_webhook` | read / write | Check and replay deliveries |
| `list_simulations` / `get_simulation` / `start_simulation` / `cancel_simulation` | read / write | Exercise the fraud engine |
| `get_workspace` / `list_workspace_members` | read | Workspace and team context |
| `list_api_keys` · `create_api_key` · `revoke_api_key` | read / write | Issue machine credentials |
| `search_audit_events` | read | Who did what, to which record, and when |
| `dashboard_summary` / `refresh_analytics` | read / write | Command center metrics |
| `verify_unit` | read | Run the consumer verification flow for a token |

`verify_unit` is the public path, so it works without any credential.

### Refused for API keys

Four operations have no API scope at all, so the server refuses them for any
key: revealing a packaging PIN, changing workspace settings, running attack
simulations, and managing API keys. They stay available to a signed-in person.

The simulation tools *are* wrapped here, so driving them means giving the server
`FAUXSHIELD_TOKEN` with an owner, admin, or member session instead of
`FAUXSHIELD_API_KEY` — the key can rehearse an attack's *evidence*, a person has
to start it.

The server tells the model which permission was missing instead of failing
opaquely. Deleting a product outright is left out on purpose; use
`archive_product` and `product_delete_impact`.

Three API areas are left out on purpose, because they belong to a person or a
device rather than to an agent:

| Not exposed | Why | Use instead |
|-------------|-----|-------------|
| Notification inbox (`notification.*`) | It is one person's unread list, addressed by their account | The Flutter app, or `fauxshield notifications list` |
| Offline field ingest (`offline.*`) | It syncs scans captured by a device that has the QR codes | `fauxshield offline ingest`, or the app's offline queue |
| Demo seeding (`demo.seed`) | It rebuilds a whole workspace and is gated by a secret | `fauxshield demo reset` with the seed secret |

The CLI covers the complete API — every endpoint the app uses — so anything an
agent should not do is still available to a person who has the credential for
it.

## Security

- **Scoped by construction.** Every call carries the caller's key, and the
  server maps each API scope to exactly one capability. A read-only key cannot
  write, no matter what the model asks for.
- **Secrets stay on the server.** PIN hashes and ciphertexts, webhook signing
  secrets, and API key hashes are `serverOnly` fields the API never sends.
- **Attributed.** Mutating calls are recorded with the identity
  `api-key:<key id>`, so the audit trail distinguishes an agent from a person.
- **Throttled.** Each key carries its own requests-per-minute limit, enforced
  per request.
- **Revocable.** Revoking a key takes effect on the key's next request, without
  restarting anything.

## Development

```bash
cd fauxshield_mcp
dart pub get
dart analyze
dart test          # config, tool surface, read-only guard, and stdio protocol
```

The test suite starts the real binary over stdio, checks the handshake and the
advertised tools, and verifies that a misconfigured server exits with a readable
error.
