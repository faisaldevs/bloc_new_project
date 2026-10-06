import 'package:bloc_arch_setup/core/database/convarters/string_list_converter.dart';
import 'package:drift/drift.dart';

class ProductTable extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  RealColumn get price => real()();
  RealColumn get discountPercentage => real().withDefault(const Constant(0))();
  // RealColumn get rating => real().nullable()();
  RealColumn get rating => real().withDefault(const Constant(0))();
  IntColumn get stock => integer().withDefault(const Constant(0))();
  TextColumn get brand => text().nullable()();
  TextColumn get sku => text().nullable()();

  IntColumn get weight => integer().withDefault(const Constant(0))();
  IntColumn get minimumOrderQuantity =>
      integer().withDefault(const Constant(1))();
  TextColumn get warrantyInformation => text().nullable()();
  TextColumn get shippingInformation => text().nullable()();
  TextColumn get availabilityStatus => text().nullable()();
  TextColumn get returnPolicy => text().nullable()();

  TextColumn get thumbnail => text().nullable()();
  TextColumn get images => text().map(StringListConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {id};
}


