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
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import '../enums/batch_status.dart' as _i9kwsvqp;
import '../enums/identity_status.dart' as _iqacwrhy;

/// Device-local cache of catalog entries for offline inspector checks. This
/// table lives only in the app's SQLite database and is refreshed from the
/// server catalog endpoint.
abstract class InspectorCacheEntry
    implements _isd.TableRow<_isc.UuidValue?>, _isc.ProtocolSerialization {
  InspectorCacheEntry._({
    this.id,
    required this.identityId,
    required this.qrToken,
    required this.productName,
    this.sku,
    this.productDescription,
    this.imageUrlsJson,
    this.packaging,
    this.shelfLife,
    this.countryRestrictionsJson,
    this.safetyInstructions,
    required this.batchReference,
    required this.batchStatus,
    this.manufactureDate,
    required this.distributionRegion,
    required this.identityStatus,
    this.recallReason,
    this.recalledAt,
    required this.refreshedAt,
  });

  factory InspectorCacheEntry({
    _isc.UuidValue? id,
    required _isc.UuidValue identityId,
    required String qrToken,
    required String productName,
    String? sku,
    String? productDescription,
    String? imageUrlsJson,
    String? packaging,
    String? shelfLife,
    String? countryRestrictionsJson,
    String? safetyInstructions,
    required String batchReference,
    required _i9kwsvqp.BatchStatus batchStatus,
    DateTime? manufactureDate,
    required String distributionRegion,
    required _iqacwrhy.IdentityStatus identityStatus,
    String? recallReason,
    DateTime? recalledAt,
    required DateTime refreshedAt,
  }) = _InspectorCacheEntryImpl;

  factory InspectorCacheEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return InspectorCacheEntry(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      identityId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['identityId'],
      ),
      qrToken: jsonSerialization['qrToken'] as String,
      productName: jsonSerialization['productName'] as String,
      sku: jsonSerialization['sku'] as String?,
      productDescription: jsonSerialization['productDescription'] as String?,
      imageUrlsJson: jsonSerialization['imageUrlsJson'] as String?,
      packaging: jsonSerialization['packaging'] as String?,
      shelfLife: jsonSerialization['shelfLife'] as String?,
      countryRestrictionsJson:
          jsonSerialization['countryRestrictionsJson'] as String?,
      safetyInstructions: jsonSerialization['safetyInstructions'] as String?,
      batchReference: jsonSerialization['batchReference'] as String,
      batchStatus: _i9kwsvqp.BatchStatus.fromJson(
        (jsonSerialization['batchStatus'] as String),
      ),
      manufactureDate: jsonSerialization['manufactureDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['manufactureDate'],
            ),
      distributionRegion: jsonSerialization['distributionRegion'] as String,
      identityStatus: _iqacwrhy.IdentityStatus.fromJson(
        (jsonSerialization['identityStatus'] as String),
      ),
      recallReason: jsonSerialization['recallReason'] as String?,
      recalledAt: jsonSerialization['recalledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['recalledAt'],
            ),
      refreshedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['refreshedAt'],
      ),
    );
  }

  static final t = InspectorCacheEntryTable();

  static const db = InspectorCacheEntryRepository._();

  @override
  _isc.UuidValue? id;

  _isc.UuidValue identityId;

  String qrToken;

  String productName;

  String? sku;

  String? productDescription;

  String? imageUrlsJson;

  String? packaging;

  String? shelfLife;

  String? countryRestrictionsJson;

  String? safetyInstructions;

  String batchReference;

  _i9kwsvqp.BatchStatus batchStatus;

  DateTime? manufactureDate;

  String distributionRegion;

  _iqacwrhy.IdentityStatus identityStatus;

  String? recallReason;

  DateTime? recalledAt;

  DateTime refreshedAt;

  @override
  _isd.Table<_isc.UuidValue?> get table => t;

  /// Returns a shallow copy of this [InspectorCacheEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InspectorCacheEntry copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? identityId,
    String? qrToken,
    String? productName,
    String? sku,
    String? productDescription,
    String? imageUrlsJson,
    String? packaging,
    String? shelfLife,
    String? countryRestrictionsJson,
    String? safetyInstructions,
    String? batchReference,
    _i9kwsvqp.BatchStatus? batchStatus,
    DateTime? manufactureDate,
    String? distributionRegion,
    _iqacwrhy.IdentityStatus? identityStatus,
    String? recallReason,
    DateTime? recalledAt,
    DateTime? refreshedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InspectorCacheEntry',
      if (id != null) 'id': id?.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'productName': productName,
      if (sku != null) 'sku': sku,
      if (productDescription != null) 'productDescription': productDescription,
      if (imageUrlsJson != null) 'imageUrlsJson': imageUrlsJson,
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictionsJson != null)
        'countryRestrictionsJson': countryRestrictionsJson,
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      'batchReference': batchReference,
      'batchStatus': batchStatus.toJson(),
      if (manufactureDate != null) 'manufactureDate': manufactureDate?.toJson(),
      'distributionRegion': distributionRegion,
      'identityStatus': identityStatus.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      'refreshedAt': refreshedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InspectorCacheEntry',
      if (id != null) 'id': id?.toJson(),
      'identityId': identityId.toJson(),
      'qrToken': qrToken,
      'productName': productName,
      if (sku != null) 'sku': sku,
      if (productDescription != null) 'productDescription': productDescription,
      if (imageUrlsJson != null) 'imageUrlsJson': imageUrlsJson,
      if (packaging != null) 'packaging': packaging,
      if (shelfLife != null) 'shelfLife': shelfLife,
      if (countryRestrictionsJson != null)
        'countryRestrictionsJson': countryRestrictionsJson,
      if (safetyInstructions != null) 'safetyInstructions': safetyInstructions,
      'batchReference': batchReference,
      'batchStatus': batchStatus.toJson(),
      if (manufactureDate != null) 'manufactureDate': manufactureDate?.toJson(),
      'distributionRegion': distributionRegion,
      'identityStatus': identityStatus.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      'refreshedAt': refreshedAt.toJson(),
    };
  }

  static InspectorCacheEntryInclude include() {
    return InspectorCacheEntryInclude._();
  }

  static InspectorCacheEntryIncludeList includeList({
    _isd.WhereExpressionBuilder<InspectorCacheEntryTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<InspectorCacheEntryTable>? orderBy,
    _isd.OrderByListBuilder<InspectorCacheEntryTable>? orderByList,
    InspectorCacheEntryInclude? include,
  }) {
    return InspectorCacheEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InspectorCacheEntry.t),
      orderByList: orderByList?.call(InspectorCacheEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InspectorCacheEntryImpl extends InspectorCacheEntry {
  _InspectorCacheEntryImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue identityId,
    required String qrToken,
    required String productName,
    String? sku,
    String? productDescription,
    String? imageUrlsJson,
    String? packaging,
    String? shelfLife,
    String? countryRestrictionsJson,
    String? safetyInstructions,
    required String batchReference,
    required _i9kwsvqp.BatchStatus batchStatus,
    DateTime? manufactureDate,
    required String distributionRegion,
    required _iqacwrhy.IdentityStatus identityStatus,
    String? recallReason,
    DateTime? recalledAt,
    required DateTime refreshedAt,
  }) : super._(
         id: id,
         identityId: identityId,
         qrToken: qrToken,
         productName: productName,
         sku: sku,
         productDescription: productDescription,
         imageUrlsJson: imageUrlsJson,
         packaging: packaging,
         shelfLife: shelfLife,
         countryRestrictionsJson: countryRestrictionsJson,
         safetyInstructions: safetyInstructions,
         batchReference: batchReference,
         batchStatus: batchStatus,
         manufactureDate: manufactureDate,
         distributionRegion: distributionRegion,
         identityStatus: identityStatus,
         recallReason: recallReason,
         recalledAt: recalledAt,
         refreshedAt: refreshedAt,
       );

  /// Returns a shallow copy of this [InspectorCacheEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  InspectorCacheEntry copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? identityId,
    String? qrToken,
    String? productName,
    Object? sku = _Undefined,
    Object? productDescription = _Undefined,
    Object? imageUrlsJson = _Undefined,
    Object? packaging = _Undefined,
    Object? shelfLife = _Undefined,
    Object? countryRestrictionsJson = _Undefined,
    Object? safetyInstructions = _Undefined,
    String? batchReference,
    _i9kwsvqp.BatchStatus? batchStatus,
    Object? manufactureDate = _Undefined,
    String? distributionRegion,
    _iqacwrhy.IdentityStatus? identityStatus,
    Object? recallReason = _Undefined,
    Object? recalledAt = _Undefined,
    DateTime? refreshedAt,
  }) {
    return InspectorCacheEntry(
      id: id is _isc.UuidValue? ? id : this.id,
      identityId: identityId ?? this.identityId,
      qrToken: qrToken ?? this.qrToken,
      productName: productName ?? this.productName,
      sku: sku is String? ? sku : this.sku,
      productDescription: productDescription is String?
          ? productDescription
          : this.productDescription,
      imageUrlsJson: imageUrlsJson is String?
          ? imageUrlsJson
          : this.imageUrlsJson,
      packaging: packaging is String? ? packaging : this.packaging,
      shelfLife: shelfLife is String? ? shelfLife : this.shelfLife,
      countryRestrictionsJson: countryRestrictionsJson is String?
          ? countryRestrictionsJson
          : this.countryRestrictionsJson,
      safetyInstructions: safetyInstructions is String?
          ? safetyInstructions
          : this.safetyInstructions,
      batchReference: batchReference ?? this.batchReference,
      batchStatus: batchStatus ?? this.batchStatus,
      manufactureDate: manufactureDate is DateTime?
          ? manufactureDate
          : this.manufactureDate,
      distributionRegion: distributionRegion ?? this.distributionRegion,
      identityStatus: identityStatus ?? this.identityStatus,
      recallReason: recallReason is String? ? recallReason : this.recallReason,
      recalledAt: recalledAt is DateTime? ? recalledAt : this.recalledAt,
      refreshedAt: refreshedAt ?? this.refreshedAt,
    );
  }
}

