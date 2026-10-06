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

/// A generated export such as an identity CSV. Exports are bounded so a single
/// call cannot exhaust server resources.
abstract class ExportFile
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ExportFile._({
    required this.filename,
    required this.mimeType,
    required this.content,
    required this.rowCount,
    required this.truncated,
  });

  factory ExportFile({
    required String filename,
    required String mimeType,
    required String content,
    required int rowCount,
    required bool truncated,
  }) = _ExportFileImpl;

  factory ExportFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExportFile(
      filename: jsonSerialization['filename'] as String,
      mimeType: jsonSerialization['mimeType'] as String,
      content: jsonSerialization['content'] as String,
      rowCount: jsonSerialization['rowCount'] as int,
      truncated: _is.BoolJsonExtension.fromJson(jsonSerialization['truncated']),
    );
  }

  String filename;

  String mimeType;

  String content;

  int rowCount;

  bool truncated;

  /// Returns a shallow copy of this [ExportFile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ExportFile copyWith({
    String? filename,
    String? mimeType,
    String? content,
    int? rowCount,
    bool? truncated,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExportFile',
      'filename': filename,
      'mimeType': mimeType,
      'content': content,
      'rowCount': rowCount,
      'truncated': truncated,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExportFile',
      'filename': filename,
      'mimeType': mimeType,
      'content': content,
      'rowCount': rowCount,
      'truncated': truncated,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ExportFileImpl extends ExportFile {
  _ExportFileImpl({
    required String filename,
    required String mimeType,
    required String content,
    required int rowCount,
    required bool truncated,
  }) : super._(
         filename: filename,
         mimeType: mimeType,
         content: content,
         rowCount: rowCount,
         truncated: truncated,
       );

  /// Returns a shallow copy of this [ExportFile]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ExportFile copyWith({
    String? filename,
    String? mimeType,
    String? content,
    int? rowCount,
    bool? truncated,
  }) {
    return ExportFile(
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      content: content ?? this.content,
      rowCount: rowCount ?? this.rowCount,
      truncated: truncated ?? this.truncated,
    );
  }
}
