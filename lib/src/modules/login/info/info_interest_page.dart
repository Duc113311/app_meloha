import 'package:dating_app/main.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/dtos/static_info/static_info.dart';

class InfoInterestPage extends StatefulWidget {
  final PageController pageController;

  const InfoInterestPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<InfoInterestPage> createState() => _InfoInterestPageState();
}

class _InfoInterestPageState extends State<InfoInterestPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  @override
  bool get wantKeepAlive => true;
  TextEditingController controller = TextEditingController();

  List<StaticInfoDto> listInterest = StaticInfoManager.shared().interests;
  List<String> selectedInterests =
      PrefAssist.getMyCustomer().profiles?.interests ?? [];
  List<StaticInfoDto> _searchResults = [];

  bool isActive = false;

  bool get isSearching {
    return controller.text.isNotEmpty;
  }

  bool checkSelectedByIndex(int i) {
    if (isSearching) {
      if (selectedInterests.contains(_searchResults[i].code)) {
        return true;
      }
      return false;
    } else {
      if (selectedInterests.contains(listInterest[i].code)) {
        return true;
      }
      return false;
    }
  }

  @override
  void initState() {
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
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            widget.pageController.previousPage(
                duration:
                    const Duration(milliseconds: ThemeDimen.animMillisDuration),
                curve: Curves.easeIn);
          },
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();

              setState(() {
                selectedInterests = [];
                controller.text = "";
              });
              PrefAssist.getMyCustomer().profiles?.interests = [];
              await PrefAssist.saveMyCustomer();
              widget.pageController.nextPage(
                  duration: const Duration(
                      milliseconds: ThemeDimen.animMillisDuration),
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
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingBig),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
              child: Text(
                S.current.txt_my_interests,
                style: ThemeUtils.getTitleStyle(),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
              child: Text(S.current.let_everyone_know_interest,
                  style: ThemeUtils.getCaptionStyle()),
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
              child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: controller,
                decoration: InputDecoration(
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 25, minWidth: 25
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  prefixIcon: SvgPicture.asset(AppImages.icSearch, colorFilter: const ColorFilter.mode(AppColors.color323232, BlendMode.srcIn),),
                  hintText: S.current.txt_find.toCapitalized,
                  hintStyle: ThemeUtils.getPlaceholderTextStyle(),
                  labelStyle: ThemeUtils.getTextFieldLabelStyle(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ThemeUtils.getTextColor(),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: ThemeUtils.getTextColor(),
                    ),
                  ),
                ),

                onChanged: onSearchTextChanged,
              ),
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
              child: Wrap(
                children: [
                  ...List.generate(
                      controller.text.isNotEmpty
                          ? _searchResults.length
                          : listInterest.length,
                      (index) => _getInterestWidgets(index)),
                  if (isSearching && _searchResults.isEmpty)
                    Center(
                        child: Text(
                      S.current.txt_no_search_result_found,
                      style: TextStyle(
                          color: ThemeUtils.getTextColor(),
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ))
                ],
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
          ],
        ),
      ),
      bottomNavigationBar: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingSmall,
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingLarge),
            child: WidgetGenerator.bottomButton(
              selected: selectedInterests.isNotEmpty,
              isShowRipple: selectedInterests.isNotEmpty ? true : false,
              buttonHeight: ThemeDimen.buttonHeightNormal,
              buttonWidth: double.infinity,
              onClick: onContinueUploadImage,
              child: Center(
                child: Text(
                  "${S.current.str_continue} ( ${selectedInterests.length} / 5 )",
                  style: ThemeUtils.getButtonStyle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSearchTextChanged(String text) async {
    _searchResults.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _searchResults = listInterest
        .where((element) =>
            element.value.toLowerCase().contains(text.toLowerCase()))
        .toList();

    setState(() {});
  }

  Widget _getInterestWidgets(int index) {
    return GestureDetector(
      onTap: () async {
        if (checkSelectedByIndex(index)) {
          setState(() {
            if (isSearching) {
              selectedInterests.remove(_searchResults[index].code);
            } else {
              selectedInterests.remove(listInterest[index].code);
            }
          });
          PrefAssist.getMyCustomer().profiles?.interests = selectedInterests;
          await PrefAssist.saveMyCustomer();
        } else if (selectedInterests.length < 5) {
          setState(() {
            if (isSearching) {
              selectedInterests.add(_searchResults[index].code);
            } else {
              selectedInterests.add(listInterest[index].code);
            }
          });
          PrefAssist.getMyCustomer().profiles?.interests = selectedInterests;
          await PrefAssist.saveMyCustomer();
        }
      },
      child: Padding(
        padding: EdgeInsets.all(ThemeDimen.paddingTiny),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: checkSelectedByIndex(index) ? ThemeUtils.getPrimaryColor() : Colors.transparent,
            border: Border.all(
                color: checkSelectedByIndex(index)
                    ? ThemeUtils.getPrimaryColor()
                    : AppColors.obxColor),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: EdgeInsets.all(ThemeDimen.paddingSmall),
          child: Text(
            textAlign: TextAlign.center,
            isSearching
                ? _searchResults[index].value
                : listInterest[index].value,
            style: ThemeUtils.getCaptionStyle(color: checkSelectedByIndex(index)
                ? Colors.white
                : ThemeColor.caption),
          ),
        ),
      ),
    );
  }

  void onContinueUploadImage() {
    if (selectedInterests.isNotEmpty) {
      PrefAssist.getMyCustomer().profiles?.interests = selectedInterests;
      PrefAssist.saveMyCustomer();
      widget.pageController.nextPage(
          duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
          curve: Curves.easeIn);
    }
  }
}
