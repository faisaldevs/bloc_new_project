import 'package:bloc_arch_setup/core/error/failure.dart';
import 'package:bloc_arch_setup/features/products/data/datasources/remote/remote_datasource.dart';
import 'package:bloc_arch_setup/features/products/domain/entities/paginated_products.dart';
import 'package:bloc_arch_setup/features/products/domain/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDatasource _datasource;

  const ProductRepositoryImpl({required this._datasource});

  @override
  Future<Either<Failure, PaginatedProducts>> getProducts({
    required int skip,
    required int limit,
  }) async {
    try {
      final products = await _datasource.getProducts(limit: limit, skip: skip);

      return Right(products.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioError(e));
    } catch (e) {
      return Left(UnknownFailure(message: "Unknown Error: ${e.toString()}"));
    }
  }

  Failure _mapDioError(DioException e) {
    final code = e.response?.statusCode;
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => const ConnectionTimeoutFailure(),
      DioExceptionType.connectionError => const ConnectionFailure(),
      DioExceptionType.badResponse => BadResponseFailure(
        code: code,
        message: _serverMessage(e.response?.data) ?? 'Server error ($code).',
      ),
      DioExceptionType.cancel => const CancelFailure(),
      DioExceptionType.badCertificate => const BadCertificateFailure(),
      DioExceptionType.unknown => UnknownFailure(
        message: e.message ?? 'Something went wrong.',
      ),
      _ => Failure(message: e.message ?? 'Something went wrong.'),
    };
  }

  String? _serverMessage(dynamic data) =>
      data is Map && data['message'] is String
      ? data['message'] as String
      : null;
}
