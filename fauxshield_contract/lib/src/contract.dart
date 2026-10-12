import 'dart:convert';

/// Version of the contract format itself.
///
/// Bump this when the shape of the document changes, so a reader can tell a
/// format change apart from an API change.
const int contractSchemaVersion = 1;

/// One parameter of an endpoint method, or one field of a model.
class ContractField {
  const ContractField({
    required this.name,
    required this.type,
    required this.nullable,
    this.required = false,
    this.defaultValue,
  });

  final String name;

  /// The declared type, aliases resolved, nested nullability preserved:
  /// `String`, `List<Product>`, `List<String?>`.
  final String type;

  /// Whether the type itself is nullable (`String?`).
  final bool nullable;

  /// Whether a caller must supply it. Model fields are never required: the
  /// server fills in a default, which is what makes them optional on the wire.
  final bool required;

  /// The default the generated code applies, as written in the source.
  final String? defaultValue;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'type': type,
    'nullable': nullable,
    if (required) 'required': true,
    if (defaultValue != null) 'default': defaultValue,
  };

  static ContractField fromJson(Map<String, dynamic> json) => ContractField(
    name: json['name'] as String,
    type: json['type'] as String,
    nullable: json['nullable'] as bool,
    required: json['required'] as bool? ?? false,
    defaultValue: json['default'] as String?,
  );
}

/// One callable method on an endpoint.
class ContractMethod {
  const ContractMethod({
    required this.name,
    required this.returns,
    required this.params,
  });

  /// Method name as the server knows it, for example `list`.
  final String name;

  /// The unwrapped return type: `List<Product>`, not `Future<List<Product>>`.
  final String returns;

  final List<ContractField> params;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'returns': returns,
    'params': params.map((param) => param.toJson()).toList(growable: false),
  };

  static ContractMethod fromJson(Map<String, dynamic> json) => ContractMethod(
    name: json['name'] as String,
    returns: json['returns'] as String,
    params: (json['params'] as List<dynamic>)
        .map((item) => ContractField.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
  );
}

/// One endpoint, with every method the client exposes.
class ContractEndpoint {
  const ContractEndpoint({required this.name, required this.methods});

  /// Endpoint name as it appears on the wire, for example `product`.
  final String name;

  final List<ContractMethod> methods;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'methods': methods.map((method) => method.toJson()).toList(growable: false),
  };

  static ContractEndpoint fromJson(Map<String, dynamic> json) =>
      ContractEndpoint(
        name: json['name'] as String,
        methods: (json['methods'] as List<dynamic>)
            .map(
              (item) => ContractMethod.fromJson(item as Map<String, dynamic>),
            )
            .toList(growable: false),
      );
}

/// One data model the API sends or receives.
class ContractModel {
  const ContractModel({required this.name, required this.fields});

  final String name;
  final List<ContractField> fields;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'fields': fields.map((field) => field.toJson()).toList(growable: false),
  };

  static ContractModel fromJson(Map<String, dynamic> json) => ContractModel(
    name: json['name'] as String,
    fields: (json['fields'] as List<dynamic>)
        .map((item) => ContractField.fromJson(item as Map<String, dynamic>))
        .toList(growable: false),
  );
}

/// One enum and its wire values.
class ContractEnum {
  const ContractEnum({required this.name, required this.values});

  final String name;
  final List<String> values;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'values': values,
  };

  static ContractEnum fromJson(Map<String, dynamic> json) => ContractEnum(
    name: json['name'] as String,
    values: (json['values'] as List<dynamic>).cast<String>(),
  );
}

/// The whole API, as one document.
///
/// This is the single description the Node.js and Python SDKs are built
/// against. It is derived from the generated Dart client — never edited by
/// hand — so it cannot describe something the API does not have.
class ApiContract {
  const ApiContract({
    required this.endpoints,
    required this.models,
    required this.enums,
    this.exceptions = const <ContractModel>[],
    this.sourceHash = '',
  });

  final List<ContractEndpoint> endpoints;
  final List<ContractModel> models;
  final List<ContractEnum> enums;

  /// The error types a call can throw. An SDK that maps them by hand needs to
  /// know their fields, so they travel with the contract.
  final List<ContractModel> exceptions;

  /// Fingerprint of the generated sources this was extracted from.
  ///
  /// The drift test compares it, so a regenerated client with an unchanged
  /// contract still shows up as something to re-run.
  final String sourceHash;

  /// Every endpoint name and method name, for coverage checks.
  Set<String> get methodNames => <String>{
    for (final endpoint in endpoints)
      for (final method in endpoint.methods) '${endpoint.name}.${method.name}',
  };

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': contractSchemaVersion,
    'sourceHash': sourceHash,
    'endpoints': endpoints
        .map((endpoint) => endpoint.toJson())
        .toList(growable: false),
    'models': models.map((model) => model.toJson()).toList(growable: false),
    'enums': enums.map((value) => value.toJson()).toList(growable: false),
    'exceptions': exceptions
        .map((model) => model.toJson())
        .toList(growable: false),
  };

  /// Pretty JSON with a trailing newline, so the file diffs cleanly.
  String encode() =>
      '${const JsonEncoder.withIndent('  ').convert(toJson())}\n';

  static ApiContract decode(String json) {
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    final version = decoded['schemaVersion'] as int?;
    if (version != contractSchemaVersion) {
      throw FormatException(
        'Contract schema version $version does not match '
        '$contractSchemaVersion; regenerate it.',
      );
    }
    return ApiContract(
      endpoints: (decoded['endpoints'] as List<dynamic>)
          .map(
            (item) => ContractEndpoint.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false),
      models: (decoded['models'] as List<dynamic>)
          .map((item) => ContractModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      enums: (decoded['enums'] as List<dynamic>)
          .map((item) => ContractEnum.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      exceptions: (decoded['exceptions'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => ContractModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      sourceHash: decoded['sourceHash'] as String? ?? '',
    );
  }
}
