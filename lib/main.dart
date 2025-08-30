import 'package:event_planning_app/core/utils/function/app_route.dart';
import 'package:event_planning_app/core/utils/theme/app_theme_data.dart';
import 'package:flutter/material.dart';

void main() {
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
