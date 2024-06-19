
import 'package:flutter/cupertino.dart';

class VerifyEmailNotifier with ChangeNotifier {
  static final shared = VerifyEmailNotifier();

  String error = '';
  void updateStatus({String err = ''}) {
    error = err;
    notifyListeners();
  }
}