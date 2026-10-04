import 'package:bloc_arch_setup/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

class PaginatedProducts extends Equatable {
  final int total;
  final int skip;
  final int limit;
  final List<ProductEntity> products;
  bool get hasReachedMaxItem => skip + limit >= total;

  const PaginatedProducts({
    required this.total,
    required this.skip,
    required this.limit,
    required this.products,
  });

  @override
  List<Object?> get props => [total, skip, limit];
}
