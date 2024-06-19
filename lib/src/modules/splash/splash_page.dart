import 'dart:async';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/dating_tabbar.dart';
import 'package:dating_app/src/modules/login/login_page.dart';
import 'package:dating_app/src/utils/locale.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/socket_manager.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key, required this.isDarkOn}) : super(key: key);
  final bool isDarkOn;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Position _currentPosition;
  bool isDarkOn = false;

  @override
  void initState() {
    super.initState();
    _checkTheme();
    // _socketService;
    // chatClient.socket.connected;
    // onRequestEnableLocation();
    isDarkOn = widget.isDarkOn;
    // check locale
    checkLocale();
  }

  void _checkTheme() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
      () {
        isDarkOn = widget.isDarkOn;
      },
    );
  }

  Future<void> handleSplashRoute() async {
    await StaticInfoManager.shared().loadData();
    final nextPage = await getNextPage();
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(context,
          PageTransition(child: nextPage, type: PageTransitionType.fade)),
    );
  }

  Future<Widget> getNextPage() async {
    String token = PrefAssist.getAccessToken();
    if (token.isEmpty) {
      return const LoginPage();
    } else {
      await SocketManager.shared().updateAuth(token);
      return const DatingTabbar();
    }
  }

  Future<void> checkLocale() async {
    var checkLocale = PrefAssist.getString(PrefConst.kDeviceLocale);
    String locale = await LocaleSupport.getCurrentDeviceLocale();
    if (checkLocale == locale) {
      PrefAssist.setBool(PrefConst.kIsChangedLocale, false);
    } else {
      PrefAssist.setBool(PrefConst.kIsChangedLocale, true);
    }
    PrefAssist.setString(PrefConst.kDeviceLocale, locale);
    handleSplashRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(children: [
            Image.asset(
              widget.isDarkOn ? AppImages.bgLogin : AppImages.bgLogin,
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
            ),
            // Column(
            //   children: [
            //     SizedBox(
            //       height: Get.height / 3,
            //     ),
            //     Center(
            //       child: Image.asset(
            //         AppImages.splesh,
            //         height: Get.height / 3,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ],
            // )
          ])
        ],
      ),
    );
  }
}
