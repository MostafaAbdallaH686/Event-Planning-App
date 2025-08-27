import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/theme/app_colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.lightBg,
  textTheme: GoogleFonts.poppinsTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    titleTextStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
  ),
);
