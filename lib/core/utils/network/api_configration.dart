import 'package:dio/dio.dart';
import 'package:event_planning_app/core/utils/network/api_endpoint.dart';

// not used there is no api
abstract class ApiConfigration {
  static BaseOptions option() => BaseOptions(
        baseUrl: ApiBaseUrl.baseUrl,
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 60),
      );
}
