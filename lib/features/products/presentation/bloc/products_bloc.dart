import 'package:bloc_arch_setup/features/products/domain/entities/product.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc_arch_setup/features/products/domain/usecases/get_products.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts _getProducts;
  ProductsBloc({required this._getProducts})
    : super(ProductsState(status: ProductStatus.initial)) {
    on<GetProductStarted>(
      _getProductStartedHandler,
      transformer: restartable(),
    );
    on<MoreProductLoded>(_moreProductLodedHandler, transformer: droppable());
  }

  Future<void> _getProductStartedHandler(
    GetProductStarted event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    final data = await _getProducts(limit: 20, skip: 0);

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status: ProductStatus.success,
          productData: success.products,
          hasReachedMax: success.hasReachedMaxItem,
        ),
      ),
    );
  }

  Future<void> _moreProductLodedHandler(
    MoreProductLoded event,
    Emitter<ProductsState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.status == ProductStatus.loading ||
        state.status == ProductStatus.loadMore) {
      return;
    }

    emit(state.copyWith(status: ProductStatus.loadMore));

    final data = await _getProducts(limit: 20, skip: state.productData.length);

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.loadMoreFailure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        state.copyWith(
          status: ProductStatus.success,
          productData: [...state.productData, ...success.products],
          hasReachedMax: success.hasReachedMaxItem,
        ),
      ),
    );
  }
}
