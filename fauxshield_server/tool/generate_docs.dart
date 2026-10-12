/// Generates `lib/src/web/docs/api_reference.g.dart` for the docs portal.
///
/// The reference is built from the API contract in
/// `../fauxshield_contract/contract/api_contract.json` — which is itself
/// extracted from the generated Dart client — and from the doc comments on the
/// server's endpoint implementations. The portal therefore describes the API
/// that exists: a method that is not in the contract cannot appear in the
/// reference, and a documented method cannot disappear from the API without
/// this generator changing its output.
///
/// ```bash
/// cd fauxshield_server
/// dart run tool/generate_docs.dart           # write the file
/// dart run tool/generate_docs.dart --check   # fail if it is out of date
/// ```
library;

import 'dart:convert';
import 'dart:io';

/// The doc comment lines that precede a declaration.
final RegExp _docLine = RegExp(r'^\s*///\s?(.*)$');

/// A line that declares something callable: `Future<X> name(`.
final RegExp _signature = RegExp(r'^\s{2}[\w<>,?\. ]+?\s+(\w+)\(');

/// The class declaration of an endpoint.
final RegExp _endpointClass = RegExp(r'^class (\w+Endpoint) extends Endpoint');

void main(List<String> args) {
  final check = args.contains('--check');
  final contractFile = File(
    '../fauxshield_contract/contract/api_contract.json',
  );
  if (!contractFile.existsSync()) {
    stderr.writeln(
      'The API contract is missing at ${contractFile.path}. '
      'Run `dart run bin/extract.dart` in fauxshield_contract first.',
    );
    exit(2);
  }

  final contract =
      jsonDecode(contractFile.readAsStringSync()) as Map<String, dynamic>;
  final endpointDocs = <String, _EndpointDoc>{};
  for (final file in Directory(
    'lib/src/endpoints',
  ).listSync().whereType<File>()) {
    if (!file.path.endsWith('.dart')) continue;
    final parsed = _parseEndpointFile(file.readAsStringSync());
    if (parsed != null) endpointDocs[parsed.name] = parsed;
  }

  final source = _emit(contract, endpointDocs);
  final target = File('lib/src/web/docs/api_reference.g.dart');

  if (check) {
    final current = target.existsSync() ? target.readAsStringSync() : '';
    final generated = _formatInPlace(target, source, restore: true);
    if (current != generated) {
      stderr.writeln(
        'api_reference.g.dart is out of date with the API contract. '
        'Run `dart run tool/generate_docs.dart` in fauxshield_server and commit the result.',
      );
      exit(1);
    }
    stdout.writeln('api_reference.g.dart matches the API contract.');
    return;
  }

  target.parent.createSync(recursive: true);
  target.writeAsStringSync(source);
  _formatInPlace(target, source);
  final endpoints = (contract['endpoints'] as List).length;
  final methods = (contract['endpoints'] as List)
      .expand((endpoint) => (endpoint as Map)['methods'] as List)
      .length;
  stdout.writeln(
    'Wrote ${target.path}: $endpoints endpoints, $methods methods, '
    '${(contract['models'] as List).length} models.',
  );
}

/// The endpoint name, its summary, and the summary of each method.
class _EndpointDoc {
  _EndpointDoc(this.name, this.summary, this.methods);

  final String name;
  final String summary;
  final Map<String, String> methods;
}

/// Reads the doc comments out of one endpoint implementation.
///
/// The class name is the endpoint name — Serverpod derives the wire name from
/// it, so `WebhookAdminEndpoint` is the `webhookAdmin` endpoint. Doc-comment
/// runs are attached to the declaration that follows them, which is either the
/// endpoint class (the endpoint's summary) or a method.
_EndpointDoc? _parseEndpointFile(String source) {
  final lines = source.split('\n');
  final methods = <String, String>{};
  var pending = <String>[];
  String? endpointSummary;
  String? endpointName;

  for (final line in lines) {
    final doc = _docLine.firstMatch(line);
    if (doc != null) {
      pending.add(doc.group(1)!.trim());
      continue;
    }

    if (pending.isNotEmpty) {
      final classMatch = _endpointClass.firstMatch(line);
      if (classMatch != null) {
        endpointSummary = _joinDoc(pending);
        endpointName = _decapitalize(
          classMatch.group(1)!.replaceAll('Endpoint', ''),
        );
      } else {
        final signature = _signature.firstMatch(line);
        if (signature != null) {
          final methodName = signature.group(1)!;
          // Only the first comment for a method is kept, so a documentation
          // comment is never overwritten by a later, unrelated one.
          methods.putIfAbsent(methodName, () => _joinDoc(pending));
        }
      }
    }
    pending = <String>[];
  }

  if (endpointName == null) return null;
  return _EndpointDoc(endpointName, endpointSummary ?? '', methods);
}

String _decapitalize(String value) =>
    value.isEmpty ? value : value[0].toLowerCase() + value.substring(1);