class InspectorCacheEntryUpdateTable
    extends _isd.UpdateTable<InspectorCacheEntryTable> {
  InspectorCacheEntryUpdateTable(super.table);

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> identityId(
    _isc.UuidValue value,
  ) => _isd.ColumnValue(
    table.identityId,
    value,
  );

  _isd.ColumnValue<String, String> qrToken(String value) => _isd.ColumnValue(
    table.qrToken,
    value,
  );

  _isd.ColumnValue<String, String> productName(String value) =>
      _isd.ColumnValue(
        table.productName,
        value,
      );

  _isd.ColumnValue<String, String> sku(String? value) => _isd.ColumnValue(
    table.sku,
    value,
  );

  _isd.ColumnValue<String, String> productDescription(String? value) =>
      _isd.ColumnValue(
        table.productDescription,
        value,
      );

  _isd.ColumnValue<String, String> imageUrlsJson(String? value) =>
      _isd.ColumnValue(
        table.imageUrlsJson,
        value,
      );

  _isd.ColumnValue<String, String> packaging(String? value) => _isd.ColumnValue(
    table.packaging,
    value,
  );

  _isd.ColumnValue<String, String> shelfLife(String? value) => _isd.ColumnValue(
    table.shelfLife,
    value,
  );

  _isd.ColumnValue<String, String> countryRestrictionsJson(String? value) =>
      _isd.ColumnValue(
        table.countryRestrictionsJson,
        value,
      );

  _isd.ColumnValue<String, String> safetyInstructions(String? value) =>
      _isd.ColumnValue(
        table.safetyInstructions,
        value,
      );

  _isd.ColumnValue<String, String> batchReference(String value) =>
      _isd.ColumnValue(
        table.batchReference,
        value,
      );

  _isd.ColumnValue<_i9kwsvqp.BatchStatus, _i9kwsvqp.BatchStatus> batchStatus(
    _i9kwsvqp.BatchStatus value,
  ) => _isd.ColumnValue(
    table.batchStatus,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> manufactureDate(DateTime? value) =>
      _isd.ColumnValue(
        table.manufactureDate,
        value,
      );

  _isd.ColumnValue<String, String> distributionRegion(String value) =>
      _isd.ColumnValue(
        table.distributionRegion,
        value,
      );

  _isd.ColumnValue<_iqacwrhy.IdentityStatus, _iqacwrhy.IdentityStatus>
  identityStatus(_iqacwrhy.IdentityStatus value) => _isd.ColumnValue(
    table.identityStatus,
    value,
  );

  _isd.ColumnValue<String, String> recallReason(String? value) =>
      _isd.ColumnValue(
        table.recallReason,
        value,
      );

  _isd.ColumnValue<DateTime, DateTime> recalledAt(DateTime? value) =>
      _isd.ColumnValue(
        table.recalledAt,
        value,
      );

  _isd.ColumnValue<DateTime, DateTime> refreshedAt(DateTime value) =>
      _isd.ColumnValue(
        table.refreshedAt,
        value,
      );
}

class InspectorCacheEntryTable extends _isd.Table<_isc.UuidValue?> {
  InspectorCacheEntryTable({super.tableRelation})
    : super(tableName: 'inspector_cache_entry') {
    updateTable = InspectorCacheEntryUpdateTable(this);
    identityId = _isd.ColumnUuid(
      'identityId',
      this,
    );
    qrToken = _isd.ColumnString(
      'qrToken',
      this,
    );
    productName = _isd.ColumnString(
      'productName',
      this,
    );
    sku = _isd.ColumnString(
      'sku',
      this,
    );
    productDescription = _isd.ColumnString(
      'productDescription',
      this,
    );
    imageUrlsJson = _isd.ColumnString(
      'imageUrlsJson',
      this,
    );
    packaging = _isd.ColumnString(
      'packaging',
      this,
    );
    shelfLife = _isd.ColumnString(
      'shelfLife',
      this,
    );
    countryRestrictionsJson = _isd.ColumnString(
      'countryRestrictionsJson',
      this,
    );
    safetyInstructions = _isd.ColumnString(
      'safetyInstructions',
      this,
    );
    batchReference = _isd.ColumnString(
      'batchReference',
      this,
    );
    batchStatus = _isd.ColumnEnum(
      'batchStatus',
      this,
      _isd.EnumSerialization.byName,
    );
    manufactureDate = _isd.ColumnDateTime(
      'manufactureDate',
      this,
    );
    distributionRegion = _isd.ColumnString(
      'distributionRegion',
      this,
    );
    identityStatus = _isd.ColumnEnum(
      'identityStatus',
      this,
      _isd.EnumSerialization.byName,
    );
    recallReason = _isd.ColumnString(
      'recallReason',
      this,
    );
    recalledAt = _isd.ColumnDateTime(
      'recalledAt',
      this,
    );
    refreshedAt = _isd.ColumnDateTime(
      'refreshedAt',
      this,
    );
  }

  late final InspectorCacheEntryUpdateTable updateTable;

  late final _isd.ColumnUuid identityId;

  late final _isd.ColumnString qrToken;

  late final _isd.ColumnString productName;

  late final _isd.ColumnString sku;

  late final _isd.ColumnString productDescription;

  late final _isd.ColumnString imageUrlsJson;

  late final _isd.ColumnString packaging;

  late final _isd.ColumnString shelfLife;

  late final _isd.ColumnString countryRestrictionsJson;

  late final _isd.ColumnString safetyInstructions;

  late final _isd.ColumnString batchReference;

  late final _isd.ColumnEnum<_i9kwsvqp.BatchStatus> batchStatus;

  late final _isd.ColumnDateTime manufactureDate;

  late final _isd.ColumnString distributionRegion;

  late final _isd.ColumnEnum<_iqacwrhy.IdentityStatus> identityStatus;

  late final _isd.ColumnString recallReason;

  late final _isd.ColumnDateTime recalledAt;

  late final _isd.ColumnDateTime refreshedAt;

  @override
  List<_isd.Column> get columns => [
    id,
    identityId,
    qrToken,
    productName,
    sku,
    productDescription,
    imageUrlsJson,
    packaging,
    shelfLife,
    countryRestrictionsJson,
    safetyInstructions,
    batchReference,
    batchStatus,
    manufactureDate,
    distributionRegion,
    identityStatus,
    recallReason,
    recalledAt,
    refreshedAt,
  ];
}

class InspectorCacheEntryInclude extends _isd.IncludeObject {
  InspectorCacheEntryInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<_isc.UuidValue?> get table => InspectorCacheEntry.t;
}

class InspectorCacheEntryIncludeList extends _isd.IncludeList {
  InspectorCacheEntryIncludeList._({
    _isd.WhereExpressionBuilder<InspectorCacheEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(InspectorCacheEntry.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<_isc.UuidValue?> get table => InspectorCacheEntry.t;
}

class InspectorCacheEntryRepository {
  const InspectorCacheEntryRepository._();

  /// Returns a list of [InspectorCacheEntry]s matching the given query parameters.
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
  Future<List<InspectorCacheEntry>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<InspectorCacheEntryTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<InspectorCacheEntryTable>? orderBy,
    _isd.OrderByListBuilder<InspectorCacheEntryTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<InspectorCacheEntry>(
      where: where?.call(InspectorCacheEntry.t),
      orderBy: orderBy?.call(InspectorCacheEntry.t),
      orderByList: orderByList?.call(InspectorCacheEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [InspectorCacheEntry] matching the given query parameters.
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
  Future<InspectorCacheEntry?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<InspectorCacheEntryTable>? where,
    int? offset,
    _isd.OrderByBuilder<InspectorCacheEntryTable>? orderBy,
    _isd.OrderByListBuilder<InspectorCacheEntryTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<InspectorCacheEntry>(
      where: where?.call(InspectorCacheEntry.t),
      orderBy: orderBy?.call(InspectorCacheEntry.t),
      orderByList: orderByList?.call(InspectorCacheEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [InspectorCacheEntry] by its [id] or null if no such row exists.
  Future<InspectorCacheEntry?> findById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<InspectorCacheEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [InspectorCacheEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [InspectorCacheEntry]s will have their `id` fields set.
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
  Future<List<InspectorCacheEntry>> insert(
    _isd.DatabaseSession session,
    List<InspectorCacheEntry> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<InspectorCacheEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [InspectorCacheEntry] and returns the inserted row.
  ///
  /// The returned [InspectorCacheEntry] will have its `id` field set.
  Future<InspectorCacheEntry> insertRow(
    _isd.DatabaseSession session,
    InspectorCacheEntry row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<InspectorCacheEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [InspectorCacheEntry]s in the list and returns the resulting rows.
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
  /// The returned [InspectorCacheEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<InspectorCacheEntry>> upsert(
    _isd.DatabaseSession session,
    List<InspectorCacheEntry> rows, {
    required _isd.ColumnSelections<InspectorCacheEntryTable> conflictColumns,
    _isd.ColumnSelections<InspectorCacheEntryTable>? updateColumns,
    _isd.WhereExpressionBuilder<InspectorCacheEntryTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<InspectorCacheEntry>(
      rows,
      conflictColumns: conflictColumns(InspectorCacheEntry.t),
      updateColumns: updateColumns?.call(InspectorCacheEntry.t),
      updateWhere: updateWhere?.call(InspectorCacheEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [InspectorCacheEntry] and returns the resulting row.
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
  /// The returned [InspectorCacheEntry] will have its `id` field set.
  Future<InspectorCacheEntry?> upsertRow(
    _isd.DatabaseSession session,
    InspectorCacheEntry row, {
    required _isd.ColumnSelections<InspectorCacheEntryTable> conflictColumns,
    _isd.ColumnSelections<InspectorCacheEntryTable>? updateColumns,
    _isd.WhereExpressionBuilder<InspectorCacheEntryTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<InspectorCacheEntry>(
      row,
      conflictColumns: conflictColumns(InspectorCacheEntry.t),
      updateColumns: updateColumns?.call(InspectorCacheEntry.t),
      updateWhere: updateWhere?.call(InspectorCacheEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [InspectorCacheEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<InspectorCacheEntry>> update(
    _isd.DatabaseSession session,
    List<InspectorCacheEntry> rows, {
    _isd.ColumnSelections<InspectorCacheEntryTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<InspectorCacheEntry>(
      rows,
      columns: columns?.call(InspectorCacheEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [InspectorCacheEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<InspectorCacheEntry> updateRow(
    _isd.DatabaseSession session,
    InspectorCacheEntry row, {
    _isd.ColumnSelections<InspectorCacheEntryTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<InspectorCacheEntry>(
      row,
      columns: columns?.call(InspectorCacheEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [InspectorCacheEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<InspectorCacheEntry?> updateById(
    _isd.DatabaseSession session,
    _isc.UuidValue id, {
    required _isd.ColumnValueListBuilder<InspectorCacheEntryUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<InspectorCacheEntry>(
      id,
      columnValues: columnValues(InspectorCacheEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [InspectorCacheEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<InspectorCacheEntry>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<InspectorCacheEntryUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<InspectorCacheEntryTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<InspectorCacheEntryTable>? orderBy,
    _isd.OrderByListBuilder<InspectorCacheEntryTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<InspectorCacheEntry>(
      columnValues: columnValues(InspectorCacheEntry.t.updateTable),
      where: where(InspectorCacheEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(InspectorCacheEntry.t),
      orderByList: orderByList?.call(InspectorCacheEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [InspectorCacheEntry]s in the list and returns the deleted rows.
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
  Future<List<InspectorCacheEntry>> delete(
    _isd.DatabaseSession session,
    List<InspectorCacheEntry> rows, {
    _isd.OrderByBuilder<InspectorCacheEntryTable>? orderBy,
    _isd.OrderByListBuilder<InspectorCacheEntryTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<InspectorCacheEntry>(
      rows,
      orderBy: orderBy?.call(InspectorCacheEntry.t),
      orderByList: orderByList?.call(InspectorCacheEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [InspectorCacheEntry].
  Future<InspectorCacheEntry> deleteRow(
    _isd.DatabaseSession session,
    InspectorCacheEntry row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<InspectorCacheEntry>(
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
  Future<List<InspectorCacheEntry>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<InspectorCacheEntryTable> where,
    _isd.OrderByBuilder<InspectorCacheEntryTable>? orderBy,
    _isd.OrderByListBuilder<InspectorCacheEntryTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<InspectorCacheEntry>(
      where: where(InspectorCacheEntry.t),
      orderBy: orderBy?.call(InspectorCacheEntry.t),
      orderByList: orderByList?.call(InspectorCacheEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<InspectorCacheEntryTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<InspectorCacheEntry>(
      where: where?.call(InspectorCacheEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [InspectorCacheEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<InspectorCacheEntryTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<InspectorCacheEntry>(
      where: where(InspectorCacheEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
