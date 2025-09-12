// ToDo:: Mostafa :: Do not Touch Please

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppThemeData {
  static final ThemeData lightThemeData = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColor.black),
      titleTextStyle: TextStyle(
        color: AppColor.black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    scaffoldBackgroundColor: AppColor.white,
    fontFamily: "Poppins",
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    useMaterial3: true,
  );
}
