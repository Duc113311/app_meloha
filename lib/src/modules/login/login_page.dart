import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/app_manager.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/dtos/customers/login_dto.dart';
import 'package:dating_app/src/domain/services/connect/connectivity_service.dart';
import 'package:dating_app/src/modules/dating_tabbar.dart';
import 'package:dating_app/src/modules/login/email_password/email_password_page.dart';
import 'package:dating_app/src/modules/login/verify/verify_email_page.dart';
import 'package:dating_app/src/modules/subviews/hl_popup.dart';
import 'package:dating_app/src/requests/auth_services.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/services/navigator/route_service.dart';
import '../../general/constants/app_image.dart';
import '../../requests/api_utils.dart';
import '../Login/input_info_sequence.dart';
import 'register/my_number_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    oAuth2Id = PrefAssist.getMyCustomer().oAuth2Id ?? "";
    loginCheck();
  }

  String oAuth2Id = "";

  bool canPop = false;
  DateTime currentBackPressTime = DateTime.now();

  Future<void> loginCheck() async {
    if (oAuth2Id.isEmpty) {
      Utils.hideLoading();
      return;
    }

    final response = await loginServer(oAuth2Id);

    if (response?.customer != null) {
      await StaticInfoManager.shared().loadData();
      Utils.hideLoading();
      RouteService.routePushReplacementPage(const DatingTabbar());
    } else if (response?.errorCode == ApiCode.customerNotRegistered) {
      PrefAssist.getMyCustomer().oAuth2Id = oAuth2Id;
      await PrefAssist.saveMyCustomer();

      await StaticInfoManager.shared().loadData();
      final email = FirebaseAuth.instance.currentUser?.email ?? "";
      Utils.hideLoading();
      if (email.isEmpty) {
        return;
      } else {
        RouteService.routeGoOnePage(const InputInfoSequence());
      }
    } else if (response?.blockExtraInfo != null) {
      final extraInfo = response!.blockExtraInfo!;
      displayBlocked(extraInfo);
    } else {
      debugPrint("Login error: ${response?.message}");
    }
  }

  Future<LoginResponseModel?> loginServer(String token) async {
    if (token.isEmpty) {
      return null;
    }
    Utils.showLoading();
    LoginResponseModel response = await ApiRegLogin.login(token);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: onWillPop,
      canPop: canPop,
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 0,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
            statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                ? Brightness.light
                : Brightness.dark,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.bgLogin),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: bodyWidget(),
        ),
      ),
    );
  }

  Widget bodyWidget() => Stack(
        children: [
          Positioned(
            bottom: (Get.height / 2) - ThemeDimen.paddingNormal,
            child: Column(
              children: [
                WidgetGenerator.getWidgetAssetAppIcon(),
                SizedBox(
                  width: Get.width,
                  height: 28.toHeightRatio(),
                  child: Text(
                    S.current.app_title.toUpperCase(),
                    style: ThemeUtils.getTitleStyle(
                        color: ThemeUtils.getPrimaryColor()),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: double.infinity,
                height: (Get.height / 2) - ThemeDimen.paddingNormal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            ThemeDimen.paddingLarge,
                            ThemeDimen.paddingSmall,
                            ThemeDimen.paddingLarge,
                            ThemeDimen.paddingLarge),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            WidgetGenerator.getRippleButton(
                              borderRadius: ThemeDimen.borderRadiusNormal,
                              buttonHeight: ThemeDimen.buttonHeightNormal,
                              buttonWidth: double.infinity,
                              onClick: _onLoginWithGoogle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    height: 16.toWidthRatio(),
                                    width: 16.toWidthRatio(),
                                    AppImages.icGoogle,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                  SizedBox(width: ThemeDimen.paddingSemiSmall),
                                  AutoSizeText(
                                    S.current.login_with_google,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: ThemeNotifier.fontBold,
                                        fontSize: 14.toWidthRatio(),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6.toHeightRatio(),
                            ),
                            WidgetGenerator.getRippleButton(
                              borderRadius: ThemeDimen.borderRadiusNormal,
                              buttonHeight: ThemeDimen.buttonHeightNormal,
                              buttonWidth: double.infinity,
                              onClick: onLoginWithFacebook,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      height: 16.toWidthRatio(),
                                      width: 16.toWidthRatio(),
                                      AppImages.icFacebook,
                                      allowDrawingOutsideViewBox: true,
                                    ),
                                    SizedBox(
                                        width: ThemeDimen.paddingSemiSmall),
                                    AutoSizeText(
                                      S.current.login_with_facebook,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: ThemeNotifier.fontBold,
                                          fontSize: 14.toWidthRatio(),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6.toHeightRatio(),
                            ),
                            WidgetGenerator.getRippleButton(
                              borderRadius: ThemeDimen.paddingBig,
                              buttonHeight: ThemeDimen.buttonHeightNormal,
                              buttonWidth: double.infinity,
                              onClick: onLoginWithPhoneNumber,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      height: 16.toWidthRatio(),
                                      width: 16.toWidthRatio(),
                                      AppImages.icPhoneNumber,
                                      allowDrawingOutsideViewBox: true,
                                    ),
                                    SizedBox(
                                        width: ThemeDimen.paddingSemiSmall),
                                    AutoSizeText(
                                      S.current.login_with_phone,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: ThemeNotifier.fontBold,
                                          fontSize: 14.toWidthRatio(),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ThemeDimen.paddingNormal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: InkWell(
                            onTap: onTroubleLoginIn,
                            child: Text(
                              S.current.trouble_login,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 12.toHeightRatio(),
                                  color: HexColor("323232"),
                                  fontFamily: ThemeNotifier.fontMulishRegular,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ThemeDimen.paddingLarge,
                              vertical: ThemeDimen.paddingNormal),
                          child: Text.rich(
                            TextSpan(
                              text: '${S.current.term_intro_1} ',
                              style: ThemeUtils.getCaptionStyle(),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (() async {
                                      if (!await launchUrl(
                                          Uri.parse(Const.kUrlPrivacyPolicy))) {
                                        Fluttertoast.showToast(
                                            msg: S.current.error_when_open_url,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.red,
                                            fontSize:
                                                ThemeTextStyle.txtSizeBig);
                                      }
                                    }),
                                  text: S.current.term_privacy_policy,
                                  style: ThemeUtils.getCaptionStyle(
                                      decor: TextDecoration.underline),
                                ),
                                TextSpan(
                                    text:
                                        ' ${S.current.txt_and.toLowerCase()} '),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (() async {
                                      if (!await launchUrl(
                                          Uri.parse(Const.kUrlCookiesPolicy))) {
                                        Fluttertoast.showToast(
                                            msg: S.current.error_when_open_url,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.white,
                                            textColor: Colors.red,
                                            fontSize:
                                                ThemeTextStyle.txtSizeBig);
                                      }
                                    }),
                                  text: S.current.term_cookies_policy,
                                  style: ThemeUtils.getCaptionStyle(decor: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  _onLoginWithGoogle() async {
    Utils.showLoading();
    await AppManager.shared().dispose();

    UserCredential? credential = await authServices.signInWithGoogle();

    if (credential?.user == null) {
      //check network
      bool checkConnect = await ConnectivityService.canConnectToNetwork();
      Utils.hideLoading();
      if (checkConnect == false) {
        Utils.internetError();
      }

      return;
    }

    oAuth2Id = await credential!.user!.getIdToken(true) ?? '';
    if (oAuth2Id.isEmpty) {
      Utils.hideLoading();
      Utils.toast(S.current.txtid_opps_something_went_wrong);
      return;
    }

    debugPrint("idToken:\n$oAuth2Id\n");
    PrefAssist.getMyCustomer().oAuth2Id = oAuth2Id;
    PrefAssist.getMyCustomer().email = credential?.user?.email;
    PrefAssist.getMyCustomer().phone = credential?.user?.phoneNumber;

    await PrefAssist.saveMyCustomer();

    await loginCheck();
  }

  onLoginWithFacebook() async {
    await AppManager.shared().dispose();

    if (kDebugMode) {
      RouteService.routeGoOnePage(const EmailPasswordPage());
    } else {
      Utils.toast(S.current.coming_soon);
    }

  }

  loginFacebookSuccess() async {
    //check network
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
      return;
    }
    RouteService.routeGoOnePage(const VerifyEmailPage());
  }

  onLoginWithPhoneNumber() async {
    await AppManager.shared().dispose();

    if (kDebugMode) {
      RouteService.routeGoOnePage(const EmailPasswordPage());
    } else {
      Utils.toast(S.current.coming_soon);
    }
  }

  void displayBlocked(BlockedExtraInfoDto extraInfo) {
    Utils.hideLoading();
    if (!mounted) {
      return;
    }
    String message = '${S.current.txt_blocked_message}\n';
    String? date;
    if (extraInfo.disable != true) {
      var formatter = DateFormat('dd MMMM yyyy HH:mm a');
      date = formatter.format(extraInfo.toDate);

      message += S.current.txt_blocked_toDate;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) => HLPopupNotification(
              okAction: () async {
                await AppManager.shared().dispose();
                RouteService.pop();
              },
              title: S.current.txt_blocked_title,
              message: message,
              highlightMessage: date,
              okTitle: S.current.txtid_ok,
            ));
  }

  Future<void> goToPhoneNumberPage() async {
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
      return;
    }
    await AppManager.shared().dispose();
    RouteService.routeGoOnePage(const MyNumberPage());
  }

  void onTroubleLoginIn() {
    Utils.toast(S.current.coming_soon);
    //RouteService.routeGoOnePage(const AccountRecoverPage());
  }

  void onWillPop(bool didPop) {
    debugPrint("didPop: $didPop");

    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 1)) {
      currentBackPressTime = now;
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: S.current.tap_back_again_to_leave);
    } else {
      Fluttertoast.cancel();
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }
}
