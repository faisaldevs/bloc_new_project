import 'package:bloc_arch_setup/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static Dio dioClient() {
    return Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
        ),
      )
      ..interceptors.addAll([
        if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
      ]);
  }
}
