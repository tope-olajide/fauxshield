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
import 'package:fauxshield_client/src/protocol/protocol.dart' as _iuzkm0gn;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../core/branding.dart' as _i1x92ga0;
import '../core/fraud_policy.dart' as _ikma2fzo;

/// A workspace is the tenant boundary for brands. All product, identity,
/// verification, fraud, and audit data is scoped to exactly one workspace.
abstract class Workspace
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Workspace._({
    this.id,
    required this.name,
    required this.slug,
    this.branding,
    this.authenticMessage,
    this.restrictedCountries,
    this.fraudPolicy,
    bool? demoMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : demoMode = demoMode ?? false,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Workspace({
    _isc.UuidValue? id,
    required String name,
    required String slug,
    _i1x92ga0.Branding? branding,
    String? authenticMessage,
    List<String>? restrictedCountries,
    _ikma2fzo.FraudPolicy? fraudPolicy,
    bool? demoMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WorkspaceImpl;

  factory Workspace.fromJson(Map<String, dynamic> jsonSerialization) {
    return Workspace(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      slug: jsonSerialization['slug'] as String,
      branding: jsonSerialization['branding'] == null
          ? null
          : _iuzkm0gn.Protocol().deserialize<_i1x92ga0.Branding>(
              jsonSerialization['branding'],
            ),
      authenticMessage: jsonSerialization['authenticMessage'] as String?,
      restrictedCountries: jsonSerialization['restrictedCountries'] == null
          ? null
          : _iuzkm0gn.Protocol().deserialize<List<String>>(
              jsonSerialization['restrictedCountries'],
            ),
      fraudPolicy: jsonSerialization['fraudPolicy'] == null
          ? null
          : _iuzkm0gn.Protocol().deserialize<_ikma2fzo.FraudPolicy>(
              jsonSerialization['fraudPolicy'],
            ),
      demoMode: jsonSerialization['demoMode'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['demoMode']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  /// Human readable workspace name.
  String name;

  /// URL friendly unique slug used in links.
  String slug;

  /// Brand presentation for consumer facing pages.
  _i1x92ga0.Branding? branding;

  /// Message shown to consumers when a product verifies as authentic.
  String? authenticMessage;

  /// ISO country codes where this brand's products may not be sold.
  List<String>? restrictedCountries;

  /// Fraud detection thresholds for this workspace.
  _ikma2fzo.FraudPolicy? fraudPolicy;

  /// When true the workspace is a public demo and may be reset by anyone.
  bool demoMode;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Workspace copyWith({
    _isc.UuidValue? id,
    String? name,
    String? slug,
    _i1x92ga0.Branding? branding,
    String? authenticMessage,
    List<String>? restrictedCountries,
    _ikma2fzo.FraudPolicy? fraudPolicy,
    bool? demoMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Workspace',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'slug': slug,
      if (branding != null) 'branding': branding?.toJson(),
      if (authenticMessage != null) 'authenticMessage': authenticMessage,
      if (restrictedCountries != null)
        'restrictedCountries': restrictedCountries?.toJson(),
      if (fraudPolicy != null) 'fraudPolicy': fraudPolicy?.toJson(),
      'demoMode': demoMode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Workspace',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'slug': slug,
      if (branding != null) 'branding': branding?.toJsonForProtocol(),
      if (authenticMessage != null) 'authenticMessage': authenticMessage,
      if (restrictedCountries != null)
        'restrictedCountries': restrictedCountries?.toJson(),
      if (fraudPolicy != null) 'fraudPolicy': fraudPolicy?.toJsonForProtocol(),
      'demoMode': demoMode,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceImpl extends Workspace {
  _WorkspaceImpl({
    _isc.UuidValue? id,
    required String name,
    required String slug,
    _i1x92ga0.Branding? branding,
    String? authenticMessage,
    List<String>? restrictedCountries,
    _ikma2fzo.FraudPolicy? fraudPolicy,
    bool? demoMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         name: name,
         slug: slug,
         branding: branding,
         authenticMessage: authenticMessage,
         restrictedCountries: restrictedCountries,
         fraudPolicy: fraudPolicy,
         demoMode: demoMode,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Workspace copyWith({
    Object? id = _Undefined,
    String? name,
    String? slug,
    Object? branding = _Undefined,
    Object? authenticMessage = _Undefined,
    Object? restrictedCountries = _Undefined,
    Object? fraudPolicy = _Undefined,
    bool? demoMode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Workspace(
      id: id is _isc.UuidValue? ? id : this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      branding: branding is _i1x92ga0.Branding?
          ? branding
          : this.branding?.copyWith(),
      authenticMessage: authenticMessage is String?
          ? authenticMessage
          : this.authenticMessage,
      restrictedCountries: restrictedCountries is List<String>?
          ? restrictedCountries
          : this.restrictedCountries?.map((e0) => e0).toList(),
      fraudPolicy: fraudPolicy is _ikma2fzo.FraudPolicy?
          ? fraudPolicy
          : this.fraudPolicy?.copyWith(),
      demoMode: demoMode ?? this.demoMode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
