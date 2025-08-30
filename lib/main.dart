import 'package:event_planning_app/core/utils/function/app_route.dart';
import 'package:event_planning_app/core/utils/theme/app_theme_data.dart';
import 'package:event_planning_app/core/utils/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //initialize firebase for project
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Event Planning App',
      theme: AppThemeData.lightThemeData,
      routerConfig: router,
    );
  }
}
