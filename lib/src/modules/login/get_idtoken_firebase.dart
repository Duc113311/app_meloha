import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/domain/services/connect/connectivity_service.dart';
import 'package:dating_app/src/modules/login/verify/verify_email_page.dart';
import 'package:dating_app/src/requests/auth_services.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/services/navigator/route_service.dart';
import '../../general/constants/app_image.dart';
import 'account/recover/account_recover_page.dart';

class GetIdTokenPage extends StatefulWidget {
  const GetIdTokenPage({Key? key}) : super(key: key);

  @override
  State<GetIdTokenPage> createState() => _GetIdTokenPageState();
}

class _GetIdTokenPageState extends State<GetIdTokenPage> {
  AuthServices authServices = AuthServices();

  @override
  void initState() {
    super.initState();
    oAuth2Id = PrefAssist.getMyCustomer().oAuth2Id ?? "";
  }

  String oAuth2Id = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light),
        toolbarHeight: 0,
      ),
      body: bodyWidget(),
    );
  }

  Widget bodyWidget() => Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          RouteService.pop();
                        },
                        icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                WidgetGenerator.getWidgetAssetAppIcon(),
                SizedBox(
                  width: Get.width,
                  height: 28.toHeightRatio(),
                  child: Text(
                    "Lấy idToken",
                    style: TextStyle(
                        fontSize: 22.toWidthRatio(),
                        color: ThemeColor.mainColor,
                        fontFamily: ThemeNotifier.fontBold,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
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
                                  SizedBox(width: ThemeDimen.paddingBig),
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
                                    SizedBox(width: ThemeDimen.paddingBig),
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
                                    SizedBox(width: ThemeDimen.paddingBig),
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
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  _onLoginWithGoogle() async {
    await FirebaseAuth.instance.signOut();
    UserCredential? credential = await authServices.signInWithGoogle();

    if (credential?.user == null) {
      return;
    }

    oAuth2Id = await credential!.user!.getIdToken(true) ?? '';
    if (oAuth2Id.isEmpty) {
      return;
    }

    await Share.share(oAuth2Id);
    debugPrint("idToken:\n$oAuth2Id\nend");
  }

  onLoginWithFacebook() async {
    await FirebaseAuth.instance.signOut();
    Utils.toast(S.current.coming_soon);
    return;
    //check network
    bool checkConnect = await ConnectivityService.canConnectToNetwork();
    if (checkConnect == false) {
      Utils.internetError();
      return;
    }
    UserCredential creden = await authServices.signInFacebook();
    if (creden.additionalUserInfo != null) {
      PrefAssist.getMyCustomer().oAuth2Id = creden.user!.uid;
      PrefAssist.saveMyCustomer();
      loginFacebookSuccess();
    } else {}
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
    final phone = FirebaseAuth.instance.currentUser?.phoneNumber ?? "";

    if (phone.isNotEmpty) {
      OkCancelResult result = await showOkCancelAlertDialog(
          context: context,
          title: S.current.app_title,
          message: "${S.current.txt_do_you_want_to_continue}: $phone?");
      if (result == OkCancelResult.ok) {
        oAuth2Id =
            await FirebaseAuth.instance.currentUser!.getIdToken(true) ?? '';
        debugPrint("idToken:\n$oAuth2Id\nend");
        await Share.share(oAuth2Id);
      }
    }
  }

  void onTroubleLoginIn() {
    RouteService.routeGoOnePage(const AccountRecoverPage());
  }
}
