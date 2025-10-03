import 'package:flutter/material.dart';

abstract class DesignWidthHeight {
  static const double width = 375;
  static const double height = 812;
}

abstract class AppWidthHeight {
  static double percentageOfWidth(BuildContext context, double num) {
    assert(num >= 0, 'Number must be non-negative');
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      throw FlutterError(
          'AppWidthHeight.percentageOfWidth requires a MediaQuery ancestor in the widget tree');
    }
    return (mediaQuery.size.width * (num / DesignWidthHeight.width));
  }

  static double percentageOfHeight(BuildContext context, double num) {
    assert(num >= 0, 'Number must be non-negative');
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      throw FlutterError(
          'AppWidthHeight.percentageOfHeight requires a MediaQuery ancestor in the widget tree');
    }
    return (mediaQuery.size.height * (num / DesignWidthHeight.height));
  }
}
