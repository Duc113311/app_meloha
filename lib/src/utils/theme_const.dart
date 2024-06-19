import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:flutter/material.dart';

import 'extensions/color_ext.dart';

class ThemeTextStyle {
  static double txtSizeSmall = 12;
  static double txtSizeNormal = 14;
  static double txtSizeBig = 18;
  static double txtSizeLarge = 22;
  static double txtSizeSuper = 30;

  static TextStyle kDatingRegularFontStyle(double size, Color color) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.normal,
      fontFamily: "Inter Regular",
    );
  }

  static TextStyle kDatingMediumFontStyle(double size, Color color) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.normal,
      fontFamily: "Inter Medium",
    );
  }
}

class ThemeDimen {
  static const int animMillisDurationQuick = 50;
  static const int animMillisDurationFast = 100;
  static const int animMillisDuration = 200;
  static double paddingTiny = 4;
  static double paddingSmall = 8;
  static double paddingSemiSmall = 10.toWidthRatio();
  static double paddingNormal = 16;
  static double paddingBig = 24;
  static double paddingLarge = 32;
  static double paddingSuper = 40;
  static double iconTiny = 20;
  static double iconSmall = 40;
  static double iconNormal = 60;
  static double iconBig = 70;
  static double iconSuper = 100;
  static double borderRadiusTiny = 4;
  static double borderRadiusSmall = 8;
  static double borderRadiusNormal = 16.toHeightRatio();
  static double borderRadiusBig = 16;
  static double buttonHeightNormal = 42.toHeightRatio();
  static double buttonHeightBig = 60;
  static double buttonHeightSuper = 148;
  static double buttonWidthNormal = 52;

}

class ThemeColor {
  static const Color facebookColor = Color.fromRGBO(61, 132, 246, 1.0);
  static const Color darkMainColor = Color(0xff242A38);
  static const Color goldColor = Color(0xffF6A800);
  static const Color goldPackColor = Color.fromRGBO(252, 246, 231, 1.0);
  static const Color modalBackgroundColor = Color(0x7F000000);
  static const Color grey3 = Color(0xff979798);
  static const Color caption = Color(0xff646465);
  static const Color buttonDisable = Color(0xff919191);

  static const Color mainColor = Color(0xFF4A88D9);
  static const List<Color> gradientColors = [Color(0xff4A88D9), Color(0xff285BC0), Color(0xff052DA6)];
}
