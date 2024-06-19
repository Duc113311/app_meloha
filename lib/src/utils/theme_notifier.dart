import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sp_util/sp_util.dart';

class ThemeUtils {
  static bool isDarkModeSetting() {
    final value = getDarkModeSetting();
    // if (SpUtil.getInt(PrefConst.kDarkModeSetting) == null) {
    //   SpUtil.putInt(PrefConst.kDarkModeSetting, value);
    // }
    //print('isDark: $value');
    return value == PrefConst.kDarkModeOn;
  }

  static int getDarkModeSetting() {
    int? code = SpUtil.getInt(PrefConst.kDarkModeSetting,
        defValue: PrefConst.kDarkModeSettingDefault);
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    if (code == PrefConst.kDarkModeSettingDefault) {
      if (brightness == Brightness.light) {
        code = PrefConst.kDarkModeOff;
      } else {
        code = PrefConst.kDarkModeOn;
      }
      SpUtil.putInt(PrefConst.kDarkModeSetting, code);
    } else {
      //print('isDark mode get: $code');
      return code!;
    }
    //print('isDark mode get: -  $code');
    return code!;

    // try {
    //   if (code == PrefConst.kDarkModeSettingDefault) {
    //     SpUtil.putInt(PrefConst.kDarkModeSetting,PrefConst.kDarkModeOff);
    //       return PrefConst.kDarkModeOff;
    //   } else {
    //     return code!;
    //   }
    // } catch (e) {
    //   print('lỗi em $e');
    // }
    // return code!;
  }

  static int toggleDarkModeSetting() {
    var code = getDarkModeSetting();
    if (code == PrefConst.kDarkModeOn) {
      code = PrefConst.kDarkModeOff;
    } else {
      code = PrefConst.kDarkModeOn;
    }
    SpUtil.putInt(PrefConst.kDarkModeSetting, code);
    ThemeNotifier.themeModeRef.switchTheme();
    setSystem(code == PrefConst.kDarkModeOn);

    print('isDark mode sau khi sua $code');
    return code;
  }

