import 'package:bloc_arch_setup/features/products/data/models/product_response_model.dart';

abstract class RemoteDatasource {
  Future<ProductResponseModel> getProducts({
    required int skip,
    required int limit,
  });
}
