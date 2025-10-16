// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Manages displaying SVG images in the app
// Provides a method to show SVG images with customizable properties
// Usage: AppSvgImage.showSvgImage(path: 'assets/image.svg', width: 100, height: 100);
// Mostafa :: Tested and Refactored
abstract class AppSvgImage {
  static Widget showSvgImage(
      {required String path,
      double? width,
      double? height,
      Color? color,
      BoxFit fit = BoxFit.contain}) {
    return SvgPicture.asset(
      color: color,
      path,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
