// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalOutboxMutationsTable extends LocalOutboxMutations
    with TableInfo<$LocalOutboxMutationsTable, LocalOutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalOutboxMutationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mutationTypeMeta = const VerificationMeta(
    'mutationType',
  );
  @override
  late final GeneratedColumn<String> mutationType = GeneratedColumn<String>(
    'mutation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mutationType,
    payloadJson,
    status,
    createdAt,
    retryCount,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_outbox_mutations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalOutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mutation_type')) {
      context.handle(
        _mutationTypeMeta,
        mutationType.isAcceptableOrUnknown(
          data['mutation_type']!,
          _mutationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mutationTypeMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalOutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalOutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mutationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mutation_type'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $LocalOutboxMutationsTable createAlias(String alias) {
    return $LocalOutboxMutationsTable(attachedDatabase, alias);
  }
}

class LocalOutboxRow extends DataClass implements Insertable<LocalOutboxRow> {
  /// Id client (UUID) pour idempotence côté sync.
  final String id;
  final String mutationType;
  final String payloadJson;

  /// 0 = pending, 1 = syncing, 2 = done, 3 = failed
  final int status;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;
  const LocalOutboxRow({
    required this.id,
    required this.mutationType,
    required this.payloadJson,
    required this.status,
    required this.createdAt,
    required this.retryCount,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mutation_type'] = Variable<String>(mutationType);
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<int>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  LocalOutboxMutationsCompanion toCompanion(bool nullToAbsent) {
    return LocalOutboxMutationsCompanion(
      id: Value(id),
      mutationType: Value(mutationType),
      payloadJson: Value(payloadJson),
      status: Value(status),
      createdAt: Value(createdAt),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
    );
  }

  factory LocalOutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalOutboxRow(
      id: serializer.fromJson<String>(json['id']),
      mutationType: serializer.fromJson<String>(json['mutationType']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<int>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mutationType': serializer.toJson<String>(mutationType),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<int>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  LocalOutboxRow copyWith({
    String? id,
    String? mutationType,
    String? payloadJson,
    int? status,
    DateTime? createdAt,
    int? retryCount,
    Value<String?> lastError = const Value.absent(),
  }) => LocalOutboxRow(
    id: id ?? this.id,
    mutationType: mutationType ?? this.mutationType,
    payloadJson: payloadJson ?? this.payloadJson,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    retryCount: retryCount ?? this.retryCount,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  LocalOutboxRow copyWithCompanion(LocalOutboxMutationsCompanion data) {
    return LocalOutboxRow(
      id: data.id.present ? data.id.value : this.id,
      mutationType: data.mutationType.present
          ? data.mutationType.value
          : this.mutationType,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalOutboxRow(')
          ..write('id: $id, ')
          ..write('mutationType: $mutationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mutationType,
    payloadJson,
    status,
    createdAt,
    retryCount,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalOutboxRow &&
          other.id == this.id &&
          other.mutationType == this.mutationType &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError);
}

class LocalOutboxMutationsCompanion extends UpdateCompanion<LocalOutboxRow> {
  final Value<String> id;
  final Value<String> mutationType;
  final Value<String> payloadJson;
  final Value<int> status;
  final Value<DateTime> createdAt;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<int> rowid;
  const LocalOutboxMutationsCompanion({
    this.id = const Value.absent(),
    this.mutationType = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalOutboxMutationsCompanion.insert({
    required String id,
    required String mutationType,
    required String payloadJson,
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mutationType = Value(mutationType),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<LocalOutboxRow> custom({
    Expression<String>? id,
    Expression<String>? mutationType,
    Expression<String>? payloadJson,
    Expression<int>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mutationType != null) 'mutation_type': mutationType,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalOutboxMutationsCompanion copyWith({
    Value<String>? id,
    Value<String>? mutationType,
    Value<String>? payloadJson,
    Value<int>? status,
    Value<DateTime>? createdAt,
    Value<int>? retryCount,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return LocalOutboxMutationsCompanion(
      id: id ?? this.id,
      mutationType: mutationType ?? this.mutationType,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mutationType.present) {
      map['mutation_type'] = Variable<String>(mutationType.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalOutboxMutationsCompanion(')
          ..write('id: $id, ')
          ..write('mutationType: $mutationType, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSyncMetaTable extends LocalSyncMeta
    with TableInfo<$LocalSyncMetaTable, LocalSyncMetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSyncMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _domainMeta = const VerificationMeta('domain');
  @override
  late final GeneratedColumn<String> domain = GeneratedColumn<String>(
    'domain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPulledAtMeta = const VerificationMeta(
    'lastPulledAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPulledAt = GeneratedColumn<DateTime>(
    'last_pulled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastCursorMeta = const VerificationMeta(
    'lastCursor',
  );
  @override
  late final GeneratedColumn<String> lastCursor = GeneratedColumn<String>(
    'last_cursor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [domain, lastPulledAt, lastCursor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sync_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSyncMetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('domain')) {
      context.handle(
        _domainMeta,
        domain.isAcceptableOrUnknown(data['domain']!, _domainMeta),
      );
    } else if (isInserting) {
      context.missing(_domainMeta);
    }
    if (data.containsKey('last_pulled_at')) {
      context.handle(
        _lastPulledAtMeta,
        lastPulledAt.isAcceptableOrUnknown(
          data['last_pulled_at']!,
          _lastPulledAtMeta,
        ),
      );
    }
    if (data.containsKey('last_cursor')) {
      context.handle(
        _lastCursorMeta,
        lastCursor.isAcceptableOrUnknown(data['last_cursor']!, _lastCursorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {domain};
  @override
  LocalSyncMetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSyncMetaRow(
      domain: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}domain'],
      )!,
      lastPulledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_pulled_at'],
      ),
      lastCursor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_cursor'],
      ),
    );
  }

  @override
  $LocalSyncMetaTable createAlias(String alias) {
    return $LocalSyncMetaTable(attachedDatabase, alias);
  }
}

class LocalSyncMetaRow extends DataClass
    implements Insertable<LocalSyncMetaRow> {
  final String domain;
  final DateTime? lastPulledAt;
  final String? lastCursor;
  const LocalSyncMetaRow({
    required this.domain,
    this.lastPulledAt,
    this.lastCursor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['domain'] = Variable<String>(domain);
    if (!nullToAbsent || lastPulledAt != null) {
      map['last_pulled_at'] = Variable<DateTime>(lastPulledAt);
    }
    if (!nullToAbsent || lastCursor != null) {
      map['last_cursor'] = Variable<String>(lastCursor);
    }
    return map;
  }

  LocalSyncMetaCompanion toCompanion(bool nullToAbsent) {
    return LocalSyncMetaCompanion(
      domain: Value(domain),
      lastPulledAt: lastPulledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPulledAt),
      lastCursor: lastCursor == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCursor),
    );
  }

  factory LocalSyncMetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSyncMetaRow(
      domain: serializer.fromJson<String>(json['domain']),
      lastPulledAt: serializer.fromJson<DateTime?>(json['lastPulledAt']),
      lastCursor: serializer.fromJson<String?>(json['lastCursor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'domain': serializer.toJson<String>(domain),
      'lastPulledAt': serializer.toJson<DateTime?>(lastPulledAt),
      'lastCursor': serializer.toJson<String?>(lastCursor),
    };
  }

  LocalSyncMetaRow copyWith({
    String? domain,
    Value<DateTime?> lastPulledAt = const Value.absent(),
    Value<String?> lastCursor = const Value.absent(),
  }) => LocalSyncMetaRow(
    domain: domain ?? this.domain,
    lastPulledAt: lastPulledAt.present ? lastPulledAt.value : this.lastPulledAt,
    lastCursor: lastCursor.present ? lastCursor.value : this.lastCursor,
  );
  LocalSyncMetaRow copyWithCompanion(LocalSyncMetaCompanion data) {
    return LocalSyncMetaRow(
      domain: data.domain.present ? data.domain.value : this.domain,
      lastPulledAt: data.lastPulledAt.present
          ? data.lastPulledAt.value
          : this.lastPulledAt,
      lastCursor: data.lastCursor.present
          ? data.lastCursor.value
          : this.lastCursor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSyncMetaRow(')
          ..write('domain: $domain, ')
          ..write('lastPulledAt: $lastPulledAt, ')
          ..write('lastCursor: $lastCursor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(domain, lastPulledAt, lastCursor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSyncMetaRow &&
          other.domain == this.domain &&
          other.lastPulledAt == this.lastPulledAt &&
          other.lastCursor == this.lastCursor);
}

class LocalSyncMetaCompanion extends UpdateCompanion<LocalSyncMetaRow> {
  final Value<String> domain;
  final Value<DateTime?> lastPulledAt;
  final Value<String?> lastCursor;
  final Value<int> rowid;
  const LocalSyncMetaCompanion({
    this.domain = const Value.absent(),
    this.lastPulledAt = const Value.absent(),
    this.lastCursor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSyncMetaCompanion.insert({
    required String domain,
    this.lastPulledAt = const Value.absent(),
    this.lastCursor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : domain = Value(domain);
  static Insertable<LocalSyncMetaRow> custom({
    Expression<String>? domain,
    Expression<DateTime>? lastPulledAt,
    Expression<String>? lastCursor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (domain != null) 'domain': domain,
      if (lastPulledAt != null) 'last_pulled_at': lastPulledAt,
      if (lastCursor != null) 'last_cursor': lastCursor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSyncMetaCompanion copyWith({
    Value<String>? domain,
    Value<DateTime?>? lastPulledAt,
    Value<String?>? lastCursor,
    Value<int>? rowid,
  }) {
    return LocalSyncMetaCompanion(
      domain: domain ?? this.domain,
      lastPulledAt: lastPulledAt ?? this.lastPulledAt,
      lastCursor: lastCursor ?? this.lastCursor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (domain.present) {
      map['domain'] = Variable<String>(domain.value);
    }
    if (lastPulledAt.present) {
      map['last_pulled_at'] = Variable<DateTime>(lastPulledAt.value);
    }
    if (lastCursor.present) {
      map['last_cursor'] = Variable<String>(lastCursor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSyncMetaCompanion(')
          ..write('domain: $domain, ')
          ..write('lastPulledAt: $lastPulledAt, ')
          ..write('lastCursor: $lastCursor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalOutboxMutationsTable localOutboxMutations =
      $LocalOutboxMutationsTable(this);
  late final $LocalSyncMetaTable localSyncMeta = $LocalSyncMetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localOutboxMutations,
    localSyncMeta,
  ];
}

typedef $$LocalOutboxMutationsTableCreateCompanionBuilder =
    LocalOutboxMutationsCompanion Function({
      required String id,
      required String mutationType,
      required String payloadJson,
      Value<int> status,
      required DateTime createdAt,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$LocalOutboxMutationsTableUpdateCompanionBuilder =
    LocalOutboxMutationsCompanion Function({
      Value<String> id,
      Value<String> mutationType,
      Value<String> payloadJson,
      Value<int> status,
      Value<DateTime> createdAt,
      Value<int> retryCount,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$LocalOutboxMutationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalOutboxMutationsTable> {
  $$LocalOutboxMutationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mutationType => $composableBuilder(
    column: $table.mutationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalOutboxMutationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalOutboxMutationsTable> {
  $$LocalOutboxMutationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mutationType => $composableBuilder(
    column: $table.mutationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalOutboxMutationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalOutboxMutationsTable> {
  $$LocalOutboxMutationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mutationType => $composableBuilder(
    column: $table.mutationType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$LocalOutboxMutationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalOutboxMutationsTable,
          LocalOutboxRow,
          $$LocalOutboxMutationsTableFilterComposer,
          $$LocalOutboxMutationsTableOrderingComposer,
          $$LocalOutboxMutationsTableAnnotationComposer,
          $$LocalOutboxMutationsTableCreateCompanionBuilder,
          $$LocalOutboxMutationsTableUpdateCompanionBuilder,
          (
            LocalOutboxRow,
            BaseReferences<
              _$AppDatabase,
              $LocalOutboxMutationsTable,
              LocalOutboxRow
            >,
          ),
          LocalOutboxRow,
          PrefetchHooks Function()
        > {
  $$LocalOutboxMutationsTableTableManager(
    _$AppDatabase db,
    $LocalOutboxMutationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalOutboxMutationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalOutboxMutationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalOutboxMutationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mutationType = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalOutboxMutationsCompanion(
                id: id,
                mutationType: mutationType,
                payloadJson: payloadJson,
                status: status,
                createdAt: createdAt,
                retryCount: retryCount,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mutationType,
                required String payloadJson,
                Value<int> status = const Value.absent(),
                required DateTime createdAt,
                Value<int> retryCount = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalOutboxMutationsCompanion.insert(
                id: id,
                mutationType: mutationType,
                payloadJson: payloadJson,
                status: status,
                createdAt: createdAt,
                retryCount: retryCount,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalOutboxMutationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalOutboxMutationsTable,
      LocalOutboxRow,
      $$LocalOutboxMutationsTableFilterComposer,
      $$LocalOutboxMutationsTableOrderingComposer,
      $$LocalOutboxMutationsTableAnnotationComposer,
      $$LocalOutboxMutationsTableCreateCompanionBuilder,
      $$LocalOutboxMutationsTableUpdateCompanionBuilder,
      (
        LocalOutboxRow,
        BaseReferences<
          _$AppDatabase,
          $LocalOutboxMutationsTable,
          LocalOutboxRow
        >,
      ),
      LocalOutboxRow,
      PrefetchHooks Function()
    >;
typedef $$LocalSyncMetaTableCreateCompanionBuilder =
    LocalSyncMetaCompanion Function({
      required String domain,
      Value<DateTime?> lastPulledAt,
      Value<String?> lastCursor,
      Value<int> rowid,
    });
typedef $$LocalSyncMetaTableUpdateCompanionBuilder =
    LocalSyncMetaCompanion Function({
      Value<String> domain,
      Value<DateTime?> lastPulledAt,
      Value<String?> lastCursor,
      Value<int> rowid,
    });

class $$LocalSyncMetaTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSyncMetaTable> {
  $$LocalSyncMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCursor => $composableBuilder(
    column: $table.lastCursor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSyncMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSyncMetaTable> {
  $$LocalSyncMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCursor => $composableBuilder(
    column: $table.lastCursor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSyncMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSyncMetaTable> {
  $$LocalSyncMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get domain =>
      $composableBuilder(column: $table.domain, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastCursor => $composableBuilder(
    column: $table.lastCursor,
    builder: (column) => column,
  );
}

class $$LocalSyncMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSyncMetaTable,
          LocalSyncMetaRow,
          $$LocalSyncMetaTableFilterComposer,
          $$LocalSyncMetaTableOrderingComposer,
          $$LocalSyncMetaTableAnnotationComposer,
          $$LocalSyncMetaTableCreateCompanionBuilder,
          $$LocalSyncMetaTableUpdateCompanionBuilder,
          (
            LocalSyncMetaRow,
            BaseReferences<
              _$AppDatabase,
              $LocalSyncMetaTable,
              LocalSyncMetaRow
            >,
          ),
          LocalSyncMetaRow,
          PrefetchHooks Function()
        > {
  $$LocalSyncMetaTableTableManager(_$AppDatabase db, $LocalSyncMetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSyncMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSyncMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSyncMetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> domain = const Value.absent(),
                Value<DateTime?> lastPulledAt = const Value.absent(),
                Value<String?> lastCursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSyncMetaCompanion(
                domain: domain,
                lastPulledAt: lastPulledAt,
                lastCursor: lastCursor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String domain,
                Value<DateTime?> lastPulledAt = const Value.absent(),
                Value<String?> lastCursor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalSyncMetaCompanion.insert(
                domain: domain,
                lastPulledAt: lastPulledAt,
                lastCursor: lastCursor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSyncMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSyncMetaTable,
      LocalSyncMetaRow,
      $$LocalSyncMetaTableFilterComposer,
      $$LocalSyncMetaTableOrderingComposer,
      $$LocalSyncMetaTableAnnotationComposer,
      $$LocalSyncMetaTableCreateCompanionBuilder,
      $$LocalSyncMetaTableUpdateCompanionBuilder,
      (
        LocalSyncMetaRow,
        BaseReferences<_$AppDatabase, $LocalSyncMetaTable, LocalSyncMetaRow>,
      ),
      LocalSyncMetaRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalOutboxMutationsTableTableManager get localOutboxMutations =>
      $$LocalOutboxMutationsTableTableManager(_db, _db.localOutboxMutations);
  $$LocalSyncMetaTableTableManager get localSyncMeta =>
      $$LocalSyncMetaTableTableManager(_db, _db.localSyncMeta);
}
