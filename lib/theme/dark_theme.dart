import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/theme/app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.darkBg,
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    titleTextStyle: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
  ),
);
