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
import '../enums/identity_status.dart' as _iqacwrhy;

/// A serialized identity for one physical unit. The QR token is bound to the
/// workspace, product, and identity through an HMAC-SHA256 signature, so a copy
/// of a token that was moved to another product or tenant fails resolution.
abstract class ProductIdentity
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ProductIdentity._({
    this.id,
    required this.workspaceId,
    required this.batchId,
    required this.qrToken,
    required this.hmacSignature,
    this.pinHash,
    this.pinCiphertext,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    this.lockedUntil,
    bool? firstVerified,
    int? verificationCount,
    this.firstVerifiedAt,
    this.lastVerifiedAt,
    this.recallReason,
    this.recalledAt,
    this.regeneratedFromId,
    this.deletedAt,
    this.deletedBy,
    this.deleteReason,
    DateTime? createdAt,
  }) : status = status ?? _iqacwrhy.IdentityStatus.active,
       failedPinAttempts = failedPinAttempts ?? 0,
       firstVerified = firstVerified ?? false,
       verificationCount = verificationCount ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory ProductIdentity({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue batchId,
    required String qrToken,
    required String hmacSignature,
    String? pinHash,
    String? pinCiphertext,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    DateTime? lockedUntil,
    bool? firstVerified,
    int? verificationCount,
    DateTime? firstVerifiedAt,
    DateTime? lastVerifiedAt,
    String? recallReason,
    DateTime? recalledAt,
    _is.UuidValue? regeneratedFromId,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    DateTime? createdAt,
  }) = _ProductIdentityImpl;

  factory ProductIdentity.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductIdentity(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      batchId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['batchId'],
      ),
      qrToken: jsonSerialization['qrToken'] as String,
      hmacSignature: jsonSerialization['hmacSignature'] as String,
      pinHash: jsonSerialization['pinHash'] as String?,
      pinCiphertext: jsonSerialization['pinCiphertext'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _iqacwrhy.IdentityStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      failedPinAttempts: jsonSerialization['failedPinAttempts'] as int?,
      lockedUntil: jsonSerialization['lockedUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lockedUntil'],
            ),
      firstVerified: jsonSerialization['firstVerified'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['firstVerified']),
      verificationCount: jsonSerialization['verificationCount'] as int?,
      firstVerifiedAt: jsonSerialization['firstVerifiedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstVerifiedAt'],
            ),
      lastVerifiedAt: jsonSerialization['lastVerifiedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastVerifiedAt'],
            ),
      recallReason: jsonSerialization['recallReason'] as String?,
      recalledAt: jsonSerialization['recalledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['recalledAt']),
      regeneratedFromId: jsonSerialization['regeneratedFromId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['regeneratedFromId'],
            ),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      deletedBy: jsonSerialization['deletedBy'] as String?,
      deleteReason: jsonSerialization['deleteReason'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = ProductIdentityTable();

  static const db = ProductIdentityRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  _is.UuidValue batchId;

  /// Cryptographically random token printed as the QR payload.
  String qrToken;

  /// HMAC-SHA256 signature over workspace, product, identity, and token.
  String hmacSignature;

  /// Bcrypt hash of the 6 digit PIN. Server only.
  String? pinHash;

  /// AES-256-GCM encrypted PIN for authorized operator retrieval. Server only.
  String? pinCiphertext;

  _iqacwrhy.IdentityStatus status;

  int failedPinAttempts;

  DateTime? lockedUntil;

  bool firstVerified;

  int verificationCount;

  DateTime? firstVerifiedAt;

  DateTime? lastVerifiedAt;

  String? recallReason;

  DateTime? recalledAt;

  /// Identity this token was regenerated from, if the original was compromised.
  _is.UuidValue? regeneratedFromId;

  DateTime? deletedAt;

  String? deletedBy;

  String? deleteReason;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProductIdentity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductIdentity copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    _is.UuidValue? batchId,
    String? qrToken,
    String? hmacSignature,
    String? pinHash,
    String? pinCiphertext,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    DateTime? lockedUntil,
    bool? firstVerified,
    int? verificationCount,
    DateTime? firstVerifiedAt,
    DateTime? lastVerifiedAt,
    String? recallReason,
    DateTime? recalledAt,
    _is.UuidValue? regeneratedFromId,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductIdentity',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'batchId': batchId.toJson(),
      'qrToken': qrToken,
      'hmacSignature': hmacSignature,
      if (pinHash != null) 'pinHash': pinHash,
      if (pinCiphertext != null) 'pinCiphertext': pinCiphertext,
      'status': status.toJson(),
      'failedPinAttempts': failedPinAttempts,
      if (lockedUntil != null) 'lockedUntil': lockedUntil?.toJson(),
      'firstVerified': firstVerified,
      'verificationCount': verificationCount,
      if (firstVerifiedAt != null) 'firstVerifiedAt': firstVerifiedAt?.toJson(),
      if (lastVerifiedAt != null) 'lastVerifiedAt': lastVerifiedAt?.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (regeneratedFromId != null)
        'regeneratedFromId': regeneratedFromId?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy,
      if (deleteReason != null) 'deleteReason': deleteReason,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductIdentity',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'batchId': batchId.toJson(),
      'qrToken': qrToken,
      'hmacSignature': hmacSignature,
      'status': status.toJson(),
      'failedPinAttempts': failedPinAttempts,
      if (lockedUntil != null) 'lockedUntil': lockedUntil?.toJson(),
      'firstVerified': firstVerified,
      'verificationCount': verificationCount,
      if (firstVerifiedAt != null) 'firstVerifiedAt': firstVerifiedAt?.toJson(),
      if (lastVerifiedAt != null) 'lastVerifiedAt': lastVerifiedAt?.toJson(),
      if (recallReason != null) 'recallReason': recallReason,
      if (recalledAt != null) 'recalledAt': recalledAt?.toJson(),
      if (regeneratedFromId != null)
        'regeneratedFromId': regeneratedFromId?.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (deletedBy != null) 'deletedBy': deletedBy,
      if (deleteReason != null) 'deleteReason': deleteReason,
      'createdAt': createdAt.toJson(),
    };
  }

  static ProductIdentityInclude include() {
    return ProductIdentityInclude._();
  }

  static ProductIdentityIncludeList includeList({
    _is.WhereExpressionBuilder<ProductIdentityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductIdentityTable>? orderBy,
    _is.OrderByListBuilder<ProductIdentityTable>? orderByList,
    ProductIdentityInclude? include,
  }) {
    return ProductIdentityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductIdentity.t),
      orderByList: orderByList?.call(ProductIdentity.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductIdentityImpl extends ProductIdentity {
  _ProductIdentityImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required _is.UuidValue batchId,
    required String qrToken,
    required String hmacSignature,
    String? pinHash,
    String? pinCiphertext,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    DateTime? lockedUntil,
    bool? firstVerified,
    int? verificationCount,
    DateTime? firstVerifiedAt,
    DateTime? lastVerifiedAt,
    String? recallReason,
    DateTime? recalledAt,
    _is.UuidValue? regeneratedFromId,
    DateTime? deletedAt,
    String? deletedBy,
    String? deleteReason,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         batchId: batchId,
         qrToken: qrToken,
         hmacSignature: hmacSignature,
         pinHash: pinHash,
         pinCiphertext: pinCiphertext,
         status: status,
         failedPinAttempts: failedPinAttempts,
         lockedUntil: lockedUntil,
         firstVerified: firstVerified,
         verificationCount: verificationCount,
         firstVerifiedAt: firstVerifiedAt,
         lastVerifiedAt: lastVerifiedAt,
         recallReason: recallReason,
         recalledAt: recalledAt,
         regeneratedFromId: regeneratedFromId,
         deletedAt: deletedAt,
         deletedBy: deletedBy,
         deleteReason: deleteReason,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ProductIdentity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProductIdentity copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    _is.UuidValue? batchId,
    String? qrToken,
    String? hmacSignature,
    Object? pinHash = _Undefined,
    Object? pinCiphertext = _Undefined,
    _iqacwrhy.IdentityStatus? status,
    int? failedPinAttempts,
    Object? lockedUntil = _Undefined,
    bool? firstVerified,
    int? verificationCount,
    Object? firstVerifiedAt = _Undefined,
    Object? lastVerifiedAt = _Undefined,
    Object? recallReason = _Undefined,
    Object? recalledAt = _Undefined,
    Object? regeneratedFromId = _Undefined,
    Object? deletedAt = _Undefined,
    Object? deletedBy = _Undefined,
    Object? deleteReason = _Undefined,
    DateTime? createdAt,
  }) {
    return ProductIdentity(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      batchId: batchId ?? this.batchId,
      qrToken: qrToken ?? this.qrToken,
      hmacSignature: hmacSignature ?? this.hmacSignature,
      pinHash: pinHash is String? ? pinHash : this.pinHash,
      pinCiphertext: pinCiphertext is String?
          ? pinCiphertext
          : this.pinCiphertext,
      status: status ?? this.status,
      failedPinAttempts: failedPinAttempts ?? this.failedPinAttempts,
      lockedUntil: lockedUntil is DateTime? ? lockedUntil : this.lockedUntil,
      firstVerified: firstVerified ?? this.firstVerified,
      verificationCount: verificationCount ?? this.verificationCount,
      firstVerifiedAt: firstVerifiedAt is DateTime?
          ? firstVerifiedAt
          : this.firstVerifiedAt,
      lastVerifiedAt: lastVerifiedAt is DateTime?
          ? lastVerifiedAt
          : this.lastVerifiedAt,
      recallReason: recallReason is String? ? recallReason : this.recallReason,
      recalledAt: recalledAt is DateTime? ? recalledAt : this.recalledAt,
      regeneratedFromId: regeneratedFromId is _is.UuidValue?
          ? regeneratedFromId
          : this.regeneratedFromId,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      deletedBy: deletedBy is String? ? deletedBy : this.deletedBy,
      deleteReason: deleteReason is String? ? deleteReason : this.deleteReason,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ProductIdentityUpdateTable extends _is.UpdateTable<ProductIdentityTable> {
  ProductIdentityUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> batchId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.batchId,
        value,
      );

  _is.ColumnValue<String, String> qrToken(String value) => _is.ColumnValue(
    table.qrToken,
    value,
  );

  _is.ColumnValue<String, String> hmacSignature(String value) =>
      _is.ColumnValue(
        table.hmacSignature,
        value,
      );

  _is.ColumnValue<String, String> pinHash(String? value) => _is.ColumnValue(
    table.pinHash,
    value,
  );

  _is.ColumnValue<String, String> pinCiphertext(String? value) =>
      _is.ColumnValue(
        table.pinCiphertext,
        value,
      );

  _is.ColumnValue<_iqacwrhy.IdentityStatus, _iqacwrhy.IdentityStatus> status(
    _iqacwrhy.IdentityStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> failedPinAttempts(int value) => _is.ColumnValue(
    table.failedPinAttempts,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lockedUntil(DateTime? value) =>
      _is.ColumnValue(
        table.lockedUntil,
        value,
      );

  _is.ColumnValue<bool, bool> firstVerified(bool value) => _is.ColumnValue(
    table.firstVerified,
    value,
  );

  _is.ColumnValue<int, int> verificationCount(int value) => _is.ColumnValue(
    table.verificationCount,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> firstVerifiedAt(DateTime? value) =>
      _is.ColumnValue(
        table.firstVerifiedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastVerifiedAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastVerifiedAt,
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

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> regeneratedFromId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.regeneratedFromId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> deletedAt(DateTime? value) =>
      _is.ColumnValue(
        table.deletedAt,
        value,
      );

  _is.ColumnValue<String, String> deletedBy(String? value) => _is.ColumnValue(
    table.deletedBy,
    value,
  );

  _is.ColumnValue<String, String> deleteReason(String? value) =>
      _is.ColumnValue(
        table.deleteReason,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ProductIdentityTable extends _is.Table<_is.UuidValue?> {
  ProductIdentityTable({super.tableRelation})
    : super(tableName: 'product_identity') {
    updateTable = ProductIdentityUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    batchId = _is.ColumnUuid(
      'batchId',
      this,
    );
    qrToken = _is.ColumnString(
      'qrToken',
      this,
    );
    hmacSignature = _is.ColumnString(
      'hmacSignature',
      this,
    );
    pinHash = _is.ColumnString(
      'pinHash',
      this,
    );
    pinCiphertext = _is.ColumnString(
      'pinCiphertext',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    failedPinAttempts = _is.ColumnInt(
      'failedPinAttempts',
      this,
      hasDefault: true,
    );
    lockedUntil = _is.ColumnDateTime(
      'lockedUntil',
      this,
    );
    firstVerified = _is.ColumnBool(
      'firstVerified',
      this,
      hasDefault: true,
    );
    verificationCount = _is.ColumnInt(
      'verificationCount',
      this,
      hasDefault: true,
    );
    firstVerifiedAt = _is.ColumnDateTime(
      'firstVerifiedAt',
      this,
    );
    lastVerifiedAt = _is.ColumnDateTime(
      'lastVerifiedAt',
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
    regeneratedFromId = _is.ColumnUuid(
      'regeneratedFromId',
      this,
    );
    deletedAt = _is.ColumnDateTime(
      'deletedAt',
      this,
    );
    deletedBy = _is.ColumnString(
      'deletedBy',
      this,
    );
    deleteReason = _is.ColumnString(
      'deleteReason',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final ProductIdentityUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnUuid batchId;

  /// Cryptographically random token printed as the QR payload.
  late final _is.ColumnString qrToken;

  /// HMAC-SHA256 signature over workspace, product, identity, and token.
  late final _is.ColumnString hmacSignature;

  /// Bcrypt hash of the 6 digit PIN. Server only.
  late final _is.ColumnString pinHash;

  /// AES-256-GCM encrypted PIN for authorized operator retrieval. Server only.
  late final _is.ColumnString pinCiphertext;

  late final _is.ColumnEnum<_iqacwrhy.IdentityStatus> status;

  late final _is.ColumnInt failedPinAttempts;

  late final _is.ColumnDateTime lockedUntil;

  late final _is.ColumnBool firstVerified;

  late final _is.ColumnInt verificationCount;

  late final _is.ColumnDateTime firstVerifiedAt;

  late final _is.ColumnDateTime lastVerifiedAt;

  late final _is.ColumnString recallReason;

  late final _is.ColumnDateTime recalledAt;

  /// Identity this token was regenerated from, if the original was compromised.
  late final _is.ColumnUuid regeneratedFromId;

  late final _is.ColumnDateTime deletedAt;

  late final _is.ColumnString deletedBy;

  late final _is.ColumnString deleteReason;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    batchId,
    qrToken,
    hmacSignature,
    pinHash,
    pinCiphertext,
    status,
    failedPinAttempts,
    lockedUntil,
    firstVerified,
    verificationCount,
    firstVerifiedAt,
    lastVerifiedAt,
    recallReason,
    recalledAt,
    regeneratedFromId,
    deletedAt,
    deletedBy,
    deleteReason,
    createdAt,
  ];
}

class ProductIdentityInclude extends _is.IncludeObject {
  ProductIdentityInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ProductIdentity.t;
}

class ProductIdentityIncludeList extends _is.IncludeList {
  ProductIdentityIncludeList._({
    _is.WhereExpressionBuilder<ProductIdentityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProductIdentity.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ProductIdentity.t;
}

class ProductIdentityRepository {
  const ProductIdentityRepository._();

  /// Returns a list of [ProductIdentity]s matching the given query parameters.
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
  Future<List<ProductIdentity>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductIdentityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductIdentityTable>? orderBy,
    _is.OrderByListBuilder<ProductIdentityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProductIdentity>(
      where: where?.call(ProductIdentity.t),
      orderBy: orderBy?.call(ProductIdentity.t),
      orderByList: orderByList?.call(ProductIdentity.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProductIdentity] matching the given query parameters.
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
  Future<ProductIdentity?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductIdentityTable>? where,
    int? offset,
    _is.OrderByBuilder<ProductIdentityTable>? orderBy,
    _is.OrderByListBuilder<ProductIdentityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProductIdentity>(
      where: where?.call(ProductIdentity.t),
      orderBy: orderBy?.call(ProductIdentity.t),
      orderByList: orderByList?.call(ProductIdentity.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProductIdentity] by its [id] or null if no such row exists.
  Future<ProductIdentity?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProductIdentity>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProductIdentity]s in the list and returns the inserted rows.
  ///
  /// The returned [ProductIdentity]s will have their `id` fields set.
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
  Future<List<ProductIdentity>> insert(
    _is.DatabaseSession session,
    List<ProductIdentity> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProductIdentity>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProductIdentity] and returns the inserted row.
  ///
  /// The returned [ProductIdentity] will have its `id` field set.
  Future<ProductIdentity> insertRow(
    _is.DatabaseSession session,
    ProductIdentity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProductIdentity>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProductIdentity]s in the list and returns the resulting rows.
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
  /// The returned [ProductIdentity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProductIdentity>> upsert(
    _is.DatabaseSession session,
    List<ProductIdentity> rows, {
    required _is.ColumnSelections<ProductIdentityTable> conflictColumns,
    _is.ColumnSelections<ProductIdentityTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductIdentityTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProductIdentity>(
      rows,
      conflictColumns: conflictColumns(ProductIdentity.t),
      updateColumns: updateColumns?.call(ProductIdentity.t),
      updateWhere: updateWhere?.call(ProductIdentity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProductIdentity] and returns the resulting row.
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
  /// The returned [ProductIdentity] will have its `id` field set.
  Future<ProductIdentity?> upsertRow(
    _is.DatabaseSession session,
    ProductIdentity row, {
    required _is.ColumnSelections<ProductIdentityTable> conflictColumns,
    _is.ColumnSelections<ProductIdentityTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductIdentityTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProductIdentity>(
      row,
      conflictColumns: conflictColumns(ProductIdentity.t),
      updateColumns: updateColumns?.call(ProductIdentity.t),
      updateWhere: updateWhere?.call(ProductIdentity.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProductIdentity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProductIdentity>> update(
    _is.DatabaseSession session,
    List<ProductIdentity> rows, {
    _is.ColumnSelections<ProductIdentityTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProductIdentity>(
      rows,
      columns: columns?.call(ProductIdentity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProductIdentity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProductIdentity> updateRow(
    _is.DatabaseSession session,
    ProductIdentity row, {
    _is.ColumnSelections<ProductIdentityTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProductIdentity>(
      row,
      columns: columns?.call(ProductIdentity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductIdentity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProductIdentity?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProductIdentityUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProductIdentity>(
      id,
      columnValues: columnValues(ProductIdentity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProductIdentity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProductIdentity>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProductIdentityUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ProductIdentityTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductIdentityTable>? orderBy,
    _is.OrderByListBuilder<ProductIdentityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProductIdentity>(
      columnValues: columnValues(ProductIdentity.t.updateTable),
      where: where(ProductIdentity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductIdentity.t),
      orderByList: orderByList?.call(ProductIdentity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProductIdentity]s in the list and returns the deleted rows.
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
  Future<List<ProductIdentity>> delete(
    _is.DatabaseSession session,
    List<ProductIdentity> rows, {
    _is.OrderByBuilder<ProductIdentityTable>? orderBy,
    _is.OrderByListBuilder<ProductIdentityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProductIdentity>(
      rows,
      orderBy: orderBy?.call(ProductIdentity.t),
      orderByList: orderByList?.call(ProductIdentity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProductIdentity].
  Future<ProductIdentity> deleteRow(
    _is.DatabaseSession session,
    ProductIdentity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProductIdentity>(
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
  Future<List<ProductIdentity>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductIdentityTable> where,
    _is.OrderByBuilder<ProductIdentityTable>? orderBy,
    _is.OrderByListBuilder<ProductIdentityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProductIdentity>(
      where: where(ProductIdentity.t),
      orderBy: orderBy?.call(ProductIdentity.t),
      orderByList: orderByList?.call(ProductIdentity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductIdentityTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProductIdentity>(
      where: where?.call(ProductIdentity.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProductIdentity] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductIdentityTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProductIdentity>(
      where: where(ProductIdentity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
