import 'package:flutter/cupertino.dart';

class TabbarItemNotifier with ChangeNotifier {
  static final shared = TabbarItemNotifier();

  int tabbarIndex = 0;

  void updateIndex(int index) {
    tabbarIndex = index;
    notifyListeners();
  }
}