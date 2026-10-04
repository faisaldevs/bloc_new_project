import 'package:bloc_arch_setup/features/products/data/datasources/remote/products_api_service.dart';
import 'package:bloc_arch_setup/features/products/data/datasources/remote/remote_datasource.dart';
import 'package:bloc_arch_setup/features/products/data/models/product_response_model.dart';

class RemoteDatasourceImpl implements RemoteDatasource {
  const RemoteDatasourceImpl({required this._api});
  final ProductsApiService _api;

  @override
  Future<ProductResponseModel> getProducts({
    required int skip,
    required int limit,
  }) {
    return _api.getProducts(skip, limit);
  }
}
