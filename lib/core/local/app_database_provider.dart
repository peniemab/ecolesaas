import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// Base locale Drift (schéma v1 : outbox + méta sync). Fermée à la destruction du scope.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
