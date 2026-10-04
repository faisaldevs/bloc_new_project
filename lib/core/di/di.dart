import 'package:bloc_arch_setup/core/network/dio_client.dart';
import 'package:bloc_arch_setup/core/storage/auth_storage.dart';
import 'package:bloc_arch_setup/core/storage/base_auth_storage.dart';
import 'package:bloc_arch_setup/features/products/data/datasources/remote/products_api_service.dart';
import 'package:bloc_arch_setup/features/products/data/datasources/remote/remote_datasource.dart';
import 'package:bloc_arch_setup/features/products/data/datasources/remote/remote_datasource_impl.dart';
import 'package:bloc_arch_setup/features/products/data/repositories/product_repository_impl.dart';
import 'package:bloc_arch_setup/features/products/domain/repositories/product_repository.dart';
import 'package:bloc_arch_setup/features/products/domain/usecases/get_products.dart';
import 'package:bloc_arch_setup/features/products/presentation/bloc/products_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependency() async {
  await _init();
  _productDI();
}

Future<void> _init() async {
  sl.registerLazySingleton<Dio>(() => DioClient.dioClient());
  sl.registerLazySingleton<FlutterSecureStorage>(() => FlutterSecureStorage());
  sl.registerLazySingleton<BaseAuthStorage>(
    () => AuthStorage(sl<FlutterSecureStorage>()),
  );
}

void _productDI() {
  sl.registerLazySingleton<ProductsApiService>(
    () => ProductsApiService(sl<Dio>()),
  );
  sl.registerLazySingleton<RemoteDatasource>(
    () => RemoteDatasourceImpl(api: sl<ProductsApiService>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(datasource: sl<RemoteDatasource>()),
  );
  // sl.registerLazySingleton<ProductRepository>(
  //   () => ProductRepositoryImpl(datasource: sl<RemoteDatasource>()),
  // );
  sl.registerLazySingleton<GetProducts>(
    () => GetProducts(repo: sl<ProductRepository>()),
  );
  sl.registerFactory<ProductsBloc>(
    () => ProductsBloc(getProducts: sl<GetProducts>()),
  );
}
