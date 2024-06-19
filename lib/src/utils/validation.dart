import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Validation {
  static bool isValidUser(String user) {
    return user.length > 6;
  }

  static bool isValidPassword(String pass) {
    return pass.length > 6;
  }

  static bool isValidationEmail(String email) {
    return EmailValidator.validate(email);
  }

  static bool isValidationPhone(String phone) {
    if (phone.isEmpty) {
      return false;
    }

    const pattern = r'^[+]*[)]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(phone)) {
      return false;
    }

    if (phone.length < 6 || phone.length > 14) {
      return false;
    }

    return true;
  }

  // birth day validator
  static String birthDateValidator(dynamic value, String locale) {
    final DateTime now = DateTime.now();
    final DateFormat formatter =
        locale.isNotEmpty ? DateFormat.y(locale) : DateFormat("yyyy");
    final String formatted = formatter.format(now);
    String str1 = value;
    List<String> str2 = str1.split('/');
    String month = str2.isNotEmpty ? str2[0] : '';
    String day = str2.length > 1 ? str2[1] : '';
    String year = str2.length > 2 ? str2[2] : '';

    debugPrint("YEAR : ${now.year}");
    debugPrint("MONTH : ${now.month}");
    debugPrint("DAY : ${now.day}");

    if (value.isEmpty) {
      return 'Birthdate is empty';
    } else if (int.parse(month) > 13) {
      return 'Month is not valid';
    } else if (int.parse(day) > 32) {
      return 'Day is not valid';
    } else if ((int.parse(year) > int.parse(formatted))) {
      return 'Year is not valid';
    } else if ((int.parse(year) < 1922)) {
      return 'Year is not valid';
    }

    return "";
  }

  static final RegExp _nonWordPattern = RegExp(
    r'[^\d\p{L}-]+',
    multiLine: true,
    unicode: true,
  );
  static String? validateStringMaxmumLength(
      String? value, [
        int maxLength = 50,
      ]) {
    final int count = value == null ? 0 : value.split(_nonWordPattern).length;

    return count < maxLength
        ? "Nhập tối đa $maxLength từ (đã nhập $count/$maxLength từ)"
        : null;
  }

  String ageOfUser(String birthDate) {
    DateTime date1 = DateFormat.yMd().parse(birthDate);
    DateTime date2 = DateTime.now();

    var age = daysBetween(date1, date2) ~/ 360;
    return age.toString();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
