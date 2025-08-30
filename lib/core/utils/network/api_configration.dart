import 'package:dio/dio.dart';
import 'package:event_planning_app/core/utils/network/api_endpoint.dart';

abstract class ApiConfigration {
  static BaseOptions option() => BaseOptions(
        baseUrl: ApiBaseUrl.baseUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 60),
      );
}
