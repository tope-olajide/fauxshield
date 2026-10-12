# FauxShield SDK for Python

`fauxshield-sdk` is the Python client for the FauxShield anti-counterfeit
platform. It speaks the same JSON-RPC API as the operator app, the CLI, and the
Node.js SDK, so products, serialized units, verifications, recalls, and the
fraud queue are all reachable from a Python process.

- **Distribution:** `fauxshield-sdk` — **import:** `fauxshield`
- **Python:** 3.9 and newer
- **Dependencies:** none (standard library only, including the HTTP transport)
- **Default API:** `https://fauxshield.api.serverpod.space`

## Install

```bash
pip install fauxshield-sdk
```

To install the working tree instead, run `pip install ./fauxshield_python` from
the repository root; published versions come from a version tag via
`.github/workflows/release-python.yml`.

## Authenticate

Every request carries either a workspace API key (`fs_live_…`) or a session
token from `fauxshield auth login` in the CLI. The key is read from the
argument, then `FAUXSHIELD_API_KEY`, and it is never written to a log or an
error message.

```bash
export FAUXSHIELD_API_KEY="fs_live_…"
```

## First call

```python
import os

from fauxshield import FauxShieldClient

client = FauxShieldClient(api_key=os.environ["FAUXSHIELD_API_KEY"])

for product in client.product.list(include_archived=False):
    print(product["name"], product["sku"])
```

No base URL is needed: the client already points at the hosted API.

## Pointing at another server

An explicitly supplied `base_url` wins over `FAUXSHIELD_URL`, which wins over
the hosted default — so a local `serverpod start` is one argument away:

```python
from fauxshield import FauxShieldClient

local = FauxShieldClient(
    api_key=os.environ["FAUXSHIELD_API_KEY"],
    base_url="http://localhost:8080",
)
```

```bash
FAUXSHIELD_URL=http://localhost:8080 python run_my_script.py
```

The URL must be `http` or `https` and must not carry a query string or
fragment; anything else raises `FauxShieldConfigError` with the expected shape
in the message.

## What is available

One attribute per API endpoint. Arguments are keyword-only and named as Python
names them; the client maps them back to the wire names, so
`page_size=50` reaches the server as `pageSize`.

| Attribute | Methods |
| --- | --- |
| `client.alert` | `assign`, `evidence`, `get`, `list`, `reports`, `signals`, `triage_report`, `update_status` |
| `client.analytics` | `dashboard`, `rollup_now` |
| `client.api_key` | `create`, `list`, `revoke` |
| `client.audit` | `query` |
| `client.batch` | `create`, `generate_identities`, `get`, `list`, `stats`, `update` |
| `client.demo` | `is_seeded`, `seed` |
| `client.identity` | `delete`, `export`, `get`, `list`, `lock`, `regenerate_token`, `restore`, `reveal_pin`, `unlock` |
| `client.notification` | `list`, `mark_all_read`, `mark_read`, `preferences`, `update_preference` |
| `client.offline` | `convert_now`, `ingest`, `records` |
| `client.product` | `archive`, `create`, `delete`, `delete_impact`, `get`, `list`, `list_deleted`, `purge`, `restore`, `update`, `upload_image` |
| `client.recall` | `lift`, `list`, `recall_batch`, `recall_identity` |
| `client.simulation` | `cancel`, `get`, `list`, `run`, `start`, `step` |
| `client.verification` | `acknowledge`, `get`, `list`, `report_fake`, `result`, `start`, `submit_pin` |
| `client.webhook_admin` | `create`, `delete`, `deliveries`, `drain_now`, `list`, `redeliver`, `rotate_secret`, `test`, `update` |
| `client.workspace` | `accept_invitation`, `bootstrap`, `change_role`, `create`, `invitations`, `invite`, `join_demo`, `members`, `remove_member`, `update` |

There is no hand-written method in the SDK that the API does not have: the
resources are generated from the shared API contract, and
`tests/test_resources.py` fails if that ever stops being true.

## A fuller example

