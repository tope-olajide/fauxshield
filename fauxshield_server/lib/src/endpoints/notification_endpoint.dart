import 'package:serverpod/serverpod.dart';

import '../core/constants.dart';
import '../generated/protocol.dart';
import '../services/rbac.dart';
import '../services/workspace_service.dart';

/// In-app notifications and per-member preferences.
class NotificationEndpoint extends Endpoint {
  /// Lists notifications for the signed-in member.
  Future<List<Notification>> list(
    Session session, {
    UuidValue? workspaceId,
    bool onlyUnread = false,
    int page = 0,
    int pageSize = 25,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.verificationsRead);
    final size = pageSize.clamp(1, FauxShieldLimits.maxPageSize);
    final offset = (page < 0 ? 0 : page) * size;
    return Notification.db.find(
      session,
      where: (t) {
        var expression =
            t.workspaceId.equals(context.workspaceId) &
            t.userIdentifier.equals(context.userIdentifier);
        if (onlyUnread) {
          expression = expression & t.read.equals(false);
        }
        return expression;
      },
      orderBy: (t) => t.createdAt.desc(),
      limit: size,
      offset: offset,
    );
  }

  /// Marks one notification as read.
  Future<Notification> markRead(
    Session session,
    UuidValue notificationId,
  ) async {
    final notification = await Notification.db.findById(
      session,
      notificationId,
    );
    if (notification == null) {
      throw NotFoundException(
        message: 'Notification not found.',
        resource: 'notification',
      );
    }
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: notification.workspaceId,
    );
    WorkspaceService.require(context, Permission.verificationsRead);
    if (notification.userIdentifier != context.userIdentifier) {
      throw AuthenticationException(
        message: 'This notification belongs to another member.',
        reason: 'forbidden',
      );
    }
    return Notification.db.updateRow(
      session,
      notification.copyWith(read: true),
    );
  }

  /// Marks every unread notification for the member as read.
  Future<int> markAllRead(Session session, {UuidValue? workspaceId}) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.verificationsRead);
    final unread = await Notification.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(context.workspaceId) &
          t.userIdentifier.equals(context.userIdentifier) &
          t.read.equals(false),
      limit: 500,
    );
    for (final notification in unread) {
      await Notification.db.updateRow(
        session,
        notification.copyWith(read: true),
      );
    }
    return unread.length;
  }

  /// Lists the member's notification preferences.
  Future<List<NotificationPreference>> preferences(
    Session session, {
    UuidValue? workspaceId,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.verificationsRead);
    return NotificationPreference.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(context.workspaceId) &
          t.userIdentifier.equals(context.userIdentifier),
    );
  }

  /// Creates or updates one channel preference.
  Future<NotificationPreference> updatePreference(
    Session session, {
    UuidValue? workspaceId,
    required NotificationChannel channel,
    bool enabled = true,
    AlertSeverity minSeverity = AlertSeverity.low,
    String? email,
  }) async {
    final context = await WorkspaceService.contextFor(
      session,
      workspaceId: workspaceId,
    );
    WorkspaceService.require(context, Permission.verificationsRead);
    final existing = await NotificationPreference.db.findFirstRow(
      session,
      where: (t) =>
          t.workspaceId.equals(context.workspaceId) &
          t.userIdentifier.equals(context.userIdentifier) &
          t.channel.equals(channel),
    );
    final now = DateTime.now().toUtc();
    if (existing == null) {
      return NotificationPreference.db.insertRow(
        session,
        NotificationPreference(
          workspaceId: context.workspaceId,
          userIdentifier: context.userIdentifier,
          channel: channel,
          enabled: enabled,
          minSeverity: minSeverity,
          email: email,
          updatedAt: now,
        ),
      );
    }
    return NotificationPreference.db.updateRow(
      session,
      existing.copyWith(
        enabled: enabled,
        minSeverity: minSeverity,
        email: email ?? existing.email,
        updatedAt: now,
      ),
    );
  }
}
