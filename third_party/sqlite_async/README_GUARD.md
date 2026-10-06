# Vendored `sqlite_async` (patch for Flutter web builds)

This directory is a copy of `sqlite_async` 0.14.5 from pub.dev, vendored so the
Flutter web app can be compiled.

## The patch

`lib/src/web/worker/worker_utils.dart` declares

```dart
base class AsyncSqliteDatabase extends WorkerDatabase {
```

where upstream 0.14.5 has `class AsyncSqliteDatabase extends WorkerDatabase`.
`WorkerDatabase` is declared `abstract base class` by `sqlite3_web`, so Dart's
class modifier rules require every subclass to also be `base`, `final`, or
`sealed`. Without the modifier, `dart2js` fails the web build with:

```
Error: The type 'AsyncSqliteDatabase' must be 'base', 'final' or 'sealed'
because the supertype 'WorkerDatabase' is 'base'.
```

The class is package-private in practice (`AsyncSqliteDatabase` is only
constructed inside the same file), so marking it `base` is a no-op for callers
and unblocks web compilation.

## Wiring

The workspace root (`fauxshield/pubspec.yaml`) overrides the dependency:

```yaml
dependency_overrides:
  sqlite_async:
    path: third_party/sqlite_async
```

Remove the override once a published `sqlite_async` release carries the
modifier or `serverpod_database` no longer pulls `sqlite_async` into the client.
