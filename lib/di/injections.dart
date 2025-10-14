import 'package:dio/dio.dart';
import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/network/api_configration.dart';
import 'package:event_planning_app/core/utils/services/toast_services.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void setupServiceLocator() {
  // Register toast service
  getIt.registerLazySingleton<ToastService>(() => FlutterToastService());
}

// For testing - inject mock
void setupTestServiceLocator() {
  getIt.registerLazySingleton<ToastService>(() => MockToastService());
}

Future<void> configureDependencies() async {
  // Make sure CacheHelper is initialized before DI
  await CacheHelper.initialize();

  // Core singletons
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper.instance);

  getIt.registerLazySingleton<Dio>(() => Dio(ApiConfigration.option()),
      instanceName: 'mainDio');
  getIt.registerLazySingleton<Dio>(() => Dio(ApiConfigration.option()),
      instanceName: 'authDio');

  // getIt.registerLazySingleton<TokenService>(
  //   () => TokenService(
  //     cacheHelper: getIt<CacheHelper>(),
  //     dio: getIt<Dio>(instanceName: 'authDio'),
  //   ),
  // );

  // // ApiHelper BEFORE repos
  // getIt.registerLazySingleton<ApiHelper>(
  //   () => ApiHelper(
  //     dio: getIt<Dio>(instanceName: 'mainDio'),
  //     tokenService: getIt<TokenService>(),
  //   ),
  // );

  // Repositories

  // getIt.registerLazySingleton<HomeRepo>(
  //     () => HomeRepo(apiHelper: getIt<ApiHelper>()));
  // getIt.registerLazySingleton<ProfileRepo>(
  //     () => ProfileRepo(apiHelper: getIt<ApiHelper>()));
  // getIt.registerLazySingleton<LoginRepo>(
  //     () => LoginRepo(apiHelper: getIt<ApiHelper>()));
  // getIt.registerLazySingleton<RegisterRepo>(
  //     () => RegisterRepo(apiHelper: getIt<ApiHelper>()));

  // Cubits
  // getIt.registerFactory<HomeCubit>(
  //     () => HomeCubit(getIt<CacheHelper>(), homeRepo: getIt<HomeRepo>()));

  // getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginRepo>()));
  // getIt.registerFactory<RegisterCubit>(
  //     () => RegisterCubit(getIt<RegisterRepo>()));
  // getIt.registerFactory<ProfileCubit>(
  //     () => ProfileCubit(profileRepo: getIt<ProfileRepo>()));
}
