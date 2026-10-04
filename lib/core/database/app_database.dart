import 'package:bloc_arch_setup/core/database/convarters/string_list_converter.dart';
import 'package:bloc_arch_setup/core/database/tables/product_table.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ProductTable])
class AppDatabase extends _$AppDatabase {
 AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: "bloc_arch_setup"));

  @override
  int get schemaVersion => 1;
}
