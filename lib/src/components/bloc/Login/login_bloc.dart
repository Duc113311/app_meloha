import 'dart:async';

import 'package:dating_app/src/utils/validation.dart';

class LoginBloc {
  final StreamController _userStreamController = StreamController();
  final StreamController _passStreamController = StreamController();

  Stream get userStream => _userStreamController.stream;
  Stream get passStream => _passStreamController.stream;

  bool isValidUserName(String userName) {
    if (!Validation.isValidUser(userName)) {
      _userStreamController.sink.addError("Your username is not valid");
      return false;
    }

    _userStreamController.sink.add("OK");
    return true;
  }

  void dispose() {
    _userStreamController.close();
    _passStreamController.close();
  }
}
