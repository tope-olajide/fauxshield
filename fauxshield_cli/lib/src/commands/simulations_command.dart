import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fauxshield_client/fauxshield_client.dart';

import '../config.dart';
import '../output.dart';

/// `fauxshield simulations ...`
class SimulationsCommand extends Command<int> {
  SimulationsCommand() {
    addSubcommand(SimulationsListCommand());
    addSubcommand(SimulationsStartCommand());
    addSubcommand(SimulationsShowCommand());
    addSubcommand(SimulationsStepCommand());
    addSubcommand(SimulationsRunCommand());
    addSubcommand(SimulationsCancelCommand());
  }

  @override
  String get name => 'simulations';

  @override
  String get description => 'Rehearse attacks against a copy of the catalogue.';

  @override
  String get invocation =>
      'fauxshield simulations <list|start|show|step|run|cancel>';
}

/// Lists recent simulations.
class SimulationsListCommand extends CliCommand {
  SimulationsListCommand() {
    argParser
      ..addOption('page', help: 'Page number, starting at 1.', defaultsTo: '1')
      ..addOption('page-size', help: 'Rows per page.', defaultsTo: '20');
  }

  @override
  String get name => 'list';

  @override
  String get description => 'List recent simulations.';

  @override
  Future<int> run() async {
    final page = int.tryParse(argResults?['page'] as String? ?? '1') ?? 1;
    final pageSize =
        int.tryParse(argResults?['page-size'] as String? ?? '20') ?? 20;
    final context = connect();
    final List<AttackSimulation> simulations;
    try {
      simulations = await context.client.simulation.list(
        page: (page < 1 ? 1 : page) - 1,
        pageSize: pageSize < 1 ? 20 : pageSize,
      );
    } catch (error) {
      throw CliException('Could not list simulations: ${describeError(error)}');
    }

    if (context.json) {
      printJson(simulations.map((simulation) => simulation.toJson()).toList());
      return 0;
    }

    printTable(
      <String>['LABEL', 'TYPE', 'STATUS', 'PROGRESS', 'CREATED', 'ID'],
      simulations
          .map(
            (simulation) => <String>[
              shorten(simulation.label, max: 24),
              simulation.type.name,
              simulation.status.name,
              '${simulation.progress}/${simulation.totalSteps}',
              formatTime(simulation.createdAt),
              simulation.id?.uuid ?? '-',
            ],
          )
          .toList(),
    );
    stdout.writeln('\n${simulations.length} simulation(s) on page $page.');
    return 0;
  }
}

/// Starts a simulation.
class SimulationsStartCommand extends CliCommand {
  SimulationsStartCommand() {
    argParser
      ..addOption(
        'type',
        abbr: 't',
        help: 'Attack to rehearse: ${_typeNames.join(', ')}.',
      )
      ..addOption('label', abbr: 'l', help: 'Name shown in the command center.')
      ..addOption('batch', abbr: 'b', help: 'Batch to act on.')
      ..addOption('steps', help: 'How many steps to spread the attack over.')
      ..addOption(
        'delay',
        help: 'Seconds between steps when the runner walks it for you.',
        defaultsTo: '0',
      );
  }

  @override
  String get name => 'start';

  @override
  String get description => 'Start a simulated attack.';

  @override
  Future<int> run() async {
    final type = parseEnum(
      requiredOption('type'),
      SimulationType.values,
      '--type',
    );
    final rawBatch = optionalOption('batch');
    final rawSteps = optionalOption('steps');
    final delay = int.tryParse(argResults?['delay'] as String? ?? '0');
    final context = connect();

    final AttackSimulation simulation;
    try {
      simulation = await context.client.simulation.start(
        request: SimulationRequest(
          type: type,
          label: optionalOption('label'),
          batchId: rawBatch == null ? null : parseUuid(rawBatch, '--batch'),
          steps: rawSteps == null ? null : int.tryParse(rawSteps),
          stepDelaySeconds: delay ?? 0,
        ),
      );
    } catch (error) {
      throw CliException(
        'Could not start the simulation: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(simulation.toJson());
      return 0;
    }
    stdout.writeln(
      'Started ${simulation.type.name} (${simulation.status.name}) as '
      '${simulation.id?.uuid}.',
    );
    stdout.writeln(
      'Watch it move with `simulations show --id <id>`, or push it along with '
      '`simulations step`.',
    );
    return 0;
  }
}

/// Shows one simulation.
class SimulationsShowCommand extends CliCommand {
  SimulationsShowCommand() {
    argParser.addOption('id', abbr: 'i', help: 'Simulation id.');
  }

