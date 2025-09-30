// ToDo:: Mostafa :: Do not Touch Please

import 'package:flutter/material.dart';

abstract class AppColor {
  static const Color scaffoldBackground = Color(0xffFFFFFF);
  static const Color white = Color(0xffFFFFFF);
  static const Color blue = Color(0xff5F33E1);
  static const Color black = Color(0xff000000);
  static const Color colorbA1 = Color(0xff25131A);
  static const Color colorb26 = Color(0xff120D26);
  static const Color colorwEE = Color(0xffEEEEEE);
  static const Color colorbr80 = Color(0xff808080);

  static const Color colorbr88 = Color(0xff8B8688); // FIX: Must be const
  static const Color colorbr688 = Color(0xff747688); // FIX: Must be const
  static const Color colorbrD8 = Color(0xffD9D9D9); // FIX: Must be const
  static const Color colorb18 = Color(0xff060518);
  static const Color border = Color(0xff8B8688);

  // Note: colorstack remains non-const because it uses Color.alphaBlend
  static Color colorstack =
  Color.alphaBlend(const Color(0xffB9DAFB), const Color(0xff9895EE));
  static const Color colorbrCC = Color(0xffCCCCCC); // FIX: Must be const
  static const Color colorbr9E = Color(0xff9E9E9E); // FIX: Must be const
  static const Color colorbr9B = Color(0xff9B9B9B); // FIX: Must be const
  static const Color primaryButton = Color(
      0xff0055FF); // FIX: Renamed from sharedbutton and made const
  static const Color facebookbutton = Color(0xff4267B2);
  static const Color googlebutton = Color(0xffDB4437);

  static const List<Color> colorsInterests = [
    Color(0xFF6B7AED),
    Color(0xFFEE544A),
    Color(0xFFFF8D5D),
    Color(0xFF7D67EE),
    Color(0xFF29D697),
    Color(0xFF39D1F2),
  ];
  static const Color colorgr88 = Color(0xff747688);
  static const Color colorblFF = Color(0xff5669FF);
  static const Color colorb4D = Color(0xff172B4D);
  static const Color colorgrDD = Color(0xffDDDDDD);
  static const Color colorbl0FF = Color(0xffEEF0FF);
  static const Color colorError = Color(0xffFF4D4D);
  static const Color whatsappColor = Color(0xFF27B43E);

  static const Color messengerColor = Color(0xFF1A7BFF);

  static const Color twitterColor = Color(0xFF3A6EFF);

  static const Color instagramColor = Color(0xFFE2425C);

  static const Color skypeColor = Color(0xFF58D3EE);

  static const Color messageColor = Color(0xFF5AF575);
}