import 'dart:math';

import 'package:dating_app/src/general/constants/app_locale.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../utils/pref_assist.dart';
import 'middle-handler/logger_interceptor.dart';



//Config header, base option
@Singleton()
 class AppClient  {
  final Dio _dio = Dio();
  final LoggerInterceptor _loggerInterceptor = LoggerInterceptor();
  Dio get dio => _dio;


  static const String DATE_TIME_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  static const String END_POINT = "http://159.223.53.162";
  static  Locale currentLocale = Localizations.localeOf(Get.context!);
  // static String local =  LocaleSupport.getCurrentDeviceLocale();
  static String API_LANGUAGE = AppLocaleEnum.getLocaleString(currentLocale.languageCode ?? 'en');
  static const String KEY_VERIFY = "bachaxPPsb9SCaz7TVJsda7cCD5sshsoft";

  static const String _chars = 'bachaxPPsb9SCaz7TVJsda7cCD5sshsoft';
  static final Random _rnd = Random();

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static String getVerifyKey() {
    return getRandomString(_rnd.nextInt(30)) + KEY_VERIFY + getRandomString(_rnd.nextInt(30));
  }
  static Map<String, String> getHeader() {
    return <String, String>{
      'Content-Type': 'application/json',
      'Accept-Language': 'en',
      'Content-Transfer-Encoding': getVerifyKey(),
      'Authorization': 'Bearer ${PrefAssist.getAccessToken()}',
    };
  }


  AppClient() {
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60), // 60 seconds
      receiveTimeout: const Duration(seconds: 60), // 60 seconds
      headers: getHeader(),
    );
    _dio.options = options;
    //_dio.interceptors.add(_loggerInterceptor);

  }

  Dio dioAuth() {
    final authToken = 'Bearer ${PrefAssist.getAccessToken()}';
    //debugPrint("authToken: $authToken");
    _dio.options.headers['Authorization'] = authToken;
    if(Get.context != null) {
      _dio.options.headers['Accept-Language'] = Intl.getCurrentLocale();
    }
    return _dio;
  }

  Dio dioNonAuth() {
    _dio.options.headers = getHeader();
    return _dio;
  }
}
