import 'package:dio/dio.dart';
import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/network/api_configration.dart';
import 'package:event_planning_app/core/utils/network/api_helper.dart';
import 'package:event_planning_app/core/utils/network/token_service.dart';
import 'package:event_planning_app/core/utils/services/toast_services.dart';
import 'package:event_planning_app/features/events/data/events_repository.dart';
import 'package:event_planning_app/features/events/data/events_repository_impl.dart';
import 'package:event_planning_app/features/events/data/repositories/event_repository.dart';
import 'package:event_planning_app/features/events/data/repositories/event_repository_impl.dart';

import 'package:event_planning_app/features/home/data/repositories/home_repository.dart';
import 'package:event_planning_app/features/home/data/repositories/home_repository_impl.dart';
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
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<TokenService>(
    () => TokenService(
      cacheHelper: getIt<CacheHelper>(),
      dio: getIt<Dio>(instanceName: 'authDio'),
    ),
  );

  //  ApiHelper BEFORE repos
  getIt.registerLazySingleton<ApiHelper>(
    () => ApiHelper(
      dio: getIt<Dio>(instanceName: 'mainDio'),
      tokenService: getIt<TokenService>(),
    ),
  );
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(getIt()),
  );
  // Repositories
  getIt.registerLazySingleton<CreateEventRepository>(() => EventRepositoryApi(
        getIt<ApiHelper>(),
      ));
  //());

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
