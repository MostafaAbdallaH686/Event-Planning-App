import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

abstract class AppSvgImage {
  static Widget showSvgImage(
      {required String path,
      double? width,
      double? height,
      BoxFit fit = BoxFit.contain}) {
    return SvgPicture.asset(path, width: width, height: height, fit: fit);
  }

  static Widget showImage(
      {required String path,
      double? width,
      double? height,
      BoxFit fit = BoxFit.contain}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(path),
          fit: fit,
        ),
      ),
    );
  }
}
