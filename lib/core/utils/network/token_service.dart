
import 'package:shared_preferences/shared_preferences.dart';

//ToDo :: Mostafa :: Implement Token Refresh Logic
class TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  final SharedPreferences _prefs;

  TokenService(this._prefs);

  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  /// Refresh access token using refresh token
  Future<bool> refreshAccessToken() async {
    // This will be called by ApiHelper interceptor
    // The actual refresh is handled by AuthRepository
    return false; // Placeholder
  }
}