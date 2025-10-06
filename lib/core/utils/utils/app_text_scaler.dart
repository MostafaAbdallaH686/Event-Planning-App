import 'package:flutter/material.dart';

abstract class AppTextScaler {
  static TextScaler get standard {
    // ignore: deprecated_member_use
    final width = WidgetsBinding.instance.window.physicalSize.width;
    final scale = (width / 375).clamp(0.9, 1.3);
    return TextScaler.linear(scale);
  }
}
