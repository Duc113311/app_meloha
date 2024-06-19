import 'dart:async';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/app_manager.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/components/widgets/switch_dart.dart';
import 'package:dating_app/src/core/data_types.dart';
import 'package:dating_app/src/domain/dtos/customer_setting/customer_setting_dto.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/libs/sliders/sliders.dart';
import 'package:dating_app/src/modules/login/login_page.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/subs/active_setting_screen.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/subs/edit_phone_page.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/subs/online_setting_screen.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/widget/account_discover_setting.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/widget/data_usage.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/widget/enable_dark_mode.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/widget/show_me_on_card.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/widget/slide_age_range.dart';
import 'package:dating_app/src/modules/subviews/back_button.dart';
import 'package:dating_app/src/modules/subviews/hl_popup.dart';
import 'package:dating_app/src/modules/subviews/premium_view.dart';
import 'package:dating_app/src/utils/change_notifiers/premium_notifier.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/change_notifiers/setting_notifier.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:notification_center/notification_center.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../components/bloc/deleted_account/deleted_account_cubit.dart';
import '../../../../components/widgets/dialogs/dating_silver_dialog.dart';
import '../../../../domain/services/navigator/route_service.dart';
import '../../../../requests/api_update_profile_setting.dart';
import 'subs/data_usage_screen.dart';
import 'widget/show_me.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key) {
    if (PrefAssist.getMyCustomer().settings?.distancePreference == null) {
      PrefAssist.getMyCustomer().settings?.distancePreference =
          DistancePreferenceDto();
    }
    if (PrefAssist.getMyCustomer().settings?.agePreference == null) {
      PrefAssist.getMyCustomer().settings?.agePreference = AgePreferenceDto();
    }
  }

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isKm = Utils.getMyCustomerDistType() == Const.kDistTypeKm;
  bool isHaveChanges = false;
  double _milValue = (PrefAssist.getMyCustomer()
              .settings
              ?.distancePreference
              ?.range
              ?.toDouble() ??
          0)
      .kmToMil();
  double _distanceRange = PrefAssist.getMyCustomer()
          .settings
          ?.distancePreference
          ?.range
          ?.toDouble() ??
      0;

  int _startAgeRange =
      PrefAssist.getMyCustomer().settings?.agePreference?.min ?? 0;
  int _endAgeRange =
      PrefAssist.getMyCustomer().settings?.agePreference?.max ?? 0;

  String strShowMeText = "";

  IntVs selectedYouSee = IntVs(0);
  IntVs selectedSeeYou = IntVs(0);

  List<_ControlObject> listControlWhoYouSees = [
    _ControlObject(S.current.balanced_recommendation,
        S.current.see_the_most_relevant, false),
    _ControlObject(
        S.current.recently, S.current.see_the_most_recently_active, false),
  ];

  List<_ControlObject> listControlWhoSeeYou = [
    _ControlObject(
        S.current.standard, S.current.only_be_shown_to_certain, false),
    _ControlObject(S.current.only_people_liked,
        S.current.only_people_you_have_liked_will_see_me, false)
  ];

  List<_MenuSetting> listAppSettings = [
    _MenuSetting(S.current.txtid_email, "email", false, false, () async {
      return false;
    }),
    _MenuSetting(S.current.txtid_push_notification, "push_noti", false, false,
        () async {
      return false;
    }),
    _MenuSetting(S.current.txtid_team_dating, "team_date", false, false,
        () async {
      return false;
    }),
  ];

  List<_MenuSetting> listPayments = [
    _MenuSetting(
        S.current.txtid_manage_payment_account, "manage_payment", false, true,
        () async {
      return false;
    }),
    _MenuSetting(
        S.current.txtid_restore_purchase, "restore_purcharse ", false, true,
        () async {
      return false;
    }),
  ];

  List<_MenuSetting> listContactUs = [
    _MenuSetting(S.current.txtid_help_support, "help_contact", false, false,
        () async {
      await launchUrl(Uri.parse(Const.kUrlHelpAndSupport));
      return true;
    })
  ];

  List<_MenuSetting> listCommunity = [
    _MenuSetting(
        S.current.txtid_community_guidelines, "guidelines", false, false,
        () async {
      await launchUrl(Uri.parse(Const.kUrlCommunityGuidelines));
      return true;
    }),
    _MenuSetting(S.current.txtid_safety_tips, "safety_tip", false, false,
        () async {
      await launchUrl(Uri.parse(Const.kUrlSafetyTip));
      return true;
    }),
    _MenuSetting(S.current.txtid_safety_center, "safety_center", false, false,
        () async {
      await launchUrl(Uri.parse(Const.kUrlSafetyCenter));
      return true;
    }),
  ];
  List<_MenuSetting> listLegal = [
    _MenuSetting(S.current.txtid_licenses, "guidelines", false, false,
        () async {
      await launchUrl(Uri.parse(Const.kUrlGuideLines));
      return true;
    }),
    _MenuSetting(
        S.current.txtid_terms_of_service, "terms_of_service", false, false,
        () async {
      await launchUrl(Uri.parse(Const.kUrlTermOfService));
      return true;
    }),
  ];

  List<_MenuSetting> listPrivacy = [
    _MenuSetting(S.current.txtid_cookies_policy, "cookies_policy", false, false,
        () async {
      await launchUrl(Uri.parse(Const.kUrlCookiesPolicy));
      return true;
    }),
    _MenuSetting(S.current.txtid_privacy_policy, "safety_center", false, false,
        () async {
      await launchUrl(Uri.parse(Const.kUrlPrivacyPolicy));
      return true;
    }),
  ];

  Timer? slideTimer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    debugPrint(placemarks.toString());
    Placemark place = placemarks[0];
    setState(() {
      Utils.toast('${place.administrativeArea}, ${place.country}');
    });
  }

  Future<void> _updateLanguages() async {
    await StaticInfoManager.shared().loadData();
    listControlWhoYouSees = [
      _ControlObject(S.current.balanced_recommendation,
          S.current.see_the_most_relevant, false),
      _ControlObject(
          S.current.recently, S.current.see_the_most_recently_active, false),
    ];

    listControlWhoSeeYou = [
      _ControlObject(
          S.current.standard, S.current.only_be_shown_to_certain, false),
      _ControlObject(S.current.only_people_liked,
          S.current.only_people_you_have_liked_will_see_me, false)
    ];
    listAppSettings = [
      _MenuSetting(S.current.txtid_email, "email", false, false, () async {
        return false;
      }),
      _MenuSetting(S.current.txtid_push_notification, "push_noti", false, false,
          () async {
        return false;
      }),
      _MenuSetting(S.current.txtid_team_dating, "team_date", false, false,
          () async {
        return false;
      }),
    ];

    listPayments = [
      _MenuSetting(
          S.current.txtid_manage_payment_account, "manage_payment", false, true,
          () async {
        return false;
      }),
      _MenuSetting(
          S.current.txtid_restore_purchase, "restore_purcharse ", false, true,
          () async {
        return false;
      }),
    ];

    listContactUs = [
      _MenuSetting(S.current.txtid_help_support, "help_contact", false, false,
          () async {
        await launchUrl(Uri.parse(Const.kUrlHelpAndSupport));
        return true;
      })
    ];

    listCommunity = [
      _MenuSetting(
          S.current.txtid_community_guidelines, "guidelines", false, false,
          () async {
        await launchUrl(Uri.parse(Const.kUrlCommunityGuidelines));
        return true;
      }),
      _MenuSetting(S.current.txtid_safety_tips, "safety_tip", false, false,
          () async {
        await launchUrl(Uri.parse(Const.kUrlSafetyTip));
        return true;
      }),
      _MenuSetting(S.current.txtid_safety_center, "safety_center", false, false,
          () async {
        await launchUrl(Uri.parse(Const.kUrlSafetyCenter));
        return true;
      }),
    ];

    listLegal = [
      _MenuSetting(S.current.txtid_licenses, "guidelines", false, false,
          () async {
        await launchUrl(Uri.parse(Const.kUrlGuideLines));
        return true;
      }),
      _MenuSetting(
          S.current.txtid_terms_of_service, "terms_of_service", false, false,
          () async {
        await launchUrl(Uri.parse(Const.kUrlTermOfService));
        return true;
      }),
    ];

    listPrivacy = [
      _MenuSetting(
          S.current.txtid_cookies_policy, "cookies_policy", false, false,
          () async {
        await launchUrl(Uri.parse(Const.kUrlCookiesPolicy));
        return true;
      }),
      _MenuSetting(
          S.current.txtid_privacy_policy, "safety_center", false, false,
          () async {
        await launchUrl(Uri.parse(Const.kUrlPrivacyPolicy));
        return true;
      }),
    ];
  }

  Future _goBack({canPop = true}) async {
    await ApiProfileSetting.updateMyCustomerSetting();
    SettingNotifier.shared.updateSettings();
    if (canPop) {
      RouteService.pop();
    }
  }

  int _selectedWho(String titleControl) {
    var i = 0;
    if (titleControl == S.current.control_who_you_see) {
      PrefAssist.getMyCustomer().plusCtrl?.whoYouSee == 'default'
          ? i = 0
          : i = 1;
    } else {
      PrefAssist.getMyCustomer().plusCtrl?.whoSeeYou == 'everyone'
          ? i = 0
          : i = 1;
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (canPop) {
        _goBack(canPop: false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
            statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                ? Brightness.light
                : Brightness.dark,
          ),
          toolbarHeight: 0,
        ),
        body: Column(
          children: [
            Row(
              children: [
                HLBackButton(
                  onPressed: () {
                    _goBack();
                  },
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  S.current.setting,
                  maxLines: 1,
                  style: ThemeUtils.getTitleStyle(fontSize: 18)
                      .copyWith(overflow: TextOverflow.ellipsis),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    if (!PremiumNotifier.shared.isPremium)
                      const PremiumView(
                      showButton: false,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ThemeDimen.paddingSmall),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            enableGlobalWidget(),
                            slideDistanceRangeWidget(),
                            slideAgeRangeWidget(),
                            showMeWidget(),
                            buildControlSettingWidget(
                                S.current.control_who_you_see,
                                listControlWhoYouSees,
                                selectedYouSee),
                            buildControlSettingWidget(
                                S.current.control_who_see_you,
                                listControlWhoSeeYou,
                                selectedSeeYou),
                            _showMeOnCardWidget(),
                            _showDistanceInWidget(),
                            _enableDarkModeWidget(),

                            privacyWidget(),
                            shareAppWidget(),

                            contactWidget(),
                            legalWidget(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: ThemeDimen.paddingNormal),
                              child: WidgetGenerator.bottomButton(
                                selected: true,
                                buttonHeight: ThemeDimen.buttonHeightNormal,
                                buttonWidth: double.infinity,
                                onClick: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return HLPopupPage(
                                          cancelAction: () {
                                            RouteService.pop();
                                          },
                                          okAction: () async {
                                            RouteService.pop();
                                            await AppManager.shared().dispose();
                                            await RouteService
                                                .routePushReplacementPage(
                                                    const LoginPage());
                                          },
                                          title: S
                                              .current.txt_logout_confirm_title,
                                          message: S.current
                                              .txt_logout_confirm_message,
                                          okTitle: S.current.txt_logout_button,
                                          cancelTitle: S.current.str_cancel,
                                        );
                                      });
                                },
                                child: Center(
                                  child: AutoSizeText(
                                    S.current.str_logout,
                                    style: ThemeUtils.getButtonStyle(),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Text(S.current.app_title.toUpperCase(),
                                      style: ThemeUtils.getTitleStyle(
                                          fontSize: 22.toWidthRatio())),
                                  Text(
                                    '${S.current.txtid_version} ${PrefAssist.getString(PrefConst.kVersionApp, "1.0")}+${PrefAssist.getString(PrefConst.kBuildNumber, "1")}',
                                    style: ThemeUtils.getTextStyle(
                                        color: ThemeUtils.headerColor()),
                                  ),
                                ],
                              ),
                            ),
                            _deletedAccount(),
                          ]
                              .expand((e) => [
                                    e,
                                    SizedBox(height: ThemeDimen.paddingBig),
                                  ])
                              .toList()
                            ..removeLast()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deletedAccount() =>
      BlocListener<DeletedAccountCubit, DeletedAccountState>(
        listener: (context, state) async {
          if (state is DeletedAccountLoading) {
            Utils.showLoading();
          } else if (state is DeletedAccountSuccess) {
            await AppManager.shared().dispose();

            Utils.hideLoading();

            await RouteService.popToRootPage();
            await RouteService.routePushReplacementPage(const LoginPage());
          } else if (state is DeletedAccountFailed) {
            Utils.hideLoading();
            Utils.toast('Deleted Account Failed');
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: ThemeDimen.paddingNormal),
          child: WidgetGenerator.bottomButton(
            selected: true,
            buttonHeight: ThemeDimen.buttonHeightNormal,
            buttonWidth: double.infinity,
            onClick: () async {
              showDialog(
                  context: context,
                  builder: (context) {
                    return HLPopupPage(
                      cancelAction: () {
                        RouteService.pop();
                      },
                      okAction: () {
                        context.read<DeletedAccountCubit>().deleted();
                        RouteService.pop();
                      },
                      title: S.current.delete_account_title,
                      message: S.current
                          .txtid_the_account_will_be_permanently_deleted_from_the_system_and_cannot_be_restored,
                      okTitle: S.current.delete_account_action,
                      cancelTitle: S.current.str_cancel,
                    );
                  });
            },
            child: Center(
              child: AutoSizeText(
                S.current.delete_account,
                style: ThemeUtils.getButtonStyle(),
              ),
            ),
          ),
        ),
      );

  Widget _getSettingsHeader(String str) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
      child: AutoSizeText(
        str,
        style: ThemeUtils.getTextStyle(),
      ),
    );
  }

  Widget _accountPhoneSettingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ThemeDimen.paddingNormal),
        _btn(
          onClick: () {
            RouteService.routeGoOnePage(const EditPhonePage());
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
            child: Row(
              children: [
                AutoSizeText(
                  S.current.phone_number,
                  style: ThemeUtils.getTextStyle(),
                  textAlign: TextAlign.center,
                ),
                const Expanded(child: SizedBox()),
                AutoSizeText(
                  PrefAssist.getMyCustomer().phone ?? "",
                  style: ThemeUtils.getTextStyle(color: AppColors.color323232),
                ),
                SizedBox(width: ThemeDimen.paddingSmall),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.color323232,
                  size: ThemeDimen.iconTiny,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ThemeDimen.paddingSmall),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
          child: AutoSizeText(S.current.verify_phone_number_help_secure,
              style: ThemeUtils.getCaptionStyle()),
        ),
      ],
    );
  }

  Widget accountDiscoverSettingWidget() {
    return AccountDiscoverSetting(
      onClick: () {
        final location = PrefAssist.getMyCustomer().location;

        if (location == null) {
          return;
        }
        getAddressFromLatLong(location.lat as double, location.long as double);
      },
    );
  }

  Widget enableGlobalWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ThemeDimen.paddingNormal),
        WidgetGenerator.getRippleButton(
          colorBg: Colors.transparent,
          borderColor: ThemeUtils.borderColor,
          borderRadius: 12.toWidthRatio(),
          buttonHeight: ThemeDimen.buttonHeightNormal,
          buttonWidth: double.infinity,
          onClick: () async {
            if (PrefAssist.getMyCustomer().settings?.global == null) {
              return;
            }
            PrefAssist.getMyCustomer().settings?.global!.isEnabled =
                !PrefAssist.getMyCustomer().settings!.global!.isEnabled;
            await PrefAssist.saveMyCustomer();
            isHaveChanges = true;
            setState(() {});
          },
          child: Row(
            children: [
              SizedBox(width: ThemeDimen.paddingSmall),
              Expanded(
                child: Text(
                  S.current.global,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: ThemeUtils.getTextStyle(),
                ),
              ),
              IgnorePointer(
                  child: HLSwitch(
                value: PrefAssist.getMyCustomer().settings?.global?.isEnabled ??
                    false,
              )),
              const SizedBox(width: 8)
            ],
          ),
        ),
        SizedBox(height: ThemeDimen.paddingSmall),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
          child: Text(
            S.current.txt_settings_global_description,
            style: ThemeUtils.getTextStyle(fontSize: 10.toWidthRatio()),
          ),
        ),
        SizedBox(height: ThemeDimen.paddingNormal),
      ],
    );
  }

  Widget _enableDarkModeWidget() {
    return EnableDarkMode(
      onClick: () async {
        await Future.delayed(const Duration(microseconds: 300), () {
          ThemeUtils.toggleDarkModeSetting();
        });
        Timer(const Duration(milliseconds: 200), () {
          setState(() {});
        });
      },
      isSwitch: ThemeUtils.isDarkModeSetting(),
    );
  }

  Widget slideDistanceRangeWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: ThemeUtils.borderColor, width: 1),
              borderRadius: BorderRadius.circular(12.toWidthRatio())),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.toWidthRatio(),
                  vertical: ThemeDimen.paddingSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      S.current.maximum_distance,
                      style:
                          ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                    ),
                    const Expanded(child: SizedBox()),
                    AutoSizeText(
                      Utils.getMyCustomerDistType() == Const.kDistTypeKm
                          ? S.current.txt_km
                          : S.current.txt_mi,
                      style:
                          ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              SfSliderTheme(
                data: SfSliderThemeData(
                    tooltipBackgroundColor: ThemeUtils.getPrimaryColor(), tooltipTextStyle: ThemeUtils.getTextStyle(color: Colors.white, fontSize: 11.toWidthRatio())),
                child: SfSlider(

                  activeColor: ThemeUtils.getPrimaryColor(),
                  inactiveColor: HexColor("E6E0E9"),
                  enableTooltip: true,
                  shouldAlwaysShowTooltip: true,
                  value: isKm ? _distanceRange : _milValue,
                  onChangeEnd: (value) {
                    setState(() {
                      if (isKm) {
                        _distanceRange = value;
                        _milValue = _distanceRange.kmToMil();
                      } else {
                        _milValue = value;
                        _distanceRange = _milValue.milToKm();
                      }
                    });
                    final range = isKm
                        ? _distanceRange.toInt()
                        : _milValue.milToKm().toInt();
                    final endValue =
                        max(1, min(range, Const.kSettingMaxDistance.toInt()));

                    PrefAssist.getMyCustomer()
                        .settings
                        ?.distancePreference!
                        .range = endValue;
                    isHaveChanges = true;
                  },
                  onChanged: (value) {
                    setState(() {
                      if (isKm) {
                        _distanceRange = value;
                      } else {
                        _milValue = value;
                      }
                    });
                  },
                  min: isKm
                      ? Const.kSettingMinDistance
                      : max(1, Const.kSettingMinDistance.kmToMil().toInt()),
                  max: isKm
                      ? Const.kSettingMaxDistance
                      : Const.kSettingMaxDistance.kmToMil().toInt(),
                  stepSize: 1,
                  tooltipShape: const SfPaddleTooltipShape(),
                ),
              ),
              WidgetGenerator.getRippleButton(
                colorBg: Colors.transparent,
                borderRadius: ThemeDimen.borderRadiusSmall,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: () {
                  if (PrefAssist.getMyCustomer().settings == null) {
                    return;
                  }
                  PrefAssist.getMyCustomer()
                          .settings!
                          .distancePreference!
                          .onlyShowInThis =
                      !PrefAssist.getMyCustomer()
                          .settings!
                          .distancePreference!
                          .onlyShowInThis!;
                  PrefAssist.saveMyCustomer();
                  isHaveChanges = true;
                  setState(() {});
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                  child: Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          S.current.only_show_people_in_this_range,
                          style: ThemeUtils.getTextStyle(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(),
                      IgnorePointer(
                          child: HLSwitch(
                              value: PrefAssist.getMyCustomer()
                                  .settings!
                                  .distancePreference!
                                  .onlyShowInThis!)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget slideAgeRangeWidget() {
    return SlideAgeRange(
      onClick: () {
        if (PrefAssist.getMyCustomer().settings == null) {
          return;
        }
        PrefAssist.getMyCustomer().settings!.agePreference!.onlyShowInThis =
            !PrefAssist.getMyCustomer()!
                .settings!
                .agePreference!
                .onlyShowInThis!;
        PrefAssist.saveMyCustomer();
        isHaveChanges = true;
        setState(() {});
      },
      onChanged: (start, end) {
        if (end - start < 6) {
          return;
        }

        setState(() {
          _startAgeRange = start;
          _endAgeRange = end;
          PrefAssist.getMyCustomer().settings?.agePreference!.min = start;
          PrefAssist.getMyCustomer().settings?.agePreference!.max = end;
          PrefAssist.saveMyCustomer();
          isHaveChanges = true;
        });
      },
      startAgeRange: _startAgeRange,
      endAgeRange: _endAgeRange,
    );
  }

  Widget showMeWidget() {
    return ShowMe(
      onClick: () {
        isHaveChanges = true;
        setState(() {});
      },
    );
  }

  Widget buildControlSettingWidget(String titleControl,
      List<_ControlObject> listControls, IntVs selectedIndex) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ThemeUtils.borderColor, width: 1),
          borderRadius: BorderRadius.circular(12.toWidthRatio())),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(12.toWidthRatio()),
                      child: AutoSizeText(
                        titleControl,
                        style:
                            ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                        maxLines: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 155,)
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const DatingSilverDialogPackage());
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        height: 35,
                        width: 155,
                        child: SvgPicture.asset(
                          AppImages.premium_background,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 155,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SvgPicture.asset(
                                    AppImages.ic_premium_heart,
                                    width: 17,
                                    height: 17,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    S.current.profile_silver_pack_title,
                                    style: ThemeUtils.getTextStyle(
                                      color: Colors.white,
                                      fontSize: 11.toWidthRatio(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Container(height: 10, color: Colors.red,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listControls.length,
            itemBuilder: (context, index) {
              return WidgetGenerator.getRippleButton(
                colorBg: Colors.transparent,
                borderRadius: ThemeDimen.borderRadiusSmall,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: () {
                  // onSave();
                  setState(() {
                    if (titleControl == S.current.control_who_you_see) {
                      PrefAssist.getMyCustomer().plusCtrl!.whoYouSee =
                          index == 0 ? 'default' : 'recently';
                    } else {
                      PrefAssist.getMyCustomer().plusCtrl!.whoSeeYou =
                          index == 0 ? 'everyone' : 'liked';
                    }
                    PrefAssist.saveMyCustomer();
                    listControls[index].isSelected = true;
                    selectedIndex.value = index;
                  });
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20.toWidthRatio()),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ThemeDimen.paddingSmall),
                              Text(
                                listControls[index].title,
                                style: ThemeUtils.getTextStyle(),
                              ),
                              Text(
                                listControls[index].description,
                                style: ThemeUtils.getCaptionStyle(
                                    color: ThemeUtils.isDarkModeSetting() ? HexColor("979798") : AppColors.color323232),
                              ),
                              SizedBox(height: ThemeDimen.paddingSmall),
                            ],
                          ),
                        ),
                        (listControls[index].isSelected &&
                                    selectedIndex.value == index ||
                                _selectedWho(titleControl) == index)
                            ? SvgPicture.asset(
                                AppImages.ic_setting_checked,
                                width: 27,
                                height: 27,
                                colorFilter: ColorFilter.mode(
                                    ThemeUtils.getPrimaryColor(),
                                    BlendMode.srcIn),
                              )
                            : SvgPicture.asset(
                                AppImages.ic_setting_uncheck,
                                width: 27,
                                height: 27,
                              ),
                        SizedBox(width: ThemeDimen.paddingSmall),
                      ],
                    ),
                    (index != listControls.length - 1)
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ThemeDimen.paddingSmall),
                            child: WidgetGenerator.getDivider(),
                          )
                        : const SizedBox(),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _showMeOnCardWidget() {
    return ShowMeOnCard(
      onClick: () {
        if (PrefAssist.getMyCustomer().settings == null) {
          return;
        }
        PrefAssist.getMyCustomer().settings?.incognitoMode =
            !PrefAssist.getMyCustomer().settings!.incognitoMode!;
        PrefAssist.saveMyCustomer();
        isHaveChanges = true;

        setState(() {});
      },
    );
  }

  Widget privacyWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ThemeUtils.borderColor, width: 1),
          borderRadius: BorderRadius.circular(12.toWidthRatio())),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.toWidthRatio()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  S.current.txtid_privacy_policy,
                  style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse(Const.kUrlCookiesPolicy))) {
                Fluttertoast.showToast(
                    msg: S.current.error_when_open_url,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    fontSize: ThemeTextStyle.txtSizeBig);
              }
            },
            child: Row(
              children: [
                SizedBox(width: 20.toWidthRatio()),
                AutoSizeText(
                  S.current.txt_cookie_policy,
                  style: ThemeUtils.getTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: ThemeDimen.paddingNormal),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              color: ThemeUtils.borderColor,
              height: 0.5,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse(Const.kUrlPrivacyPolicy))) {
                Fluttertoast.showToast(
                    msg: S.current.error_when_open_url,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    fontSize: ThemeTextStyle.txtSizeBig);
              }
            },
            child: Row(
              children: [
                SizedBox(width: 20.toWidthRatio()),
                AutoSizeText(
                  S.current.txtid_privacy_policy,
                  style: ThemeUtils.getTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: ThemeDimen.paddingNormal),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              color: ThemeUtils.borderColor,
              height: 0.5,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse(Const.kUrlPrivacyPolicy))) {
                Fluttertoast.showToast(
                    msg: S.current.error_when_open_url,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    fontSize: ThemeTextStyle.txtSizeBig);
              }
            },
            child: Row(
              children: [
                SizedBox(width: 20.toWidthRatio()),
                AutoSizeText(
                  S.current.txt_privacy_preferences,
                  style: ThemeUtils.getTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: ThemeDimen.paddingNormal),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  Widget shareAppWidget() {
    return GestureDetector(
      child: Container(
        height: ThemeDimen.buttonHeightNormal,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: ThemeColor.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal)),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppImages.icShare),
              const SizedBox(
                width: 8,
              ),
              Text(
                "${S.current.share} ${S.current.app_title}",
                style: ThemeUtils.getPopupTitleStyle(
                    fontSize: 14.toWidthRatio(), color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget contactWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ThemeUtils.borderColor, width: 1),
          borderRadius: BorderRadius.circular(12.toWidthRatio())),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.toWidthRatio()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  S.current.txt_contact_us,
                  style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse(Const.kUrlHelpAndSupport))) {
                Fluttertoast.showToast(
                    msg: S.current.error_when_open_url,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    fontSize: ThemeTextStyle.txtSizeBig);
              }
            },
            child: Row(
              children: [
                SizedBox(width: 20.toWidthRatio()),
                AutoSizeText(
                  S.current.txt_help_support,
                  style: ThemeUtils.getTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: ThemeDimen.paddingNormal),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  Widget legalWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ThemeUtils.borderColor, width: 1),
          borderRadius: BorderRadius.circular(12.toWidthRatio())),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.toWidthRatio()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  S.current.txt_legal,
                  style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse(Const.kUrlSafetyCenter))) {
                Fluttertoast.showToast(
                    msg: S.current.error_when_open_url,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    fontSize: ThemeTextStyle.txtSizeBig);
              }
            },
            child: Row(
              children: [
                SizedBox(width: 20.toWidthRatio()),
                AutoSizeText(
                  S.current.txtid_licenses,
                  style: ThemeUtils.getTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: ThemeDimen.paddingNormal),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              color: ThemeUtils.borderColor,
              height: 0.5,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse(Const.kUrlTermOfService))) {
                Fluttertoast.showToast(
                    msg: S.current.error_when_open_url,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    fontSize: ThemeTextStyle.txtSizeBig);
              }
            },
            child: Row(
              children: [
                SizedBox(width: 20.toWidthRatio()),
                AutoSizeText(
                  S.current.txtid_terms_of_service,
                  style: ThemeUtils.getTextStyle(),
                  textAlign: TextAlign.left,
                ),
                SizedBox(width: ThemeDimen.paddingNormal),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }

  Widget _buildBlockContactWidget() {
    return WidgetGenerator.getRippleButton(
      colorBg: ThemeUtils.getShadowColor(),
      borderRadius: ThemeDimen.borderRadiusSmall,
      buttonHeight: ThemeDimen.buttonHeightNormal,
      buttonWidth: double.infinity,
      onClick: () {
        Utils.toast(S.current.coming_soon);
      },
      child: Padding(
        padding: EdgeInsets.all(ThemeDimen.paddingSmall),
        child: GestureDetector(
          onTap: () {
            Utils.toast(S.current.coming_soon);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.current.block_contact, style: ThemeUtils.getTextStyle()),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.color323232,
                size: ThemeDimen.iconTiny,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataUsageWidget() {
    return DataUsage(
      onClick: () {
        isHaveChanges = true;
        RouteService.routeGoOnePage(const DataUsageScreen());
      },
    );
  }

  Widget _buildWebProfileWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ThemeDimen.paddingSmall,
              vertical: ThemeDimen.paddingSmall),
          child: Text(
            S.current.web_profile.toUpperCase(),
            style: ThemeUtils.getTextStyle(color: ThemeUtils.getPrimaryColor()),
          ),
        ),
        WidgetGenerator.getRippleButton(
          colorBg: Colors.transparent,
          borderRadius: ThemeDimen.borderRadiusSmall,
          buttonHeight: ThemeDimen.buttonHeightNormal,
          buttonWidth: double.infinity,
          onClick: () {
            Utils.toast(S.current.coming_soon);
          },
          child: Padding(
            padding: EdgeInsets.all(ThemeDimen.paddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.current.user_name, style: ThemeUtils.getTextStyle()),
                Row(
                  children: [
                    Text(PrefAssist.getMyCustomer().fullname,
                        style: ThemeUtils.getTextStyle()),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.color323232,
                      size: ThemeDimen.iconTiny,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ThemeDimen.paddingSmall,
              vertical: ThemeDimen.paddingSmall),
          child:
              Text(S.current.user_name_notice, style: ThemeUtils.getCaptionStyle()),
        )
      ],
    );
  }

  Widget _buildCommonSettingWidget(String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getSettingsHeader(title),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                color: ThemeUtils.getShadowColor(),
                borderRadius: BorderRadius.all(
                    Radius.circular(ThemeDimen.borderRadiusSmall))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeDimen.paddingSmall,
                    vertical: ThemeDimen.paddingSmall,
                  ),
                  child: Text(
                    title.toUpperCase(),
                    style: ThemeUtils.getTextStyle(
                        color: ThemeUtils.getPrimaryColor()),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                WidgetGenerator.getRippleButton(
                  colorBg: ThemeUtils.getShadowColor(),
                  borderRadius: ThemeDimen.borderRadiusSmall,
                  buttonHeight: ThemeDimen.buttonHeightNormal,
                  buttonWidth: double.infinity,
                  onClick: () {
                    RouteService.routeGoOnePage(const OnlineSettingScreen());
                    isHaveChanges = true;
                  },
                  child: Row(
                    children: [
                      SizedBox(width: ThemeDimen.paddingSmall),
                      Text(S.current.online, style: ThemeUtils.getTextStyle()),
                      const Expanded(child: SizedBox()),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.color323232,
                        size: ThemeDimen.iconTiny,
                      ),
                      SizedBox(width: ThemeDimen.paddingSmall),
                    ],
                  ),
                ),
                WidgetGenerator.getRippleButton(
                  colorBg: ThemeUtils.getShadowColor(),
                  borderRadius: ThemeDimen.borderRadiusSmall,
                  buttonHeight: ThemeDimen.buttonHeightNormal,
                  buttonWidth: double.infinity,
                  onClick: () {
                    RouteService.routeGoOnePage(const ActiveSettingScreen());
                    isHaveChanges = true;
                  },
                  child: Row(
                    children: [
                      SizedBox(width: ThemeDimen.paddingSmall),
                      Text(S.current.recently_active_status,
                          style: ThemeUtils.getTextStyle()),
                      const Expanded(child: SizedBox()),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.color323232,
                        size: ThemeDimen.iconTiny,
                      ),
                      SizedBox(width: ThemeDimen.paddingSmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMenuSettingWidget(List<_MenuSetting> listMenus, String title) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeUtils.getShadowColor(),
        borderRadius:
            BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeDimen.paddingSmall,
              vertical: ThemeDimen.paddingSmall,
            ),
            child: Text(
              title.toUpperCase(),
              style:
                  ThemeUtils.getTextStyle(color: ThemeUtils.getPrimaryColor()),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listMenus.length,
            itemBuilder: (context, index) {
              return WidgetGenerator.getRippleButton(
                colorBg: ThemeUtils.getShadowColor(),
                borderRadius: ThemeDimen.borderRadiusSmall,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: () async {
                  listMenus[index].isSelected = !listMenus[index].isSelected;
                  if (!await listMenus[index].onClick()) {
                    Utils.toast(S.current.coming_soon);
                  }
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                  child: Column(
                    children: [
                      SizedBox(height: ThemeDimen.paddingNormal),
                      Row(
                        children: [
                          Text(
                            listMenus[index].title,
                            style: ThemeUtils.getTextStyle(),
                          ),
                          const Expanded(child: SizedBox()),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.color323232,
                            size: ThemeDimen.iconTiny,
                          ),
                        ],
                      ),
                      SizedBox(height: ThemeDimen.paddingNormal),
                      (index != listMenus.length - 1)
                          ? WidgetGenerator.getDivider()
                          : const SizedBox(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // show distance in
  Widget _showDistanceInWidget() {
    String unitDistType = Utils.getMyCustomerDistType();
    String strDistanceShow = S.current.txt_km;
    if (unitDistType == Const.kDistTypeMiles) {
      strDistanceShow = S.current.txt_mi;
    }
    return Container(
      padding: EdgeInsets.all(ThemeDimen.paddingSmall),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ThemeUtils.borderColor, width: 1),
          borderRadius: BorderRadius.circular(12.toWidthRatio())),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 6.toWidthRatio(),
              ),
              Text(
                S.current.show_distance_in,
                style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
              ),
              const Spacer(),
              Text(strDistanceShow,
                  style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()))
            ],
          ),
          SizedBox(height: ThemeDimen.paddingNormal),
          Row(
            children: [
              SizedBox(width: ThemeDimen.paddingLarge),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (PrefAssist.getMyCustomer().settings == null) {
                      return;
                    }
                    PrefAssist.getMyCustomer()
                        .settings!
                        .distancePreference!
                        .unit = Const.kDistTypeKm;
                    PrefAssist.saveMyCustomer();
                    isHaveChanges = true;
                    isKm = true;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: unitDistType == Const.kDistTypeKm
                            ? ThemeUtils.getPrimaryColor()
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(ThemeDimen.borderRadiusSmall),
                        border: unitDistType == Const.kDistTypeKm
                            ? null
                            : Border.all(
                                color: ThemeUtils.isDarkModeSetting() ? HexColor("979798") : AppColors.color323232, width: 0.5)),
                    width: double.infinity,
                    height: ThemeDimen.buttonHeightNormal,
                    child: Center(
                      child: Text(
                        S.current.txt_km,
                        style: ThemeUtils.getPopupTitleStyle(
                            fontSize: 14.toWidthRatio(),
                            color: unitDistType == Const.kDistTypeKm
                                ? Colors.white
                                : ThemeUtils.isDarkModeSetting() ? HexColor("979798") : AppColors.color323232),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ThemeDimen.paddingSuper),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (PrefAssist.getMyCustomer().settings == null) {
                      return;
                    }

                    PrefAssist.getMyCustomer()
                        .settings!
                        .distancePreference!
                        .unit = Const.kDistTypeMiles;
                    PrefAssist.saveMyCustomer();
                    isHaveChanges = true;
                    isKm = false;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: unitDistType != Const.kDistTypeKm
                            ? ThemeUtils.getPrimaryColor()
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(ThemeDimen.borderRadiusSmall),
                        border: unitDistType != Const.kDistTypeKm
                            ? null
                            : Border.all(
                                color: ThemeUtils.isDarkModeSetting() ? HexColor("979798") : AppColors.color323232, width: 0.5)),
                    width: double.infinity,
                    height: ThemeDimen.buttonHeightNormal,
                    child: Center(
                      child: Text(
                        S.current.txt_mi,
                        style: ThemeUtils.getPopupTitleStyle(
                            fontSize: 14.toWidthRatio(),
                            color: unitDistType != Const.kDistTypeKm
                                ? Colors.white
                                : ThemeUtils.isDarkModeSetting() ? HexColor("979798") : AppColors.color323232),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: ThemeDimen.paddingLarge),
            ],
          ),
          SizedBox(height: ThemeDimen.paddingNormal),
        ],
      ),
    );
  }

  Widget _btn(
          {required void Function() onClick,
          required Widget child,
          double? borderRadius}) =>
      WidgetGenerator.getRippleButton(
        colorBg: ThemeUtils.getShadowColor(),
        borderRadius: borderRadius,
        buttonHeight: ThemeDimen.buttonHeightNormal,
        buttonWidth: double.infinity,
        onClick: onClick,
        child: child,
      );
}

class _ControlObject {
  late String _title;
  late String _description;
  late bool _isSelected;

  _ControlObject(String title, String description, bool isSelected) {
    _title = title;
    _description = description;
    _isSelected = isSelected;
  }

  String get title => _title;

  set title(value) => _title = value;

  String get description => _description;

  set description(value) => _description = value;

  bool get isSelected => _isSelected;

  set isSelected(value) => _isSelected = value;

// List<MatchObject> get listObjects => this._listObjects;

// set listObjects(_listObjects value) => this._listObjects = value;
}

class _MenuSetting {
  late String _title;
  late String _key;
  late bool _isSelected;
  late bool _isExpanded;
  late Future<bool> Function() onClick;

  _MenuSetting(
      String title, String key, bool isSelected, bool isExpand, this.onClick) {
    _title = title;
    _key = key;
    _isSelected = isSelected;
    _isExpanded = isExpand;
  }

  set title(value) => _title = value;

  String get title => _title;

  String get key => _key;

  set key(value) => _key = value;

  bool get isSelected => _isSelected;

  set isSelected(value) => _isSelected = value;

  bool get isExpanded => _isExpanded;

  set isExpanded(value) => _isExpanded = value;
}
