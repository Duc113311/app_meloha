import 'dart:convert';

import 'package:dating_app/src/utils/change_notifiers/premium_notifier.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class RemoteConfigsManager {
  static FirebaseRemoteConfig? _remoteConfig;
  static double TIME_CAPPING = 1000 * 60 * 2; // 5 minutes
  static DateTime? _oldRequestTime;

  static Future<FirebaseRemoteConfig> get remoteConfig async {
    if (_remoteConfig != null) {
      return _remoteConfig!;
    }
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 0),
    ));
    return _remoteConfig!;
  }

  static void loadConfigs() async {
    final currentTime = DateTime.now();
    final oldTime = _oldRequestTime?.millisecondsSinceEpoch ?? 0;
    if (currentTime.millisecondsSinceEpoch - oldTime < TIME_CAPPING) {
      debugPrint(
          "Time capping remote configs. - diff: ${currentTime.millisecondsSinceEpoch - oldTime} - capping: $TIME_CAPPING");
      return;
    }
    _oldRequestTime = currentTime;
    final configs = await remoteConfig;
    await configs.fetchAndActivate();

    final configsString = configs.getString("Configs");
    if (configsString.isNotEmpty) {
      final model = jsonDecode(configsString);
      final enablePremium = model["enablePremium"] as bool;
      await PremiumNotifier.shared.setPremium(enablePremium);
    } else {
      debugPrint("cannot get remote configs");
    }
  }
}
