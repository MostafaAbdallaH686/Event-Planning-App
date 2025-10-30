import 'package:dio/dio.dart';
import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/network/api_configration.dart';
import 'package:event_planning_app/core/utils/network/api_endpoint.dart';
import 'package:event_planning_app/core/utils/network/api_helper.dart';
import 'package:event_planning_app/core/utils/network/token_service.dart';
import 'package:event_planning_app/core/utils/services/toast_services.dart';
import 'package:event_planning_app/features/auth/cubit/cubits/auth_cubit.dart';
import 'package:event_planning_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:event_planning_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:event_planning_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:event_planning_app/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:event_planning_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/login_with_facebook_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/login_with_google_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:event_planning_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:event_planning_app/features/events/data/events_repository.dart';
import 'package:event_planning_app/features/events/data/events_repository_impl.dart';
import 'package:event_planning_app/features/events/data/repositories/event_repository.dart';
import 'package:event_planning_app/features/events/data/repositories/event_repository_impl.dart';

import 'package:event_planning_app/features/home/data/repositories/home_repository.dart';
import 'package:event_planning_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  // Token Service
  getIt.registerLazySingleton(() => TokenService(getIt()));
  // Dio
  final dio = Dio(BaseOptions(
    baseUrl: ApiBaseUrl.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  getIt.registerLazySingleton(() => dio);

  // API Helper
  getIt.registerLazySingleton(() => ApiHelper(
        dio: getIt(),
        tokenService: getIt(),
      ));

  // Google Sign In
  getIt.registerLazySingleton(() => GoogleSignIn.instance);

  // Facebook Auth
  getIt.registerLazySingleton(() => FacebookAuth.instance);

  // ==================== Auth Feature ====================
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      apiHelper: getIt(),
      googleSignIn: getIt(),
      facebookAuth: getIt(),
    ),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginWithGoogleUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginWithFacebookUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));

  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(getIt()),
  );
  // Repositories
  getIt.registerLazySingleton<CreateEventRepository>(() => EventRepositoryApi(
        getIt<ApiHelper>(),
      ));
  //Cubits

// Register AuthCubit

  getIt.registerFactory(() => AuthCubit(
        loginUseCase: getIt(),
        registerUseCase: getIt(),
        loginWithGoogleUseCase: getIt(),
        loginWithFacebookUseCase: getIt(),
        logoutUseCase: getIt(),
        getCurrentUserUseCase: getIt(),
      ));
}
