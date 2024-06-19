
import 'package:flutter/cupertino.dart';

class EditProfileNotifier with ChangeNotifier {
  static final shared = EditProfileNotifier();

  void updateProfile() {
    notifyListeners();
  }
}