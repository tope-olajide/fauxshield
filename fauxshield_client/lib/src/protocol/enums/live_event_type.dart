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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

enum LiveEventType implements _isc.SerializableModel {
  verificationCompleted,
  fraudAlertCreated,
  fraudAlertUpdated,
  batchRecalled,
  identityStatusChanged,
  offlineScanIngested,
  simulationProgress,
  fakeReportCreated;

  static LiveEventType fromJson(String name) {
    switch (name) {
      case 'verificationCompleted':
        return LiveEventType.verificationCompleted;
      case 'fraudAlertCreated':
        return LiveEventType.fraudAlertCreated;
      case 'fraudAlertUpdated':
        return LiveEventType.fraudAlertUpdated;
      case 'batchRecalled':
        return LiveEventType.batchRecalled;
      case 'identityStatusChanged':
        return LiveEventType.identityStatusChanged;
      case 'offlineScanIngested':
        return LiveEventType.offlineScanIngested;
      case 'simulationProgress':
        return LiveEventType.simulationProgress;
      case 'fakeReportCreated':
        return LiveEventType.fakeReportCreated;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "LiveEventType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
