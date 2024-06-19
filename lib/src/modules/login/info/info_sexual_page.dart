import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../main.dart';
import '../../../domain/dtos/static_info/static_info.dart';

class InfoSexualPage extends StatefulWidget {
  final PageController pageController;

  const InfoSexualPage(this.pageController, {super.key});

  @override
  State<InfoSexualPage> createState() => _InfoSexualPageState();
}

class _InfoSexualPageState extends State<InfoSexualPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  @override
  bool get wantKeepAlive => true;
  bool isActive = false;
  bool _isCheckedShowMyOrientation =
      PrefAssist.getMyCustomer().profiles?.showCommon?.showSexual ?? false;
  List<StaticInfoDto> listOrientation = StaticInfoManager.shared().sexuals;
  List<String> mySexuals =
      PrefAssist.getMyCustomer().profiles?.orientationSexuals ?? [];
  bool _preferNotSay = false;

  bool checkSelectedByIndex(int i) {
    if (i == listOrientation.length) {
      return _preferNotSay;
    }
    if (mySexuals.contains(listOrientation[i].code)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _preferNotSay = mySexuals.contains(StaticInfoDto.preferNotSay.code);
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
                mySexuals = [];
                _isCheckedShowMyOrientation = false;
                _preferNotSay = false;
              });
              PrefAssist.getMyCustomer().profiles?.showCommon.showSexual = false;
              PrefAssist.getMyCustomer().profiles?.orientationSexuals = [];
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingBig),
            Text(
              S.current.my_sexual_oriental_is,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            Text(
              S.current.select_up_to_3,
              style: ThemeUtils.getCaptionStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            ListView.builder(
              reverse: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: listOrientation.length + 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (index == listOrientation.length) {
                          setState(() {
                            _preferNotSay = !_preferNotSay;
                            if (_preferNotSay) {
                              mySexuals = [StaticInfoDto.preferNotSay.code];
                            } else {
                              mySexuals = [];
                            }
                          });
                        } else {
                          setState(() {
                            mySexuals.removeWhere((element) => element == StaticInfoDto.preferNotSay.code);
                          });
                          if (checkSelectedByIndex(index)) {
                            setState(() {
                              mySexuals.remove(listOrientation[index].code);
                            });
                          } else if (mySexuals.length < 3) {
                            setState(() {
                              mySexuals.add(listOrientation[index].code);
                              _preferNotSay = false;
                            });
                          }
                        }

                        PrefAssist.getMyCustomer()
                            .profiles
                            ?.orientationSexuals = List.from(mySexuals);
                        await PrefAssist.saveMyCustomer();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: AutoSizeText(index == listOrientation.length ? S.current.txt_prefer_not_say : listOrientation[index].value,
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
                  _isCheckedShowMyOrientation = !_isCheckedShowMyOrientation;
                });
                PrefAssist.getMyCustomer().profiles?.showCommon?.showSexual =
                    _isCheckedShowMyOrientation;
                await PrefAssist.saveMyCustomer();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSuper),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _isCheckedShowMyOrientation
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
              selected: mySexuals.isNotEmpty || _preferNotSay,
              isShowRipple: mySexuals.isNotEmpty || _preferNotSay ? true : false,
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
    if (mySexuals.isNotEmpty || _preferNotSay) {
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
          curve: Curves.easeIn);
    }
  }
}
