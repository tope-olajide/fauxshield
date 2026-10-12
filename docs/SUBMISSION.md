# Submission pack — Build Something Real: The Serverpod Hackathon

Everything needed to fill in the BuilderBase submission form, written against
the four published judging criteria. Copy from here; the video URL is the one
blank to fill once the recording is uploaded.

- **Deadline:** 14 October 2026 · **Winners:** 22 October, live at Full Stack
  Flutter
- **Judging:** 30% does it work · 25% use of the Serverpod stack · 25% craft and
  technical creativity · 20% usefulness
- **Entry requirement:** Serverpod must be the backend. It is: the API, the
  streaming channel, the background jobs, the database layer, the web pages,
  and the deployment all run in one Serverpod 4 server.

## Links to paste into the form

| Field | Value |
| --- | --- |
| Project name | FauxShield — anti-counterfeit command center |
| Repository | https://github.com/tope-olajide/fauxshield (public) |
| Live app (web) | https://fauxshield.serverpod.space/ |
| Consumer verification page | https://fauxshield.serverpod.space/verify |
| Operator app | https://fauxshield.serverpod.space/app |
| Developer documentation | https://fauxshield.serverpod.space/docs |
| API (JSON-RPC) | https://fauxshield.api.serverpod.space |
| Video (2 min) | _paste the upload URL here once recorded_ |
| CLI / SDKs | `dart pub global activate fauxshield_cli` · `fauxshield_mcp` · `npm install fauxshield` · `pip install fauxshield-sdk` · `dart pub add fauxshield_client` |

## Short description (≈ 60 words)

FauxShield lets a brand serialize every physical unit it makes with a signed QR
code and a packaging PIN. A shopper gets an authoritative verdict from a web
page — no app, no account. Behind it the brand gets unit-level identity, a fraud
engine that turns a copied code into a visible event, alerts with evidence,
recalls, offline field inspections, and an audit trail. Built end to end on
Serverpod 4 and Flutter.

## Full description (≈ 200 words)

Counterfeits kill people and destroy livelihoods: 1 in 10 medical products in
low- and middle-income countries is substandard or falsified, 30–60% of seeds
and pesticides in some regions are fake, and enforcement only ever sees
seizures after the fact. The missing layer is evidence at the unit level — proof
that one specific pack is genuine, and a record of what happened to it.

FauxShield is that layer. A brand registers products and manufacturing batches,
and every unit is minted with a random 128-bit QR token, an HMAC-SHA256
signature, and a six-digit PIN stored as a PBKDF2 hash. A consumer scans the
pack, enters the PIN under the scratch panel, and gets a verdict in seconds;
sessions are device-bound, replay-protected, and only an allow-listed view ever
leaves the server. Every scan feeds a fraud engine that evaluates six checks
against a per-workspace policy — clone detection, velocity, PIN brute force,
batch duplication, distributor leakage, and restricted-market scans — plus PIN
lockout and offline reconciliation. Signals become deduplicated alerts with
evidence, operators work them in a live Flutter command center, and response is
first class: signed webhooks, unit locks, and batch recalls.

Everything runs in one Serverpod server: 15 endpoint classes, 84 `.spy.yaml`
models, streaming events, four recurring future-call jobs, Serverpod's offline
sync, and the server-rendered landing, consumer, and documentation pages.
Seventeen registered routes, one database, one deploy.

## How the criteria map

| Criterion | Where it shows |
| --- | --- |
| **Does it work (30%)** | The whole flow is live and unauthenticated where it should be: `/verify` runs token resolution → PIN → verdict against the deployed database, `/app` is the real operator app, and the demo workspace is seeded through the same services as production data. 70 server tests (unit + integration, embedded PostgreSQL, no Docker), 13 CLI and 26 MCP tests, CI on every push. |
| **Use of the Serverpod stack (25%)** | Endpoints and generated protocol; 84 `.spy.yaml` models generating schema and migrations; Serverpod's email identity provider with JWTs; `watchWorkspace` streaming; four recurring future calls plus paced simulation steps; `database: sync` offline records; row-locked transactions; the web server rendering the public pages; `serverpod_test`; Serverpod Cloud deploy. The README's "How Serverpod is used" table names the file for each one. |
| **Craft and technical creativity (25%)** | Cryptographic identity (HMAC-bound tokens, PBKDF2 PINs, AES-GCM reveals, audited reveals), replay and device binding, deduplicating alert pipeline with evidence, attack simulations that run through the real pipeline, offline-first field work, a 42-page generated documentation portal, and four published clients (Dart, Node.js, Python, CLI) plus an MCP server, all parity-checked against a generated contract. |
| **Usefulness (20%)** | One clear user, one clear problem: a brand that cannot tell its own product from a copy, and a shopper who cannot tell a real pack from a fake. Medicines, seeds, food, cosmetics, electronics, and auto parts are all named in the README's problem section and on `/features` and `/about`. |

## Demo video

`docs/DEMO_SCRIPT.md` is the shot list (target 1:55, two browser windows plus
the operator app). The scenes assume the deployed instance:

1. `https://fauxshield.serverpod.space/` — the landing page with live counters
   and the demo code + packaging PIN, then `/verify` for an authentic verdict.
2. `/verify` — report the product, then show it land in the app's **Alerts**.
3. `/app` — dashboard, then the **Live** feed during a simulation.
4. **More → Simulations → Clone attack** — verification events, a clone signal,
   a critical alert with evidence and a map.
5. Close on the catalog → **Recall batch**.

Record at 1440p, keep the cursor deliberate, and let the live feed show the
work. Upload (unlisted is fine, but a public link is safer for judges), then
paste the URL into the form and add it to the README's intro.
