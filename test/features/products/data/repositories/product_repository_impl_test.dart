import 'package:bloc_arch_setup/core/error/failure.dart';
import 'package:bloc_arch_setup/features/products/data/datasources/remote/remote_datasource.dart';
import 'package:bloc_arch_setup/features/products/data/models/product_response_model.dart';
import 'package:bloc_arch_setup/features/products/data/repositories/product_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDatasource extends Mock implements RemoteDatasource {}

void main() {
  late ProductRepositoryImpl repo;
  late MockRemoteDatasource mockRemoteDatasource;

  setUp(() {
    mockRemoteDatasource = MockRemoteDatasource();
    repo = ProductRepositoryImpl(datasource: mockRemoteDatasource);
  });

  final skip = 10;
  final limit = 20;
  final products = ProductResponseModel(
    limit: 20,
    products: [],
    skip: 10,
    total: 30,
  );

  group("Product Repository Test with Remote Datasource", () {
    test('Get Products with success', () async {
      //arrange
      when(
        () => mockRemoteDatasource.getProducts(
          skip: any(named: "skip"),
          limit: any(named: "limit"),
        ),
      ).thenAnswer((_) async => products);

      // act

      final result = await repo.getProducts(skip: skip, limit: limit);

      //assert
      expect(result, Right(products.toEntity()));
    });

    test('Get Products Failure on Connection Timeout', () async {
      //arrange
      when(
        () => mockRemoteDatasource.getProducts(
          skip: any(named: "skip"),
          limit: any(named: "limit"),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // act

      final result = await repo.getProducts(skip: skip, limit: limit);

      //assert
      expect(result, Left(ConnectionTimeoutFailure()));
    });

    test('Get Products Failure on Connection Failure', () async {
      //arrange
      when(
        () => mockRemoteDatasource.getProducts(
          skip: any(named: "skip"),
          limit: any(named: "limit"),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
          response: Response(requestOptions: RequestOptions()),
        ),
      );

      // act

      final result = await repo.getProducts(skip: skip, limit: limit);

      //assert
      expect(result, Left(ConnectionFailure()));
    });

    test('Get Products Failure on Bad Response with server message', () async {
      //arrange
      when(
        () => mockRemoteDatasource.getProducts(
          skip: any(named: "skip"),
          limit: any(named: "limit"),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 404,
            data: {'message': 'Product not found'},
          ),
        ),
      );

      // act
      final result = await repo.getProducts(skip: skip, limit: limit);

      //assert
      expect(
        result,
        Left(BadResponseFailure(code: 404, message: 'Product not found')),
      );
    });

    test(
      'Get Products Failure on Bad Response without server message',
      () async {
        //arrange
        when(
          () => mockRemoteDatasource.getProducts(
            skip: any(named: "skip"),
            limit: any(named: "limit"),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 500,
            ),
          ),
        );

        // act
        final result = await repo.getProducts(skip: skip, limit: limit);

        //assert
        expect(
          result,
          Left(BadResponseFailure(code: 500, message: 'Server error (500).')),
        );
      },
    );

    test('Get Products Failure on Cancel', () async {
      //arrange
      when(
        () => mockRemoteDatasource.getProducts(
          skip: any(named: "skip"),
          limit: any(named: "limit"),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.cancel,
        ),
      );

      // act
      final result = await repo.getProducts(skip: skip, limit: limit);

      //assert
      expect(result, Left(CancelFailure()));
    });

    test('Get Products Failure on Bad Certificate', () async {
      //arrange
      when(
        () => mockRemoteDatasource.getProducts(
          skip: any(named: "skip"),
          limit: any(named: "limit"),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.badCertificate,
        ),
      );

      // act
      final result = await repo.getProducts(skip: skip, limit: limit);

      //assert
      expect(result, Left(BadCertificateFailure()));
    });

    test('Get Products Failure on Unknown Dio Exception', () async {
      //arrange
      when(
        () => mockRemoteDatasource.getProducts(
          skip: any(named: "skip"),
          limit: any(named: "limit"),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.unknown,
          message: 'Socket closed',
        ),
      );

      // act
      final result = await repo.getProducts(skip: skip, limit: limit);

      //assert
      expect(result, Left(UnknownFailure(message: 'Socket closed')));
    });

    test('Get Products Failure on Unexpected Exception', () async {
      //arrange
      when(
        () => mockRemoteDatasource.getProducts(
          skip: any(named: "skip"),
          limit: any(named: "limit"),
        ),
      ).thenThrow(Exception('boom'));

      // act
      final result = await repo.getProducts(skip: skip, limit: limit);

      //assert
      expect(
        result,
        Left(UnknownFailure(message: 'Unknown Error: Exception: boom')),
      );
    });
  });
}
