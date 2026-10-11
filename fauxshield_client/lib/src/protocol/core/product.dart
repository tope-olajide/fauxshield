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

/// A brand product. Products group manufacturing batches, and each batch holds
/// serialized identities for individual physical units.
abstract class Product
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Product._({
    this.id,
    required this.workspaceId,
    required this.name,
    this.sku,
    this.category,
    this.description,
    this.imageUrls,
    this.packaging,
    this.shelfLife,
    this.countryRestrictions,
    this.safetyInstructions,
    this.createdBy,
    this.archivedAt,
    this.deletedAt,
    this.deletedBy,
    this.deleteReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Product({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String name,
    String? sku,
    String? category,
    String? description,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
    String? createdBy,
    DateTime? archivedAt,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      name: jsonSerialization['name'] as String,
      sku: jsonSerialization['sku'] as String?,
      category: jsonSerialization['category'] as String?,
      description: jsonSerialization['description'] as String?,
      imageUrls: jsonSerialization['imageUrls'] == null
          ? null
          : _iuzkm0gn.Protocol().deserialize<List<String>>(
              jsonSerialization['imageUrls'],
            ),
      packaging: jsonSerialization['packaging'] as String?,
      shelfLife: jsonSerialization['shelfLife'] as String?,
      countryRestrictions: jsonSerialization['countryRestrictions'] == null
          ? null
          : _iuzkm0gn.Protocol().deserialize<List<String>>(
              jsonSerialization['countryRestrictions'],
            ),
      safetyInstructions: jsonSerialization['safetyInstructions'] as String?,
      createdBy: jsonSerialization['createdBy'] as String?,
      archivedAt: jsonSerialization['archivedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['archivedAt'],
            ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      deletedBy: jsonSerialization['deletedBy'] as String?,
      deleteReason: jsonSerialization['deleteReason'] as String?,
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

  _isc.UuidValue workspaceId;

  String name;

  /// Stock keeping unit or internal product code.
  String? sku;

  String? category;

  String? description;

  /// Public image URLs shown on consumer verification pages.
  List<String>? imageUrls;

  /// Packaging description shown to consumers.
  String? packaging;

  /// Shelf life guidance shown to consumers.
  String? shelfLife;

  /// Country codes where this product may not be sold.
  List<String>? countryRestrictions;

  /// Safety and usage instructions shown to consumers.
  String? safetyInstructions;

  String? createdBy;

  DateTime? archivedAt;

  /// Soft delete marker: the product sits in the recycle bin until it is
  /// restored or permanently purged. Null means the product is live.
  DateTime? deletedAt;

  String? deletedBy;

  String? deleteReason;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Product copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workspaceId,
    String? name,
    String? sku,
    String? category,
    String? description,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
    String? createdBy,
    DateTime? archivedAt,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'name': name,
      if (sku != null) 'sku': sku,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (imageUrls != null) 'imageUrls': imageUrls?.toJson(),
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictions != null)
        'countryRestrictions': countryRestrictions?.toJson(),
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      if (createdBy != null) 'createdBy': createdBy,
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy,
      if (deleteReason != null) 'deleteReason': deleteReason,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'name': name,
      if (sku != null) 'sku': sku,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (imageUrls != null) 'imageUrls': imageUrls?.toJson(),
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictions != null)
        'countryRestrictions': countryRestrictions?.toJson(),
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      if (createdBy != null) 'createdBy': createdBy,
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy,
      if (deleteReason != null) 'deleteReason': deleteReason,
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

class _ProductImpl extends Product {
  _ProductImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue workspaceId,
    required String name,
    String? sku,
    String? category,
    String? description,
    List<String>? imageUrls,
    String? packaging,
    String? shelfLife,
    List<String>? countryRestrictions,
    String? safetyInstructions,
    String? createdBy,
    DateTime? archivedAt,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         name: name,
         sku: sku,
         category: category,
         description: description,
         imageUrls: imageUrls,
         packaging: packaging,
         shelfLife: shelfLife,
         countryRestrictions: countryRestrictions,
         safetyInstructions: safetyInstructions,
         createdBy: createdBy,
         archivedAt: archivedAt,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
         deleteReason: deleteReason,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Product copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? workspaceId,
    String? name,
    Object? sku = _Undefined,
    Object? category = _Undefined,
    Object? description = _Undefined,
    Object? imageUrls = _Undefined,
    Object? packaging = _Undefined,
    Object? shelfLife = _Undefined,
    Object? countryRestrictions = _Undefined,
    Object? safetyInstructions = _Undefined,
    Object? createdBy = _Undefined,
    Object? archivedAt = _Undefined,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
    Object? deleteReason = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id is _isc.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      sku: sku is String? ? sku : this.sku,
      category: category is String? ? category : this.category,
      description: description is String? ? description : this.description,
      imageUrls: imageUrls is List<String>?
          ? imageUrls
          : this.imageUrls?.map((e0) => e0).toList(),
      packaging: packaging is String? ? packaging : this.packaging,
      shelfLife: shelfLife is String? ? shelfLife : this.shelfLife,
      countryRestrictions: countryRestrictions is List<String>?
          ? countryRestrictions
          : this.countryRestrictions?.map((e0) => e0).toList(),
      safetyInstructions: safetyInstructions is String?
          ? safetyInstructions
          : this.safetyInstructions,
      createdBy: createdBy is String? ? createdBy : this.createdBy,
      archivedAt: archivedAt is DateTime? ? archivedAt : this.archivedAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is String? ? deletedBy : this.deletedBy,
      deleteReason: deleteReason is String? ? deleteReason : this.deleteReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
