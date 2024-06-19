import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../main.dart';
import '../../../components/bloc/static_info/static_info_data.dart';
import '../../../domain/dtos/static_info/static_info.dart';
import '../../../general/constants/app_color.dart';
import '../../../general/constants/app_image.dart';
import '../../../utils/pref_assist.dart';
import '../../../utils/utils.dart';

class InfoEthnicityPage extends StatefulWidget {
  final PageController pageController;

  const InfoEthnicityPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<InfoEthnicityPage> createState() => _InfoEthnicityPageState();
}

class _InfoEthnicityPageState extends State<InfoEthnicityPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  @override
  bool get wantKeepAlive => true;
  bool isActive = false;
  bool _isCheckedShowMyInfo =
      PrefAssist.getMyCustomer().profiles?.showCommon?.showEthnicity ?? false;
  List<StaticInfoDto> listEthnicities = StaticInfoManager.shared().ethnicities;
  List<String> myEthnicities =
      PrefAssist.getMyCustomer().profiles?.ethnicitys ?? [];

  bool _preferNotSay = false;

  bool checkSelectedByIndex(int i) {
    if (i == listEthnicities.length) {
      return _preferNotSay;
    }
    if (myEthnicities.contains(listEthnicities[i].code)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _preferNotSay = myEthnicities.contains(StaticInfoDto.preferNotSay.code);

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
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            widget.pageController.previousPage(
                duration:
                    const Duration(milliseconds: ThemeDimen.animMillisDuration),
                curve: Curves.easeIn);
          },
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
                myEthnicities = [];
                _isCheckedShowMyInfo = false;
                _preferNotSay = false;
              });
              PrefAssist.getMyCustomer().profiles?.showCommon.showEthnicity = false;
              PrefAssist.getMyCustomer().profiles?.ethnicitys = [];
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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingBig),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icEthnicityInfo, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn)),
                SizedBox(
                  width: ThemeDimen.paddingNormal,
                ),
                Text(
                  S.current.txt_what_is_your_ethnicity.toCapitalized,
                  style: ThemeUtils.getTitleStyle(),
                ),
              ],
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            SizedBox(height: ThemeDimen.paddingBig),
            ListView.builder(
              reverse: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: listEthnicities.length + 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (index == listEthnicities.length) {
                          setState(() {
                            _preferNotSay = !_preferNotSay;
                            if (_preferNotSay) {
                              myEthnicities = [StaticInfoDto.preferNotSay.code];
                            } else {
                              myEthnicities = [];
                            }
                          });
                        } else {
                          setState(() {
                            myEthnicities.removeWhere((element) => element == StaticInfoDto.preferNotSay.code);
                          });
                          if (checkSelectedByIndex(index)) {
                            setState(() {
                              myEthnicities.remove(listEthnicities[index].code);
                            });
                          } else {
                            setState(() {
                              myEthnicities.add(listEthnicities[index].code);
                              _preferNotSay = false;
                            });
                          }
                        }

                        PrefAssist.getMyCustomer().profiles?.ethnicitys =
                            List.from(myEthnicities);
                        await PrefAssist.saveMyCustomer();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: AutoSizeText(
                                  index == listEthnicities.length
                                      ? S.current.txt_prefer_not_say
                                      : listEthnicities[index].value,
                                  style: ThemeUtils.getTextStyle(),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          checkSelectedByIndex(index)
                              ? SvgPicture.asset(AppImages.ic_checkbox_selected, width: 25, height: 25,)
                              : SvgPicture.asset(AppImages.ic_checkbox_unselect, width: 25, height: 25,),
                        ],
                      ),
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: ThemeDimen.paddingNormal,
                horizontal: ThemeDimen.paddingTiny),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  _isCheckedShowMyInfo = !_isCheckedShowMyInfo;
                });
                PrefAssist.getMyCustomer().profiles?.showCommon?.showEthnicity =
                    _isCheckedShowMyInfo;
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
                    _isCheckedShowMyInfo
                        ? SvgPicture.asset(AppImages.ic_checkbox_selected, width: 25, height: 25,)
                        : SvgPicture.asset(AppImages.ic_checkbox_unselect, width: 25, height: 25,),
                    SizedBox(width: ThemeDimen.paddingTiny),
                    Flexible(
                      child: AutoSizeText(
                        S.current.txt_show_on_my_profile,
                        style: ThemeUtils.getTextStyle(),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        minFontSize: 8,
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
              selected : myEthnicities.isNotEmpty || _preferNotSay,
              isShowRipple: myEthnicities.isNotEmpty || _preferNotSay ? true : false,
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

  void onContinueHandle() {
    if (myEthnicities.isNotEmpty || _preferNotSay) {
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
          curve: Curves.easeIn);
    }
  }
}
