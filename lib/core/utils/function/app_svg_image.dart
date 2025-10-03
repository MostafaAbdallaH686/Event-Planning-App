import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