  @override
  String get name => 'show';

  @override
  String get description => 'Show a simulation and its progress.';

  @override
  Future<int> run() async {
    final simulationId = parseUuid(requiredOption('id'), '--id');
    final context = connect();
    final AttackSimulation simulation;
    try {
      simulation = await context.client.simulation.get(simulationId);
    } catch (error) {
      throw CliException(
        'Could not read the simulation: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(simulation.toJson());
      return 0;
    }

    stdout.writeln('${simulation.label} (${simulation.type.name})');
    stdout.writeln('  status:   ${simulation.status.name}');
    stdout.writeln(
      '  progress: ${simulation.progress}/${simulation.totalSteps}',
    );
    stdout.writeln('  created:  ${formatTime(simulation.createdAt)}');
    stdout.writeln('  started:  ${formatTime(simulation.startedAt)}');
    stdout.writeln('  finished: ${formatTime(simulation.completedAt)}');
    if (simulation.summaryJson != null) {
      stdout.writeln(
        '  summary:  ${shorten(simulation.summaryJson, max: 300)}',
      );
    }
    return 0;
  }
}

/// Advances a simulation by one step.
class SimulationsStepCommand extends CliCommand {
  SimulationsStepCommand() {
    argParser.addOption('id', abbr: 'i', help: 'Simulation id.');
  }

  @override
  String get name => 'step';

  @override
  String get description => 'Advance a simulation by one step now.';

  @override
  Future<int> run() async {
    final simulationId = parseUuid(requiredOption('id'), '--id');
    final context = connect();
    final AttackSimulation simulation;
    try {
      simulation = await context.client.simulation.step(simulationId);
    } catch (error) {
      throw CliException(
        'Could not step the simulation: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(simulation.toJson());
      return 0;
    }
    stdout.writeln(
      '${simulation.status.name} at '
      '${simulation.progress}/${simulation.totalSteps}.',
    );
    return 0;
  }
}

/// Runs every remaining step.
class SimulationsRunCommand extends CliCommand {
  SimulationsRunCommand() {
    argParser.addOption('id', abbr: 'i', help: 'Simulation id.');
  }

  @override
  String get name => 'run';

  @override
  String get description => 'Finish a simulation now instead of waiting.';

  @override
  Future<int> run() async {
    final simulationId = parseUuid(requiredOption('id'), '--id');
    final context = connect();
    final AttackSimulation simulation;
    try {
      simulation = await context.client.simulation.run(simulationId);
    } catch (error) {
      throw CliException(
        'Could not run the simulation: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(simulation.toJson());
      return 0;
    }
    stdout.writeln(
      '${simulation.label} finished as ${simulation.status.name}.',
    );
    return 0;
  }
}

/// Cancels a queued or running simulation.
class SimulationsCancelCommand extends CliCommand {
  SimulationsCancelCommand() {
    argParser.addOption('id', abbr: 'i', help: 'Simulation id.');
  }

  @override
  String get name => 'cancel';

  @override
  String get description => 'Cancel a simulation.';

  @override
  Future<int> run() async {
    final simulationId = parseUuid(requiredOption('id'), '--id');
    final context = connect();
    final AttackSimulation simulation;
    try {
      simulation = await context.client.simulation.cancel(simulationId);
    } catch (error) {
      throw CliException(
        'Could not cancel the simulation: ${describeError(error)}',
      );
    }

    if (context.json) {
      printJson(simulation.toJson());
      return 0;
    }
    stdout.writeln('${simulation.label} is ${simulation.status.name}.');
    return 0;
  }
}

/// Every simulation type, for help text.
final List<String> _typeNames = SimulationType.values
    .map((type) => type.name)
    .toList(growable: false);
