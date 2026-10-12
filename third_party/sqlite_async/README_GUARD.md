# Vendored `sqlite_async` — obsolete, no longer wired in

This directory is a copy of `sqlite_async` 0.14.5 from pub.dev, with one line
patched so `dart2js` would accept it. **Nothing depends on it any more**: the
workspace resolves `sqlite_async` from pub.dev, and a release web build of the
unpatched package is byte-identical to the build made with this copy.

## The patch

`lib/src/web/worker/worker_utils.dart` declares

```dart
base class AsyncSqliteDatabase extends WorkerDatabase {
```

where upstream 0.14.5 has `class AsyncSqliteDatabase extends WorkerDatabase`.
`WorkerDatabase` is declared `abstract base class` by `sqlite3_web` 0.9.5 and
later, so Dart's class modifier rules require every subclass to also be `base`,
`final`, or `sealed`, and `dart2js` fails the web build with:

```
Error: The type 'AsyncSqliteDatabase' must be 'base', 'final' or 'sealed'
because the supertype 'WorkerDatabase' is 'base'.
```

## Why the patch is no longer needed

`sqlite3_web` only became `base` in 0.9.5. `serverpod_database` 4.0.4 pins

```yaml
  # sqlite3_web 0.9.5 made WorkerDatabase base, which sqlite_async 0.14.5
  # does not compile against.
  sqlite3_web: '>=0.9.4 <0.9.5'
```

so the workspace resolves `sqlite3_web` 0.9.4, where
`lib/src/database.dart` still declares `abstract class WorkerDatabase` — plain
`abstract`, no `base` modifier. Upstream `sqlite_async` 0.14.5 therefore
compiles as published, and `flutter build web --release --base-href /app/`
succeeds without this copy in the graph.

`sqlite_async` 0.14.6 carries the modifier upstream, but it requires
`sqlite3_web: ^0.9.5`, which cannot be satisfied while `serverpod_database`
pins `<0.9.5`. Until that pin lifts, 0.14.5 is the version to use.

## Why the override must not come back

The patch used to be wired up with a path override (`dependency_overrides:
sqlite_async: path: ...`). Do not reinstate it. A path override makes
`pubspec.lock` record a *path* source for `sqlite_async`, and Serverpod Cloud
builds the server from a filtered workspace:

- it regenerates the root `pubspec.yaml` with only the workspace packages the
  **server** depends on (here: `fauxshield_server`), and it uploads only that
  package plus the root `pubspec.yaml`/`pubspec.lock` and `.scloud/`;
- `third_party/` is therefore never uploaded, so a root-level path override
  fails with `depends on sqlite_async from path which doesn't exist`;
- and even from a workspace member, where the override resolves locally, the
  uploaded lockfile still says `path: third_party/sqlite_async` while the cloud
  pubspec has no override, so the build dies in
  `dart pub get --enforce-lockfile` with `Unable to satisfy ../pubspec.yaml
  using ../pubspec.lock`.

If the class-modifier problem ever returns (for example, `serverpod_database`
stops pinning `sqlite3_web`, and something resolves `sqlite3_web` >= 0.9.5 while
`sqlite_async` is < 0.14.6), prefer moving `sqlite_async` to a release that
carries the modifier — a hosted fix keeps the lockfile cloud-deployable.
Vendoring again is the last resort.
