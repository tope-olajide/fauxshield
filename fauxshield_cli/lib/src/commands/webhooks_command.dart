import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield webhooks ...`
class WebhooksCommand extends Command<int> {
  WebhooksCommand() {
    addSubcommand(WebhooksListCommand());
    addSubcommand(WebhooksCreateCommand());
    addSubcommand(WebhooksTestCommand());
    addSubcommand(WebhooksDeliveriesCommand());
    addSubcommand(WebhooksRotateCommand());
    addSubcommand(WebhooksDeleteCommand());
    addSubcommand(WebhooksDrainCommand());
  }

  @override
  String get name => 'webhooks';

  @override
  String get description => 'Manage signed webhook endpoints and deliveries.';

  @override
  String get invocation =>
      'fauxshield webhooks '
      '<list|create|test|deliveries|rotate|delete|drain>';
}

/// Lists the webhook endpoints of the workspace.
class WebhooksListCommand extends CliCommand {
  @override
  String get name => 'list';

  @override
  String get description => 'List webhook endpoints.';

  @override
  Future<int> run() async {
    final context = connect();
    final List<WebhookEndpoint> endpoints;
    try {
      endpoints = await context.client.webhookAdmin.list();
    } catch (error) {
      throw CliException('Could not list webhooks: ${describeError(error)}');
    }

    if (context.json) {
      printJson(endpoints.map((endpoint) => endpoint.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['URL', 'EVENTS', 'STATE', 'FAILS', 'ROTATED', 'ID'],
      endpoints
          .map(
            (endpoint) => <String>[
              shorten(endpoint.url, max: 44),
              endpoint.subscribedEvents.length.toString(),
              endpoint.enabled ? 'enabled' : 'disabled',
              endpoint.consecutiveFailures.toString(),
              formatTime(endpoint.secretRotatedAt),
              endpoint.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${endpoints.length} endpoint(s).');
    return 0;
  }
}

/// Registers a webhook endpoint.
class WebhooksCreateCommand extends CliCommand {
  WebhooksCreateCommand() {
    argParser
      ..addOption(
        'endpoint',
        abbr: 'u',
        help: 'HTTPS URL that receives events. `--url` is the server.',
        valueHelp: 'https://example.test/hooks/fauxshield',
      )
      ..addOption(
        'events',
        abbr: 'e',
        help: 'Comma separated events: ${_eventNames.join(', ')}.',
        defaultsTo: 'fraudAlertCreated,recallIssued',
      )
      ..addOption('description', abbr: 'd', help: 'What this endpoint is for.');
  }

  @override
  String get name => 'create';

  @override
  String get description => 'Register a webhook endpoint and print its secret.';

  @override
  Future<int> run() async {
    final url = requiredOption('endpoint');
    final events = parseEnumList(
      argResults?['events'] as String? ?? '',
      WebhookEventType.values,
      '--events',
    );
    final context = connect();
    final WebhookEndpointSecret created;
    try {
      created = await context.client.webhookAdmin.create(
        url: url,
        events: events,
        description: optionalOption('description'),
      );
    } catch (error) {
      throw CliException(
        'Could not create the webhook: ${describeError(error)}',
      );
    }

    if (context.json) {
      // The signing secret is only ever returned here, so JSON output keeps it
      // for pipelines that store it in a secret manager.
      printJson(created.toJson());
      return 0;
    }

    stdout.writeln('Created webhook ${created.endpoint.id?.uuid}');
    stdout.writeln('  url:    ${created.endpoint.url}');
    stdout.writeln(
      '  events: ${created.endpoint.subscribedEvents.map((e) => e.name).join(', ')}',
    );
    stdout.writeln('  secret: ${created.secret}');
    stdout.writeln('\n${created.warning}');
    stdout.writeln(
      'Verify each delivery with HMAC-SHA256 over the raw body using that '
      'secret.',
    );
    return 0;
  }
}

/// Sends a signed test delivery.
class WebhooksTestCommand extends CliCommand {
  WebhooksTestCommand() {
    argParser.addOption('id', abbr: 'i', help: 'Endpoint id.');
  }

  @override
  String get name => 'test';

  @override
  String get description => 'Send a signed test event and report the result.';

  @override
  Future<int> run() async {
    final endpointId = parseUuid(requiredOption('id'), '--id');
    final context = connect();
    final WebhookTestResult result;
    try {
      result = await context.client.webhookAdmin.test(endpointId: endpointId);
    } catch (error) {
      throw CliException('Could not send the test: ${describeError(error)}');
    }

    if (context.json) {
      printJson(result.toJson());
      return 0;
    }

    stdout.writeln(result.success ? 'Delivered.' : 'Delivery failed.');
    if (result.statusCode != null) {
      stdout.writeln('  status: ${result.statusCode}');
    }
    if (result.responseTimeMs != null) {
      stdout.writeln('  time:   ${result.responseTimeMs}ms');
    }
    if (result.error != null) stdout.writeln('  error:  ${result.error}');
    return result.success ? 0 : exitFailure;
  }
}

/// Lists recent deliveries for an endpoint.
class WebhooksDeliveriesCommand extends CliCommand {
  WebhooksDeliveriesCommand() {
    argParser
      ..addOption('id', abbr: 'i', help: 'Endpoint id.')
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '25');
  }

  @override
  String get name => 'deliveries';

  @override
  String get description => 'List recent deliveries for an endpoint.';

  @override
  Future<int> run() async {
    final endpointId = parseUuid(requiredOption('id'), '--id');
    final page = int.tryParse(argResults?['page'] as String? ?? '1') ?? 1;
    final pageSize =
        int.tryParse(argResults?['page-size'] as String? ?? '25') ?? 25;
    final context = connect();
    final List<WebhookDelivery> deliveries;
    try {
      deliveries = await context.client.webhookAdmin.deliveries(
        endpointId: endpointId,
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 25 : pageSize,
      );
    } catch (error) {
      throw CliException('Could not list deliveries: ${describeError(error)}');
    }

    if (context.json) {
      printJson(deliveries.map((delivery) => delivery.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['EVENT', 'STATUS', 'TRIES', 'HTTP', 'WHEN', 'ID'],
      deliveries
          .map(
            (delivery) => <String>[
              delivery.eventType.name,
              delivery.status.name,
              '${delivery.attemptCount}/${delivery.maxAttempts}',
              delivery.lastHttpStatus?.toString() ?? '-',
              formatTime(delivery.createdAt),
              delivery.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${deliveries.length} delivery(ies) on page $page.');
    return 0;
  }
}

/// Rotates the signing secret.
class WebhooksRotateCommand extends CliCommand {
  WebhooksRotateCommand() {
    argParser.addOption('id', abbr: 'i', help: 'Endpoint id.');
  }

  @override
  String get name => 'rotate';

  @override
  String get description => 'Rotate the signing secret of an endpoint.';

  @override
  Future<int> run() async {
    final endpointId = parseUuid(requiredOption('id'), '--id');
    final context = connect();
    final WebhookEndpointSecret rotated;
    try {
      rotated = await context.client.webhookAdmin.rotateSecret(
        endpointId: endpointId,
      );
    } catch (error) {
      throw CliException(
        'Could not rotate the secret: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(rotated.toJson());
      return 0;
    }

    stdout.writeln('New secret: ${rotated.secret}');
    stdout.writeln(
      '\n${rotated.warning} Update the receiving service before the overlap '
      'window closes.',
    );
    return 0;
  }
}

/// Disables an endpoint.
class WebhooksDeleteCommand extends CliCommand {
  WebhooksDeleteCommand() {
    argParser
      ..addOption('id', abbr: 'i', help: 'Endpoint id.')
      ..addFlag(
        'yes',
        abbr: 'y',
        negatable: false,
        help: 'Skip the confirmation prompt.',
      );
  }

  @override
  String get name => 'delete';

  @override
  String get description => 'Delete a webhook endpoint.';

  @override
  Future<int> run() async {
    final endpointId = parseUuid(requiredOption('id'), '--id');
    final context = connect();

    if (!confirmDestructive(
      argResults?['yes'] as bool? ?? false,
      'Delete webhook $endpointId? Events stop being delivered to it.',
    )) {
      stdout.writeln('Cancelled.');
      return 0;
    }

    final WebhookEndpoint deleted;
    try {
      deleted = await context.client.webhookAdmin.delete(
        endpointId: endpointId,
      );
    } catch (error) {
      throw CliException(
        'Could not delete the webhook: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(deleted.toJson());
      return 0;
    }
    stdout.writeln('Deleted webhook ${deleted.id?.uuid}.');
    return 0;
  }
}

/// Drains the delivery outbox right now.
class WebhooksDrainCommand extends CliCommand {
  @override
  String get name => 'drain';

  @override
  String get description =>
      'Deliver queued webhook events now instead of waiting for the timer.';

  @override
  Future<int> run() async {
    final context = connect();
    final int sent;
    try {
      sent = await context.client.webhookAdmin.drainNow();
    } catch (error) {
      throw CliException('Could not drain the outbox: ${describeError(error)}');
    }

    if (context.json) {
      printJson(<String, dynamic>{'delivered': sent});
    } else {
      stdout.writeln('Delivered $sent queued event(s).');
    }
    return 0;
  }
}

/// Every webhook event name, for help text.
final List<String> _eventNames = WebhookEventType.values
    .map((event) => event.name)
    .toList(growable: false);