  static void setSystem(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: isDark
            ? const Color.fromRGBO(37, 42, 55, 1.0)
            : Colors.grey.withOpacity(0.1),
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor:
            isDark ? const Color.fromRGBO(37, 42, 55, 1.0) : Colors.white,
      ),
    );
  }

  static Color getPrimaryColor() {
    return AppColors.primaryColor;
  }

  static Color getTextButtonColor() {
    return Colors.white;
  }

  static Color getScaffoldBackgroundColor() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("000410")
        : HexColor("FCFCFE");
  }

  static Color getTabbarBackgroundColor() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("FFFFFF")
        : HexColor("021242");
  }

  static Color getShadowColor() {
    return Theme.of(Get.context!).shadowColor;
  }

  static Color getTextColor() {
    return ThemeUtils.isDarkModeSetting()
        ? AppColors.colorECF3FB
        : AppColors.color323232;
  }

  static Color getTitleColor() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("ECF3FB")
        : HexColor("070D15");
  }

  static Color getCaptionColor() {
    return ThemeUtils.isDarkModeSetting()
        ? ThemeColor.grey3
        : ThemeColor.caption;
  }

  static TextStyle getTextFieldLabelStyle({Color? color}) {
    return TextStyle(
        fontFamily: ThemeNotifier.fontRegular,
        color: color ?? ThemeUtils.getTextColor(),
        fontSize: 14.toWidthRatio());
  }

  static TextStyle getHeaderStyle({double? fontSize, Color? color}) {
    return TextStyle(
      color: color ?? ThemeUtils.headerColor(),
      fontSize: fontSize ?? 16.toWidthRatio(),
      fontFamily: ThemeNotifier.fontBold
    );
  }

  static TextStyle getTitleStyle({double? fontSize, Color? color}) {
    return TextStyle(
      color: color ?? ThemeUtils.getTitleColor(),
      fontSize: fontSize ?? 20.toWidthRatio(),
      fontFamily: ThemeNotifier.fontBold,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle getPopupTitleStyle({double? fontSize, Color? color}) {
    return TextStyle(
        color: color ?? ThemeUtils.getTextColor(),
        fontSize: fontSize ?? 20.toWidthRatio(),
        fontFamily: ThemeNotifier.fontSemiBold);
  }

  static TextStyle getTextStyle(
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    final textColor = color ?? ThemeUtils.getTextColor();
    return TextStyle(
        color: textColor,
        fontSize: fontSize ?? 14.toWidthRatio(),
        fontFamily: ThemeNotifier.fontRegular,
        fontWeight: fontWeight);
  }

  static TextStyle getTextMediumStyle(
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    final textColor = color ?? ThemeUtils.headerColor();
    return TextStyle(
        color: textColor,
        fontSize: fontSize ?? 14.toWidthRatio(),
        fontFamily: ThemeNotifier.fontMedium,
        fontWeight: fontWeight);
  }

  static TextStyle getErrorStyle(
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? Colors.red,
        fontSize: fontSize ?? 14.toWidthRatio(),
        fontFamily: ThemeNotifier.fontBold,
        fontWeight: fontWeight);
  }

  static TextStyle getButtonStyle({Color? color, double? fontSize}) {
    return TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize ?? 14.toWidthRatio(),
        fontFamily: ThemeNotifier.fontBold,
        fontWeight: FontWeight.w600);
  }

  static TextStyle getPlaceholderTextStyle({Color? color}) {
    return TextStyle(
        fontFamily: ThemeNotifier.fontLivvicItalic,
        color: color ?? ThemeUtils.color646465,
        fontSize: 14.toWidthRatio());
  }

  //MARK: Chat UI
  static Color getTextFieldColor() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("495063")
        : HexColor("f5f5f5");
  }

  static Color getChatBackgroundColor() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("232b38")
        : HexColor("ffffff");
  }

  static Color getChatTextFieldColor() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("8e99b4")
        : HexColor("8686a0");
  }

  static Color getChatBubbleColor() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("ececec")
        : HexColor("8686a0");
  }

  static Color get chatFullnameColor {
    return ThemeUtils.isDarkModeSetting()
        ? const Color(0xffFCFCFE)
        : const Color(0xff1D1B20);
  }
  static Color get headerInfoColor {
    return ThemeUtils.isDarkModeSetting()
        ? const Color(0xffE2E2E4)
        : const Color(0xff4C4C4C);
  }

  static TextStyle getCaptionStyle(
      {Color? color, double? fontSize, TextDecoration? decor, Color? decorColor}) {
    return TextStyle(
        fontFamily: ThemeNotifier.fontRegular,
        fontSize: fontSize ?? 12.8.toWidthRatio(),
        color: color ?? ThemeUtils.getCaptionColor(), decoration: decor, decorationColor: decorColor);
  }

  static TextStyle getRightButtonStyle(
      {double? fontSize, TextDecoration? decoration}) {
    return TextStyle(
        color: getRightButtonColor(),
        fontSize: fontSize ?? 16.toWidthRatio(),
        fontFamily: ThemeNotifier.fontRegular,
        decoration: decoration ?? TextDecoration.underline);
  }

  //TODO: Chuyển tất cả configs về màu sắc về đây
  static Color getRightButtonColor() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("E6EAF6")
        : HexColor("000410");
  }

  static Color getAddNewButtonColor() {
    return HexColor("000410");
  }

  static Color colorGrey1() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("323232")
        : HexColor("E2E2E4");
  }

  static Color headerColor() {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("E2E2E4")
        : HexColor("323232");
  }

  static Color get borderColor {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("646465")
        : HexColor("C7C7C7");
  }
  static Color get color646465 {
    return ThemeUtils.isDarkModeSetting()
        ? HexColor("C7C7C7")
        : HexColor("646465");
  }
}

class ThemeNotifier with ChangeNotifier {
  static ThemeNotifier themeModeRef = ThemeNotifier();

  void switchTheme() {
    notifyListeners();
  }

  static String fontRegular = "Livvic Regular";
  static String fontMedium = "Livvic Medium";
  static String fontBold = "Livvic Bold";
  static String fontSemiBold = "Livvic SemiBold";
  static String fontLivvicItalic = "Livvic Italic";
  static String fontMulishBold = "Mulish Bold";
  static String fontMulishRegular = "Mulish Regular";

