import 'dart:convert';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_util/sp_util.dart';

import '../domain/dtos/customers/customers_dto.dart';
import '../domain/dtos/profiles/avatar_dto.dart';
import 'extensions/object_ext.dart';

export 'pref_const.dart';

class PrefAssist {
  static CustomerDto? _myCustomerInfo;

  static CustomerDto getMyCustomer() {
    if (PrefAssist._myCustomerInfo != null) return PrefAssist._myCustomerInfo!;
    String jsonString = PrefAssist.getString('kMyCustomerInfo');
    if (jsonString.isEmpty) {
      PrefAssist._myCustomerInfo = CustomerDto.createEmptyCustomer();
    } else {
      PrefAssist._myCustomerInfo =
          CustomerDto.fromJson(json.decode(jsonString));
    }
    return PrefAssist._myCustomerInfo ?? CustomerDto.createEmptyCustomer();
  }

  static String getAccessToken() {
    String token = PrefAssist.getString(PrefConst.kAuthToken);
    debugPrint("return access token: $token");
    return token;
  }

  static Future<void> setAccessToken(String token) async {
    await PrefAssist.setString(PrefConst.kAuthToken, token);
    debugPrint("update access token: $token");
  }

  static Future<void> setMyCustomer(CustomerDto customer) async {
    _myCustomerInfo = customer;
    await PrefAssist.setString(
        'kMyCustomerInfo', json.encode(customer.toJson()));
  }

  static Future<void> saveMyCustomer() async {
    await PrefAssist.setMyCustomer(getMyCustomer());
  }

  static Future<void> clearMyCustomer() async {
    _myCustomerInfo = null;
    await PrefAssist.setString('kMyCustomerInfo', '');
    await PrefAssist.setAccessToken('');
  }

  static dynamic getDynamic(String key, dynamic defaultValue) {
    return GetStorage().read(key) ?? defaultValue;
  }

  static Future<void> setDynamic(String key, dynamic value) async {
    return await GetStorage().write(key, value);
  }

  static bool getBool(String key, [bool defaultValue = false]) {
    return GetStorage().read(key) ?? defaultValue;
  }

  static Future<bool?> getBoolSharePre(String key,
      [bool defaultValue = false]) async {
    return SpUtil.getBool(key);
  }

  static Future<void> setBool(String key, bool value) async {
    return await GetStorage().write(key, value);
  }

  static Future<bool>? setBoolSharePre(String key, bool value) {
    return SpUtil.putBool(key, value);
  }

  static List<String> getListString(String key,
      [List<String> defaultValue = const []]) {
    dynamic result = GetStorage().read(key);
    if (result != null) {
      return List<String>.from(result);
    } else if (defaultValue.isNotEmpty) {
      return defaultValue;
    } else {
      return [];
    }
  }

  static Future<void> setListString(String key, List<String> value) async {
    return await GetStorage().write(key, value);
  }

  static String getString(String key, [String defaultValue = '']) {
    return GetStorage().read(key) ?? defaultValue;
  }

  static Future<void> setString(String key, String value) async {
    return await GetStorage().write(key, value);
  }

  static int getInt(String key, [int defaultValue = 0]) {
    return GetStorage().read(key) ?? defaultValue;
  }

  static Future<int?> getIntSharePre(String key, [int defaultValue = 0]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<void> setInt(String key, int value) async {
    return await GetStorage().write(key, value);
  }

  static Future<bool> setIntSharePre(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value);
  }

  static double getDouble(String key, [double defaultValue = 0]) {
    return GetStorage().read(key) ?? defaultValue;
  }

  static Future<void> setDouble(String key, double value) async {
    return await GetStorage().write(key, value);
  }

  static bool hasKey(String key) {
    return GetStorage().hasData(key);
  }
}
