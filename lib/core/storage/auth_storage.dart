import 'dart:developer';

import 'package:bloc_arch_setup/core/storage/base_auth_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage implements BaseAuthStorage {
  const AuthStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const accessTokenKey = "access_token_key";
  static const refreshTokenKey = "refresh_token_key";

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: accessTokenKey);
    } catch (e) {
      log("Token Get Failed with : ${e.toString()}");
      return null;
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await Future.wait([
        _storage.delete(key: accessTokenKey),
        _storage.delete(key: refreshTokenKey),
      ]);
    } catch (e) {
      log("Access Token Delete Failed with : ${e.toString()}");
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: refreshTokenKey);
    } catch (e) {
      log("Refresh Token Get Failed with : ${e.toString()}");
      return null;
    }
  }

  @override
  Future<void> saveToken(String accessToken, String refreshToken) async {
    try {
      await Future.wait([
        _storage.write(key: accessTokenKey, value: accessToken),
        _storage.write(key: refreshTokenKey, value: refreshToken),
      ]);
    } catch (e) {
      log("Token Save Failed with : ${e.toString()}");
    }
  }
}
