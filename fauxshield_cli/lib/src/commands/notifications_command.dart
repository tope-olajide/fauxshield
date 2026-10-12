import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield notifications ...`
class NotificationsCommand extends Command<int> {
  NotificationsCommand() {
    addSubcommand(NotificationsListCommand());
    addSubcommand(NotificationsReadCommand());
    addSubcommand(NotificationsReadAllCommand());
    addSubcommand(NotificationsPreferencesCommand());
    addSubcommand(NotificationsSetPreferenceCommand());
  }

  @override
  String get name => 'notifications';

  @override
  String get description => 'Read the inbox and set alerting preferences.';

  @override
  String get invocation =>
      'fauxshield notifications <list|read|read-all|preferences|set>';
}

/// Lists notifications.
class NotificationsListCommand extends CliCommand {
  NotificationsListCommand() {
    argParser
      ..addFlag(
        'unread',
        abbr: 'u',
        negatable: false,
        help: 'Only show notifications that have not been read.',
      )
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '25');
  }

  @override
  String get name => 'list';

  @override
  String get description => 'List notifications for the signed-in account.';

  @override
  Future<int> run() async {
    final page = int.tryParse(argResults?['page'] as String? ?? '1') ?? 1;
    final pageSize =
        int.tryParse(argResults?['page-size'] as String? ?? '25') ?? 25;
    final context = connect();
    final List<Notification> notifications;
    try {
      notifications = await context.client.notification.list(
        onlyUnread: argResults?['unread'] as bool? ?? false,
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 25 : pageSize,
      );
    } catch (error) {
      throw CliException(
        'Could not list notifications: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(notifications.map((item) => item.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['WHEN', 'TYPE', 'TITLE', 'READ', 'ID'],
      notifications
          .map(
            (item) => <String>[
              formatTime(item.createdAt),
              item.type.name,
              shorten(item.title, max: 40),
              yesNo(item.read),
              item.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${notifications.length} notification(s) on page $page.');
    return 0;
  }
}

/// Marks one notification as read.
class NotificationsReadCommand extends CliCommand {
  NotificationsReadCommand() {
    argParser.addOption('id', abbr: 'i', help: 'Notification id.');
  }

  @override
  String get name => 'read';

  @override
  String get description => 'Mark one notification as read.';

  @override
  Future<int> run() async {
    final notificationId = parseUuid(requiredOption('id'), '--id');
    final context = connect();
    final Notification notification;
    try {
      notification = await context.client.notification.markRead(notificationId);
    } catch (error) {
      throw CliException(
        'Could not mark the notification: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(notification.toJson());
      return 0;
    }
    stdout.writeln('Marked "${notification.title}" as read.');
    return 0;
  }
}

/// Marks everything as read.
class NotificationsReadAllCommand extends CliCommand {
  @override
  String get name => 'read-all';

  @override
  String get description => 'Mark every notification as read.';

  @override
  Future<int> run() async {
    final context = connect();
    final int count;
    try {
      count = await context.client.notification.markAllRead();
    } catch (error) {
      throw CliException(
        'Could not mark the notifications: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(<String, dynamic>{'markedRead': count});
    } else {
      stdout.writeln('Marked $count notification(s) as read.');
    }
    return 0;
  }
}

/// Shows the alerting preferences of the account.
class NotificationsPreferencesCommand extends CliCommand {
  @override
  String get name => 'preferences';

  @override
  String get description => 'Show how alerts and digests reach you.';

  @override
  Future<int> run() async {
    final context = connect();
    final List<NotificationPreference> preferences;
    try {
      preferences = await context.client.notification.preferences();
    } catch (error) {
      throw CliException(
        'Could not read preferences: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(preferences.map((item) => item.toJson()).toList());
      return 0;
    }

    if (preferences.isEmpty) {
      stdout.writeln(
        'No overrides: everything follows the workspace default '
        '(in-app alerts for medium severity and up).',
      );
      return 0;
    }

    printTable(
      <String>['CHANNEL', 'STATE', 'MIN SEVERITY', 'EMAIL'],
      preferences
          .map(
            (item) => <String>[
              item.channel.name,
              item.enabled ? 'on' : 'off',
              item.minSeverity.name,
              item.email ?? '-',
            ],
          )
          .toList(),
    );
    return 0;
  }
}

/// Sets one alerting preference.
class NotificationsSetPreferenceCommand extends CliCommand {
  NotificationsSetPreferenceCommand() {
    argParser
      ..addOption(
        'channel',
        abbr: 'c',
        help: 'Channel: inApp or email.',
      )
      ..addOption(
        'min-severity',
        abbr: 's',
        help: 'Lowest severity that notifies you: low, medium, high, critical.',
        defaultsTo: 'medium',
      )
      ..addOption('email', abbr: 'e', help: 'Address for the email channel.')
      ..addFlag(
        'off',
        negatable: false,
        help: 'Turn the channel off instead of on.',
      );
  }

  @override
  String get name => 'set';

  @override
  String get description => 'Turn a notification channel on or off.';

  @override
  Future<int> run() async {
    final channel = parseEnum(
      requiredOption('channel'),
      NotificationChannel.values,
      '--channel',
    );
    final minSeverity = parseEnum(
      argResults?['min-severity'] as String? ?? 'medium',
      AlertSeverity.values,
      '--min-severity',
    );
    final context = connect();
    final NotificationPreference preference;
    try {
      preference = await context.client.notification.updatePreference(
        channel: channel,
        enabled: !(argResults?['off'] as bool? ?? false),
        minSeverity: minSeverity,
        email: optionalOption('email'),
      );
    } catch (error) {
      throw CliException(
        'Could not save the preference: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(preference.toJson());
      return 0;
    }
    stdout.writeln(
      '${preference.channel.name} is ${preference.enabled ? 'on' : 'off'} '
      'from ${preference.minSeverity.name} severity.',
    );
    return 0;
  }
}
