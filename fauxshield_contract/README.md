# fauxshield_contract

One description of the FauxShield API, extracted from the generated Dart client,
for every SDK that has to speak it.

```bash
# rewrite contract/api_contract.json
dart run fauxshield_contract:extract

# fail (exit 1) when the file is out of date — what CI runs
dart run fauxshield_contract:extract --check
```

## Why it exists

The Node.js and Python SDKs have to call the same API as the Dart SDK. Three
hand-maintained descriptions of the same API drift apart, and the drift is
invisible until a user hits it. The generated Dart client is already a complete,
compiler-checked description of the protocol — every method, parameter, type,
nullability, default, model field, enum value, and error type — so this package
reads it and writes a language-neutral document instead of asking anyone to keep
a second copy up to date.

An OpenAPI document would be the usual answer, and it is the wrong one here:
calls are Serverpod JSON-RPC (`product.list` over the framework's envelope), not
REST resources, so an OpenAPI file would describe the data model while
misstating the transport. See `docs/DEVELOPER_PLATFORM.md` for that decision.

## What it contains

`contract/api_contract.json`, with:

| Section | What it holds |
|---------|---------------|
| `endpoints` | Every endpoint of this API, its methods, their return types and parameters (name, type, nullability, required, default) |
| `models` | Every data model with its fields, types, and the defaults the server applies |
| `enums` | Every enum with its wire values |
| `exceptions` | Every error type and its fields, so another language can map them |
| `sourceHash` | Fingerprint of the generated sources, so a regenerated client is visible in a diff |

Types are written as the API declares them, with the generator's import prefixes
removed: `UuidValue`, `List<Product>`, `String`. Top-level nullability has its
own flag; nested nullability stays in the type (`List<String?>`). `Future<...>`
is unwrapped, because every method returns one.

Framework endpoints that Serverpod bundles into the client — the email IDP and
JWT refresh wrappers — are left out on purpose: they carry types this API does
not define, and an SDK does not have to model them to talk to FauxShield.

## How it is kept honest

- `test/contract_test.dart` checks the extraction against the real client:
  endpoint names, parameter lists, unwrapped futures, defaults read out of the
  generated constructors, enum values, error fields, and that no type carries a
  generator-private name.
- `test/drift_test.dart` fails when the checked-in contract no longer equals a
  fresh extraction — which is what happens the moment `serverpod generate` runs
  and the contract is not refreshed.
- CI runs `dart analyze` and `dart test` here, plus
  `dart run fauxshield_contract:extract --check` as its own step, so a drifted
  contract is a red build rather than a slow surprise in an SDK.

## Using it from another language

Read the JSON in whatever way suits the SDK's build: it is deliberately plain —
arrays of objects, no keys that depend on the reader, no timestamps — so it can
be committed, diffed, and checked into a Node.js or Python package's own build
step. The SDK's own tests are then written against this file, which is how the
same call ends up serialized identically in Dart, Node.js, and Python.
