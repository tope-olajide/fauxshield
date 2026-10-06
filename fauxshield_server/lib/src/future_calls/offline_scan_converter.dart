import 'package:serverpod/serverpod.dart';

import '../services/offline_ingest_service.dart';

/// Converts offline scans synced to the server into verification sessions.
///
/// Inspector devices queue scans while offline; Serverpod's offline sync
/// mirrors those rows up. This task claims pending rows, runs the full fraud
/// pipeline, and writes the authoritative verdict back to the synced row so
/// it reaches the device on its next sync.
class OfflineScanConverter extends FutureCall {
  Future<void> convert(Session session) async {
    await OfflineIngestService().convertPending(session);
  }
}
