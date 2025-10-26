// ToDo later ::Mostafa

//Api helper class to handle API requests using Dio package with token refresh mechanism.
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/errors/network_failure.dart';
import 'package:event_planning_app/core/utils/network/api_keypoint.dart';
import 'package:event_planning_app/core/utils/network/token_service.dart';

// class ApiHelper {
//   ApiHelper({required Dio dio, required TokenService tokenService})
//       : _dio = dio,
//         _tokenService = tokenService {
//     _setupInterceptors();
//   }

//   final Dio _dio;
//   final TokenService _tokenService;

//   void _setupInterceptors() {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           // Add auth headers if needed
//           final headers = _getHeaders(options.uri.path.contains('refresh'));

//           options.headers.addAll(headers);
//           return handler.next(options);
//         },
//         onError: (error, handler) async {
//           if (error.response?.statusCode == 401) {
//             try {
//               final didRefresh = await _tokenService.refreshAccessToken();

//               if (didRefresh) {
//                 // Retry the original request
//                 final retryResponse = await _retryRequest(error.requestOptions);
//                 return handler.resolve(retryResponse);
//               }
//             } catch (e) {
//               return handler.next(error);
//             }
//           }
//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   Future<dynamic> postMultipart({
//     required String endPoint,
//     required Map<String, dynamic> fields,
//     File? file,
//     String fileField = 'image',
//     bool isAuth = true,
//     ProgressCallback? onSendProgress,
//   }) async {
//     try {
//       final headers = getOption(isAuth);

//       final formData = FormData();

// // Add fields safely
//       fields.forEach((key, value) {
//         if (value == null) return;
//         if (value is List || value is Map) {
//           formData.fields.add(MapEntry(key, jsonEncode(value)));
//         } else {
//           formData.fields.add(MapEntry(key, value.toString()));
//         }
//       });

//       if (file != null) {
//         final ext = p.extension(file.path).replaceFirst('.', '').toLowerCase();
//         final mime = _getMimeType(file.path); // e.g., jpeg, png
//         formData.files.add(MapEntry(
//           fileField,
//           await MultipartFile.fromFile(
//             file.path,
//             filename: p.basename(file.path),
//             contentType: MediaType('image', mime),
//           ),
//         ));
//       }

//       final response = await _dio.post(
//         endPoint,
//         data: formData,
//         options: Options(
//           headers: headers,
//           contentType: 'multipart/form-data',
//         ),
//         onSendProgress: onSendProgress,
//       );

//       return response.data;
//     } on DioException catch (e) {
//       throw CustomDioException(
//         errMessage: ServerFailure.fromDioError(e).errorMessage,
//       );
//     }
//   }

//   Future<Response> _retryRequest(RequestOptions requestOptions) async {
//     final headers = _getHeaders(requestOptions.path.contains('refresh'));

//     return _dio.request(
//       requestOptions.path,
//       data: requestOptions.data,
//       queryParameters: requestOptions.queryParameters,
//       options: Options(
//         method: requestOptions.method,
//         headers: headers,
//         contentType: requestOptions.contentType,
//         responseType: requestOptions.responseType,
//         receiveTimeout: requestOptions.receiveTimeout,
//         sendTimeout: requestOptions.sendTimeout,
//       ),
//     );
//   }

//   Map<String, dynamic> _getHeaders(bool isRefreshToken) {
//     if (isRefreshToken) {
//       final refreshToken = CacheHelper.instance.getDataString(
//         key: SharedPrefereneceKey.refreshtoken,
//       );
//       if (refreshToken != null) {
//         return {ApiKeypoint.authorization: "Bearer $refreshToken"};
//       }
//     } else {
//       final accessToken = CacheHelper.instance.getDataString(
//         key: SharedPrefereneceKey.accesstoken,
//       );
//       if (accessToken != null) {
//         return {ApiKeypoint.authorization: "Bearer $accessToken"};
//       }
//     }
//     return {};
//   }

