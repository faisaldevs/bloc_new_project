import 'package:bloc_arch_setup/core/database/app_database.dart';
import 'package:bloc_arch_setup/features/products/data/datasources/local/local_datasource.dart';
import 'package:bloc_arch_setup/features/products/data/models/product_response_model.dart';
import 'package:drift/drift.dart';

class LocalDatasourceImpl implements LocalDatasource {
  const LocalDatasourceImpl({required this._database});
  final AppDatabase _database;

  @override
  Future<int> count() async {
    return await _database.productTable.count().getSingle();
  }

  @override
  Future<List<ProductTableData>> getProducts({
    required int skip,
    required int limit,
  }) async {
    return (_database.select(_database.productTable)
          ..orderBy([(t) => OrderingTerm.asc(t.id)])
          ..limit(limit, offset: skip))
        .get();
  }

  @override
  Future<void> saveProducts(
    List<Product> products, {
    required int skip,
    required int total,
  }) async {
    await _database.batch(
      (batch) => batch.insertAllOnConflictUpdate(
        _database.productTable,
        products.map(
          (e) => ProductTableCompanion.insert(
            id: Value(e.id),
            title: e.title ?? "",
            description: e.description ?? "",
            category: e.category ?? "",
            price: e.price ?? 0,
            discountPercentage: Value.absentIfNull(e.discountPercentage),
            rating: Value.absentIfNull(e.rating),
            stock: Value.absentIfNull(e.stock),
            brand: Value(e.brand),
            sku: Value(e.sku),
            weight: Value.absentIfNull(e.weight),
            minimumOrderQuantity: Value.absentIfNull(e.minimumOrderQuantity),
            warrantyInformation: Value(e.warrantyInformation),
            shippingInformation: Value(e.shippingInformation),
            availabilityStatus: Value(e.availabilityStatus),
            returnPolicy: Value(e.returnPolicy),
            thumbnail: Value(e.thumbnail),
            images: Value(e.images),
          ),
        ),
      ),
    );
  }
}
