import 'dart:async';

import 'package:dating_app/src/utils/validation.dart';

class AuthBloc {
  // email stream controller
  final StreamController _emailVerifyController = StreamController();
  Stream get emailVerifyStream => _emailVerifyController.stream;

  // phone stream controller
  final StreamController _phoneVerifyController = StreamController();
  Stream get phoneVerifyStream => _phoneVerifyController.stream;

  // check email verify invalid
  bool isEmailValid(String email) {
    // if (email.isEmpty) {
    //   _emailVerifyController.sink.addError("Email can not be empty");
    //   return false;
    // }

    if (!Validation.isValidationEmail(email)) {
      _emailVerifyController.sink.addError("Your Email input is not valid");
      return false;
    }

    _emailVerifyController.sink.add("");
    return true;
  }

  // check phone number is invalid
  bool isPhoneNumberValid(String phone) {
    // if (phone.length >= 6 && phone.length <= 14) {
    //   _phoneVerifyController.sink.addError("Your phone number is not valid");
    //   return false;
    // }

    if (!Validation.isValidationPhone(phone)) {
      _phoneVerifyController.sink.addError("Your phone number is not valid");
      return false;
    }

    _phoneVerifyController.sink.add("");
    return true;
  }

  // dispose stream
  void dispose() {
    _emailVerifyController.close();
  }
}
