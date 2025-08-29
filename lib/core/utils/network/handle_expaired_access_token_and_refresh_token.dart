// ToDo later ::Mostafa

// import 'package:to_do_app/core/cache/cache_helper.dart';
// import 'package:to_do_app/core/cache/shared_preferenece_key.dart';
// import 'package:to_do_app/core/failure/dio_exception.dart';
// import 'package:to_do_app/core/function/app_route.dart';
// import 'package:to_do_app/core/network/api_endpoint.dart';
// import 'package:to_do_app/core/network/api_helper.dart';
// import 'package:to_do_app/core/network/api_keypoint.dart';
// import 'package:to_do_app/features/auth/login/presentation/login_screen.dart';

// Future<bool> handleExpairedAcessToken() async {
//   final apiHelper = ApiHelper();
//   final cacheHelper = CacheHelper();

//   try {
//     final refreshToken = cacheHelper.getDataString(
//       key: SharedPrefereneceKey.refreshtoken,
//     );

//     if (refreshToken == null) {
//       handleExpairedRefrechToken();
//       return false;
//     }

//     final response = await apiHelper.get(
//       endPoint: "${ApiEndpoint.refreshtoken}?token=$refreshToken",
//     );

//     final newAccessToken = response[ApiKeypoint.accesstoken];
//     if (newAccessToken != null && newAccessToken is String) {
//       await cacheHelper.saveData(
//         key: SharedPrefereneceKey.accesstoken,
//         value: newAccessToken,
//       );
//       return true;
//     }

//     // If no new access token was returned
//     handleExpairedRefrechToken();
//     return false;
//   } on CustomDioException catch (_) {
//     handleExpairedRefrechToken();
//     return false;
//   } catch (_) {
//     handleExpairedRefrechToken();
//     return false;
//   }
// }

// void handleExpairedRefrechToken() {
//   final cacheHelper = CacheHelper();
//   cacheHelper.clearData();
//   Future.microtask(() {
//     AppRoute.navigateToAndDeleteAllPathRoute(LoginScreen());
//   });
// }
