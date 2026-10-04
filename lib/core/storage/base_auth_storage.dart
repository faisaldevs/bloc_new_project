abstract class BaseAuthStorage {
  Future<void> saveToken(String accessToken, String refreshToken);
  Future<void> clearToken();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
}
