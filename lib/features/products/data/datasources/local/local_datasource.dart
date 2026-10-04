import 'package:bloc_arch_setup/core/database/app_database.dart';
import 'package:bloc_arch_setup/features/products/data/models/product_response_model.dart';

abstract class LocalDatasource {
  Future<List<ProductTableData>> getProducts({
    required int skip,
    required int limit,
  });
  Future<int> count();

  Future<void> saveProducts(
    List<Product> products, {
    required int skip,
    required int total,
  });
}
