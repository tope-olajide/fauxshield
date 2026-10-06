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

enum WebhookEventType implements _is.SerializableModel {
  verificationCompleted,
  fraudAlertCreated,
  fraudAlertUpdated,
  batchStatusChanged,
  identityStatusChanged,
  recallIssued,
  fakeReportCreated,
  testEvent;

  static WebhookEventType fromJson(String name) {
    switch (name) {
      case 'verificationCompleted':
        return WebhookEventType.verificationCompleted;
      case 'fraudAlertCreated':
        return WebhookEventType.fraudAlertCreated;
      case 'fraudAlertUpdated':
        return WebhookEventType.fraudAlertUpdated;
      case 'batchStatusChanged':
        return WebhookEventType.batchStatusChanged;
      case 'identityStatusChanged':
        return WebhookEventType.identityStatusChanged;
      case 'recallIssued':
        return WebhookEventType.recallIssued;
      case 'fakeReportCreated':
        return WebhookEventType.fakeReportCreated;
      case 'testEvent':
        return WebhookEventType.testEvent;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "WebhookEventType"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
