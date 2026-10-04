import 'package:bloc_arch_setup/core/error/failure.dart';
import 'package:bloc_arch_setup/features/products/domain/entities/paginated_products.dart';
import 'package:bloc_arch_setup/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProducts {
  const GetProducts({required this._repo});
  final ProductRepository _repo;

  Future<Either<Failure, PaginatedProducts>> call({
    required int skip,
    required int limit,
  }) async {
    return _repo.getProducts(limit: limit, skip: skip);
  }
}
