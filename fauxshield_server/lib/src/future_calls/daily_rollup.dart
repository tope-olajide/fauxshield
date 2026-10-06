import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/analytics_service.dart';

/// Materializes daily analytics rollups for every workspace.
///
/// Today and yesterday are both recomputed so late writes land in the right
/// bucket. The dashboard reads these rollups and stays fast at billions of
/// verification rows.
class DailyRollup extends FutureCall {
  Future<void> rollup(Session session) async {
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final workspaces = await Workspace.db.find(
      session,
      orderBy: (t) => t.createdAt,
      limit: 500,
    );
    for (final workspace in workspaces) {
      final workspaceId = workspace.id!;
      await AnalyticsService.rollupDay(
        session,
        workspaceId: workspaceId,
        day: today,
      );
      await AnalyticsService.rollupDay(
        session,
        workspaceId: workspaceId,
        day: yesterday,
      );
    }
  }
}
