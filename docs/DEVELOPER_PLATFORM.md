# Developer platform: audit, implementation, and report

This is the working document behind the developer-platform work: what existed in
this repository, what was built on top of it, how each claim was verified, and
what is deliberately left for its owner to authorize. The source of truth is the
code and its tests — a file or a page existing is not evidence that a feature
works, so every line below names how it was checked.

Audited 2026-10-12 against `main`; report updated after the implementation pass.

> **A note on counting endpoints.** The project's README and demo script say
> "18 endpoints", which counts the two authentication endpoints Serverpod's auth
> module contributes (`emailIdp`, `jwtRefresh`) alongside the platform's own.
> This document counts the 15 endpoint classes under
> `fauxshield_server/lib/src/endpoints/`, because those are what the contract,
> the SDKs, and the API reference cover; the auth endpoints are documented by
> Serverpod.

## 1. What the platform was

| Surface | State at audit | Evidence |
|---------|----------------|----------|
| API | Serverpod **JSON-RPC** over `https://fauxshield.api.serverpod.space`, 15 endpoint classes, session + API-key auth with scopes and per-key rate limits, audit log, webhooks, live event channel, offline ingest, simulations, cloud-stored media | `fauxshield_server/lib/src/endpoints/`, server suite |
| Dart SDK | `fauxshield_client` — generated protocol client covering every endpoint, model, and exception; base URL supplied by the caller | `fauxshield_client/lib/src/protocol/client.dart` |
| CLI | `fauxshield_cli` — 18 commands, table and JSON output, credential resolution flag → environment → file → hosted default | `fauxshield_cli/README.md`, its tests |
| MCP server | `fauxshield_mcp` — 55 tools, stdio transport, read-only switch, credentials from the environment or the CLI session | `fauxshield_mcp/README.md`, its tests |
| Public site | Server-rendered landing, `/features`, `/pricing`, `/about`, `/docs`, and the consumer `/verify` page | `fauxshield_server/lib/src/web/` |
| Deployment | Dockerfile + Serverpod Cloud guide, hosted web and API | `docs/DEPLOYMENT.md` |

Gaps found: no Node.js or Python SDK, no machine-readable contract, no
endpoint-by-endpoint reference, a single-page `/docs` with no sidebar or search,
no cross-language checks, and no executed examples.

## 2. SDK architecture for Node.js and Python

The API is not REST: every call is a Serverpod JSON-RPC request whose envelope,
method names (`product.list`), and serialization come from the framework. An
OpenAPI document generated from the endpoints would describe the resource model
but misstate the wire protocol, and any client generated from it would be a
second, divergent client.

| Approach | Verdict |
|----------|---------|
| Native hand-written SDKs per language | Rejected alone: three implementations of 86 methods and 76 models drift the moment one changes. |
| OpenAPI-first, generated clients | Rejected: the transport is JSON-RPC, so OpenAPI cannot be the authoritative contract without adding a REST gateway to the server. |
| **Hybrid: extract a contract from the generated Dart client, then generate resources for each language with hand-written cores around them** | **Chosen.** The generated Dart client is already the complete, compiler-checked description of the protocol. A small extractor turns it into a language-neutral contract; each SDK is generated from that contract and wraps it in idiomatic errors, retries, timeouts, and configuration. |

Consequences:

1. **The contract is derived, never hand-maintained.** It is read out of
   `fauxshield_client` (itself generated from the server's models and
   endpoints), so it cannot describe something the API does not have.
2. **Shared checks, not duplicated logic.** One script compares all three SDKs
   against the contract, and the documentation reference is generated from it.
3. **One base-URL policy everywhere.** Hosted default built in, explicit
   override wins over `FAUXSHIELD_URL`, invalid URLs rejected with a message that
   says what to change, secrets never logged.

## 3. What was delivered

