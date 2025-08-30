import 'package:get/get.dart';

abstract class AppWidthHeight {
  static final double width = Get.width;
  static final double height = Get.height;

  static double persantageOfWidth(double persentage) {
    if (persentage > 100 || persentage <= 0) {
      return width;
    }
    return ((width * persentage) / 100);
  }

  static double persantageOfHeight(double persentage) {
    if (persentage > 100 || persentage <= 0) {
      return height;
    }
    return ((height * persentage) / 100);
  }
}

abstract class DeviceWidthHeight {
  static final double width = Get.width;
  static final double height = Get.height;

  static double perentageOfWidth(double wdt) {
    double percentageFromDesign = ((wdt * width) / DesignWidthHeight.width);
    return percentageFromDesign;
  }

  static double perentageOfHeight(double hei) {
    double percentageFromDesign = ((hei * height) / DesignWidthHeight.height);
    return percentageFromDesign;
  }
}

abstract class DesignWidthHeight {
  static const double width = 360;
  static const double height = 800;
}
