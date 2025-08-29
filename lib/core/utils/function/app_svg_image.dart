import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class AppSvgImage {
  static Widget showSvgImage(
      {required String path,
      double? width,
      double? height,
      BoxFit fit = BoxFit.contain}) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
