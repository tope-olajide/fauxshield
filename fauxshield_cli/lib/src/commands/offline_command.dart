import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield offline ...`
class OfflineCommand extends Command<int> {
  OfflineCommand() {
    addSubcommand(OfflineRecordsCommand());
    addSubcommand(OfflineIngestCommand());
    addSubcommand(OfflineConvertCommand());
  }

  @override
  String get name => 'offline';

  @override
  String get description => 'Sync scans captured by a device with no signal.';

  @override
  String get invocation => 'fauxshield offline <records|ingest|convert>';
}

/// Lists the scans a device uploaded.
class OfflineRecordsCommand extends CliCommand {
  OfflineRecordsCommand() {
    argParser
      ..addOption('device', abbr: 'd', help: 'Only records from this device.')
      ..addFlag(
        'pending',
        negatable: false,
        help: 'Only records that have not been turned into sessions yet.',
      )
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '25');
  }

  @override
  String get name => 'records';

  @override
  String get description => 'List uploaded offline scan records.';

  @override
  Future<int> run() async {
    final page = int.tryParse(argResults?['page'] as String? ?? '1') ?? 1;
    final pageSize =
        int.tryParse(argResults?['page-size'] as String? ?? '25') ?? 25;
    final context = connect();
    final List<OfflineScanRecord> records;
    try {
      records = await context.client.offline.records(
        deviceId: optionalOption('device'),
        onlyPending: argResults?['pending'] as bool? ?? false,
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 25 : pageSize,
      );
    } catch (error) {
      throw CliException('Could not list records: ${describeError(error)}');
    }

    if (context.json) {
      printJson(records.map((record) => record.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['SCANNED', 'DEVICE', 'PROVISIONAL', 'VERDICT', 'PLACE', 'ID'],
      records
          .map(
            (record) => <String>[
              formatTime(record.scannedAt),
              shorten(record.deviceId, max: 16),
              record.provisionalOutcome ?? '-',
              record.processed ? 'converted' : 'pending',
              shorten(
                <String?>[
                  record.city,
                  record.country,
                ].whereType<String>().join(', '),
                max: 18,
              ),
              record.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${records.length} record(s) on page $page.');
    return 0;
  }
}

/// Uploads a batch of offline scans, the way the field device does.
class OfflineIngestCommand extends CliCommand {
  OfflineIngestCommand() {
    argParser
      ..addOption(
        'device',
        abbr: 'd',
        help: 'Device that captured the scans.',
      )
      ..addOption(
        'file',
        abbr: 'f',
        help:
            'JSON file holding a list of scans, or `-` to read stdin. Each '
            'entry: localId, qrToken, scannedAt, and optionally latitude, '
            'longitude, country, city, and provisionalOutcome.',
      )
      ..addOption(
        'device-fingerprint',
        help: 'Fingerprint to attach to the scans.',
      );
  }

  @override
  String get name => 'ingest';

  @override
  String get description =>
      'Upload scans captured offline and get their verdicts back.';

  @override
  Future<int> run() async {
    final deviceId = requiredOption('device');
    final path = requiredOption('file');
    final raw = path == '-' ? _readStdin() : File(path).readAsStringSync();
    final scans = _parseScans(raw, deviceId);

    final context = connect();
    final List<OfflineScanVerdict> verdicts;
    try {
      verdicts = await context.client.offline.ingest(
        deviceId: deviceId,
        scans: scans,
      );
    } catch (error) {
      throw CliException('Could not upload the scans: ${describeError(error)}');
    }

    if (context.json) {
      printJson(verdicts.map((verdict) => verdict.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['LOCAL ID', 'OUTCOME', 'RISK', 'MESSAGE'],
      verdicts
          .map(
            (verdict) => <String>[
              shorten(verdict.localId, max: 20),
              verdict.outcome?.name ?? '-',
              verdict.riskScore?.name ?? '-',
              shorten(verdict.message, max: 44),
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${verdicts.length} scan(s) accepted.');
    return 0;
  }

  /// Reads everything piped in, so a multi-line JSON file works too.
  static String _readStdin() {
    final buffer = StringBuffer();
    while (true) {
      final line = stdin.readLineSync(encoding: utf8);
      if (line == null) break;
      buffer.writeln(line);
    }
    return buffer.toString();
  }

  /// Reads the scan list, naming the offending entry rather than the whole file.
  List<OfflineScanInput> _parseScans(String raw, String deviceId) {
    Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException catch (error) {
      throw CliException.usage('That file is not JSON: ${error.message}');
    }
    if (decoded is! List || decoded.isEmpty) {
      throw CliException.usage('The file must hold a non-empty JSON array.');
    }

    final scans = <OfflineScanInput>[];
    for (var index = 0; index < decoded.length; index++) {
      final entry = decoded[index];
      if (entry is! Map) {
        throw CliException.usage('Entry $index is not an object.');
      }
      final localId = entry['localId'];
      final qrToken = entry['qrToken'];
      final scannedAt = entry['scannedAt'];
      if (localId is! String || qrToken is! String) {
        throw CliException.usage(
          'Entry $index needs string `localId` and `qrToken` fields.',
        );
      }
      final scanned = scannedAt is String ? DateTime.tryParse(scannedAt) : null;
      if (scanned == null) {
        throw CliException.usage(
          'Entry $index needs an ISO 8601 `scannedAt` timestamp.',
        );
      }
      scans.add(
        OfflineScanInput(
          localId: localId,
          deviceId: deviceId,
          deviceFingerprint: optionalOption('device-fingerprint'),
          qrToken: qrToken,
          scannedAt: scanned.toUtc(),
          latitude: _number(entry['latitude']),
          longitude: _number(entry['longitude']),
          country: entry['country'] is String
              ? entry['country'] as String
              : null,
          city: entry['city'] is String ? entry['city'] as String : null,
          provisionalOutcome: entry['provisionalOutcome'] is String
              ? entry['provisionalOutcome'] as String
              : null,
        ),
      );
    }
    return scans;
  }

  /// Reads a JSON number that may arrive as an int or a double.
  static double? _number(Object? value) {
    if (value is num) return value.toDouble();
    return null;
  }
}

/// Converts queued records into verification sessions right now.
class OfflineConvertCommand extends CliCommand {
  @override
  String get name => 'convert';

  @override
  String get description =>
      'Turn pending offline scans into verification sessions now.';

  @override
  Future<int> run() async {
    final context = connect();
    final int converted;
    try {
      converted = await context.client.offline.convertNow();
    } catch (error) {
      throw CliException(
        'Could not convert the records: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(<String, dynamic>{'converted': converted});
    } else {
      stdout.writeln('Converted $converted offline scan(s).');
    }
    return 0;
  }
}
