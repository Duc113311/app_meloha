import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:flutter/cupertino.dart';

class VerifyAccountNotifier with ChangeNotifier {
  static final shared = VerifyAccountNotifier();

  int verify = PrefAssist.getMyCustomer().verified;

  void updateStatus(int status, {bool autoSave = true}) {
    verify = status;
    if (autoSave) {
      PrefAssist.getMyCustomer().explore?.verified = status;
      PrefAssist.saveMyCustomer();
    }
    notifyListeners();
  }
}