```python
import os

from fauxshield import FauxShieldClient, NotFoundError

client = FauxShieldClient(api_key=os.environ["FAUXSHIELD_API_KEY"])

summary = client.analytics.dashboard(window_days=30)
print("open alerts:", summary["openAlerts"])

alerts = client.alert.list(status="open", page=1, page_size=20)
for alert in alerts:
    print(alert["id"], alert["severity"], alert["title"])

try:
    client.product.get(product_id="00000000-0000-0000-0000-000000000000")
except NotFoundError as error:
    print("no such product:", error.request)
```

## Responses

Responses are the API's JSON, decoded into plain dictionaries and lists. Typed
dictionaries for every model (`Product`, `Batch`, `FraudAlert`, …) and every
enum (`AlertStatus`, `SignalType`, …) are generated under
`fauxshield.generated.models` if you want annotations in your own code:

```python
from fauxshield.generated.models import Product

def name_of(product: Product) -> str:
    return product["name"]
```

## Errors

Everything raised derives from `FauxShieldError`, so one `except` clause is
enough:

| Error | Raised when |
| --- | --- |
| `AuthenticationError` | missing, wrong, or expired credential; denied scope |
| `ValidationError` | the server rejected the arguments; `field` names the offender |
| `NotFoundError` | no such resource, or not visible to this credential |
| `ConflictError` | the change conflicts with current state |
| `RateLimitError` | too many requests; `retry_after` says when to retry |
| `VerificationError` | a consumer verification was refused (wrong PIN, locked unit) |
| `ServiceUnavailableError` | the API cannot serve the request right now |
| `ApiError` | anything else the server answered with |
| `ConnectionError` | the request never reached the API (DNS, TLS, socket) |
| `TimeoutError` | the request ran past `timeout` |
| `FauxShieldConfigError` | the configuration is unusable |

A typed failure arrives as HTTP `400` carrying the exception as the body —
`{"className": "NotFoundException", "data": {"message": "..."}}` — so the error
type is chosen by `className`, and `field` comes straight from the server. The
status code is used only when the body names nothing: `401`/`403` for a missing
credential or a denied scope, `500` when the server itself failed.

Each error carries `status`, `field`, `retry_after`, `request`, `body`, and a
`to_dict()` that is safe to log (it leaves the body out).

## Timeouts and retries

```python
client = FauxShieldClient(
    api_key=os.environ["FAUXSHIELD_API_KEY"],
    timeout=10.0,      # seconds per request
    max_retries=2,     # retries after the first attempt
)
```

Connection failures, timeouts, `429` and `5xx` answers are retried with
exponential backoff, honouring `Retry-After` when the server sends it. A
`ValidationError` or a `NotFoundError` is never retried: a retry cannot fix it.

## Testing your integration

`HttpTransport` takes an `opener` — a callable that performs one request and
returns `(status, body)` — and `FauxShieldClient` takes a `transport`, so a test
needs no network and no monkeypatching:

```python
from fauxshield import FauxShieldClient

class FakeTransport:
    def __init__(self):
        self.calls = []

    def call(self, endpoint, method, params):
        self.calls.append((endpoint, method, params))
        return [{"name": "Coffee", "sku": "C-1"}]

transport = FakeTransport()
client = FauxShieldClient(api_key="fs_live_test", transport=transport)

assert client.product.list(include_archived=False)[0]["sku"] == "C-1"
assert transport.calls == [("product", "list", {"includeArchived": False, "search": None, "workspaceId": None})]
```

The SDK's own tests use exactly this seam: `python -m unittest discover -s tests`
with `PYTHONPATH=src`.

## Versioning

`fauxshield.__version__` and the package metadata move together. The SDK follows
the API: a change that adds an endpoint or a field is a minor release, and
anything that removes or renames one is a major release.

## Links

- Documentation: <https://fauxshield.serverpod.space/docs>
- API reference: <https://fauxshield.serverpod.space/docs#api>
- Source: <https://github.com/tope-olajide/fauxshield>
