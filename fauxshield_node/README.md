# fauxshield — Node.js and TypeScript SDK

Typed access to the FauxShield API from Node.js: products, manufacturing
batches, serialized units, consumer verifications, the fraud queue, recalls,
webhooks, simulations, and the audit log.

```bash
npm install fauxshield
```

## Quickstart

```ts
import { FauxShieldClient } from 'fauxshield';

const client = new FauxShieldClient({ apiKey: process.env.FAUXSHIELD_API_KEY });

// Products, newest state first.
const products = await client.product.list({ includeArchived: false });

// One unit, by the id the list returned.
const batch = await client.batch.stats({ batchId: products[0]!.batches[0]!.id! });
console.log(batch.active, batch.flagged);
```

Every call returns a promise, every argument object is typed, and every response
is the model the API sent — the fields are the same names the API uses.

## The API URL

Nothing has to be configured: the SDK talks to the hosted API,
`https://fauxshield.api.serverpod.space`, unless it is told otherwise.

| Where the URL comes from | Priority |
|--------------------------|----------|
| `baseUrl` passed to the constructor | highest |
| `FAUXSHIELD_URL` environment variable | |
| the built-in hosted default | lowest |

Pointing at a local server during development:

```ts
const local = new FauxShieldClient({
  apiKey: process.env.FAUXSHIELD_API_KEY,
  baseUrl: 'http://localhost:8080',
});
```

A base URL must be `http` or `https` and must not carry a query string or
fragment; anything else is refused when the client is built, with a message that
says what to change.

## Credentials

An API key (`fs_live_...`) or a session JWT, passed as `apiKey` or set in
`FAUXSHIELD_API_KEY`. Keys are never logged, never included in an error message,
and masked if one ever ends up inside a URL by mistake. Create keys in the
operator app under **Settings → API keys**, with the narrowest scopes the
integration needs.

## Errors

One base class, one subclass per case, so `catch` can be as broad or as narrow
as the caller wants:

| Error | `code` | Raised when |
|-------|--------|-------------|
| `AuthenticationError` | `authentication` | Missing, wrong, or expired credential; denied scope |
| `ValidationError` | `validation` | The server rejected the arguments; `field` names the offender |
| `NotFoundError` | `not_found` | The resource does not exist or is not visible to this credential |
| `ConflictError` | `conflict` | The change conflicts with current state |
| `RateLimitError` | `rate_limit` | Too many requests; `retryAfterSeconds` says when to retry |
| `ServiceUnavailableError` | `service_unavailable` | The API cannot serve the request right now |
| `VerificationError` | `verification` | A consumer verification was refused: wrong PIN, locked unit, expired session |
| `ApiError` | `api_error` | Anything else the server answered with |
| `TimeoutError` | `timeout` | The request ran past `timeoutMs`, default 30 s |
| `ConnectionError` | `connection` | The request never reached the API |

A typed failure arrives as HTTP `400` with the exception as the body
(`{ className, data: { message, code, ... } }`), so the subclass is chosen by
`className` and `field` comes straight from the server. The status code is only
consulted when the body names nothing — `401`/`403` for a missing credential or
a denied scope, `500` when the server itself failed.

```ts
import { NotFoundError, RateLimitError, ValidationError } from 'fauxshield';

try {
  await client.product.create({ name: 'Olive Oil', sku: 'OO-1L' });
} catch (error) {
  if (error instanceof ValidationError) console.error(error.field, error.message);
  else if (error instanceof RateLimitError) await sleep(error.retryAfterSeconds! * 1000);
  else if (error instanceof NotFoundError) console.error('gone');
  else throw error;
}
```

## Retries and timeouts

Connection failures, timeouts, `429`, `5xx`, and a plain `500` are retried with a
short backoff, honouring `Retry-After` when the server sends one. Everything
else is raised immediately, because a retry cannot fix it.

```ts
const client = new FauxShieldClient({
  apiKey: process.env.FAUXSHIELD_API_KEY,
  timeoutMs: 60_000, // a 1000-unit batch generation runs long
  maxRetries: 3,
});
```

`fetch` can be replaced — for a proxy, an environment without the global, or a
test double:

```ts
const client = new FauxShieldClient({ apiKey: 'fs_live_…', fetch: myFetch });
```

## Where the types come from

`src/generated/` is produced by `npm run generate` from
`../fauxshield_contract/contract/api_contract.json`, which is itself extracted
from the server's generated Dart client. That chain is why this SDK cannot
describe a method, parameter, or model field the API does not have, and why a
call that type-checks here is a call the server accepts.

Regenerate after the API changes:

```bash
# in fauxshield_contract
dart run fauxshield_contract:extract
# in fauxshield_node
npm run generate
```

## Development

```bash
npm install
npm test        # builds with tsc, then runs the tests
npm run build   # TypeScript -> dist/
```

The tests cover the base URL rules, the error mapping, the wire protocol
(including retries and timeouts) against a fake `fetch`, and every one of the
86 methods in the contract reaching the endpoint it claims to.
