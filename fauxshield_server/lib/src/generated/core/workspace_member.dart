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
import '../enums/membership_role.dart' as _icl0wo19;

/// Links an authenticated user to a workspace with a role. Authorization for
/// every operator endpoint is derived from this record.
abstract class WorkspaceMember
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  WorkspaceMember._({
    this.id,
    required this.workspaceId,
    required this.userIdentifier,
    required this.email,
    this.displayName,
    _icl0wo19.MembershipRole? role,
    this.notificationEmail,
    DateTime? createdAt,
  }) : role = role ?? _icl0wo19.MembershipRole.member,
       createdAt = createdAt ?? DateTime.now();

  factory WorkspaceMember({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String userIdentifier,
    required String email,
    String? displayName,
    _icl0wo19.MembershipRole? role,
    String? notificationEmail,
    DateTime? createdAt,
  }) = _WorkspaceMemberImpl;

  factory WorkspaceMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceMember(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workspaceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['workspaceId'],
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      email: jsonSerialization['email'] as String,
      displayName: jsonSerialization['displayName'] as String?,
      role: jsonSerialization['role'] == null
          ? null
          : _icl0wo19.MembershipRole.fromJson(
              (jsonSerialization['role'] as String),
            ),
      notificationEmail: jsonSerialization['notificationEmail'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = WorkspaceMemberTable();

  static const db = WorkspaceMemberRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue workspaceId;

  /// The serverpod auth user identifier. Never trust a client supplied value.
  String userIdentifier;

  String email;

  String? displayName;

  _icl0wo19.MembershipRole role;

  /// Optional notification email when it differs from the sign-in email.
  String? notificationEmail;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorkspaceMember copyWith({
    _is.UuidValue? id,
    _is.UuidValue? workspaceId,
    String? userIdentifier,
    String? email,
    String? displayName,
    _icl0wo19.MembershipRole? role,
    String? notificationEmail,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkspaceMember',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'email': email,
      if (displayName != null) 'displayName': displayName,
      'role': role.toJson(),
      if (notificationEmail != null) 'notificationEmail': notificationEmail,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkspaceMember',
      if (id != null) 'id': id?.toJson(),
      'workspaceId': workspaceId.toJson(),
      'userIdentifier': userIdentifier,
      'email': email,
      if (displayName != null) 'displayName': displayName,
      'role': role.toJson(),
      if (notificationEmail != null) 'notificationEmail': notificationEmail,
      'createdAt': createdAt.toJson(),
    };
  }

  static WorkspaceMemberInclude include() {
    return WorkspaceMemberInclude._();
  }

  static WorkspaceMemberIncludeList includeList({
    _is.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorkspaceMemberTable>? orderBy,
    _is.OrderByListBuilder<WorkspaceMemberTable>? orderByList,
    WorkspaceMemberInclude? include,
  }) {
    return WorkspaceMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkspaceMember.t),
      orderByList: orderByList?.call(WorkspaceMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceMemberImpl extends WorkspaceMember {
  _WorkspaceMemberImpl({
    _is.UuidValue? id,
    required _is.UuidValue workspaceId,
    required String userIdentifier,
    required String email,
    String? displayName,
    _icl0wo19.MembershipRole? role,
    String? notificationEmail,
    DateTime? createdAt,
  }) : super._(
         id: id,
         workspaceId: workspaceId,
         userIdentifier: userIdentifier,
         email: email,
         displayName: displayName,
         role: role,
         notificationEmail: notificationEmail,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorkspaceMember copyWith({
    Object? id = _Undefined,
    _is.UuidValue? workspaceId,
    String? userIdentifier,
    String? email,
    Object? displayName = _Undefined,
    _icl0wo19.MembershipRole? role,
    Object? notificationEmail = _Undefined,
    DateTime? createdAt,
  }) {
    return WorkspaceMember(
      id: id is _is.UuidValue? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      email: email ?? this.email,
      displayName: displayName is String? ? displayName : this.displayName,
      role: role ?? this.role,
      notificationEmail: notificationEmail is String?
          ? notificationEmail
          : this.notificationEmail,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WorkspaceMemberUpdateTable extends _is.UpdateTable<WorkspaceMemberTable> {
  WorkspaceMemberUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> workspaceId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.workspaceId,
    value,
  );

  _is.ColumnValue<String, String> userIdentifier(String value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> displayName(String? value) => _is.ColumnValue(
    table.displayName,
    value,
  );

  _is.ColumnValue<_icl0wo19.MembershipRole, _icl0wo19.MembershipRole> role(
    _icl0wo19.MembershipRole value,
  ) => _is.ColumnValue(
    table.role,
    value,
  );

  _is.ColumnValue<String, String> notificationEmail(String? value) =>
      _is.ColumnValue(
        table.notificationEmail,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class WorkspaceMemberTable extends _is.Table<_is.UuidValue?> {
  WorkspaceMemberTable({super.tableRelation})
    : super(tableName: 'workspace_member') {
    updateTable = WorkspaceMemberUpdateTable(this);
    workspaceId = _is.ColumnUuid(
      'workspaceId',
      this,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    displayName = _is.ColumnString(
      'displayName',
      this,
    );
    role = _is.ColumnEnum(
      'role',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    notificationEmail = _is.ColumnString(
      'notificationEmail',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final WorkspaceMemberUpdateTable updateTable;

  late final _is.ColumnUuid workspaceId;

  /// The serverpod auth user identifier. Never trust a client supplied value.
  late final _is.ColumnString userIdentifier;

  late final _is.ColumnString email;

  late final _is.ColumnString displayName;

  late final _is.ColumnEnum<_icl0wo19.MembershipRole> role;

  /// Optional notification email when it differs from the sign-in email.
  late final _is.ColumnString notificationEmail;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    workspaceId,
    userIdentifier,
    email,
    displayName,
    role,
    notificationEmail,
    createdAt,
  ];
}

class WorkspaceMemberInclude extends _is.IncludeObject {
  WorkspaceMemberInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => WorkspaceMember.t;
}

class WorkspaceMemberIncludeList extends _is.IncludeList {
  WorkspaceMemberIncludeList._({
    _is.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorkspaceMember.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => WorkspaceMember.t;
}

class WorkspaceMemberRepository {
  const WorkspaceMemberRepository._();

  /// Returns a list of [WorkspaceMember]s matching the given query parameters.
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
  Future<List<WorkspaceMember>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorkspaceMemberTable>? orderBy,
    _is.OrderByListBuilder<WorkspaceMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WorkspaceMember>(
      where: where?.call(WorkspaceMember.t),
      orderBy: orderBy?.call(WorkspaceMember.t),
      orderByList: orderByList?.call(WorkspaceMember.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WorkspaceMember] matching the given query parameters.
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
  Future<WorkspaceMember?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    int? offset,
    _is.OrderByBuilder<WorkspaceMemberTable>? orderBy,
    _is.OrderByListBuilder<WorkspaceMemberTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WorkspaceMember>(
      where: where?.call(WorkspaceMember.t),
      orderBy: orderBy?.call(WorkspaceMember.t),
      orderByList: orderByList?.call(WorkspaceMember.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WorkspaceMember] by its [id] or null if no such row exists.
  Future<WorkspaceMember?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WorkspaceMember>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WorkspaceMember]s in the list and returns the inserted rows.
  ///
  /// The returned [WorkspaceMember]s will have their `id` fields set.
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
  Future<List<WorkspaceMember>> insert(
    _is.DatabaseSession session,
    List<WorkspaceMember> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<WorkspaceMember>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [WorkspaceMember] and returns the inserted row.
  ///
  /// The returned [WorkspaceMember] will have its `id` field set.
  Future<WorkspaceMember> insertRow(
    _is.DatabaseSession session,
    WorkspaceMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorkspaceMember>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [WorkspaceMember]s in the list and returns the resulting rows.
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
  /// The returned [WorkspaceMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorkspaceMember>> upsert(
    _is.DatabaseSession session,
    List<WorkspaceMember> rows, {
    required _is.ColumnSelections<WorkspaceMemberTable> conflictColumns,
    _is.ColumnSelections<WorkspaceMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<WorkspaceMemberTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<WorkspaceMember>(
      rows,
      conflictColumns: conflictColumns(WorkspaceMember.t),
      updateColumns: updateColumns?.call(WorkspaceMember.t),
      updateWhere: updateWhere?.call(WorkspaceMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [WorkspaceMember] and returns the resulting row.
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
  /// The returned [WorkspaceMember] will have its `id` field set.
  Future<WorkspaceMember?> upsertRow(
    _is.DatabaseSession session,
    WorkspaceMember row, {
    required _is.ColumnSelections<WorkspaceMemberTable> conflictColumns,
    _is.ColumnSelections<WorkspaceMemberTable>? updateColumns,
    _is.WhereExpressionBuilder<WorkspaceMemberTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<WorkspaceMember>(
      row,
      conflictColumns: conflictColumns(WorkspaceMember.t),
      updateColumns: updateColumns?.call(WorkspaceMember.t),
      updateWhere: updateWhere?.call(WorkspaceMember.t),
      transaction: transaction,
    );
  }

  /// Updates all [WorkspaceMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorkspaceMember>> update(
    _is.DatabaseSession session,
    List<WorkspaceMember> rows, {
    _is.ColumnSelections<WorkspaceMemberTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<WorkspaceMember>(
      rows,
      columns: columns?.call(WorkspaceMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [WorkspaceMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorkspaceMember> updateRow(
    _is.DatabaseSession session,
    WorkspaceMember row, {
    _is.ColumnSelections<WorkspaceMemberTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorkspaceMember>(
      row,
      columns: columns?.call(WorkspaceMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkspaceMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WorkspaceMember?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<WorkspaceMemberUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<WorkspaceMember>(
      id,
      columnValues: columnValues(WorkspaceMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WorkspaceMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<WorkspaceMember>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<WorkspaceMemberUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<WorkspaceMemberTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<WorkspaceMemberTable>? orderBy,
    _is.OrderByListBuilder<WorkspaceMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<WorkspaceMember>(
      columnValues: columnValues(WorkspaceMember.t.updateTable),
      where: where(WorkspaceMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkspaceMember.t),
      orderByList: orderByList?.call(WorkspaceMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [WorkspaceMember]s in the list and returns the deleted rows.
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
  Future<List<WorkspaceMember>> delete(
    _is.DatabaseSession session,
    List<WorkspaceMember> rows, {
    _is.OrderByBuilder<WorkspaceMemberTable>? orderBy,
    _is.OrderByListBuilder<WorkspaceMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<WorkspaceMember>(
      rows,
      orderBy: orderBy?.call(WorkspaceMember.t),
      orderByList: orderByList?.call(WorkspaceMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [WorkspaceMember].
  Future<WorkspaceMember> deleteRow(
    _is.DatabaseSession session,
    WorkspaceMember row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorkspaceMember>(
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
  Future<List<WorkspaceMember>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorkspaceMemberTable> where,
    _is.OrderByBuilder<WorkspaceMemberTable>? orderBy,
    _is.OrderByListBuilder<WorkspaceMemberTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<WorkspaceMember>(
      where: where(WorkspaceMember.t),
      orderBy: orderBy?.call(WorkspaceMember.t),
      orderByList: orderByList?.call(WorkspaceMember.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<WorkspaceMember>(
      where: where?.call(WorkspaceMember.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WorkspaceMember] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<WorkspaceMemberTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WorkspaceMember>(
      where: where(WorkspaceMember.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
