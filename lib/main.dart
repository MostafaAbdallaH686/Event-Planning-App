// ignore_for_file: avoid_print

import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/function/app_route.dart';
import 'package:event_planning_app/core/utils/services/firestore_service.dart';
import 'package:event_planning_app/core/utils/services/toast_services.dart';
import 'package:event_planning_app/core/utils/theme/app_theme_data.dart';
import 'package:event_planning_app/core/utils/firebase/firebase_options.dart';
import 'package:event_planning_app/di/injections.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/data/user_repo.dart';
import 'package:event_planning_app/features/events/cubit/event_details_cubit.dart';
import 'package:event_planning_app/features/events/cubit/interested_cubit.dart';
import 'package:event_planning_app/features/events/data/interested_repo.dart';
import 'package:event_planning_app/features/home/cubit/home_cubit.dart';
import 'package:event_planning_app/features/home/cubit/search_cubit.dart';
import 'package:event_planning_app/features/home/data/home_repo.dart';
import 'package:event_planning_app/features/onboarding/cubit/on_boarding_cubit.dart';
import 'package:event_planning_app/features/profile/cubit/profile_cubit.dart';
import 'package:event_planning_app/features/profile/data/profile_repostiry.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.initialize();
  await configureDependencies();
// Register the toast service
  setupServiceLocator();
  assert(getIt.isRegistered<ToastService>(), 'ToastService not registered');
  await Supabase.initialize(
    url: "https://wjvxhrqdhcikwllmmkdi.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndqdnhocnFkaGNpa3dsbG1ta2RpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA0MzE5OTEsImV4cCI6MjA3NjAwNzk5MX0.AKULfXKInrrSYXvlXeIXktVqFHp8EwdYpVent8hbf7k",
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GoogleSignIn.instance.initialize(
    serverClientId:
        '229484552631-tuupqshucmh9spj48gr7qlj3u0rs9te2.apps.googleusercontent.com',
  );
  Stripe.publishableKey =
      'pk_test_515K0kaPycg1qZpCBE4caw2vrF41XRXxCS9XV70t220rPgDo13h1ju401e0duiDhs3x1XsG0MszY97pcD1p1TEgt000HUH9YwsS';

  await Stripe.instance.applySettings();

  runApp(MyApp(
    cacheHelper: getIt<CacheHelper>(),
  ));
}

class MyApp extends StatelessWidget {
  final CacheHelper cacheHelper;

  const MyApp({super.key, required this.cacheHelper});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserCubit(UserRepository())),
        BlocProvider(
            create: (_) =>
                InterestedCubit(InterestedRepository(FirestoreService()))),
        BlocProvider(create: (_) => HomeCubit(HomeRepo(FirestoreService()))),
        BlocProvider(
          create: (_) => SearchCubit(FirestoreService()),
        ),
        BlocProvider(
          create: (_) => EventCubit(FirestoreService()),
        ),
        BlocProvider(
          create: (context) => OnBoardingCubit(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(ProfileRepository()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Event Planning App',
        theme: AppThemeData.lightThemeData,
        routerConfig: router,
      ),
    );
  }
}
