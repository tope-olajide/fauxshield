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

/// Confirmation shown to a consumer after reporting a suspicious product.
abstract class ReportAcknowledgement
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ReportAcknowledgement._({
    required this.reportId,
    required this.message,
    required this.createdAt,
  });

  factory ReportAcknowledgement({
    required _is.UuidValue reportId,
    required String message,
    required DateTime createdAt,
  }) = _ReportAcknowledgementImpl;

  factory ReportAcknowledgement.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReportAcknowledgement(
      reportId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['reportId'],
      ),
      message: jsonSerialization['message'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _is.UuidValue reportId;

  String message;

  DateTime createdAt;

  /// Returns a shallow copy of this [ReportAcknowledgement]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReportAcknowledgement copyWith({
    _is.UuidValue? reportId,
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
    return _is.SerializationManager.encode(this);
  }
}

class _ReportAcknowledgementImpl extends ReportAcknowledgement {
  _ReportAcknowledgementImpl({
    required _is.UuidValue reportId,
    required String message,
    required DateTime createdAt,
  }) : super._(
         reportId: reportId,
         message: message,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReportAcknowledgement]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReportAcknowledgement copyWith({
    _is.UuidValue? reportId,
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
