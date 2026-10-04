import 'package:bloc_arch_setup/core/storage/base_auth_storage.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends QueuedInterceptor {
  final BaseAuthStorage authStorage;
  AuthInterceptor({required this.authStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await authStorage.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }
    handler.next(options);
  }
}
