import 'package:dating_app/src/app_manager.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/modules/login/login_page.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/services/navigator/route_service.dart';
import '../../../general/constants/app_constants.dart';
import '../../../general/constants/app_image.dart';
import '../input_info_sequence.dart';

class DatingRulesPage extends StatefulWidget {
  final PageController pageController;

  const DatingRulesPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<DatingRulesPage> createState() => _DatingRulesPageState();
}

class _DatingRulesPageState extends State<DatingRulesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              if (await InputInfoSequence.showExitConfirmDialog(context) ==
                  Utils.kDialogPositiveValue) {
                try {
                  await AppManager.shared().dispose();
                  await RouteService.routePushReplacementPage(const LoginPage());
                } catch (e) {
                  print(e);
                  await RouteService.popToRootPage();
                }
              }
            },
            icon: SvgPicture.asset(
              AppImages.icArrowBack,
              colorFilter:
                  ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
            ),
          ),
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
            statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                ? Brightness.light
                : Brightness.dark,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: ThemeDimen.paddingBig),

              WidgetGenerator.getWidgetAssetAppIcon(),
              SizedBox(height: ThemeDimen.paddingBig),
              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  textAlign: TextAlign.center,
                  S.current.welcome_dating,
                  style: ThemeUtils.getTitleStyle(fontSize: 22),
                ),
              ),
              SizedBox(height: ThemeDimen.paddingSmall),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
                child: Center(
                  child: Text(
                    S.current.follow_house_rules,
                    style: ThemeUtils.getTextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: ThemeDimen.paddingLarge),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeDimen.paddingNormal,
                    vertical: ThemeDimen.paddingNormal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24 / 667 * AppConstants.height,
                      width: 50 / 375 * AppConstants.width,
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        AppImages.icHand,
                        height: 24 / 667 * AppConstants.height,
                        width: 24 / 375 * AppConstants.width,
                        allowDrawingOutsideViewBox: true,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    Container(
                      width: Get.width - 100,
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.current.be_your_self,
                              style: ThemeUtils.getTitleStyle(fontSize: 18)),
                          SizedBox(height: 3 / 667 * AppConstants.height),
                          Text(
                            S.current.be_your_self_msg,
                            style: ThemeUtils.getTextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeDimen.paddingNormal,
                    vertical: ThemeDimen.paddingNormal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24 / 667 * AppConstants.height,
                      width: 50 / 375 * AppConstants.width,
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        AppImages.icHand,
                        height: 24 / 667 * AppConstants.height,
                        width: 24 / 375 * AppConstants.width,
                        allowDrawingOutsideViewBox: true,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    Container(
                      width: Get.width - 90,
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.current.stay_safe,
                              style: ThemeUtils.getTitleStyle(fontSize: 18)),
                          const SizedBox(height: 3),
                          Text.rich(
                            TextSpan(
                              style: ThemeUtils.getTextStyle(fontSize: 16),
                              children: [
                                TextSpan(text: '${S.current.stay_safe_msg_1} ', style: ThemeUtils.getTextStyle(fontSize: 16)),
                                TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = (() async {
                                        if (!await launchUrl(Uri.parse(
                                            Const.kUrlDateSafetyGuidelines))) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  S.current.error_when_open_url,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.white,
                                              textColor: Colors.red,
                                              fontSize:
                                                  ThemeTextStyle.txtSizeBig);
                                        }
                                      }),
                                    text: S.current.stay_safe_msg_2,
                                    style: ThemeUtils.getTextStyle(fontSize: 16).copyWith(decoration: TextDecoration.underline)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeDimen.paddingNormal,
                    vertical: ThemeDimen.paddingNormal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24 / 667 * AppConstants.height,
                      width: 50 / 375 * AppConstants.width,
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        AppImages.icHand,
                        height: 24 / 667 * AppConstants.height,
                        width: 24 / 375 * AppConstants.width,
                        allowDrawingOutsideViewBox: true,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    Container(
                      width: Get.width - 90,
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.current.play_it_cool,
                              style: ThemeUtils.getTitleStyle(fontSize: 18)),
                          const SizedBox(height: 3),
                          Text(
                            S.current.play_it_cool_msg,
                            style: ThemeUtils.getTextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeDimen.paddingNormal,
                    vertical: ThemeDimen.paddingNormal),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 24 / 667 * AppConstants.height,
                      width: 50 / 375 * AppConstants.width,
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        AppImages.icHand,
                        height: 24 / 667 * AppConstants.height,
                        width: 24 / 375 * AppConstants.width,
                        allowDrawingOutsideViewBox: true,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                    Container(
                      width: Get.width - 90,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(S.current.be_proactive,
                                style: ThemeUtils.getTitleStyle(fontSize: 18)),
                          ),
                          const SizedBox(height: 3),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S.current.be_proactive_msg,
                              style: ThemeUtils.getTextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16,),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingSmall,
                  ThemeDimen.paddingSuper,
                  ThemeDimen.paddingLarge),
              child: WidgetGenerator.getRippleButton(
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: onAgreeCondition,
                child: Center(
                  child: Text(
                    S.current.str_continue.toCapitalized,
                    style: ThemeUtils.getButtonStyle(),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  void onAgreeCondition() {
    PrefAssist.setBool(PrefConst.kAgreeDatingRule, true);

    widget.pageController.nextPage(
        duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
        curve: Curves.easeIn);
  }
}
