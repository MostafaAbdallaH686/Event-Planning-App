import 'package:flutter/material.dart';

class Dim {
  static double height(BuildContext c, double v) => MediaQuery.of(c).size.height * v;
  static double width(BuildContext c, double v) => MediaQuery.of(c).size.width * v;

  static double fsSmall(BuildContext c) => width(c, 0.035);
  static double fsMedium(BuildContext c) => width(c, 0.05);
  static double fsLarge(BuildContext c) => width(c, 0.07);
}
