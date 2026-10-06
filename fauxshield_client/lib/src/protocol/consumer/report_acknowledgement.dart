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

/// Confirmation shown to a consumer after reporting a suspicious product.
abstract class ReportAcknowledgement
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReportAcknowledgement._({
    required this.reportId,
    required this.message,
    required this.createdAt,
  });

  factory ReportAcknowledgement({
    required _isc.UuidValue reportId,
    required String message,
    required DateTime createdAt,
  }) = _ReportAcknowledgementImpl;

  factory ReportAcknowledgement.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReportAcknowledgement(
      reportId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['reportId'],
      ),
      message: jsonSerialization['message'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _isc.UuidValue reportId;

  String message;

  DateTime createdAt;

  /// Returns a shallow copy of this [ReportAcknowledgement]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReportAcknowledgement copyWith({
    _isc.UuidValue? reportId,
    String? message,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportAcknowledgement',
      'reportId': reportId.toJson(),
      'message': message,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportAcknowledgement',
      'reportId': reportId.toJson(),
      'message': message,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ReportAcknowledgementImpl extends ReportAcknowledgement {
  _ReportAcknowledgementImpl({
    required _isc.UuidValue reportId,
    required String message,
    required DateTime createdAt,
  }) : super._(
         reportId: reportId,
         message: message,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReportAcknowledgement]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReportAcknowledgement copyWith({
    _isc.UuidValue? reportId,
    String? message,
    DateTime? createdAt,
  }) {
    return ReportAcknowledgement(
      reportId: reportId ?? this.reportId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
