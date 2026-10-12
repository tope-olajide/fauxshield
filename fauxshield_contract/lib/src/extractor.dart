import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

import 'contract.dart';

/// Generated files that describe the transport rather than the API.
const Set<String> _plumbingFiles = <String>{
  'protocol.dart',
  'sync_tables.dart',
};

/// Reads the generated Dart client and describes the API it exposes.
///
/// The generated client is the only complete description of this API that
/// already exists: it is compiled against the server's models, so it cannot
/// name a method, parameter, or field the API does not have. Parsing it is how
/// the Node.js and Python SDKs get a contract that stays true — an OpenAPI
/// document would have to be maintained by hand, and this API is Serverpod
/// JSON-RPC rather than REST.
///
/// The parse is syntax-only on purpose: it works without resolving imports, so
/// it runs in a plain `dart test` with no analysis context, and it reads types
/// from the source text. Import prefixes are stripped with
/// [_normalizeType], which is why the extractor keeps the import table.
class ContractExtractor {
  ContractExtractor({required this.clientRoot});

  /// Root of the generated client package, for example `fauxshield_client`.
  final Directory clientRoot;

  Directory get _protocolDirectory =>
      Directory('${clientRoot.path}/lib/src/protocol');

  /// Extracts the contract from the files on disk.
  ApiContract extract() {
    final files =
        _protocolDirectory
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    final endpoints = <ContractEndpoint>[];
    final models = <ContractModel>[];
    final enums = <ContractEnum>[];
    final exceptions = <ContractModel>[];
    final sources = <String>[];

    for (final file in files) {
      final relative = file.path
          .substring(_protocolDirectory.path.length + 1)
          .replaceAll(r'\', '/');
      if (_plumbingFiles.contains(relative)) continue;
      // The endpoint classes are declared in client.dart, next to the client
      // object itself; only their own classes are interesting there.
      final isClientFile = relative == 'client.dart';

      final source = file.readAsStringSync();
      sources.add(source);
      final unit = parseString(
        content: source,
        path: file.path,
        throwIfDiagnostics: false,
      ).unit;
      final aliases = _importAliases(unit);

      for (final declaration in unit.declarations) {
        if (declaration is EnumDeclaration) {
          enums.add(_enum(declaration));
          continue;
        }
        if (declaration is! ClassDeclaration) continue;
        final name = declaration.namePart.typeName.lexeme;
        if (name.startsWith('_')) continue;
        if (_isProjectEndpoint(declaration)) {
          endpoints.add(_endpoint(declaration, aliases));
        } else if (isClientFile) {
          // The auth IDP and JWT refresh endpoints belong to Serverpod rather
          // than this API, and the client and module classes are plumbing; the
          // contract describes what a FauxShield SDK has to implement.
          continue;
        } else if (relative.startsWith('exceptions/')) {
          exceptions.add(_model(declaration, aliases));
        } else if (relative.startsWith('enums/')) {
          // Enums are handled above; a helper class in an enum file is not part
          // of the API surface.
          continue;
        } else if (_isQueryPlumbing(name)) {
          // Serverpod's query layer for a table is generated into the client
          // for its offline sync feature, but it is not a wire model: its
          // fields are database columns, not values the API sends.
          continue;
        } else {
          models.add(_model(declaration, aliases));
        }
      }
    }

    endpoints.sort((a, b) => a.name.compareTo(b.name));
    models.sort((a, b) => a.name.compareTo(b.name));
    enums.sort((a, b) => a.name.compareTo(b.name));
    exceptions.sort((a, b) => a.name.compareTo(b.name));

    return ApiContract(
      endpoints: endpoints,
      models: models,
      enums: enums,
      exceptions: exceptions,
      sourceHash: _fingerprint(sources),
    );
  }

  /// Whether a class belongs to Serverpod's table query layer.
  static bool _isQueryPlumbing(String name) {
    const suffixes = <String>[
      'Table',
      'UpdateTable',
      'Include',
      'IncludeList',
      'Repository',
      'Column',
      'ColumnDefinition',
    ];
    return suffixes.any(name.endsWith);
  }

  /// Whether a class is one of this project's endpoints.
  ///
  /// Serverpod generates a wrapper per endpoint: this project's ones extend
  /// `EndpointRef`, while the bundled auth endpoints extend framework base
  /// classes and carry types an SDK does not have to model.
  static bool _isProjectEndpoint(ClassDeclaration declaration) {
    final clause = declaration.extendsClause?.toSource();
    if (clause == null) return false;
    // Compare the final segment rather than searching for a substring:
    // `EndpointRefreshJwtTokens` contains `EndpointRef` without being one.
    final base = clause.replaceAll(RegExp(r'\s+'), '').split('.').last;
    return base == 'EndpointRef';
  }

  ContractEndpoint _endpoint(
    ClassDeclaration declaration,
    Map<String, String> aliases,
  ) {
    final methods = <ContractMethod>[];
    for (final member in declaration.body.members) {
      if (member is! MethodDeclaration) continue;
      if (member.isGetter || member.isSetter) continue;
      // Endpoint methods all funnel through callServerEndpoint. Anything else
      // is a local helper the generator added, and not part of the API.
      if (!member.toSource().contains('callServerEndpoint')) continue;
      methods.add(
        ContractMethod(
          name: member.name.lexeme,
          returns: _unwrapFuture(
            _normalizeType(member.returnType?.toSource() ?? 'void', aliases),
          ),
          params: _params(member, aliases),
        ),
      );
    }
    methods.sort((a, b) => a.name.compareTo(b.name));

    return ContractEndpoint(
      name:
          _endpointName(declaration) ??
          _snakeCase(declaration.namePart.typeName.lexeme),
      methods: methods,
    );
  }

  /// The endpoint name as the server knows it, read from its `name` getter.
  static String? _endpointName(ClassDeclaration declaration) {
    for (final member in declaration.body.members) {
      if (member is! MethodDeclaration || !member.isGetter) continue;
      if (member.name.lexeme != 'name') continue;
      final match = RegExp(r"""=>\s*'([^']+)'""").firstMatch(member.toSource());
      if (match != null) return match.group(1);
    }
    return null;
  }

  List<ContractField> _params(
    MethodDeclaration method,
    Map<String, String> aliases,
  ) {
    final parameters =
        method.parameters?.parameters ?? const <FormalParameter>[];
    final fields = <ContractField>[];
    for (final parameter in parameters) {
      // `required bool includeArchived`, `UuidValue? workspaceId`,
      // `List<String>? imageUrls = const <String>[]`.
      final match = RegExp(
        r'^(?<required>required\s+)?(?<type>[^=]+?)\s+(?<name>[A-Za-z_]\w*)'
        r'\s*(?:=\s*(?<default>.*))?$',
        dotAll: true,
      ).firstMatch(parameter.toSource().trim());
      if (match == null) continue;

      final declared = _normalizeType(match.namedGroup('type')!, aliases);
      final nullable = declared.endsWith('?');
      final defaultValue = match.namedGroup('default')?.trim();
      fields.add(
        ContractField(
          name: match.namedGroup('name')!,
          // Top-level nullability lives in its own flag so a reader does not
          // have to parse the type; nested nullability stays in the type.
          type: nullable
              ? declared.substring(0, declared.length - 1)
              : declared,
          nullable: nullable,
          // A positional parameter is required unless it carries a default; a
          // named one only when it says `required`.
          required: parameter.isNamed
              ? match.namedGroup('required') != null
              : defaultValue == null,
          defaultValue: defaultValue,
        ),
      );
    }
    return fields;
  }

  ContractModel _model(
    ClassDeclaration declaration,
    Map<String, String> aliases,
  ) {
    final defaults = _defaults(declaration, aliases);
    final fields = <ContractField>[];
    for (final member in declaration.body.members) {
      if (member is! FieldDeclaration) continue;
      final type = member.fields.type?.toSource();
      if (type == null) continue;
      final declared = _normalizeType(type, aliases);
      final nullable = declared.endsWith('?');
      for (final variable in member.fields.variables) {
        final name = variable.name.lexeme;
        if (name.startsWith('_')) continue;
        fields.add(
          ContractField(
            name: name,
            type: nullable
                ? declared.substring(0, declared.length - 1)
                : declared,
            nullable: nullable,
            defaultValue: defaults[name],
          ),
        );
      }
    }
    return ContractModel(
      name: declaration.namePart.typeName.lexeme,
      fields: fields,
    );
  }

  /// Defaults the generated constructor applies, keyed by field name.
  ///
  /// They are written as `field = field ?? 60` in the private constructor's
  /// initializer list, which is where the server's `.spy.yaml` default ends up.
  static Map<String, String> _defaults(
    ClassDeclaration declaration,
    Map<String, String> aliases,
  ) {
    final defaults = <String, String>{};
    for (final member in declaration.body.members) {
      if (member is! ConstructorDeclaration) continue;
      for (final initializer in member.initializers) {
        if (initializer is! ConstructorFieldInitializer) continue;
        final expression = initializer.expression;
        if (expression is! BinaryExpression) continue;
        if (expression.operator.lexeme != '??') continue;
        defaults[initializer.fieldName.name] = _normalizeType(
          expression.rightOperand.toSource(),
          aliases,
        );
      }
    }
    return defaults;
  }

  ContractEnum _enum(EnumDeclaration declaration) => ContractEnum(
    name: declaration.namePart.typeName.lexeme,
    values: declaration.body.constants
        .map((constant) => constant.name.lexeme)
        .toList(growable: false),
  );

  /// Maps the import prefixes in one file to what they point at.
  static Map<String, String> _importAliases(CompilationUnit unit) {
    final aliases = <String, String>{};
    for (final directive in unit.directives) {
      if (directive is! ImportDirective) continue;
      final prefix = directive.prefix?.name;
      final uri = directive.uri.stringValue;
      if (prefix == null || uri == null) continue;
      aliases[prefix] = uri;
    }
    return aliases;
  }

  /// Strips generated import prefixes and tidies whitespace.
  ///
  /// `_i1hi8dz8.Product` becomes `Product`, `_isc.UuidValue` becomes `UuidValue`
  /// and `_ida.Future<List<_i1hi8dz8.Product>>` becomes
  /// `Future<List<Product>>`, so a contract reader in another language sees the
  /// type the API actually speaks instead of the generator's private names.
  static String _normalizeType(String source, Map<String, String> aliases) {
    var type = source.replaceAll(RegExp(r'\s+'), ' ').trim();
    type = type.replaceAll(RegExp(r'\b_[A-Za-z0-9]+\.'), '');
    return type;
  }

  /// Unwraps one `Future<...>` layer: every endpoint call is asynchronous.
  static String _unwrapFuture(String type) {
    if (!type.startsWith('Future<') || !type.endsWith('>')) return type;
    return type.substring('Future<'.length, type.length - 1).trim();
  }

  /// `EndpointWebhookAdmin` to `webhook_admin` for the fallback name.
  static String _snakeCase(String name) {
    final stripped = name.startsWith('Endpoint')
        ? name.substring('Endpoint'.length)
        : name;
    return stripped
        .replaceAllMapped(
          RegExp('([a-z0-9])([A-Z])'),
          (match) => '${match.group(1)}_${match.group(2)}',
        )
        .toLowerCase();
  }

  /// FNV-1a over every source file, so a regenerated client is detectable.
  ///
  /// 32-bit on purpose: Dart's integers are 64-bit two's complement, so a
  /// 64-bit multiply would overflow into negative values, and the fingerprint
  /// only has to change when the sources change.
  static String _fingerprint(List<String> sources) {
    var hash = 0x811c9dc5;
    for (final source in sources) {
      for (final byte in utf8.encode(source)) {
        hash = (hash ^ byte) & 0xFFFFFFFF;
        hash = (hash * 0x01000193) & 0xFFFFFFFF;
      }
    }
    return hash.toRadixString(16).padLeft(8, '0');
  }
}
