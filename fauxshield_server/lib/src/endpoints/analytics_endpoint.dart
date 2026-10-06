import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../services/analytics_service.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// Dashboard analytics for the command center.
class AnalyticsEndpoint extends Endpoint {
  /// Builds the dashboard payload for the last [windowDays] days.
  Future<DashboardSummary> dashboard(
    Session session, {
    UuidValue? workspaceId,
    int windowDays = 14,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.analyticsRead);
    return AnalyticsService.dashboard(
      session,
      workspaceId: context.workspaceId,
      windowDays: windowDays,
    );
  }

  /// Recomputes one day's rollup on demand. Defaults to today.
  Future<DailyWorkspaceStat> rollupNow(
    Session session, {
    UuidValue? workspaceId,
    DateTime? day,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.analyticsRead);
    final target = day?.toUtc() ?? DateTime.now().toUtc();
    return AnalyticsService.rollupDay(
      session,
      workspaceId: context.workspaceId,
      day: DateTime.utc(target.year, target.month, target.day),
    );
  }
}
