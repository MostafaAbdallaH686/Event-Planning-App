import 'package:dio/dio.dart';
import 'package:event_planning_app/core/utils/errors/dio_app_expception.dart';
import 'package:event_planning_app/core/utils/network/api/api_consumer.dart';
import 'package:event_planning_app/core/utils/network/api/api_interseptor.dart';
import 'package:event_planning_app/core/utils/network/api_endpoint.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options = BaseOptions(
      baseUrl: ApiBaseUrl.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    );
    dio.interceptors.add(ApiInterceptors());
    dio.interceptors.add(LogInterceptor(
        request: true,
        error: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true));
  }

  @override
  Future delete(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
      bool isFormData = false}) {
    try {
      return dio
          .delete(url,
              data: isFormData ? FormData.fromMap({...?data}) : data,
              queryParameters: queryParameters,
              options: Options(headers: headers))
          .then((response) => response);
    } on DioException catch (e) {
      throw DioAppException.fromDioException(e);
    }
  }

  @override
  Future get(String url,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? headers}) {
    try {
      return dio
          .get(url,
              queryParameters: queryParameters,
              options: Options(headers: headers))
          .then((response) => response);
    } on DioException catch (e) {
      throw DioAppException.fromDioException(e);
    }
  }

  @override
  Future patch(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      bool isFormData = false}) {
    try {
      return dio
          .patch(url,
              data: isFormData ? FormData.fromMap({...?data}) : data,
              queryParameters: queryParameters,
              options: Options(headers: headers))
          .then((response) => response);
    } on DioException catch (e) {
      throw DioAppException.fromDioException(e);
    }
  }

  @override
  Future post(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      bool isFormData = false}) async {
    try {
      var response = await dio.post(url,
          data: isFormData ? FormData.fromMap({...?data}) : data,
          queryParameters: queryParameters,
          options: Options(headers: headers));
      return response;
    } on DioException catch (e) {
      throw DioAppException.fromDioException(e);
    }
  }
}
