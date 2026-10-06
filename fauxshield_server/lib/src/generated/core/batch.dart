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
import '../enums/batch_status.dart' as _i9kwsvqp;

/// A manufacturing batch for one product. Identities are generated per batch,
/// and a batch can be recalled as a whole.
abstract class Batch
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Batch._({
    this.id,
    required this.workspaceId,
    required this.productId,
    required this.reference,
    required this.manufactureDate,
    this.expiryDate,
    required this.distributionRegion,
    required this.quantity,
    _i9kwsvqp.BatchStatus? status,
    this.notes,
    this.recallReason,
    this.recalledAt,
    this.recalledBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : status = status ?? _i9kwsvqp.BatchStatus.created,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Batch({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue productId,
    required String reference,
    required DateTime manufactureDate,
    DateTime? expiryDate,
    required String distributionRegion,
    required int quantity,
    _i9kwsvqp.BatchStatus? status,
    String? notes,
    String? recallReason,
    DateTime? recalledAt,
    String? recalledBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BatchImpl;

  factory Batch.fromJson(Map<String, dynamic> jsonSerialization) {
    return Batch(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      productId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['productId'],
      ),
      reference: jsonSerialization['reference'] as String,
      manufactureDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['manufactureDate'],
      ),
      expiryDate: jsonSerialization['expiryDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['expiryDate']),
      distributionRegion: jsonSerialization['distributionRegion'] as String,
      quantity: jsonSerialization['quantity'] as int,
      status: jsonSerialization['status'] == null
          ? null
          : _i9kwsvqp.BatchStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      notes: jsonSerialization['notes'] as String?,
      recallReason: jsonSerialization['recallReason'] as String?,
      recalledAt: jsonSerialization['recalledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['recalledAt']),
      recalledBy: jsonSerialization['recalledBy'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = BatchTable();

  static const db = BatchRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  _is.UuidValue productId;

  /// Manufacturing reference or lot number printed on packaging.
  String reference;

  DateTime manufactureDate;

  DateTime? expiryDate;

  /// Expected distribution region, for example NG or West Africa.
  String distributionRegion;

  /// Planned unit quantity for this batch.
  int quantity;

  _i9kwsvqp.BatchStatus status;

  String? notes;

  String? recallReason;

  DateTime? recalledAt;

  String? recalledBy;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Batch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Batch copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    _is.UuidValue? productId,
    String? reference,
    DateTime? manufactureDate,
    DateTime? expiryDate,
    String? distributionRegion,
    int? quantity,
    _i9kwsvqp.BatchStatus? status,
    String? notes,
    String? recallReason,
    DateTime? recalledAt,
    String? recalledBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Batch',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'productId': productId.toJson(),
      'reference': reference,
      'manufactureDate': manufactureDate.toJson(),
      if (expiryDate != null) 'expiryDate': expiryDate?.toJson(),
      'distributionRegion': distributionRegion,
      'quantity': quantity,
      'status': status.toJson(),
      if (notes != null) 'notes': notes,
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (recalledBy != null) 'recalledBy': recalledBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Batch',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'productId': productId.toJson(),
      'reference': reference,
      'manufactureDate': manufactureDate.toJson(),
      if (expiryDate != null) 'expiryDate': expiryDate?.toJson(),
      'distributionRegion': distributionRegion,
      'quantity': quantity,
      'status': status.toJson(),
      if (notes != null) 'notes': notes,
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (recalledBy != null) 'recalledBy': recalledBy,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static BatchInclude include() {
    return BatchInclude._();
  }

  static BatchIncludeList includeList({
    _is.WhereExpressionBuilder<BatchTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BatchTable>? orderBy,
    _is.OrderByListBuilder<BatchTable>? orderByList,
    BatchInclude? include,
  }) {
    return BatchIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Batch.t),
      orderByList: orderByList?.call(Batch.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BatchImpl extends Batch {
  _BatchImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue productId,
    required String reference,
    required DateTime manufactureDate,
    DateTime? expiryDate,
    required String distributionRegion,
    required int quantity,
    _i9kwsvqp.BatchStatus? status,
    String? notes,
    String? recallReason,
    DateTime? recalledAt,
    String? recalledBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         productId: productId,
         reference: reference,
         manufactureDate: manufactureDate,
         expiryDate: expiryDate,
         distributionRegion: distributionRegion,
         quantity: quantity,
         status: status,
         notes: notes,
         recallReason: recallReason,
         recalledAt: recalledAt,
         recalledBy: recalledBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Batch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Batch copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    _is.UuidValue? productId,
    String? reference,
    DateTime? manufactureDate,
    Object? expiryDate = _Undefined,
    String? distributionRegion,
    int? quantity,
    _i9kwsvqp.BatchStatus? status,
    Object? notes = _Undefined,
    Object? recallReason = _Undefined,
    Object? recalledAt = _Undefined,
    Object? recalledBy = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Batch(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      productId: productId ?? this.productId,
      reference: reference ?? this.reference,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expiryDate: expiryDate is DateTime? ? expiryDate : this.expiryDate,
      distributionRegion: distributionRegion ?? this.distributionRegion,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      notes: notes is String? ? notes : this.notes,
      recallReason: recallReason is String? ? recallReason : this.recallReason,
      recalledAt: recalledAt is DateTime? ? recalledAt : this.recalledAt,
      recalledBy: recalledBy is String? ? recalledBy : this.recalledBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class BatchUpdateTable extends _is.UpdateTable<BatchTable> {
  BatchUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> productId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.productId,
    value,
  );

  _is.ColumnValue<String, String> reference(String value) => _is.ColumnValue(
    table.reference,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> manufactureDate(DateTime value) =>
      _is.ColumnValue(
        table.manufactureDate,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiryDate(DateTime? value) =>
      _is.ColumnValue(
        table.expiryDate,
        value,
      );

  _is.ColumnValue<String, String> distributionRegion(String value) =>
      _is.ColumnValue(
        table.distributionRegion,
        value,
      );

  _is.ColumnValue<int, int> quantity(int value) => _is.ColumnValue(
    table.quantity,
    value,
  );

  _is.ColumnValue<_i9kwsvqp.BatchStatus, _i9kwsvqp.BatchStatus> status(
    _i9kwsvqp.BatchStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> notes(String? value) => _is.ColumnValue(
    table.notes,
    value,
  );

  _is.ColumnValue<String, String> recallReason(String? value) =>
      _is.ColumnValue(
        table.recallReason,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> recalledAt(DateTime? value) =>
      _is.ColumnValue(
        table.recalledAt,
        value,
      );

  _is.ColumnValue<String, String> recalledBy(String? value) => _is.ColumnValue(
    table.recalledBy,
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

class BatchTable extends _is.Table<_is.UuidValue?> {
  BatchTable({super.tableRelation}) : super(tableName: 'batch') {
    updateTable = BatchUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    productId = _is.ColumnUuid(
      'productId',
      this,
    );
    reference = _is.ColumnString(
      'reference',
      this,
    );
    manufactureDate = _is.ColumnDateTime(
      'manufactureDate',
      this,
    );
    expiryDate = _is.ColumnDateTime(
      'expiryDate',
      this,
    );
    distributionRegion = _is.ColumnString(
      'distributionRegion',
      this,
    );
    quantity = _is.ColumnInt(
      'quantity',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    notes = _is.ColumnString(
      'notes',
      this,
    );
    recallReason = _is.ColumnString(
      'recallReason',
      this,
    );
    recalledAt = _is.ColumnDateTime(
      'recalledAt',
      this,
    );
    recalledBy = _is.ColumnString(
      'recalledBy',
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

  late final BatchUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnUuid productId;

  /// Manufacturing reference or lot number printed on packaging.
  late final _is.ColumnString reference;

  late final _is.ColumnDateTime manufactureDate;

  late final _is.ColumnDateTime expiryDate;

  /// Expected distribution region, for example NG or West Africa.
  late final _is.ColumnString distributionRegion;

  /// Planned unit quantity for this batch.
  late final _is.ColumnInt quantity;

  late final _is.ColumnEnum<_i9kwsvqp.BatchStatus> status;

  late final _is.ColumnString notes;

  late final _is.ColumnString recallReason;

  late final _is.ColumnDateTime recalledAt;

  late final _is.ColumnString recalledBy;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    productId,
    reference,
    manufactureDate,
    expiryDate,
    distributionRegion,
    quantity,
    status,
    notes,
    recallReason,
    recalledAt,
    recalledBy,
    createdAt,
    updatedAt,
  ];
}

class BatchInclude extends _is.IncludeObject {
  BatchInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Batch.t;
}

class BatchIncludeList extends _is.IncludeList {
  BatchIncludeList._({
    _is.WhereExpressionBuilder<BatchTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Batch.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Batch.t;
}

class BatchRepository {
  const BatchRepository._();

  /// Returns a list of [Batch]s matching the given query parameters.
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
  Future<List<Batch>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BatchTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BatchTable>? orderBy,
    _is.OrderByListBuilder<BatchTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Batch>(
      where: where?.call(Batch.t),
      orderBy: orderBy?.call(Batch.t),
      orderByList: orderByList?.call(Batch.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Batch] matching the given query parameters.
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
  Future<Batch?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BatchTable>? where,
    int? offset,
    _is.OrderByBuilder<BatchTable>? orderBy,
    _is.OrderByListBuilder<BatchTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Batch>(
      where: where?.call(Batch.t),
      orderBy: orderBy?.call(Batch.t),
      orderByList: orderByList?.call(Batch.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Batch] by its [id] or null if no such row exists.
  Future<Batch?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Batch>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Batch]s in the list and returns the inserted rows.
  ///
  /// The returned [Batch]s will have their `id` fields set.
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
  Future<List<Batch>> insert(
    _is.DatabaseSession session,
    List<Batch> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Batch>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Batch] and returns the inserted row.
  ///
  /// The returned [Batch] will have its `id` field set.
  Future<Batch> insertRow(
    _is.DatabaseSession session,
    Batch row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Batch>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Batch]s in the list and returns the resulting rows.
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
  /// The returned [Batch]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Batch>> upsert(
    _is.DatabaseSession session,
    List<Batch> rows, {
    required _is.ColumnSelections<BatchTable> conflictColumns,
    _is.ColumnSelections<BatchTable>? updateColumns,
    _is.WhereExpressionBuilder<BatchTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Batch>(
      rows,
      conflictColumns: conflictColumns(Batch.t),
      updateColumns: updateColumns?.call(Batch.t),
      updateWhere: updateWhere?.call(Batch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Batch] and returns the resulting row.
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
  /// The returned [Batch] will have its `id` field set.
  Future<Batch?> upsertRow(
    _is.DatabaseSession session,
    Batch row, {
    required _is.ColumnSelections<BatchTable> conflictColumns,
    _is.ColumnSelections<BatchTable>? updateColumns,
    _is.WhereExpressionBuilder<BatchTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Batch>(
      row,
      conflictColumns: conflictColumns(Batch.t),
      updateColumns: updateColumns?.call(Batch.t),
      updateWhere: updateWhere?.call(Batch.t),
      transaction: transaction,
    );
  }

  /// Updates all [Batch]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Batch>> update(
    _is.DatabaseSession session,
    List<Batch> rows, {
    _is.ColumnSelections<BatchTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Batch>(
      rows,
      columns: columns?.call(Batch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Batch]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Batch> updateRow(
    _is.DatabaseSession session,
    Batch row, {
    _is.ColumnSelections<BatchTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Batch>(
      row,
      columns: columns?.call(Batch.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Batch] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Batch?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<BatchUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Batch>(
      id,
      columnValues: columnValues(Batch.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Batch]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Batch>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BatchUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BatchTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BatchTable>? orderBy,
    _is.OrderByListBuilder<BatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Batch>(
      columnValues: columnValues(Batch.t.updateTable),
      where: where(Batch.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Batch.t),
      orderByList: orderByList?.call(Batch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Batch]s in the list and returns the deleted rows.
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
  Future<List<Batch>> delete(
    _is.DatabaseSession session,
    List<Batch> rows, {
    _is.OrderByBuilder<BatchTable>? orderBy,
    _is.OrderByListBuilder<BatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Batch>(
      rows,
      orderBy: orderBy?.call(Batch.t),
      orderByList: orderByList?.call(Batch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Batch].
  Future<Batch> deleteRow(
    _is.DatabaseSession session,
    Batch row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Batch>(
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
  Future<List<Batch>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BatchTable> where,
    _is.OrderByBuilder<BatchTable>? orderBy,
    _is.OrderByListBuilder<BatchTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Batch>(
      where: where(Batch.t),
      orderBy: orderBy?.call(Batch.t),
      orderByList: orderByList?.call(Batch.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BatchTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Batch>(
      where: where?.call(Batch.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Batch] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BatchTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Batch>(
      where: where(Batch.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
