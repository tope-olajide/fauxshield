import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../generated/protocol.dart';
import '../services/offline_ingest_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Offline field scan ingestion.
///
/// Inspector devices queue scans locally while offline. When connectivity
/// returns they either upload them here for immediate verdicts, or let
/// Serverpod's offline sync mirror the rows and the recurring converter
/// process them. Both paths converge on the same server side conversion.
class OfflineEndpoint extends Endpoint {
  /// Uploads a batch of queued scans and returns authoritative verdicts.
  Future<List<OfflineScanVerdict>> ingest(
    Session session, {
    UuidValue? workspaceId,
    required String deviceId,
    required List<OfflineScanInput> scans,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesRead);
    return OfflineIngestService().ingest(
      session,
      workspaceId: context.workspaceId,
      deviceId: deviceId,
      scans: scans,
    );
  }

  /// Lists synced scans for a device, newest first, with their verdicts.
  Future<List<OfflineScanRecord>> records(
    Session session, {
    UuidValue? workspaceId,
    String? deviceId,
    bool onlyPending = false,
    int page = 0,
    int pageSize = 25,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesRead);
    final size = pageSize.clamp(1, FauxShieldLimits.maxPageSize);
    final offset = (page < 0 ? 0 : page) * size;
    return OfflineScanRecord.db.find(
      session,
      where: (t) {
        var expression = t.workspaceId.equals(context.workspaceId);
        if (deviceId != null) {
          expression = expression & t.deviceId.equals(deviceId);
        }
        if (onlyPending) {
          expression = expression & t.processed.equals(false);
        }
        return expression;
      },
      orderBy: (t) => t.scannedAt.desc(),
      limit: size,
      offset: offset,
    );
  }

  /// Converts pending scans immediately instead of waiting for the scheduler.
  Future<int> convertNow(Session session, {UuidValue? workspaceId}) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.identitiesRead);
    return OfflineIngestService().convertPending(session, batchSize: 50);
  }
}