//   Future<dynamic> get({
//     required String endPoint,
//     bool isAuth = false,
//   }) async {
//     try {
//       final response = await _dio.get(endPoint);
//       return response.data;
//     } on DioException catch (e) {
//       throw CustomDioException(
//         errMessage: ServerFailure.fromDioError(e).errorMessage,
//       );
//     }
//   }

//   Future<dynamic> post({
//     required String endPoint,
//     required Map<String, dynamic>? data,
//     bool isAuth = false,
//   }) async {
//     try {
//       final response = await _dio.post(
//         endPoint,
//         data: data,
//         options: Options(contentType: 'application/json'),
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw CustomDioException(
//         errMessage: ServerFailure.fromDioError(e).errorMessage,
//       );
//     }
//   }

//   Future<dynamic> uploadFile({
//     required String endPoint,
//     required File file,
//     required String fileField,
//     bool isAuth = false,
//   }) async {
//     try {
//       final headers = getOption(isAuth);
//       final mimeType = _getMimeType(file.path);

//       final formData = dio.FormData.fromMap({
//         fileField: await dio.MultipartFile.fromFile(
//           file.path,
//           filename: file.path.split('/').last,
//           contentType: MediaType('image', mimeType),
//         ),
//       });
//       if (!await file.exists()) {
//         throw CustomDioException(errMessage: 'Selected file does not exist');
//       }

//       final response = await _dio.post(
//         endPoint,
//         data: formData,
//         options: dio.Options(
//           headers: headers,
//           contentType: 'multipart/form-data',
//         ),
//       );

//       return response.data;
//     } on dio.DioException catch (e) {
//       throw CustomDioException(
//         errMessage: ServerFailure.fromDioError(e).errorMessage,
//       );
//     }
//   }

//   String _getMimeType(String path) {
//     final ext = path.split('.').last.toLowerCase();
//     switch (ext) {
//       case 'jpg':
//       case 'jpeg':
//         return 'jpeg';
//       case 'png':
//         return 'png';
//       case 'gif':
//         return 'gif';
//       default:
//         return 'jpeg';
//     }
//   }

//   Future<dynamic> put({
//     required String endPoint,
//     required Map<String, dynamic>? data,
//     bool isAuth = false,
//   }) async {
//     try {
//       final headers = getOption(isAuth);

//       final response = await _dio.put(
//         endPoint,
//         data: data,
//         options: dio.Options(
//           headers: headers,
//           contentType: 'application/json',
//         ),
//       );

//       return response.data;
//     } on dio.DioException catch (e) {
//       throw CustomDioException(
//           errMessage: ServerFailure.fromDioError(e).errorMessage);
//     }
//   }

//   Future<dynamic> patch(String endPoint) async {
//     final response = await _dio.patch(endPoint);
//     return response.data;
//   }

//   Future<dynamic> delete({
//     required String endPoint,
//     bool isAuth = false,
//   }) async {
//     try {
//       final headers = getOption(isAuth);
//       final response = await _dio.delete(
//         endPoint,
//         options: dio.Options(
//           headers: headers,
//           contentType: 'application/json',
//         ),
//       );
//       return response.data;
//     } on dio.DioException catch (e) {
//       throw CustomDioException(
//           errMessage: ServerFailure.fromDioError(e).errorMessage);
//     }
//   }

//   Map<String, dynamic> getOption(
//     bool isAuth, {
//     bool isReferechToken = false,
//   }) {
//     if (isReferechToken) {
//       final refreshToken = CacheHelper.instance.getDataString(
//         key: SharedPrefereneceKey.refreshtoken,
//       );
//       if (refreshToken != null) {
//         return {
//           ApiKeypoint.authorization: "Bearer $refreshToken",
//         };
//       }
//     }

//     if (isAuth) {
//       final accessToken =
//       CacheHelper.instance.getDataString(
//         key: SharedPrefereneceKey.accesstoken,
//       );

//       if (accessToken != null) {
//         return {
//           ApiKeypoint.authorization: "Bearer $accessToken",
//         };
//       }
//     }

//     return {};
//   }
// }
// ⚠️ TEMPORARY: Static token for testing
// TODO: Remove this when authentication is implemented
class _DevConfig {
  // 🔴 REPLACE THIS WITH YOUR ACTUAL TOKEN FROM POSTMAN
  static const String staticAccessToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjE1YzhhZjNjLTgzNWMtNDk0Yy04ODI2LTc0ZjE2MGNlMzQxMSIsInJvbGUiOiJPUkdBTklaRVIiLCJpYXQiOjE3NjE0ODkxMjYsImV4cCI6MTc2MTQ5MDAyNn0.mMDlEl8kpmSoZZL2UCR7OQFAx9VS42q693dyUn-et0g';

  // Set to false once you implement real authentication
  static const bool useStaticToken = true;
}

class ApiHelper {
  ApiHelper({required Dio dio, required TokenService tokenService})
      : _dio = dio,
        _tokenService = tokenService {
    _setupInterceptors();
  }

  final Dio _dio;
  final TokenService _tokenService;

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final headers = _getHeaders(options.uri.path.contains('refresh'));
          options.headers.addAll(headers);

          // Debug log to verify token is being sent
          if (options.headers.containsKey(ApiKeypoint.authorization)) {
            print(
                '🔑 Auth header: ${options.headers[ApiKeypoint.authorization]}');
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          // Skip refresh logic if using static token
          if (_DevConfig.useStaticToken) {
            return handler.next(error);
          }

          if (error.response?.statusCode == 401) {
            try {
              final didRefresh = await _tokenService.refreshAccessToken();
              if (didRefresh) {
                final retryResponse = await _retryRequest(error.requestOptions);
                return handler.resolve(retryResponse);
              }
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// Get headers for authentication
  Map<String, dynamic> _getHeaders(bool isRefreshToken) {
    // 🔴 TEMPORARY: Use static token for testing
    if (_DevConfig.useStaticToken) {
      return {
        ApiKeypoint.authorization: 'Bearer ${_DevConfig.staticAccessToken}',
      };
    }

    // ✅ PRODUCTION: Get from cache (implement this after login)
    if (isRefreshToken) {
      final refreshToken = CacheHelper.instance.getDataString(
        key: SharedPrefereneceKey.refreshtoken,
      );
      if (refreshToken != null) {
        return {ApiKeypoint.authorization: "Bearer $refreshToken"};
      }
    } else {
      final accessToken = CacheHelper.instance.getDataString(
        key: SharedPrefereneceKey.accesstoken,
      );
      if (accessToken != null) {
        return {ApiKeypoint.authorization: "Bearer $accessToken"};
      }
    }

    return {};
  }

  /// Get options with auth header (used by individual methods)
  Map<String, dynamic> getOption(
    bool isAuth, {
    bool isRefreshToken = false,
  }) {
    if (!isAuth) return {};

    // 🔴 TEMPORARY: Use static token for testing
    if (_DevConfig.useStaticToken) {
      return {
        ApiKeypoint.authorization: 'Bearer ${_DevConfig.staticAccessToken}',
      };
    }

    // ✅ PRODUCTION: Get from cache
    if (isRefreshToken) {
      final refreshToken = CacheHelper.instance.getDataString(
        key: SharedPrefereneceKey.refreshtoken,
      );
      if (refreshToken != null) {
        return {ApiKeypoint.authorization: "Bearer $refreshToken"};
      }
    }

    if (isAuth) {
      final accessToken = CacheHelper.instance.getDataString(
        key: SharedPrefereneceKey.accesstoken,
      );
      if (accessToken != null) {
        return {ApiKeypoint.authorization: "Bearer $accessToken"};
      }
    }

    return {};
  }

  /// POST multipart/form-data (for file uploads with event data)
  Future<dynamic> postMultipart({
    required String endPoint,
    required Map<String, dynamic> fields,
    File? file,
    String fileField = 'image',
    bool isAuth = true,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final headers = getOption(isAuth);
      final formData = FormData();

      // Add form fields
      fields.forEach((key, value) {
        if (value == null) return;

        // Handle complex types
        if (value is List || value is Map) {
          formData.fields.add(MapEntry(key, jsonEncode(value)));
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Add file if provided
      if (file != null) {
        if (!await file.exists()) {
          throw CustomDioException(
            errMessage: 'Image file does not exist at path: ${file.path}',
          );
        }

        final mimeType = _getMimeType(file.path);
        formData.files.add(
          MapEntry(
            fileField,
            await MultipartFile.fromFile(
              file.path,
              filename: p.basename(file.path),
              contentType: MediaType('image', mimeType),
            ),
          ),
        );

        print('📎 Uploading file: ${p.basename(file.path)} ($mimeType)');
      }

      // Debug: Print what we're sending
      print('📤 POST $endPoint');
      print('📋 Fields: ${fields.keys.join(", ")}');

      final response = await _dio.post(
        endPoint,
        data: formData,
        options: Options(
          headers: headers,
          contentType: 'multipart/form-data',
        ),
        onSendProgress: onSendProgress,
      );

      print('✅ Response: ${response.statusCode}');
      return response.data;
    } on DioException catch (e) {
      print('❌ DioException: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      }
      throw CustomDioException(
        errMessage: ServerFailure.fromDioError(e).errorMessage,
      );
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw CustomDioException(errMessage: 'Unexpected error: $e');
    }
  }

  Future<dynamic> get({
    required String endPoint,
    bool isAuth = false,
  }) async {
    try {
      final headers = isAuth ? getOption(true) : <String, dynamic>{};
      final response = await _dio.get(
        endPoint,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw CustomDioException(
        errMessage: ServerFailure.fromDioError(e).errorMessage,
      );
    }
  }

  Future<dynamic> post({
    required String endPoint,
    required Map<String, dynamic>? data,
    bool isAuth = false,
  }) async {
    try {
      final headers = isAuth ? getOption(true) : <String, dynamic>{};
      final response = await _dio.post(
        endPoint,
        data: data,
        options: Options(
          headers: headers,
          contentType: 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw CustomDioException(
        errMessage: ServerFailure.fromDioError(e).errorMessage,
      );
    }
  }

  Future<dynamic> put({
    required String endPoint,
    required Map<String, dynamic>? data,
    bool isAuth = false,
  }) async {
    try {
      final headers = getOption(isAuth);
      final response = await _dio.put(
        endPoint,
        data: data,
        options: Options(
          headers: headers,
          contentType: 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw CustomDioException(
        errMessage: ServerFailure.fromDioError(e).errorMessage,
      );
    }
  }

  Future<dynamic> delete({
    required String endPoint,
    bool isAuth = false,
  }) async {
    try {
      final headers = getOption(isAuth);
      final response = await _dio.delete(
        endPoint,
        options: Options(
          headers: headers,
          contentType: 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw CustomDioException(
        errMessage: ServerFailure.fromDioError(e).errorMessage,
      );
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final headers = _getHeaders(requestOptions.path.contains('refresh'));
    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: headers,
        contentType: requestOptions.contentType,
        responseType: requestOptions.responseType,
        receiveTimeout: requestOptions.receiveTimeout,
        sendTimeout: requestOptions.sendTimeout,
      ),
    );
  }

  String _getMimeType(String path) {
    final ext = p.extension(path).replaceFirst('.', '').toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'jpeg';
      case 'png':
        return 'png';
      case 'gif':
        return 'gif';
      case 'webp':
        return 'webp';
      default:
        return 'jpeg';
    }
  }
}
