part of 'products_bloc.dart';

enum ProductStatus {
  initial,
  loading,
  success,
  failure,
  loadMore,
  loadMoreFailure,
}

class ProductsState extends Equatable {
  final ProductStatus status;
  final List<ProductEntity> productData;
  final String? errorMessage;
  final bool hasReachedMax;

  const ProductsState({
    this.status = ProductStatus.initial,
    this.productData = const [],
    this.errorMessage,
    this.hasReachedMax = false,
  });

  ProductsState copyWith({
    ProductStatus? status,
    List<ProductEntity>? productData,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return ProductsState(
      status: status ?? this.status,
      productData: productData ?? this.productData,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, productData, errorMessage, hasReachedMax];
}
