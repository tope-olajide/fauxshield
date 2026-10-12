import 'dart:io';

import 'package:fauxshield_contract/fauxshield_contract.dart';
import 'package:test/test.dart';

/// The endpoints this API exposes, as the client declares them.
const List<String> _endpointNames = <String>[
  'alert',
  'analytics',
  'apiKey',
  'audit',
  'batch',
  'demo',
  'identity',
  'notification',
  'offline',
  'product',
  'recall',
  'simulation',
  'verification',
  'webhookAdmin',
  'workspace',
];

void main() {
  final root = findWorkspaceRoot();
  final clientRoot = Directory('${root.path}/fauxshield_client');
  final contract = ContractExtractor(clientRoot: clientRoot).extract();

  ContractMethod method(String endpoint, String name) => contract.endpoints
      .firstWhere((value) => value.name == endpoint)
      .methods
      .firstWhere((value) => value.name == name);

  ContractField param(String endpoint, String name, String paramName) => method(
    endpoint,
    name,
  ).params.firstWhere((value) => value.name == paramName);

  group('Given the extracted contract', () {
    test('describes every endpoint of this API and nothing else', () {
      expect(
        contract.endpoints.map((endpoint) => endpoint.name).toList(),
        _endpointNames,
      );
    });

    test('describes the methods of an endpoint with their signatures', () {
      expect(
        method('product', 'list').returns,
        'List<Product>',
        reason: 'the Future wrapper is unwrapped: every call is a request',
      );
      expect(
        method('product', 'list').params.map((param) => param.name),
        <String>['workspaceId', 'search', 'includeArchived'],
      );
      expect(param('product', 'list', 'includeArchived').required, isTrue);
      expect(param('product', 'list', 'workspaceId').required, isFalse);
      expect(param('product', 'list', 'workspaceId').nullable, isTrue);
      expect(param('product', 'list', 'workspaceId').type, 'UuidValue');
    });

    test('marks positional parameters as required', () {
      final productId = param('product', 'get', 'productId');

      expect(productId.required, isTrue);
      expect(productId.type, 'UuidValue');
    });

    test('keeps nested nullability in the type', () {
      final countryRestrictions = param(
        'product',
        'create',
        'countryRestrictions',
      );

      expect(countryRestrictions.type, 'List<String>');
      expect(countryRestrictions.nullable, isTrue);
    });

    test('names no generator-private type', () {
      final types = <String>[];
      for (final endpoint in contract.endpoints) {
        for (final value in endpoint.methods) {
          types.add(value.returns);
          types.addAll(value.params.map((param) => param.type));
        }
      }
      for (final model in contract.models) {
        types.addAll(model.fields.map((field) => field.type));
      }

      for (final type in types) {
        expect(
          type,
          isNot(matches(RegExp(r'_[A-Za-z0-9]+\.'))),
          reason: 'import prefixes belong to the generator, not the contract',
        );
      }
    });

    test('records the defaults the server applies', () {
      final policy = contract.models.firstWhere(
        (model) => model.name == 'FraudPolicy',
      );
      String defaultOf(String field) => policy.fields
          .firstWhere((value) => value.name == field)
          .defaultValue!;

      expect(defaultOf('velocityThreshold'), '10');
      expect(defaultOf('pinAttackThreshold'), '5');
      expect(defaultOf('autoLockOnFraud'), 'true');
      expect(defaultOf('cloneDistanceThresholdKm'), '100');
    });

    test('records enums with their wire values', () {
      final signalType = contract.enums.firstWhere(
        (value) => value.name == 'SignalType',
      );

      expect(signalType.values, contains('pinAttack'));
      expect(signalType.values, contains('batchDuplication'));
    });

    test('records the error types a caller has to map', () {
      final names = contract.exceptions.map((model) => model.name).toList();
      List<String> fieldsOf(String name) => contract.exceptions
          .firstWhere((model) => model.name == name)
          .fields
          .map((field) => field.name)
          .toList();

      expect(names, contains('ValidationException'));
      expect(names, contains('NotFoundException'));
      // The shared fields live on the base type, and each subtype adds the ones
      // that tell a caller what to do about it.
      expect(
        fieldsOf('ApiException'),
        containsAll(<String>['message', 'code']),
      );
      expect(fieldsOf('ValidationException'), contains('field'));
      expect(fieldsOf('AuthenticationException'), contains('reason'));
    });

    test('every name it states exists in the generated client', () {
      final source = File(
        '${clientRoot.path}/lib/src/protocol/client.dart',
      ).readAsStringSync();

      for (final endpoint in contract.endpoints) {
        expect(source, contains("'${endpoint.name}'"));
        for (final value in endpoint.methods) {
          expect(
            source,
            contains("'${value.name}'"),
            reason: '${endpoint.name}.${value.name}',
          );
        }
      }
    });
  });
}
