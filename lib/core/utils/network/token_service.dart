import 'package:dio/dio.dart';
import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/network/api_endpoint.dart';
import 'package:event_planning_app/core/utils/network/api_keypoint.dart';
import 'package:event_planning_app/features/auth/view/login/login_screen.dart';
import 'package:flutter/material.dart';

//ToDo :: Mostafa :: Implement Token Refresh Logic
class TokenService {
  final CacheHelper cacheHelper;
  final Dio dio;

  TokenService({required this.cacheHelper, required this.dio});

  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = cacheHelper.getDataString(
        key: SharedPrefereneceKey.refreshtoken,
      );

      if (refreshToken == null) {
        handleRefreshTokenExpired();
        return false;
      }

      final response = await dio.get(
        "${ApiEndpoint.refreshToken}?token=$refreshToken",
      );

      final newAccessToken = response.data[ApiKeypoint.accesstoken];
      if (newAccessToken != null && newAccessToken is String) {
        await cacheHelper.saveData(
          key: SharedPrefereneceKey.accesstoken,
          value: newAccessToken,
        );
        return true;
      }

      handleRefreshTokenExpired();
      return false;
    } on DioException catch (_) {
      handleRefreshTokenExpired();
      return false;
    } catch (_) {
      handleRefreshTokenExpired();
      return false;
    }
  }

  void handleRefreshTokenExpired() {
    cacheHelper.clearData();
    Future.microtask(() {});
  }
}
