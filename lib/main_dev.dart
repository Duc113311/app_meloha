import 'dart:async';
import 'dart:developer';

import 'package:dating_app/src/app.dart';
import 'package:dating_app/src/general/app_flavor/app_config.dart';
import 'package:dating_app/src/general/constants/app_enum.dart';
import 'package:dating_app/src/general/inject_dependencies/inject_dependencies.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  configureDependencies();
runZonedGuarded(
          () async{
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    PrefAssist.setString(PrefConst.kVersionApp, packageInfo.version);
    PrefAssist.setString(PrefConst.kBuildNumber, packageInfo.buildNumber);
  });

  runApp(ScreenUtilInit(
    builder: (context,widget) {
      return const AppConfig(
          environment: AppEnvironment.DEVELOPMENT,
          child: HeartLinkApp());
    }
  ));

            },
                (error, stackTrace) => log(error.toString(), stackTrace: stackTrace));
}
