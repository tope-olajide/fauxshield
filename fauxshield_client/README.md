# fauxshield_client

Dart and Flutter client for the FauxShield anti-counterfeit platform.

It is the generated SDK for the FauxShield Serverpod server: typed models for
products, batches, serialized units, verification sessions, fraud alerts,
recalls, webhooks, simulations, and audit events, plus one endpoint class per
server endpoint. The operator app, the CLI, and the MCP server all talk to the
API through this package, so there is exactly one description of the wire
format.

## Generated code

Everything under `lib/src/protocol/` and the `Client` entry point are written by
`serverpod generate`. **Do not edit them by hand** — the next generation pass
overwrites them. Change the source of truth instead:

| To change | Edit |
|-----------|------|
| A model, field, or enum | `fauxshield_server/lib/src/models/**/*.spy.yaml` |
| A callable operation | `fauxshield_server/lib/src/endpoints/*.dart` |
| Which endpoints exist | `fauxshield_server/lib/server.dart` |

Then regenerate from the server package (`serverpod generate`, or just let
`serverpod start` do it as it watches the files). `analysis_options.yaml`
intentionally excludes `lib/src/protocol/**` from analysis, because generated
files are not written to satisfy this repo's lint set.

## Using it

Add the package. Inside this workspace it is resolved by path, so clients can
depend on it with:

```yaml
dependencies:
  fauxshield_client:
    path: ../fauxshield_client
```

Point a client at a server and, if the calls need an account, give it a
credential:

```dart
import 'package:fauxshield_client/fauxshield_client.dart';

final client = Client('https://fauxshield.api.serverpod.space');

// An API key (fs_live_...) or a session JWT; the server tells them apart.
client.authKeyProvider = BearerTokenProvider('fs_live_...');

final products = await client.product.list();
final batches = await client.batch.list(productId: products.first.id!);
final stats = await client.batch.stats(batches.first.id!);
```

Without a credential the client can still call the consumer flow, which is
unauthenticated by design:

```dart
final presentation = await client.verification.start(token, fingerprint);
```

### Authentication

`BearerTokenProvider` is the one-line provider for both credential kinds. For a
person, exchange an email and password for a session and let the auth module
refresh it:

```dart
final session = await Client(url).emailIdp.login(
  email: email,
  password: password,
);
client.authKeyProvider = BearerTokenProvider(session.token);
```

The operator app wraps all of this in `fauxshield_flutter/lib/client.dart`,
including token refresh and the offline queue, and is the best reference for a
long-lived Flutter client.

### Failures

Refused calls throw the exception models the server declares, all extending
`ApiException` with a `message`: `AuthenticationException`,
`ValidationException`, `ConflictException`, `NotFoundException`,
`RateLimitException`, `ServiceUnavailableException`, and
`VerificationException` for the consumer flow. Transport problems arrive as
`ServerpodClientException` from `serverpod_client`.

```dart
try {
  await client.identity.lock(identityId: id, reason: 'leaked code');
} on AuthenticationException catch (error) {
  // Not signed in, or the key was revoked.
} on ValidationException catch (error) {
  // The server rejected a field; error.field names it.
}
```

## Realtime and offline

- `client.verification.watchWorkspace()` is a stream of live command center
  events: verifications, alerts, recalls, offline ingest, and simulation
  progress.
- `lib/src/protocol/sync_tables.dart` describes the tables the operator app
  keeps locally, so field scans survive without a connection and sync when the
  device is back online.

## Tests

The package is generated, so it is covered from the server side: the server's
suite (`cd fauxshield_server && dart test`) exercises every endpoint through
this client, including the web routes and the demo seeder.

```bash
cd fauxshield_client
dart analyze
```

## Related packages

- [`fauxshield_server`](../fauxshield_server) — the server this describes.
- [`fauxshield_flutter`](../fauxshield_flutter) — operator app.
- [`fauxshield_cli`](../fauxshield_cli) — terminal client.
- [`fauxshield_mcp`](../fauxshield_mcp) — MCP server for AI agents.
