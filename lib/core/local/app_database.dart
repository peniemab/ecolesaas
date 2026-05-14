import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

/// File d’attente des mutations à envoyer vers Supabase (L-01 / outbox).
@DataClassName('LocalOutboxRow')
class LocalOutboxMutations extends Table {
  /// Id client (UUID) pour idempotence côté sync.
  TextColumn get id => text()();

  TextColumn get mutationType => text()();

  TextColumn get payloadJson => text()();

  /// 0 = pending, 1 = syncing, 2 = done, 3 = failed
  IntColumn get status => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();

  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Dernière synchro « pull » par domaine métier (élèves, rapports, etc.).
@DataClassName('LocalSyncMetaRow')
class LocalSyncMeta extends Table {
  TextColumn get domain => text()();

  DateTimeColumn get lastPulledAt => dateTime().nullable()();

  TextColumn get lastCursor => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {domain};
}

@DriftDatabase(tables: [LocalOutboxMutations, LocalSyncMeta])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final dir = await getApplicationSupportDirectory();
    final file = File(p.join(dir.path, 'school_saas_local.db'));
    final cache = (await getTemporaryDirectory()).path;
    sqlite3.sqlite3.tempDirectory = cache;
    return NativeDatabase.createInBackground(file);
  });
}
