/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

enum SimulationStatus implements _is.SerializableModel {
  queued,
  running,
  completed,
  cancelled,
  failed;

  static SimulationStatus fromJson(String name) {
    switch (name) {
      case 'queued':
        return SimulationStatus.queued;
      case 'running':
        return SimulationStatus.running;
      case 'completed':
        return SimulationStatus.completed;
      case 'cancelled':
        return SimulationStatus.cancelled;
      case 'failed':
        return SimulationStatus.failed;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SimulationStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
