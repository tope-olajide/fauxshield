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
import 'package:fauxshield_server/src/generated/protocol.dart' as _ipgzzizd;
import 'package:serverpod/serverpod.dart' as _is;
import '../offline/inspector_catalog_entry.dart' as _ieg77an1;

/// A snapshot of the catalog an inspector device needs for offline field work.
abstract class InspectorCatalog
    implements _is.SerializableModel, _is.ProtocolSerialization {
  InspectorCatalog._({
    required this.workspaceId,
    required this.generatedAt,
    required this.entries,
  });

  factory InspectorCatalog({
    required _is.UuidValue workspaceId,
    required DateTime generatedAt,
    required List<_ieg77an1.InspectorCatalogEntry> entries,
  }) = _InspectorCatalogImpl;

  factory InspectorCatalog.fromJson(Map<String, dynamic> jsonSerialization) {
    return InspectorCatalog(
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      generatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      entries: _ipgzzizd.Protocol()
          .deserialize<List<_ieg77an1.InspectorCatalogEntry>>(
            jsonSerialization['entries'],
          ),
    );
  }

  _is.UuidValue workspaceId;

  DateTime generatedAt;

  List<_ieg77an1.InspectorCatalogEntry> entries;

  /// Returns a shallow copy of this [InspectorCatalog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  InspectorCatalog copyWith({
    _is.UuidValue? workspaceId,
    DateTime? generatedAt,
    List<_ieg77an1.InspectorCatalogEntry>? entries,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InspectorCatalog',
      'workspaceId': workspaceId.toJson(),
      'generatedAt': generatedAt.toJson(),
      'entries': entries.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InspectorCatalog',
      'workspaceId': workspaceId.toJson(),
      'generatedAt': generatedAt.toJson(),
      'entries': entries.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _InspectorCatalogImpl extends InspectorCatalog {
  _InspectorCatalogImpl({
    required _is.UuidValue workspaceId,
    required DateTime generatedAt,
    required List<_ieg77an1.InspectorCatalogEntry> entries,
  }) : super._(
         workspaceId: workspaceId,
         generatedAt: generatedAt,
         entries: entries,
       );

  /// Returns a shallow copy of this [InspectorCatalog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  InspectorCatalog copyWith({
    _is.UuidValue? workspaceId,
    DateTime? generatedAt,
    List<_ieg77an1.InspectorCatalogEntry>? entries,
  }) {
    return InspectorCatalog(
      workspaceId: workspaceId ?? this.workspaceId,
      generatedAt: generatedAt ?? this.generatedAt,
      entries: entries ?? this.entries.map((e0) => e0.copyWith()).toList(),
    );
  }
}
