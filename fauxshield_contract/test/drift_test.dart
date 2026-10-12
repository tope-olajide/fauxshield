import 'dart:io';

import 'package:fauxshield_contract/fauxshield_contract.dart';
import 'package:test/test.dart';

void main() {
  final root = findWorkspaceRoot();

  group('Given the checked-in API contract', () {
    test('it matches a fresh extraction of the generated client', () {
      final file = File('${root.path}/$contractPath');
      expect(
        file.existsSync(),
        isTrue,
        reason: 'run: dart run fauxshield_contract:extract',
      );

      final extracted = ContractExtractor(
        clientRoot: Directory('${root.path}/fauxshield_client'),
      ).extract();

      expect(
        file.readAsStringSync(),
        extracted.encode(),
        reason:
            'The generated client changed without the contract following it, '
            'which is how the Node.js and Python SDKs start describing an API '
            'that no longer exists. Run: dart run fauxshield_contract:extract',
      );
    });

    test('the fingerprint it records comes from the client on disk', () {
      final checkedIn = ApiContract.decode(
        File('${root.path}/$contractPath').readAsStringSync(),
      );
      final extracted = ContractExtractor(
        clientRoot: Directory('${root.path}/fauxshield_client'),
      ).extract();

      expect(checkedIn.sourceHash, extracted.sourceHash);
      expect(checkedIn.sourceHash, isNotEmpty);
      expect(
        checkedIn.methodNames,
        extracted.methodNames,
        reason: 'a stale contract would describe a different set of methods',
      );
    });
  });
}
