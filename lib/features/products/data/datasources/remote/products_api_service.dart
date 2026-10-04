import 'package:bloc_arch_setup/core/network/api_endpoints.dart';
import 'package:bloc_arch_setup/features/products/data/models/product_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'products_api_service.g.dart';

@RestApi()
abstract class ProductsApiService {
  factory ProductsApiService(Dio dio, {String? baseUrl}) = _ProductsApiService;

  @GET(ApiEndpoints.products)
  Future<ProductResponseModel> getProducts(
    @Query("skip") int skip,
    @Query("limit") int limit,
  );
}