| Milestone | Delivered | Evidence |
|-----------|-----------|----------|
| 0. Public pages | Every non-auth page (landing, features, pricing, about, docs) shows a **Dashboard** button to `/app` — nav and page CTAs — instead of a sign in / sign up pair; `/verify` keeps its own header and offers no operator path. Any unauthenticated visitor landing in `/app` gets the app's own sign in. | `site_chrome.dart`, marketing templates, `test/unit/site_chrome_test.dart` |
| 1. Contract | `fauxshield_contract` reads the generated Dart client and writes `contract/api_contract.json` — 15 platform endpoints, 86 methods, 51 models, 25 enums, 8 exceptions — with a drift test and a `--check` gate in CI | `fauxshield_contract/`, its tests |
| 2. Node.js / TypeScript SDK | `fauxshield_node` (`npm install fauxshield`): generated resources and types, hosted default with `baseUrl` override, typed errors, timeouts, retries, injectable `fetch`, ESM, Node 20+ | 28 tests passing, `npm run build` + `tsc`; published as `fauxshield@0.1.0` |
| 3. Python SDK | `fauxshield_python` (`pip install fauxshield-sdk`, import `fauxshield`): generated resources and typed models, keyword arguments, standard-library transport, typed errors, retries honouring `retry_after`, injectable transport, Python 3.9+ | 43 tests passing, wheel built and imported from the installed copy; published as `fauxshield-sdk@0.1.0` |
| 4. Parity checks | `tools/check_parity.py` compares Dart, Node.js, and Python against the contract (methods, endpoints, models, enums), checks every published default URL, and checks CLI/MCP naming in the docs | 86/86 methods and 76/76 models in all three; exits non-zero on drift (verified by breaking a method name on purpose) |
| 5. Documentation portal | `/docs` is a 42-page portal: overview, getting started, authentication, generated API reference (one page per endpoint with parameter tables and cURL/Dart/TypeScript/Python examples, plus model and enum references), SDK pages (Dart, Node.js, Python, parity matrix), CLI reference (18 commands, 72 names), MCP reference (55 tools), five guides, and a reference section | `fauxshield_server/lib/src/web/docs/`; 28 portal and chrome tests across `test/unit/docs_*_test.dart` and `test/unit/site_chrome_test.dart` |
| 6. Drift and executed checks | CI regenerates and diffs the docs reference (`dart run tool/generate_docs.dart --check`), runs the parity script, both SDK suites, the Python wheel install, and the portal's own tests | `.github/workflows/tests.yml`; `.github/workflows/release-python.yml` and `.github/workflows/release-npm.yml` publish the SDKs from a version tag |

### Documentation portal detail

- **Generated, not written twice.** `dart run tool/generate_docs.dart` reads the
  contract and the endpoint sources' doc comments and writes
  `lib/src/web/docs/api_reference.g.dart`. Every endpoint page, model page, enum
  page, SDK resource table, and the parity matrix come from it.
- **Navigation is derived from one list of pages**, so a page cannot appear in
  the sidebar without a route, and cannot be missing from search: the search
  index is built from the same pages and served at `/docs/search.json`.
- **Search works**: it indexes titles, headings, and prose, matches on every
  term, ranks title hits first, links to the section anchor, has an empty state,
  and opens with `/` or `Ctrl`/`⌘`+`K`.
- **Reading experience**: persistent responsive sidebar with collapsible groups,
  breadcrumbs, on-page table of contents with a scroll marker, previous/next
  links, anchor links on headings, copy buttons, language tabs that work without
  JavaScript, a helpful not-found page (marked `noindex`), visible focus states,
  and a `prefers-reduced-motion` rule.
- **The old single-page `/docs` was replaced** by the portal; `docs.html` and
  `docs_page.dart` are gone, and their content lives on as proper pages
  (local development, first workflow, authentication, webhooks, CLI).

### Default API URL and overrides

Every published client defaults to the hosted deployment, established in
`docs/DEPLOYMENT.md` and used throughout the repository:

| Client | Default | Override |
|--------|---------|----------|
| Node.js | `https://fauxshield.api.serverpod.space` | `baseUrl` or `FAUXSHIELD_URL` |
| Python | `https://fauxshield.api.serverpod.space` | `base_url` or `FAUXSHIELD_URL` |
| CLI | `https://fauxshield.api.serverpod.space` | `--url` or `FAUXSHIELD_URL` |
| MCP server | `https://fauxshield.api.serverpod.space` | `FAUXSHIELD_URL` |
| Dart client | host supplied by the caller; the Flutter app reads it from the server's `/app/assets/assets/config.json`, which the deployment generates from its public host | pass another host, or another `--dart-define=SERVER_URL` |

Precedence is the same in each: an explicit value wins, then the environment,
then the built-in default. Localhost appears only in local-development
instructions, never as a default, and `tools/check_parity.py` fails if that
changes.

## 4. Verification performed

