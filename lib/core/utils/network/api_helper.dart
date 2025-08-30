// ToDo later ::Mostafa

// import 'dart:io';

// import 'package:dio/dio.dart' as dio;
// import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
// import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
// import 'package:event_planning_app/core/utils/failure/dio_exception.dart';
// import 'package:event_planning_app/core/utils/network/api_keypoint.dart';

// class ApiHelper {
//   ApiHelper._() {
//     objectDio.interceptors.add(
//       InterceptorsWrapper(onRequest: (options, handler) {
//         return handler.next(options);
//       }, onResponse: (response, handler) {
//         return handler.next(response);
//       }, onError: (e, handler) async {
//         if (e.response?.statusCode == 401) {
//           final didRefresh = await handleExpairedAcessToken();

//           if (didRefresh) {
//             final newAccessToken = CacheHelper().getDataString(
//               key: SharedPrefereneceKey.accesstoken,
//             );

//             final requestOptions = e.requestOptions;

//             if (newAccessToken != null) {
//               requestOptions.headers[ApiKeypoint.authorization] =
//                   "Bearer $newAccessToken";

//               try {
//                 final retryResponse = await objectDio.request(
//                   requestOptions.path,
//                   data: requestOptions.data,
//                   queryParameters: requestOptions.queryParameters,
//                   options: Options(
//                     method: requestOptions.method,
//                     headers: requestOptions.headers,
//                     contentType: requestOptions.contentType,
//                     responseType: requestOptions.responseType,
//                     receiveTimeout: requestOptions.receiveTimeout,
//                     sendTimeout: requestOptions.sendTimeout,
//                   ),
//                 );

//                 return handler.resolve(retryResponse);
//               } catch (retryError) {
//                 return handler.reject(retryError as DioException);
//               }
//             }
//           }
//         }

//         return handler.next(e);
//       }),
//     );
//   }
//   static final ApiHelper _instance = ApiHelper._();
//   factory ApiHelper() => _instance;

//   final objectDio = dio.Dio(ApiConfigration.option());

//   Future<dynamic> get({
//     required String endPoint,
//     bool isAuth = false,
//   }) async {
//     try {
//       final headers = getOption(isAuth);

//       final response =
//           await objectDio.get(endPoint, options: dio.Options(headers: headers));

//       return response.data;
//     } on dio.DioException catch (e) {
//       if (e.response?.statusCode == 401 && isAuth) {
//         // Token expired? Try refresh
//         final didRefresh = await handleExpairedAcessToken();
//         if (didRefresh) {
//           // Retry original request with new token
//           final retryHeaders = getOption(isAuth);
//           final retryResponse = await objectDio.get(
//             endPoint,
//             options: dio.Options(headers: retryHeaders),
//           );
//           return retryResponse.data;
//         }
//       }

//       throw CustomDioException(
//           errMessage: ServerFailure.fromDioError(e).errorMessage);
//     }
//   }

//   Future<dynamic> post({
//     required String endPoint,
//     required Map<String, dynamic>? data,
//     bool isAuth = false,
//     bool isReferechToken = false,
//   }) async {
//     try {
//       final headers = getOption(isAuth, isReferechToken: isReferechToken);

//       final response = await objectDio.post(
//         endPoint,
//         data: data,
//         options: dio.Options(
//           headers: headers,
//           contentType: 'application/json',
//         ),
//       );

//       return response.data;
//     } on dio.DioException catch (e) {
//       if (e.response?.statusCode == 401 && isAuth) {
//         final didRefresh = await handleExpairedAcessToken();
//         if (didRefresh) {
//           final retryHeaders = getOption(isAuth);
//           final retryResponse = await objectDio.post(
//             endPoint,
//             data: data,
//             options: dio.Options(
//               headers: retryHeaders,
//               contentType: 'application/json',
//             ),
//           );
//           return retryResponse.data;
//         }
//       }

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

//       final response = await objectDio.post(
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

//       final response = await objectDio.put(
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
//     final response = await objectDio.patch(endPoint);
//     return response.data;
//   }

//   Future<dynamic> delete({
//     required String endPoint,
//     bool isAuth = false,
//   }) async {
//     try {
//       final headers = getOption(isAuth);
//       final response = await objectDio.delete(
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
//     final cacheHelper = CacheHelper();

//     if (isReferechToken) {
//       final refreshToken = cacheHelper.getDataString(
//         key: SharedPrefereneceKey.refreshtoken,
//       );
//       if (refreshToken != null) {
//         return {
//           ApiKeypoint.authorization: "Bearer $refreshToken",
//         };
//       }
//     }

//     if (isAuth) {
//       final accessToken = cacheHelper.getDataString(
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