String _joinDoc(List<String> lines) {
  final text = lines
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .join(' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return text;
}

String _emit(Map<String, dynamic> contract, Map<String, _EndpointDoc> docs) {
  final buffer = StringBuffer()
    ..writeln('// GENERATED FILE - do not edit.')
    ..writeln('//')
    ..writeln(
      '// Written by tool/generate_docs.dart from the API contract and the doc',
    )
    ..writeln(
      '// comments on the endpoint implementations. Run that tool after a model or',
    )
    ..writeln('// endpoint change; CI fails when this file is out of date.')
    ..writeln('library;')
    ..writeln()
    ..writeln("import 'docs_model.dart';")
    ..writeln()
    ..writeln(
      '/// Fingerprint of the generated client the contract was read from.',
    )
    ..writeln(
      'const String docsContractSourceHash = ${_string(contract['sourceHash'] ?? '')};',
    )
    ..writeln()
    ..writeln('/// The API, as the documentation portal describes it.')
    ..writeln('final DocsApi docsApi = DocsApi(')
    ..writeln('  endpoints: <DocsEndpoint>[');

  for (final endpoint in contract['endpoints'] as List) {
    final map = endpoint as Map<String, dynamic>;
    final name = map['name'] as String;
    final doc = docs[name];
    buffer
      ..writeln('    DocsEndpoint(')
      ..writeln('      name: ${_string(name)},')
      ..writeln('      title: ${_string(_title(name))},')
      ..writeln('      summary: ${_string(doc?.summary ?? '')},')
      ..writeln('      methods: <DocsMethod>[');
    for (final method in map['methods'] as List) {
      final methodMap = method as Map<String, dynamic>;
      final methodName = methodMap['name'] as String;
      final params = (methodMap['params'] as List).cast<Map<String, dynamic>>();
      buffer
        ..writeln('        DocsMethod(')
        ..writeln('          name: ${_string(methodName)},')
        ..writeln(
          '          returns: ${_string(methodMap['returns'] as String)},',
        )
        ..writeln(
          '          summary: ${_string(doc?.methods[methodName] ?? '')},',
        )
        ..writeln('          params: <DocsParam>[');
      for (final param in params) {
        buffer.writeln('            ${_param(param)},');
      }
      buffer
        ..writeln('          ],')
        ..writeln('        ),');
    }
    buffer
      ..writeln('      ],')
      ..writeln('    ),');
  }

  buffer
    ..writeln('  ],')
    ..writeln('  models: <DocsModel>[');

  for (final model in contract['models'] as List) {
    final map = model as Map<String, dynamic>;
    buffer
      ..writeln('    DocsModel(')
      ..writeln('      name: ${_string(map['name'] as String)},')
      ..writeln('      fields: <DocsParam>[');
    for (final field in (map['fields'] as List).cast<Map<String, dynamic>>()) {
      buffer.writeln('        ${_field(field)},');
    }
    buffer
      ..writeln('      ],')
      ..writeln('    ),');
  }

  buffer
    ..writeln('  ],')
    ..writeln('  enums: <DocsEnum>[');

  for (final value in contract['enums'] as List) {
    final map = value as Map<String, dynamic>;
    final values = (map['values'] as List).cast<String>();
    buffer
      ..writeln('    DocsEnum(')
      ..writeln('      name: ${_string(map['name'] as String)},')
      ..writeln('      values: <String>[${values.map(_string).join(', ')}],')
      ..writeln('    ),');
  }

  buffer
    ..writeln('  ],')
    ..writeln(');')
    ..writeln();

  return buffer.toString();
}

String _param(Map<String, dynamic> json) {
  final parts = <String>[
    'name: ${_string(json['name'] as String)}',
    'type: ${_string(json['type'] as String)}',
    if (json['nullable'] == true) 'nullable: true',
    if (json['required'] == true) 'required: true',
    if (json['default'] != null)
      'defaultValue: ${_string(json['default'] as String)}',
  ];
  return 'DocsParam(${parts.join(', ')})';
}

String _field(Map<String, dynamic> json) {
  final parts = <String>[
    'name: ${_string(json['name'] as String)}',
    'type: ${_string(json['type'] as String)}',
    if (json['nullable'] == true) 'nullable: true',
    if (json['default'] != null)
      'defaultValue: ${_string(json['default'] as String)}',
  ];
  return 'DocsParam(${parts.join(', ')})';
}

/// `webhookAdmin` -> `Webhook admin`, `apiKey` -> `API keys`.
String _title(String name) {
  switch (name) {
    case 'apiKey':
      return 'API keys';
    case 'webhookAdmin':
      return 'Webhooks';
    default:
      final words = name.replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (match) => '${match.group(1)} ${match.group(2)}',
      );
      final capitalized = words[0].toUpperCase() + words.substring(1);
      return capitalized.endsWith('s') ? capitalized : '${capitalized}s';
  }
}

/// Writes [source] to [target], formats it with the SDK's own formatter, and
/// returns the formatted text.
///
/// The formatting happens in place, inside the package, because the formatter
/// reads the language version from the package's own configuration — formatting
/// a copy in a temporary directory would produce a file that `dart format`
/// disagrees with. With [restore], the previous contents (or the absence of the
/// file) are put back, which is what the `--check` mode needs.
String _formatInPlace(File target, String source, {bool restore = false}) {
  final previous = target.existsSync() ? target.readAsStringSync() : null;
  target.parent.createSync(recursive: true);
  target.writeAsStringSync(source);

  final result = Process.runSync(Platform.resolvedExecutable, <String>[
    'format',
    target.path,
  ]);
  if (result.exitCode != 0) {
    stderr.writeln('dart format failed on ${target.path}: ${result.stderr}');
  }
  final formatted = target.readAsStringSync();

  if (restore) {
    if (previous == null) {
      target.deleteSync();
    } else {
      target.writeAsStringSync(previous);
    }
  }
  return formatted;
}

String _string(String value) {
  final escaped = value
      .replaceAll('\\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll('\n', r'\n')
      .replaceAll('\r', '')
      .replaceAll(r'$', r'\$');
  return "'$escaped'";
}