| Check | Result |
|-------|--------|
| `dart analyze` (server, CLI, MCP, contract) | Clean |
| `dart test` in `fauxshield_server` | 70 tests passing (40 unit, 30 integration), including 28 portal and chrome tests |
| `dart run tool/generate_docs.dart --check` | Reference matches the contract, and `dart format` leaves it unchanged |
| `dart run bin/extract.dart --check` (contract) | Matches the generated client, 11 tests passing |
| `dart test` in `fauxshield_cli` / `fauxshield_mcp` | 13 / 26 tests passing |
| `npm test` in `fauxshield_node` | 28 tests passing |
| `python -m unittest discover -s tests` in `fauxshield_python` | 43 tests passing |
| Python wheel | Built with `pip wheel`, installed into a clean target, imported, default URL asserted |
| `python tools/check_parity.py` | 86/86 methods, 76/76 models, 15/15 endpoints, 72/72 CLI names, 55/55 MCP tools, hosted default everywhere |
| Drift detection | Breaking a method name on purpose exits 1 and names the drift |
| Live API, unauthenticated (read-only) | `POST /product/list` → 400 `AuthenticationException`; `POST /verification/start` with an unknown code → 400 `VerificationException`; `POST /product/nope` → 400. Confirmed that typed failures arrive as HTTP 400 with `{ className, data: { message, code, … } }`, which the SDK error mapping and the error reference now state |

What could not be checked here, and why:

- **Authenticated live integration tests** need a test account or API key on the
  hosted deployment; none exists in the repository. The SDK suites therefore run
  against injected transports and fixtures, which proves the client side of the
  protocol but not a live write.
- **The portal in a browser** was verified by rendering every page through its
  template in tests (no unresolved values, one active page, open group,
  anchors, pager, links). Serving it over HTTP and clicking through it needs a
  running server, which this environment does not start.
- **Package publishing** is done, and was verified from the registries rather
  than from the working tree: `fauxshield@0.1.0` on npm and
  `fauxshield-sdk@0.1.0` on PyPI were each installed back into a clean
  environment and refused a live call with the typed `AuthenticationError` an
  unauthenticated caller should get; `fauxshield_client` 1.0.0 was installed
  back from pub.dev the same way and refused with `AuthenticationException`;
  and `fauxshield_cli` 1.0.0 and `fauxshield_mcp` 1.0.0 were activated from
  pub.dev in a scratch pub cache and run. npm and PyPI release from CI on a
  version tag: `.github/workflows/release-python.yml` publishes
  `fauxshield-sdk` and `.github/workflows/release-npm.yml` publishes
  `fauxshield`, each after checking the tag against its own manifest,
  regenerating the SDK, running its suite, and installing the exact artifact
  it will upload into a clean environment. pub.dev publishing is still manual.

## 5. Remaining gaps and what needs authorization

| Item | State |
|------|-------|
| Publishing the SDKs | **Done** — `fauxshield@0.1.0` (npm), `fauxshield-sdk@0.1.0` (PyPI), and `fauxshield_client` 1.0.0 (pub.dev) are live. A version tag now releases npm and PyPI from CI (`.github/workflows/release-npm.yml` once the `NPM_TOKEN` secret exists, `.github/workflows/release-python.yml` once `PYPI_API_TOKEN` exists); the next tag must name a version above 0.1.0, because neither registry accepts a version it already has. |
| `fauxshield_client` (Dart) on pub.dev | **Done** — 1.0.0 is live, installed back from pub.dev in a scratch project, where a live call was refused with `AuthenticationException`. In this repository the Flutter app, CLI, and MCP keep resolving the local workspace copy, because the generator rewrites it on every server change. |
| `fauxshield_cli` and `fauxshield_mcp` on pub.dev | **Done** — both are live at 1.0.0, activated from pub.dev in a scratch pub cache and run (`fauxshield --version`, `fauxshield-mcp --version`). Every installation instruction in the READMEs and the docs portal now uses the hosted commands, and the portal's MCP page documents the real configuration (`fauxshield-mcp`, `FAUXSHIELD_READ_ONLY`). |
| Authenticated live test suite | Needs a credential on the hosted deployment |
| Everything committed | Nothing here is deployed; the deployed server is unchanged by this pass |

## 6. How to reproduce the verification

```bash
# Contract, SDKs, and documentation reference
cd fauxshield_contract && dart test && dart run bin/extract.dart --check
cd ../fauxshield_server && dart run tool/generate_docs.dart --check && dart test
cd ../fauxshield_node && npm install && npm test
cd ../fauxshield_python && PYTHONPATH=src python -m unittest discover -s tests
cd .. && python tools/check_parity.py

# Release the SDKs from a tag: the tag names the version the manifest already
# declares, and a package-scoped tag releases one package on its own.
git tag v0.2.0 && git push origin v0.2.0                                 # both SDKs
git tag fauxshield-v0.2.0 && git push origin fauxshield-v0.2.0           # npm only
git tag fauxshield-sdk-v0.2.0 && git push origin fauxshield-sdk-v0.2.0   # PyPI only

# Publish a Dart package (the first publish of a name is interactive)
cd fauxshield_client && dart pub publish
cd ../fauxshield_cli && dart pub publish
cd ../fauxshield_mcp && dart pub publish
```
