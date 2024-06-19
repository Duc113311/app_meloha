
import 'package:flutter/cupertino.dart';

class SettingNotifier with ChangeNotifier {
  static final shared = SettingNotifier();


  void updateSettings() {
    notifyListeners();
  }
}