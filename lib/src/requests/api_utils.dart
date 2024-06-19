import 'dart:math';
export 'api_reg_login.dart';
export 'telegram_debug.dart';

import 'package:dating_app/src/general/constants/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/pref_assist.dart';

class ApiUtils {
  static const String DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static const String END_POINT = "https://api.heartlinkdating.com";
  static  Locale currentLocale = Localizations.localeOf(Get.context!);
  static  String API_LANGUAGE = AppLocaleEnum.getLocaleString(currentLocale.languageCode ?? 'en');
  static const String KEY_VERIFY = "bachaxPPsb9SCaz7TVJsda7cCD5sshsoft";

  static const String _chars = 'bachaxPPsb9SCaz7TVJsda7cCD5sshsoft';
  static final Random _rnd = Random();

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static String getVerifyKey() {
    return getRandomString(_rnd.nextInt(30)) + KEY_VERIFY + getRandomString(_rnd.nextInt(30));
  }

  static Map<String, String> getHeader() {
    final token = PrefAssist.getAccessToken();
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept-Language': API_LANGUAGE,
      'Content-Transfer-Encoding': getVerifyKey(),
      'Authorization': 'Bearer $token',
    };
  }

  static jsonInsertUpdateTime(Map<String, dynamic> json) {
    json['updateTime'] = DateTime.now().millisecondsSinceEpoch;
    return json;
  }

  static jsonCheckUpdateTime(Map<String, dynamic> json) {
    if (json['updateTime'] == null) {
      jsonInsertUpdateTime(json);
      return true;
    }
    return DateTime.now().millisecondsSinceEpoch - json['updateTime'] < 5 * 60 * 1000;
  }

  static Map<String, dynamic> removeNullOrEmpty(Map<String, dynamic> json) {
    json.removeWhere((key, value) => value == null || value == '');
    return json;
  }
}

class ApiCode {
  static const int internalError = -1;
  static const int customerNotRegistered = 422;
  static const int success = 200;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int dataFormatUnexpected = -2;
}
