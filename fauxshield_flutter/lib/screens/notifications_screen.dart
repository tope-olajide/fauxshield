import 'package:fauxshield_client/fauxshield_client.dart';
import 'package:flutter/material.dart' hide Notification;

import '../app/app_state.dart';
import '../client.dart';
import '../utils/formatting.dart';
import '../widgets/common.dart';

/// In-app notifications plus per-channel preferences.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Notification> _notifications = <Notification>[];
  List<NotificationPreference> _preferences = <NotificationPreference>[];
  bool _onlyUnread = false;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = _notifications.isEmpty;
      _error = null;
    });
    try {
      final workspaceId = widget.controller.workspaceId;
      final results = await Future.wait(<Future<Object>>[
        client.notification.list(
          workspaceId: workspaceId,
          onlyUnread: _onlyUnread,
          page: 0,
          pageSize: 50,
        ),
        client.notification.preferences(workspaceId: workspaceId),
      ]);
      if (!mounted) return;
      setState(() {
        _notifications = results[0] as List<Notification>;
        _preferences = results[1] as List<NotificationPreference>;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error is ApiException ? error.message : error.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Mark all read',
            onPressed: _markAllRead,
            icon: const Icon(Icons.done_all_rounded),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorState(message: _error!, onRetry: _load);
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          SectionCard(
            title: 'Inbox',
            subtitle: '${_notifications.where((n) => !n.read).length} unread',
            trailing: FilterChip(
              label: const Text('Unread only'),
              selected: _onlyUnread,
              onSelected: (value) {
                setState(() => _onlyUnread = value);
                _load();
              },
            ),
            child: _notifications.isEmpty
                ? const Text('Nothing here yet.')
                : Column(
                    children: <Widget>[
                      for (final notification in _notifications)
                        _notificationTile(notification),
                    ],
                  ),
          ),
          SectionCard(
            title: 'Preferences',
            subtitle:
                'Choose which channels may reach you and at what severity.',
            child: _preferences.isEmpty
                ? const Text('No preferences configured yet.')
                : Column(
                    children: <Widget>[
                      for (final preference in _preferences)
                        _preferenceTile(preference),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _notificationTile(Notification notification) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: notification.read
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.primaryContainer,
        child: Icon(
          notification.type == NotificationType.recall
              ? Icons.campaign_rounded
              : (notification.type == NotificationType.fraudAlert
                    ? Icons.gpp_maybe_rounded
                    : Icons.notifications_rounded),
          size: 20,
        ),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.read ? FontWeight.w400 : FontWeight.w700,
        ),
      ),
      subtitle: Text(
        '${notification.body}\n${relativeTime(notification.createdAt)}',
      ),
      isThreeLine: true,
      onTap: notification.read ? null : () => _markRead(notification),
    );
  }

  Widget _preferenceTile(NotificationPreference preference) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              preference.channel == NotificationChannel.email
                  ? 'Email'
                  : 'In-app',
            ),
            subtitle: Text(
              preference.email ??
                  'Minimum severity: ${preference.minSeverity.name}',
            ),
            value: preference.enabled,
            onChanged: (value) => _updatePreference(preference, enabled: value),
          ),
          if (preference.channel == NotificationChannel.email)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Row(
                children: <Widget>[
                  Text(
                    'Minimum severity',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<AlertSeverity>(
                    value: preference.minSeverity,
                    isDense: true,
                    items: <DropdownMenuItem<AlertSeverity>>[
                      for (final severity in AlertSeverity.values)
                        DropdownMenuItem<AlertSeverity>(
                          value: severity,
                          child: Text(severity.name),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _updatePreference(preference, minSeverity: value);
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _markRead(Notification notification) async {
    try {
      await client.notification.markRead(notification.id!);
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          error is ApiException ? error.message : error.toString(),
          error: true,
        );
      }
    }
    _load();
  }

  Future<void> _markAllRead() async {
    try {
      final count = await client.notification.markAllRead(
        workspaceId: widget.controller.workspaceId,
      );
      if (mounted) showMessage(context, '$count notifications marked read.');
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          error is ApiException ? error.message : error.toString(),
          error: true,
        );
      }
    }
    _load();
  }

  Future<void> _updatePreference(
    NotificationPreference preference, {
    bool? enabled,
    AlertSeverity? minSeverity,
  }) async {
    try {
      await client.notification.updatePreference(
        workspaceId: widget.controller.workspaceId,
        channel: preference.channel,
        enabled: enabled ?? preference.enabled,
        minSeverity: minSeverity ?? preference.minSeverity,
        email: preference.email,
      );
      if (mounted) showMessage(context, 'Preference updated.');
    } catch (error) {
      if (mounted) {
        showMessage(
          context,
          error is ApiException ? error.message : error.toString(),
          error: true,
        );
      }
    }
    _load();
  }
}
