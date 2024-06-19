import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:flutter/cupertino.dart';

class PremiumNotifier with ChangeNotifier {
  static final shared = PremiumNotifier();

  Future<void> togglePremium() async {
    await setPremium(!isPremium);
  }

  bool get isPremium {
    return PrefAssist.getBool(PrefConst.kPremiumVersion, true);
  }

  Future<void> setPremium(bool value) async {
    await PrefAssist.setBool(PrefConst.kPremiumVersion, value);
    notifyListeners();
  }
}
