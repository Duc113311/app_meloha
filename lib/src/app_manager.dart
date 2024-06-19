import 'package:dating_app/src/utils/card_manager.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/socket_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppManager {
  static final GlobalKey<NavigatorState> globalKeyRootMaterial =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> globalKeyRootScaffold =
      GlobalKey<NavigatorState>();


  //static AppSession get appSession => AppSession();
  static final AppManager _shared = AppManager._internal();
  AppManager._internal();
  static AppManager shared() => _shared;


  Future<void> dispose() async {
    FirebaseMessaging.instance.deleteToken();
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }

    SocketManager.shared().closeSocket();
    CardManager.shared().removeAll();
    PrefAssist.setBool(PrefConst.kAgreeDatingRule,false);
    await PrefAssist.clearMyCustomer();

  }
}
