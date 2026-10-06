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

/// A brand product. Products group manufacturing batches, and each batch holds
/// serialized identities for individual physical units.
abstract class Product
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Product({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      name: jsonSerialization['name'] as String,
      sku: jsonSerialization['sku'] as String?,
      category: jsonSerialization['category'] as String?,
      description: jsonSerialization['description'] as String?,
      imageUrls: jsonSerialization['imageUrls'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<List<String>>(
              jsonSerialization['imageUrls'],
            ),
      packaging: jsonSerialization['packaging'] as String?,
      shelfLife: jsonSerialization['shelfLife'] as String?,
      countryRestrictions: jsonSerialization['countryRestrictions'] == null
          ? null
          : _ipgzzizd.Protocol().deserialize<List<String>>(
              jsonSerialization['countryRestrictions'],
            ),
      safetyInstructions: jsonSerialization['safetyInstructions'] as String?,
      createdBy: jsonSerialization['createdBy'] as String?,
      archivedAt: jsonSerialization['archivedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['archivedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = ProductTable();

  static const db = ProductRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

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

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Product copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
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
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static ProductInclude include() {
    return ProductInclude._();
  }

  static ProductIncludeList includeList({
    _is.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    ProductInclude? include,
  }) {
    return ProductIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductImpl extends Product {
  _ProductImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
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
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Product copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id is _is.UuidValue? ? id : this.id,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProductUpdateTable extends _is.UpdateTable<ProductTable> {
  ProductUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> sku(String? value) => _is.ColumnValue(
    table.sku,
    value,
  );

  _is.ColumnValue<String, String> category(String? value) => _is.ColumnValue(
    table.category,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> imageUrls(List<String>? value) =>
      _is.ColumnValue(
        table.imageUrls,
        value,
      );

  _is.ColumnValue<String, String> packaging(String? value) => _is.ColumnValue(
    table.packaging,
    value,
  );

  _is.ColumnValue<String, String> shelfLife(String? value) => _is.ColumnValue(
    table.shelfLife,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> countryRestrictions(
    List<String>? value,
  ) => _is.ColumnValue(
    table.countryRestrictions,
    value,
  );

  _is.ColumnValue<String, String> safetyInstructions(String? value) =>
      _is.ColumnValue(
        table.safetyInstructions,
        value,
      );

  _is.ColumnValue<String, String> createdBy(String? value) => _is.ColumnValue(
    table.createdBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> archivedAt(DateTime? value) =>
      _is.ColumnValue(
        table.archivedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class ProductTable extends _is.Table<_is.UuidValue?> {
  ProductTable({super.tableRelation}) : super(tableName: 'product') {
    updateTable = ProductUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    sku = _is.ColumnString(
      'sku',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    imageUrls = _is.ColumnSerializable<List<String>>(
      'imageUrls',
      this,
    );
    packaging = _is.ColumnString(
      'packaging',
      this,
    );
    shelfLife = _is.ColumnString(
      'shelfLife',
      this,
    );
    countryRestrictions = _is.ColumnSerializable<List<String>>(
      'countryRestrictions',
      this,
    );
    safetyInstructions = _is.ColumnString(
      'safetyInstructions',
      this,
    );
    createdBy = _is.ColumnString(
      'createdBy',
      this,
    );
    archivedAt = _is.ColumnDateTime(
      'archivedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
      hasDefault: true,
    );
  }

  late final ProductUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnString name;

  /// Stock keeping unit or internal product code.
  late final _is.ColumnString sku;

  late final _is.ColumnString category;

  late final _is.ColumnString description;

  /// Public image URLs shown on consumer verification pages.
  late final _is.ColumnSerializable<List<String>> imageUrls;

  /// Packaging description shown to consumers.
  late final _is.ColumnString packaging;

  /// Shelf life guidance shown to consumers.
  late final _is.ColumnString shelfLife;

  /// Country codes where this product may not be sold.
  late final _is.ColumnSerializable<List<String>> countryRestrictions;

  /// Safety and usage instructions shown to consumers.
  late final _is.ColumnString safetyInstructions;

  late final _is.ColumnString createdBy;

  late final _is.ColumnDateTime archivedAt;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    name,
    sku,
    category,
    description,
    imageUrls,
    packaging,
    shelfLife,
    countryRestrictions,
    safetyInstructions,
    createdBy,
    archivedAt,
    createdAt,
    updatedAt,
  ];
}

class ProductInclude extends _is.IncludeObject {
  ProductInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Product.t;
}

class ProductIncludeList extends _is.IncludeList {
  ProductIncludeList._({
    _is.WhereExpressionBuilder<ProductTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Product.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Product.t;
}

class ProductRepository {
  const ProductRepository._();

  /// Returns a list of [Product]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Product>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Product>(
      where: where?.call(Product.t),
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Product] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Product?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductTable>? where,
    int? offset,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Product>(
      where: where?.call(Product.t),
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Product] by its [id] or null if no such row exists.
  Future<Product?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Product>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Product]s in the list and returns the inserted rows.
  ///
  /// The returned [Product]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> insert(
    _is.DatabaseSession session,
    List<Product> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Product>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Product] and returns the inserted row.
  ///
  /// The returned [Product] will have its `id` field set.
  Future<Product> insertRow(
    _is.DatabaseSession session,
    Product row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Product>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Product]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Product]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> upsert(
    _is.DatabaseSession session,
    List<Product> rows, {
    required _is.ColumnSelections<ProductTable> conflictColumns,
    _is.ColumnSelections<ProductTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Product>(
      rows,
      conflictColumns: conflictColumns(Product.t),
      updateColumns: updateColumns?.call(Product.t),
      updateWhere: updateWhere?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Product] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Product] will have its `id` field set.
  Future<Product?> upsertRow(
    _is.DatabaseSession session,
    Product row, {
    required _is.ColumnSelections<ProductTable> conflictColumns,
    _is.ColumnSelections<ProductTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Product>(
      row,
      conflictColumns: conflictColumns(Product.t),
      updateColumns: updateColumns?.call(Product.t),
      updateWhere: updateWhere?.call(Product.t),
      transaction: transaction,
    );
  }

  /// Updates all [Product]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> update(
    _is.DatabaseSession session,
    List<Product> rows, {
    _is.ColumnSelections<ProductTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Product>(
      rows,
      columns: columns?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Product]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Product> updateRow(
    _is.DatabaseSession session,
    Product row, {
    _is.ColumnSelections<ProductTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Product>(
      row,
      columns: columns?.call(Product.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Product] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Product?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProductUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Product>(
      id,
      columnValues: columnValues(Product.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Product]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProductUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProductTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Product>(
      columnValues: columnValues(Product.t.updateTable),
      where: where(Product.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Product]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> delete(
    _is.DatabaseSession session,
    List<Product> rows, {
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Product>(
      rows,
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Product].
  Future<Product> deleteRow(
    _is.DatabaseSession session,
    Product row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Product>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Product>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductTable> where,
    _is.OrderByBuilder<ProductTable>? orderBy,
    _is.OrderByListBuilder<ProductTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Product>(
      where: where(Product.t),
      orderBy: orderBy?.call(Product.t),
      orderByList: orderByList?.call(Product.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Product>(
      where: where?.call(Product.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Product] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Product>(
      where: where(Product.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
