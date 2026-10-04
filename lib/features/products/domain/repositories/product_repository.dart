import 'package:bloc_arch_setup/core/error/failure.dart';
import 'package:bloc_arch_setup/features/products/domain/entities/paginated_products.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductRepository {
  Future<Either<Failure, PaginatedProducts>> getProducts({
    required int skip,
    required int limit,
  });
}
