// ToDo :: Make your padding here
import 'package:flutter/material.dart';

abstract class AppPadding {
  // Horizontal Paddings
  static const EdgeInsets horizontal22 =
  EdgeInsets.symmetric(horizontal: 22);
  static const EdgeInsets horizontal16 =
  EdgeInsets.symmetric(horizontal: 16);

  // Vertical Paddings
  static const EdgeInsets vertical10 =
  EdgeInsets.symmetric(vertical: 10);
  static const EdgeInsets vertical16 =
  EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets verticalMedium =
  EdgeInsets.symmetric(vertical: 12);

  // General
  static const EdgeInsets textFormField16 =
  EdgeInsets.symmetric(vertical: 16, horizontal: 16);
  static const EdgeInsets taskContainer =
  EdgeInsets.symmetric(vertical: 12, horizontal: 13);

  // Default spacing values
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;


  static const EdgeInsets buttonVertical10 =
  EdgeInsets.symmetric(vertical: 10);


}
