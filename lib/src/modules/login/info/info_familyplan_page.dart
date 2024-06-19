import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../main.dart';
import '../../../components/bloc/static_info/static_info_data.dart';
import '../../../domain/dtos/static_info/static_info.dart';
import '../../../general/constants/app_color.dart';
import '../../../general/constants/app_image.dart';
import '../../../utils/pref_assist.dart';
import '../../../utils/utils.dart';

class InfoFamilyPlanPage extends StatefulWidget {
  final PageController pageController;

  const InfoFamilyPlanPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<InfoFamilyPlanPage> createState() => _InfoFamilyPlanPageState();
}

class _InfoFamilyPlanPageState extends State<InfoFamilyPlanPage>
    with WidgetsBindingObserver, RouteAware {
  List<StaticInfoDto> listFamilyPlans = StaticInfoManager.shared().familyPlans;
  String myFamilyPlan =
      PrefAssist.getMyCustomer().profiles?.familyPlan ?? '';

  bool _isCheckedShowFamilyPlan =
      PrefAssist.getMyCustomer().profiles?.showCommon?.showFamilyPlan ??
          false;
  int selectedIndex = -1;
  bool _preferNotSay = false;
  bool isActive = false;

  @override
  void initState() {
    _preferNotSay = myFamilyPlan.contains(StaticInfoDto.preferNotSay.code);
    selectedIndex = _preferNotSay
        ? listFamilyPlans.length
        : listFamilyPlans.indexWhere((element) => element.code == myFamilyPlan);

    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (isActive) {
          callBackChangeLanguage();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);

    setState(() {
      isActive = true;
    });
  }

  @override
  void didPushNext() {
    // Route was pushed onto navigator and is now topmost route.
    isActive = false;
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
    isActive = true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future<void> callBackChangeLanguage() async {
    await StaticInfoManager.shared().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => widget.pageController.previousPage(
              duration:
              const Duration(milliseconds: ThemeDimen.animMillisDuration),
              curve: Curves.easeIn),
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              setState(() {
                _isCheckedShowFamilyPlan = false;
                myFamilyPlan = "";
                _preferNotSay = false;
              });
              PrefAssist.getMyCustomer().profiles?.showCommon.showFamilyPlan = false;
              PrefAssist.getMyCustomer().profiles?.familyPlan = "";
              await PrefAssist.saveMyCustomer();
              widget.pageController.nextPage(
                  duration:
                  const Duration(milliseconds: ThemeDimen.animMillisDuration),
                  curve: Curves.easeIn);
            },
            child: Text(
              S.current.txtid_skip,
              style: ThemeUtils.getRightButtonStyle(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ThemeDimen.paddingBig),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icFamilyPlan, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn)),
                SizedBox(
                  width: ThemeDimen.paddingNormal,
                ),
                Expanded(
                  child: Text(
                    S.current.txt_what_about_the_famyly_plan.toCapitalized,
                    maxLines: 2,
                    style: ThemeUtils.getTitleStyle(),
                  ),
                ),
              ],
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            ListView.builder(
              reverse: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: listFamilyPlans.length + 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (index == listFamilyPlans.length) {
                          setState(() {
                            _preferNotSay = !_preferNotSay;
                            if (_preferNotSay) {
                              myFamilyPlan = StaticInfoDto.preferNotSay.code;
                            } else {
                              myFamilyPlan = '';
                            }
                          });
                        } else {
                          setState(() {
                            myFamilyPlan = listFamilyPlans[index].code;
                            _preferNotSay = false;
                          });
                        }
                        setState(() {
                          selectedIndex = index;
                        });

                        PrefAssist.getMyCustomer().profiles?.familyPlan =
                            myFamilyPlan;
                        await PrefAssist.saveMyCustomer();
                      },
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 30,
                                child: AutoSizeText(
                                    index == listFamilyPlans.length
                                        ? S.current.txt_prefer_not_say
                                        : listFamilyPlans[index].value,
                                    style: ThemeUtils.getTextStyle(),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            SizedBox(width: ThemeDimen.paddingNormal),
                            SizedBox(
                                width: ThemeDimen.paddingNormal,
                                height: ThemeDimen.buttonHeightNormal),
                            selectedIndex == index
                                ? SvgPicture.asset(AppImages.icRadioChecked, width: 30, height: 30,)
                                : SvgPicture.asset(AppImages.icRadioOff, width: 30, height: 30,)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                  ],
                );
              },
            ),
            SizedBox(height: ThemeDimen.paddingBig),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: ThemeDimen.paddingNormal),
            child: GestureDetector(
              onTap: () async {
                setState(
                        () => _isCheckedShowFamilyPlan = !_isCheckedShowFamilyPlan);
                PrefAssist.getMyCustomer()
                    .profiles
                    ?.showCommon
                    ?.showFamilyPlan = _isCheckedShowFamilyPlan;
                await PrefAssist.saveMyCustomer();
              },
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSuper),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _isCheckedShowFamilyPlan
                        ? SvgPicture.asset(AppImages.ic_checkbox_selected, width: 25, height: 25,)
                        : SvgPicture.asset(AppImages.ic_checkbox_unselect, width: 25, height: 25,),
                    SizedBox(width: ThemeDimen.paddingTiny),
                    Flexible(
                      child: AutoSizeText(
                        S.current.txt_show_on_my_profile,
                        style: ThemeUtils.getTextStyle(),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        minFontSize: 7,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingSmall,
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingLarge),
            child: WidgetGenerator.bottomButton(
              selected: selectedIndex != -1,
              isShowRipple: selectedIndex != -1,
              buttonHeight: ThemeDimen.buttonHeightNormal,
              buttonWidth: double.infinity,
              onClick: onContinueHandle,
              child: Center(
                child: Text(
                  S.current.str_continue,
                  style: ThemeUtils.getButtonStyle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onContinueHandle() async {
    if (selectedIndex != -1) {
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
          curve: Curves.easeIn);
    }
  }
}
