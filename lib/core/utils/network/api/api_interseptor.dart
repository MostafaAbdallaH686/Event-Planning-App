import 'package:dio/dio.dart';


class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // await TokenHandeller.refreshAccessToken();
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.badResponse) {
      if (err.response?.statusCode == 401) {
       
      }
      // Handle other status codes
      if (err.response?.statusCode == 403) {
        // Handle forbidden error
      } else if (err.response?.statusCode == 404) {
        // Handle not found error
      } else if (err.response?.statusCode == 500) {
        // Handle server error
      }
    }

    super.onError(err, handler);
  }
}