import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dating_app/src/app.dart';
import 'package:dating_app/src/general/inject_dependencies/inject_dependencies.dart';
import 'package:dating_app/src/utils/change_notifiers/verify_email_notifier.dart';
import 'package:dating_app/src/utils/const.dart';
import 'package:dating_app/src/utils/notification_manager.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/remote_configs.dart';
import 'package:dating_app/src/utils/sp_util.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'firebase_options.dart';

List<CameraDescription> cameras = [];
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

setupGetStorage() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await GetStorage.init(appDocumentDirectory.path);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = _cert;
  }

  bool _cert(X509Certificate cert, String host, int port) => true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SentryFlutter.init((options) {
    options.dsn = 'https://76f9a84d921543b0ffb8a59c64f9ed37@o4507292449570816.ingest.de.sentry.io/4507292451930192';
    options.tracesSampleRate = 1.0;
  });

  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e.description);
  }
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();

  FirebaseAuth.instance.authStateChanges().listen((user) {
    debugPrint(
        "FirebaseAuth... current user has been changed!\ndisplayName: ${user?.displayName}, email: ${user?.email},  phone: ${user?.phoneNumber}");
  });
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  if (initialLink != null) {
    final Uri deepLink = initialLink.link;
    debugPrint(deepLink.toString());
    handleDeeplink(deepLink);
  }

  FirebaseDynamicLinks.instance.onLink.listen(
    (pendingDynamicLinkData) async {
      if (pendingDynamicLinkData != null) {
        final Uri deepLink = pendingDynamicLinkData.link;
        handleDeeplink(deepLink);
      } else {
        print("pendingDynamicLinkData is nil");
      }
    },
  );

  await setupGetStorage();
  configureDependencies();
  try {
    await SPService().getInstance();
  } catch (e) {
    print(e);
  }
  ThemeUtils.setSystem(ThemeUtils.isDarkModeSetting());

  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    PrefAssist.setString(PrefConst.kVersionApp, packageInfo.version);
    PrefAssist.setString(PrefConst.kBuildNumber, packageInfo.buildNumber);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    PrefAssist.setString("fcmToken", fcmToken);
    debugPrint("fcm onTokenRefresh: $fcmToken");
  }).onError((err) {
    debugPrint('fcm onTokenRefresh $err');
  });

  FirebaseMessaging.instance.getToken().then((value) {
    String token = value ?? "";
    PrefAssist.setString("fcmToken", token);
    debugPrint("fcm getToken: $token");
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      LocalNotificationManager.shared().show(
          message.notification!.title!, message.notification!.body!, payload: message.data.toString());
    } else {

      // String isOngoing = message.data["is_ongoing"];
      // String title = message.data["title"];
      //
      // LocalNotificationManager.shared()
      //     .show(title, isOngoing, payload: message.data.toString());
    }
  });

  RemoteConfigsManager.loadConfigs();

  runApp(Phoenix(
    child: ScreenUtilInit(builder: (context, widget) {
      return const HeartLinkApp();
    }),
  ));
}

Future<void> handleDeeplink(Uri deeplink) async {
  debugPrint("deeplink: ${deeplink.toString()}");

  final user = FirebaseAuth.instance.currentUser;
  final verifyEmail = PrefAssist.getString(Const.kVerifyEmail);
  if (user != null && verifyEmail.isNotEmpty) {
    final email = user.email ?? '';
    if (email.isEmpty) {
      final authCredential = EmailAuthProvider.credentialWithLink(
          email: verifyEmail, emailLink: deeplink.toString());
      await user!.linkWithCredential(authCredential).then((value) async {
        PrefAssist.getMyCustomer().email = user.email;
        await PrefAssist.saveMyCustomer();

        VerifyEmailNotifier.shared.updateStatus();
        debugPrint('Successfully signed in with email link!');
      }).catchError((error) {
        VerifyEmailNotifier.shared.updateStatus(err: error.toString());
        debugPrint('Can not verify Email: ${error.toString()}');
      });
    } else {
      debugPrint('da co email: $email');
    }
  } else {
    print("user is empty");
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.notification != null) {
    LocalNotificationManager.shared()
        .show(message.notification!.title!, message.notification!.body!, payload: message.data.toString());
  } else {
    //String isOngoing = message.data["is_ongoing"];
    // String title = message.data["title"];
    //
    // LocalNotificationManager.shared()
    //     .show(title, isOngoing, message.data.toString());
  }
}