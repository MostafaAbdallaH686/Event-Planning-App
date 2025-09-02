import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/function/app_route.dart';
import 'package:event_planning_app/core/utils/theme/app_theme_data.dart';
import 'package:event_planning_app/core/utils/firebase/firebase_options.dart';
import 'package:event_planning_app/features/auth/cubit/user_cubit.dart';
import 'package:event_planning_app/features/auth/data/user_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  //initialize firebase for project
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '229484552631-tuupqshucmh9spj48gr7qlj3u0rs9te2.apps.googleusercontent.com',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(UserRepository()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Event Planning App',
        theme: AppThemeData.lightThemeData,
        routerConfig: router,
      ),
    );
  }
}
