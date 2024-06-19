import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/setting_page.dart';
import 'package:dating_app/src/modules/profile/screens/view_and_edit_profile_page.dart';
import 'package:dating_app/src/modules/subviews/premium_view.dart';
import 'package:dating_app/src/modules/subviews/upgrade_button.dart';
import 'package:dating_app/src/requests/api_update_profile_setting.dart';
import 'package:dating_app/src/utils/change_notifiers/edit_profile_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/premium_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/verify_account_notifier.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../domain/services/navigator/route_service.dart';
import '../../../general/constants/app_image.dart';
import '../../../utils/pref_assist.dart';
import '../../explore/screens/verifyPhoto/photo_verify_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  bool isVerified = false;
  List<String> userProfilePhotos = [];
  int infoComplete = 0;
  String strFirstName = "";
  String strUserDoB = "";

  @override
  bool wantKeepAlive = true;

  @override
  void initState() {
    super.initState();
    ThemeNotifier.themeModeRef.addListener(() {
      if(mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addObserver(this);
    _updateUserInfo();

    PremiumNotifier.shared.addListener(() {
      if(mounted) {
        setState(() {});
      }
      debugPrint(PremiumNotifier.shared.isPremium.toString());
    });

    VerifyAccountNotifier.shared.addListener(() async {
      debugPrint("user verify status: ${PrefAssist.getMyCustomer().verified}");
      if(mounted) {
        setState(() {});
      }
    });

  }

  _updateUserInfo() async {
    await ApiProfileSetting.getProfile();
    EditProfileNotifier.shared.updateProfile();
    setState(() {});
  }

  @override
  void didChangeLocales(List<Locale>? locales) async {
    super.didChangeLocales(locales);
    await StaticInfoManager.shared().loadData();
    _updateUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              S.current.app_title.toUpperCase(),
              style: ThemeUtils.getTitleStyle(),
            ),
            const Spacer(),
          ],
        ),
        actions: [
          UpgradeButton(
            isPremium: PremiumNotifier.shared.isPremium,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PrefAssist.getMyCustomer().isEmpty
              ? Container(
                  color: Colors.red,
                  width: context.width,
                  height: context.height,
                )
              : Column(
                  children: [
                    SizedBox(height: ThemeDimen.paddingNormal),
                    _avatarWidget(),
                    _settingWidget(),
                    if (!PremiumNotifier.shared.isPremium)
                      const PremiumView(),
                    //const SlidePremiumPackage(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _avatarWidget() {
    int percent = PrefAssist.getMyCustomer().getPercentCompleted;
    return Column(
      children: [
        // avatar
        Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  await RouteService.routeGoOnePage(ViewEditProfilePage(
                    tabIndex: 1,
                  ));
                  setState(() {});
                },
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.transparent,
                  child: CircularPercentIndicator(
                    animationDuration: 1000,
                    animateFromLastPercent: true,
                    animation: true,
                    radius: 75,
                    startAngle: 180,
                    progressColor: HexColor("00C766"),
                    percent: percent / 100,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: () async {
                  await RouteService.routeGoOnePage(ViewEditProfilePage(
                    tabIndex: 1,
                  ));
                  setState(() {});
                },
                child: Center(
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(65),
                      child: CacheImageView(
                        imageURL: PrefAssist.getMyCustomer().getAvatarUrl,
                        fit: BoxFit.cover,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 25,
                  width: 100,
                  decoration: BoxDecoration(
                    color: HexColor("00C766"),
                    borderRadius:
                        BorderRadius.circular(ThemeDimen.borderRadiusSmall),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "$percent% ${S.current.new_txtid_completed}",
                        textAlign: TextAlign.center,
                      
                        style: ThemeUtils.getCaptionStyle(
                            fontSize: ThemeTextStyle.txtSizeSmall,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ThemeDimen.paddingSmall),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
          child: SizedBox(
            width: Get.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 7,
                      child: Text(
                        PrefAssist.getMyCustomer().fullname,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: ThemeUtils.getTitleStyle(
                            fontSize: 16.toWidthRatio()),
                      ),
                    ),
                    Text(
                      ', ${PrefAssist.getMyCustomer().getAge()}',
                      style: ThemeUtils.getTitleStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 3,),
                    GestureDetector(
                      onTap: () {
                        if (PrefAssist.getMyCustomer().verified ==
                            Const.kVerifyAccountSuccess) {
                          return;
                        }
                        if (PrefAssist.getMyCustomer().verified ==
                            Const.kVerifyAccountPending) {
                          Utils.toast(
                              S.current.txtid_your_account_is_being_verified);
                          return;
                        }
                        RouteService.routeGoOnePage(const PhotoVerifyPage());
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            PrefAssist.getMyCustomer().myVerifyImage,
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _settingWidget() {
    return Padding(
      padding: EdgeInsets.all(ThemeDimen.paddingSuper),
      child: Center(
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  WidgetGenerator.getRippleCircleButton(
                    colorBg:
                        PrefAssist.getBool(PrefConst.kFirstDefaultMode, false)
                            ? Colors.white
                            : const Color.fromRGBO(37, 42, 55, 1.0),
                    onClick: () async {
                      await RouteService.routeGoOnePage(SettingPage());
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    childBg: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: ThemeUtils.getScaffoldBackgroundColor(),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: ThemeUtils.getTextColor(),
                      size: 32,
                    ),
                  ),
                  SizedBox(height: ThemeDimen.paddingSmall),
                  Text(
                    S.current.setting.toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: ThemeNotifier.fontSemiBold,
                        color: ThemeUtils.isDarkModeSetting()
                            ? Colors.white
                            : HexColor("737E99")),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(height: ThemeDimen.paddingSuper),
                  WidgetGenerator.getRippleCircleButton(
                    onClick: () async {
                      await RouteService.routeGoOnePage(ViewEditProfilePage(
                        tabIndex: 0,
                      ));
                      setState(() {});
                    },
                    childBg: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: ThemeUtils.getScaffoldBackgroundColor(),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    child: SizedBox(
                      child: Center(
                        child: SvgPicture.asset(
                          AppImages.icEditProfile,
                          width: 32,
                          height: 32,
                          colorFilter: ColorFilter.mode(
                              ThemeUtils.getTextColor(), BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ThemeDimen.paddingSmall),
                  Text(
                    S.current.edit_profile.toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: ThemeNotifier.fontSemiBold,
                        color: ThemeUtils.isDarkModeSetting()
                            ? Colors.white
                            : HexColor("737E99")),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  WidgetGenerator.getRippleCircleButton(
                    onClick: () {
                      Utils.toast(S.current.coming_soon);
                    },
                    childBg: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: ThemeUtils.getScaffoldBackgroundColor(),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.icSafety,
                        height: 32,
                        width: 32,
                        color: ThemeUtils.getTextColor(),
                        allowDrawingOutsideViewBox: true,
                      ),
                    ),
                  ),
                  SizedBox(height: ThemeDimen.paddingSmall),
                  Text(
                    S.current.safety.toUpperCase(),
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: ThemeNotifier.fontSemiBold,
                        color: ThemeUtils.isDarkModeSetting()
                            ? Colors.white
                            : HexColor("737E99")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
