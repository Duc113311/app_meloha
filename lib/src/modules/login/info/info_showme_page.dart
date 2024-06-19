import 'package:dating_app/main.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/dtos/static_info/static_info.dart';

class InfoShowMePage extends StatefulWidget {
  final PageController pageController;

  const InfoShowMePage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<InfoShowMePage> createState() => _InfoShowMePageState();
}

class _InfoShowMePageState extends State<InfoShowMePage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  @override
  bool get wantKeepAlive => true;

  List<StaticInfoDto> listGendersFilter =
      StaticInfoManager.shared().genderFilters;

  String genderCode = "";
  int indexSelected = -1;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    genderCode = PrefAssist.getMyCustomer().settings?.genderFilter ?? '';
    for (int i = 0; i < listGendersFilter.length; i++) {
      if (listGendersFilter[i].code == genderCode) {
        indexSelected = i;
      }
    }
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
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () => widget.pageController.previousPage(
              duration:
                  const Duration(milliseconds: ThemeDimen.animMillisDuration),
              curve: Curves.easeIn),
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ThemeDimen.paddingSmall),
            Text(
              S.current.show_me,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Container(
              color: Colors.transparent,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listGendersFilter.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: ThemeDimen.paddingNormal),
                    child: AnimatedContainer(
                      duration: const Duration(
                          milliseconds: ThemeDimen.animMillisDuration),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(ThemeDimen.borderRadiusNormal),
                        ),
                        border: Border.all(
                          width: 2,
                          color: index == indexSelected
                              ? ThemeUtils.getPrimaryColor()
                              : ThemeUtils.borderColor,
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            indexSelected = index;
                            PrefAssist.getMyCustomer()
                                .settings
                                ?.genderFilter = listGendersFilter[index].code;
                            PrefAssist.saveMyCustomer();
                          });
                        },
                        title: Center(
                          child: Text(
                            listGendersFilter[index].value,
                            style: index == indexSelected
                                ? ThemeUtils.getPopupTitleStyle(
                                    color: ThemeUtils.getPrimaryColor())
                                : ThemeUtils.getPopupTitleStyle(),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
              colorBg: indexSelected >= 0
                  ? ThemeUtils.getPrimaryColor()
                  : AppColors.color323232,
              buttonHeight: ThemeDimen.buttonHeightNormal,
              buttonWidth: double.infinity,
              onClick: onContinueUniInfo,
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

  void onContinueUniInfo() {
    if ((PrefAssist.getMyCustomer().settings?.genderFilter ?? "").isEmpty) return;
    widget.pageController.nextPage(
        duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
        curve: Curves.easeIn);
  }
}
