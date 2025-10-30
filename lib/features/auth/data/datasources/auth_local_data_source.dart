import 'dart:convert';

import 'package:event_planning_app/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<void> cacheUser(UserModel user);

  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<UserModel?> getCachedUser();

  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'cached_user';

  final SharedPreferences _prefs;

  const AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _prefs.setString(_accessTokenKey, accessToken);
    await _prefs.setString(_refreshTokenKey, refreshToken);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<String?> getAccessToken() async {
    return _prefs.getString(_accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _prefs.getString(_refreshTokenKey);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;

    try {
      return UserModel.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
    await _prefs.remove(_userKey);
  }
}