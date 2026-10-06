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
import '../enums/invitation_status.dart' as _imshd44a;
import '../enums/membership_role.dart' as _icl0wo19;

/// An invitation for a new teammate. The invite code is shared out of band and
/// redeemed inside the app after signing in.
abstract class Invitation
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  Invitation._({
    this.id,
    required this.workspaceId,
    required this.email,
    _icl0wo19.MembershipRole? role,
    this.codeHash,
    required this.codePrefix,
    _imshd44a.InvitationStatus? status,
    required this.invitedBy,
    required this.expiresAt,
    this.acceptedAt,
    this.acceptedBy,
    DateTime? createdAt,
  }) : role = role ?? _icl0wo19.MembershipRole.member,
       status = status ?? _imshd44a.InvitationStatus.pending,
       createdAt = createdAt ?? DateTime.now();

  factory Invitation({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String email,
    _icl0wo19.MembershipRole? role,
    String? codeHash,
    required String codePrefix,
    _imshd44a.InvitationStatus? status,
    required String invitedBy,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    String? acceptedBy,
    DateTime? createdAt,
  }) = _InvitationImpl;

  factory Invitation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Invitation(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      email: jsonSerialization['email'] as String,
      role: jsonSerialization['role'] == null
          ? null
          : _icl0wo19.MembershipRole.fromJson(
              (jsonSerialization['role'] as String),
            ),
      codeHash: jsonSerialization['codeHash'] as String?,
      codePrefix: jsonSerialization['codePrefix'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _imshd44a.InvitationStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      invitedBy: jsonSerialization['invitedBy'] as String,
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
      acceptedBy: jsonSerialization['acceptedBy'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = InvitationTable();

  static const db = InvitationRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  String email;

  _icl0wo19.MembershipRole role;

  /// Single use invite code. Stored hashed, shown once at creation time.
  String? codeHash;

  String codePrefix;

  _imshd44a.InvitationStatus status;

  String invitedBy;

  DateTime expiresAt;

  DateTime? acceptedAt;

  String? acceptedBy;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [Invitation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Invitation copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    String? email,
    _icl0wo19.MembershipRole? role,
    String? codeHash,
    String? codePrefix,
    _imshd44a.InvitationStatus? status,
    String? invitedBy,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    String? acceptedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Invitation',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'email': email,
      'role': role.toJson(),
      if (codeHash != null) 'codeHash': codeHash,
      'codePrefix': codePrefix,
      'status': status.toJson(),
      'invitedBy': invitedBy,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (acceptedBy != null) 'acceptedBy': acceptedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Invitation',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'email': email,
      'role': role.toJson(),
      'codePrefix': codePrefix,
      'status': status.toJson(),
      'invitedBy': invitedBy,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
      if (acceptedBy != null) 'acceptedBy': acceptedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  static InvitationInclude include() {
    return InvitationInclude._();
  }

  static InvitationIncludeList includeList({
    _is.WhereExpressionBuilder<InvitationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InvitationTable>? orderBy,
    _is.OrderByListBuilder<InvitationTable>? orderByList,
    InvitationInclude? include,
  }) {
    return InvitationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Invitation.t),
      orderByList: orderByList?.call(Invitation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InvitationImpl extends Invitation {
  _InvitationImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String email,
    _icl0wo19.MembershipRole? role,
    String? codeHash,
    required String codePrefix,
    _imshd44a.InvitationStatus? status,
    required String invitedBy,
    required DateTime expiresAt,
    DateTime? acceptedAt,
    String? acceptedBy,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         email: email,
         role: role,
         codeHash: codeHash,
         codePrefix: codePrefix,
         status: status,
         invitedBy: invitedBy,
         expiresAt: expiresAt,
         acceptedAt: acceptedAt,
         acceptedBy: acceptedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Invitation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Invitation copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    String? email,
    _icl0wo19.MembershipRole? role,
    Object? codeHash = _Undefined,
    String? codePrefix,
    _imshd44a.InvitationStatus? status,
    String? invitedBy,
    DateTime? expiresAt,
    Object? acceptedAt = _Undefined,
    Object? acceptedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return Invitation(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      email: email ?? this.email,
      role: role ?? this.role,
      codeHash: codeHash is String? ? codeHash : this.codeHash,
      codePrefix: codePrefix ?? this.codePrefix,
      status: status ?? this.status,
      invitedBy: invitedBy ?? this.invitedBy,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
      acceptedBy: acceptedBy is String? ? acceptedBy : this.acceptedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class InvitationUpdateTable extends _is.UpdateTable<InvitationTable> {
  InvitationUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<_icl0wo19.MembershipRole, _icl0wo19.MembershipRole> role(
    _icl0wo19.MembershipRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<String, String> codeHash(String? value) => _is.ColumnValue(
    table.codeHash,
    value,
  );

  _is.ColumnValue<String, String> codePrefix(String value) => _is.ColumnValue(
    table.codePrefix,
    value,
  );

  _is.ColumnValue<_imshd44a.InvitationStatus, _imshd44a.InvitationStatus>
  status(_imshd44a.InvitationStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> invitedBy(String value) => _is.ColumnValue(
    table.invitedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> acceptedAt(DateTime? value) =>
      _is.ColumnValue(
        table.acceptedAt,
        value,
      );

  _is.ColumnValue<String, String> acceptedBy(String? value) => _is.ColumnValue(
    table.acceptedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class InvitationTable extends _is.Table<_is.UuidValue?> {
  InvitationTable({super.tableRelation}) : super(tableName: 'invitation') {
    updateTable = InvitationUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    codeHash = _is.ColumnString(
      'codeHash',
      this,
    );
    codePrefix = _is.ColumnString(
      'codePrefix',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    invitedBy = _is.ColumnString(
      'invitedBy',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    acceptedAt = _is.ColumnDateTime(
      'acceptedAt',
      this,
    );
    acceptedBy = _is.ColumnString(
      'acceptedBy',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final InvitationUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  late final _is.ColumnString email;

  late final _is.ColumnEnum<_icl0wo19.MembershipRole> role;

  /// Single use invite code. Stored hashed, shown once at creation time.
  late final _is.ColumnString codeHash;

  late final _is.ColumnString codePrefix;

  late final _is.ColumnEnum<_imshd44a.InvitationStatus> status;

  late final _is.ColumnString invitedBy;

  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime acceptedAt;

  late final _is.ColumnString acceptedBy;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    email,
    role,
    codeHash,
    codePrefix,
    status,
    invitedBy,
    expiresAt,
    acceptedAt,
    acceptedBy,
    createdAt,
  ];
}

class InvitationInclude extends _is.IncludeObject {
  InvitationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => Invitation.t;
}

class InvitationIncludeList extends _is.IncludeList {
  InvitationIncludeList._({
    _is.WhereExpressionBuilder<InvitationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Invitation.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => Invitation.t;
}

class InvitationRepository {
  const InvitationRepository._();

  /// Returns a list of [Invitation]s matching the given query parameters.
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
  Future<List<Invitation>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InvitationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InvitationTable>? orderBy,
    _is.OrderByListBuilder<InvitationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Invitation>(
      where: where?.call(Invitation.t),
      orderBy: orderBy?.call(Invitation.t),
      orderByList: orderByList?.call(Invitation.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Invitation] matching the given query parameters.
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
  Future<Invitation?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InvitationTable>? where,
    int? offset,
    _is.OrderByBuilder<InvitationTable>? orderBy,
    _is.OrderByListBuilder<InvitationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Invitation>(
      where: where?.call(Invitation.t),
      orderBy: orderBy?.call(Invitation.t),
      orderByList: orderByList?.call(Invitation.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Invitation] by its [id] or null if no such row exists.
  Future<Invitation?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Invitation>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Invitation]s in the list and returns the inserted rows.
  ///
  /// The returned [Invitation]s will have their `id` fields set.
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
  Future<List<Invitation>> insert(
    _is.DatabaseSession session,
    List<Invitation> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Invitation>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Invitation] and returns the inserted row.
  ///
  /// The returned [Invitation] will have its `id` field set.
  Future<Invitation> insertRow(
    _is.DatabaseSession session,
    Invitation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Invitation>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Invitation]s in the list and returns the resulting rows.
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
  /// The returned [Invitation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Invitation>> upsert(
    _is.DatabaseSession session,
    List<Invitation> rows, {
    required _is.ColumnSelections<InvitationTable> conflictColumns,
    _is.ColumnSelections<InvitationTable>? updateColumns,
    _is.WhereExpressionBuilder<InvitationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Invitation>(
      rows,
      conflictColumns: conflictColumns(Invitation.t),
      updateColumns: updateColumns?.call(Invitation.t),
      updateWhere: updateWhere?.call(Invitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Invitation] and returns the resulting row.
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
  /// The returned [Invitation] will have its `id` field set.
  Future<Invitation?> upsertRow(
    _is.DatabaseSession session,
    Invitation row, {
    required _is.ColumnSelections<InvitationTable> conflictColumns,
    _is.ColumnSelections<InvitationTable>? updateColumns,
    _is.WhereExpressionBuilder<InvitationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Invitation>(
      row,
      conflictColumns: conflictColumns(Invitation.t),
      updateColumns: updateColumns?.call(Invitation.t),
      updateWhere: updateWhere?.call(Invitation.t),
      transaction: transaction,
    );
  }

  /// Updates all [Invitation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Invitation>> update(
    _is.DatabaseSession session,
    List<Invitation> rows, {
    _is.ColumnSelections<InvitationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Invitation>(
      rows,
      columns: columns?.call(Invitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Invitation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Invitation> updateRow(
    _is.DatabaseSession session,
    Invitation row, {
    _is.ColumnSelections<InvitationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Invitation>(
      row,
      columns: columns?.call(Invitation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Invitation] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Invitation?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<InvitationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Invitation>(
      id,
      columnValues: columnValues(Invitation.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Invitation]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Invitation>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<InvitationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<InvitationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<InvitationTable>? orderBy,
    _is.OrderByListBuilder<InvitationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Invitation>(
      columnValues: columnValues(Invitation.t.updateTable),
      where: where(Invitation.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Invitation.t),
      orderByList: orderByList?.call(Invitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Invitation]s in the list and returns the deleted rows.
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
  Future<List<Invitation>> delete(
    _is.DatabaseSession session,
    List<Invitation> rows, {
    _is.OrderByBuilder<InvitationTable>? orderBy,
    _is.OrderByListBuilder<InvitationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Invitation>(
      rows,
      orderBy: orderBy?.call(Invitation.t),
      orderByList: orderByList?.call(Invitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Invitation].
  Future<Invitation> deleteRow(
    _is.DatabaseSession session,
    Invitation row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Invitation>(
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
  Future<List<Invitation>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<InvitationTable> where,
    _is.OrderByBuilder<InvitationTable>? orderBy,
    _is.OrderByListBuilder<InvitationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Invitation>(
      where: where(Invitation.t),
      orderBy: orderBy?.call(Invitation.t),
      orderByList: orderByList?.call(Invitation.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<InvitationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Invitation>(
      where: where?.call(Invitation.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Invitation] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<InvitationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Invitation>(
      where: where(Invitation.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
