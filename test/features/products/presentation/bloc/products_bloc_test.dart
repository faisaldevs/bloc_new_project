import 'package:bloc_arch_setup/core/error/failure.dart';
import 'package:bloc_arch_setup/features/products/domain/entities/paginated_products.dart';
import 'package:bloc_arch_setup/features/products/domain/entities/product.dart';
import 'package:bloc_arch_setup/features/products/domain/usecases/get_products.dart';
import 'package:bloc_arch_setup/features/products/presentation/bloc/products_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProducts extends Mock implements GetProducts {}

void main() {
  late ProductsBloc productBloc;
  late MockGetProducts mockGetProducts;

  final products = [
    const ProductEntity(id: 1, title: 'Product 1', price: 10.0),
    const ProductEntity(id: 2, title: 'Product 2', price: 20.0),
  ];

  setUp(() {
    mockGetProducts = MockGetProducts();
    productBloc = ProductsBloc(getProducts: mockGetProducts);
  });

  tearDown(() {
    productBloc.close();
  });

  group("Products Bloc Test", () {
    // blocTest(
    //   "emit [initial] state on Bloc Initialization",
    //   build: () => productBloc,

    //   expect: () => [ProductStatus.initial],
    // );

    test("emit [initial] state on Bloc Initialization", () {
      expect(productBloc.state, ProductsState(status: ProductStatus.initial));
    });

    blocTest(
      "emit [loading,success] state on GetProductStarted event Success",

      //  arrange
      build: () {
        when(
          () => mockGetProducts(
            limit: any(named: "limit"),
            skip: any(named: "skip"),
          ),
        ).thenAnswer(
          (_) async => Right(
            PaginatedProducts(limit: 20, products: products, skip: 0, total: 2),
          ),
        );

        return productBloc;
      },
      //act
      act: (bloc) => bloc.add(GetProductStarted()),

      //assert
      expect: () => [
        ProductsState(status: ProductStatus.loading),
        ProductsState(
          status: ProductStatus.success,
          productData: products,
          hasReachedMax: true,
        ),
      ],
    );
    blocTest(
      "emit [loading,failure] state on GetProductStarted event fail",

      //  arrange
      build: () {
        when(
          () => mockGetProducts(
            limit: any(named: "limit"),
            skip: any(named: "skip"),
          ),
        ).thenAnswer((_) async => Left(UnknownFailure()));

        return productBloc;
      },
      //act
      act: (bloc) => bloc.add(GetProductStarted()),

      //assert
      expect: () => [
        ProductsState(status: ProductStatus.loading),
        ProductsState(
          status: ProductStatus.failure,
          errorMessage: "Something went wrong.",
        ),
      ],
    );

    blocTest(
      "emit [loadingMore, success] state on MoreProductLoded event success",

      //  arrange
      build: () {
        when(
          () => mockGetProducts(
            limit: any(named: "limit"),
            skip: any(named: "skip"),
          ),
        ).thenAnswer(
          (_) async => Right(
            PaginatedProducts(
              total: 40,
              skip: 2,
              limit: 20,
              products: products,
            ),
          ),
        );

        return productBloc;
      },
      //act
      act: (bloc) => bloc.add(MoreProductLoded()),

      //assert
      expect: () => [
        ProductsState(status: ProductStatus.loadMore),
        ProductsState(
          status: ProductStatus.success,
          productData: products,
          hasReachedMax: false,
        ),
      ],
    );
    blocTest(
      "emit [loadingMore, loadMoreFailure] state on MoreProductLoded event Fails",

      //  arrange
      build: () {
        when(
          () => mockGetProducts(
            limit: any(named: "limit"),
            skip: any(named: "skip"),
          ),
        ).thenAnswer((_) async => Left(UnknownFailure()));

        return productBloc;
      },
      //act
      act: (bloc) => bloc.add(MoreProductLoded()),

      //assert
      expect: () => [
        ProductsState(status: ProductStatus.loadMore),
        ProductsState(
          status: ProductStatus.loadMoreFailure,
          errorMessage: "Something went wrong.",
        ),
      ],
    );
  });
}


/*

 test('initial state is ProductStatus.initial', () {
      expect(
        productBloc.state,
        const ProductsState(status: ProductStatus.initial),
      );
    });

    blocTest<ProductsBloc, ProductsState>(
      'emits [loading, success] when GetProductStarted succeeds',
      build: () {
        // arrange
        when(
          () => mockGetProducts(
            limit: any(named: 'limit'),
            skip: any(named: 'skip'),
          ),
        ).thenAnswer(
          (_) async => Right(
            PaginatedProducts(total: 2, skip: 0, limit: 20, products: products),
          ),
        );
        return productBloc;
      },
      act: (bloc) => bloc.add(GetProductStarted()),
      expect: () => [
        const ProductsState(status: ProductStatus.loading),
        ProductsState(
          status: ProductStatus.success,
          productData: products,
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [loading, failure] when GetProductStarted fails',
      build: () {
        // arrange
        when(
          () => mockGetProducts(
            limit: any(named: 'limit'),
            skip: any(named: 'skip'),
          ),
        ).thenAnswer((_) async => const Left(failure));
        return productBloc;
      },
      act: (bloc) => bloc.add(GetProductStarted()),
      expect: () => [
        const ProductsState(status: ProductStatus.loading),
        ProductsState(
          status: ProductStatus.failure,
          errorMessage: failure.message,
        ),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits [loadMore, success] and appends products when MoreProductLoded succeeds',
      seed: () => ProductsState(
        status: ProductStatus.success,
        productData: products,
        hasReachedMax: false,
      ),
      build: () {
        // arrange
        when(
          () => mockGetProducts(
            limit: any(named: 'limit'),
            skip: any(named: 'skip'),
          ),
        ).thenAnswer(
          (_) async => Right(
            PaginatedProducts(total: 4, skip: 2, limit: 20, products: products),
          ),
        );
        return productBloc;
      },
      act: (bloc) => bloc.add(MoreProductLoded()),
      expect: () => [
        ProductsState(status: ProductStatus.loadMore, productData: products),
        ProductsState(
          status: ProductStatus.success,
          productData: [...products, ...products],
          hasReachedMax: true,
        ),
      ],
    );

    blocTest<ProductsBloc, ProductsState>(
      'emits nothing when MoreProductLoded is added but hasReachedMax is true',
      seed: () => ProductsState(
        status: ProductStatus.success,
        productData: products,
        hasReachedMax: true,
      ),
      build: () => productBloc,
      act: (bloc) => bloc.add(MoreProductLoded()),
      expect: () => [],
      verify: (_) => verifyNever(
        () => mockGetProducts(
          limit: any(named: 'limit'),
          skip: any(named: 'skip'),
        ),
      ),
    );
*/