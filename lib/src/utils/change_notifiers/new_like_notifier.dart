
import 'package:flutter/cupertino.dart';

class NewLikeNotifier with ChangeNotifier {
  static final shared = NewLikeNotifier();


  void gotNewLike() {
    notifyListeners();
  }
}