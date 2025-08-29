// ToDo:: Mostafa :: Do not Touch Please

import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppThemeData {
  static final ThemeData lightThemeData = ThemeData(
    scaffoldBackgroundColor: AppColor.white,
    fontFamily: "Poppins",
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
    useMaterial3: true,
  );
}
