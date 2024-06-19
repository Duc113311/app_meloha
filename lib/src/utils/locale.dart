import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocaleSupport {
  LocaleSupport._();

  static Future<String> getCurrentDeviceLocale() async {
    String locale1 = "";
    try {
      final locale = await Devicelocale.currentLocale;
      locale1 = locale.toString();
    } on PlatformException {
      debugPrint("Cannot get current locale");
    }

    return locale1;
  }

  static Future<bool> checkForSupport() async {
    final isSupport = await Devicelocale.isLanguagePerAppSettingSupported;
    debugPrint("isSupport : $isSupport");


    return await Devicelocale.isLanguagePerAppSettingSupported;
  }
}
