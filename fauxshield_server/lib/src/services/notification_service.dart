import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Creates in-app notifications for workspace members.
///
/// Notifications are stored per member and respect per-channel preferences.
/// The live stream is published by the caller so the command center can show
/// the event even before the notification list is refreshed.
abstract final class NotificationService {
  static Future<void> notifyWorkspace(
    Session session, {
    required UuidValue workspaceId,
    required NotificationType type,
    required String title,
    required String body,
    String? targetType,
    UuidValue? targetId,
    AlertSeverity minSeverity = AlertSeverity.low,
  }) async {
    final members = await WorkspaceMember.db.find(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
      limit: 200,
    );
    if (members.isEmpty) return;

    final preferences = await NotificationPreference.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.channel.equals(NotificationChannel.inApp),
    );
    final byUser = <String, NotificationPreference>{};
    for (final preference in preferences) {
      byUser[preference.userIdentifier] = preference;
    }

    final now = DateTime.now().toUtc();
    final rows = <Notification>[];
    for (final member in members) {
      final preference = byUser[member.userIdentifier];
      if (preference != null) {
        if (!preference.enabled) continue;
        if (_severityRank(preference.minSeverity) >
            _severityRank(minSeverity)) {
          continue;
        }
      }
      rows.add(
        Notification(
          workspaceId: workspaceId,
          userIdentifier: member.userIdentifier,
          type: type,
          title: title,
          body: body,
          targetType: targetType,
          targetId: targetId,
          createdAt: now,
        ),
      );
    }
    if (rows.isNotEmpty) {
      await Notification.db.insert(session, rows);
    }
  }

  static int _severityRank(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.low:
        return 0;
      case AlertSeverity.medium:
        return 1;
      case AlertSeverity.high:
        return 2;
      case AlertSeverity.critical:
        return 3;
    }
  }
}