  static const Color _lightTextColor = Colors.black;
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color.fromRGBO(74, 136, 217, 1.0),
    secondaryHeaderColor: const Color.fromRGBO(74, 80, 98, 1.0),
    hintColor: const Color(0xff7B7B7B),
    shadowColor: const Color(0xffEEF1FA),
    brightness: Brightness.light,
    indicatorColor: Colors.black,
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    scaffoldBackgroundColor: HexColor("FCFCFE"),
    dividerColor: const Color(0xffE2E2E4),
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
          fontSize: ThemeTextStyle.txtSizeBig,
          color: _lightTextColor,
          fontFamily: fontMedium),
      centerTitle: true,
      elevation: 0,
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 1.5,
      trackShape: const RoundedRectSliderTrackShape(),
      activeTrackColor: const Color.fromRGBO(74, 136, 217, 1.0),
      inactiveTrackColor: const Color(0xffE2E2E4),
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 14.0,
        pressedElevation: 8.0,
      ),
      rangeThumbShape: const RoundRangeSliderThumbShape(
        enabledThumbRadius: 14.0,
        pressedElevation: 8.0,
      ),
      thumbColor: const Color.fromRGBO(74, 136, 217, 1.0),
      overlayColor: const Color.fromRGBO(74, 136, 217, 1.0).withOpacity(0.2),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 32.0),
      tickMarkShape: const RoundSliderTickMarkShape(),
      activeTickMarkColor: const Color.fromRGBO(74, 136, 217, 1.0),
      inactiveTickMarkColor: Colors.white,
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: Colors.black,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white), colorScheme: const ColorScheme(brightness: Brightness.light, primary: Colors.grey, onPrimary: Colors.purple, secondary: Colors.yellow, onSecondary: Colors.amber, error: Colors.red, onError: Colors.red, surface: Color(0xffFCFCFE), onSurface: Color(0xff323232)),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color.fromRGBO(74, 136, 217, 1.0),
    secondaryHeaderColor: const Color.fromRGBO(148, 157, 183, 1.0),
    hintColor: const Color.fromRGBO(112, 121, 146, 1.0),
    shadowColor: const Color.fromRGBO(78, 80, 98, 1.0),
    brightness: Brightness.dark,
    indicatorColor: Colors.white,
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color.fromRGBO(37, 42, 55, 1.0)),
    scaffoldBackgroundColor: HexColor("000410"),
    dividerColor: Colors.black12,
    appBarTheme: AppBarTheme(
      color: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          fontSize: ThemeTextStyle.txtSizeBig,
          color: _lightTextColor,
          fontFamily: fontMedium),
      centerTitle: true,
      elevation: 0,
    ),
    sliderTheme: SliderThemeData(
      trackHeight: 1.5,
      trackShape: const RoundedRectSliderTrackShape(),
      activeTrackColor: const Color.fromRGBO(74, 136, 217, 1.0),
      inactiveTrackColor: const Color(0xffE2E2E4),
      thumbShape: const RoundSliderThumbShape(
        enabledThumbRadius: 14.0,
        pressedElevation: 8.0,
      ),
      rangeThumbShape: const RoundRangeSliderThumbShape(
        enabledThumbRadius: 14.0,
        pressedElevation: 8.0,
      ),
      thumbColor: const Color.fromRGBO(74, 136, 217, 1.0),
      overlayColor: const Color.fromRGBO(74, 136, 217, 1.0).withOpacity(0.2),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 32.0),
      tickMarkShape: const RoundSliderTickMarkShape(),
      activeTickMarkColor: const Color.fromRGBO(74, 136, 217, 1.0),
      inactiveTickMarkColor: Colors.white,
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: Colors.black,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }), bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black), colorScheme: ColorScheme(brightness: Brightness.dark, primary: Colors.grey, onPrimary: HexColor("000410"), secondary: Colors.grey, onSecondary: HexColor("000410"), error: HexColor("000410"), onError: Colors.red, surface: const Color(0xff000410), onSurface: const Color(0xffECF3FB)),
  );
}
