import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../general/constants/app_color.dart';
import '../../../utils/pref_assist.dart';
import '../../../utils/utils.dart';

class InfoHeightPage extends StatefulWidget {
  final PageController pageController;

  const InfoHeightPage(this.pageController, {super.key});

  @override
  State<InfoHeightPage> createState() => _InfoHeightPageState();
}

class _InfoHeightPageState extends State<InfoHeightPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  bool _showInfo =
      PrefAssist.getMyCustomer().profiles?.showCommon.showHeight ?? false;

  static const double _itemHeight = 60;
  List<double> items = [];
  int selectedItemIndex = 0;
  List<GlobalKey> _key = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    double minHeight = 100;
    for (int index = 1; index < 150; index++) {
      items.add(minHeight + index);
    }
    _key = List.generate(items.length, (index) => GlobalKey());
    setupHeight();

    super.initState();
  }

  void setupHeight() {
    final height = PrefAssist.getMyCustomer().getHeight;
    if (height != -1) {
      selectedItemIndex =
          items.indexWhere((element) => element.toInt() == height.toInt());
    } else {
      selectedItemIndex = items.indexWhere((element) => element.toInt() == 179);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
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
              PrefAssist.getMyCustomer().profiles?.showCommon.showHeight =
                  false;
              PrefAssist.getMyCustomer().profiles?.height = -1;
              await PrefAssist.saveMyCustomer();

              setState(() {
                _showInfo = false;
                selectedItemIndex = 0;
                setupHeight();
              });

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
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingBig),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icRuler,
                    colorFilter: ColorFilter.mode(
                        ThemeUtils.getTextColor(), BlendMode.srcIn)),
                SizedBox(
                  width: ThemeDimen.paddingNormal,
                ),
                Text(
                  S.current.txt_how_tall_are_you,
                  style: ThemeUtils.getTitleStyle(),
                ),
              ],
            ),
            SizedBox(height: ThemeDimen.paddingSuper),
            Container(
              color: Colors.transparent,
              height: _itemHeight * 5,
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: selectedItemIndex),
                useMagnifier: true,
                itemExtent: _itemHeight,
                onSelectedItemChanged: (int index) async {
                  debugPrint("value: ${items[index]}");

                  setState(() {
                    selectedItemIndex = index;
                  });
                  PrefAssist.getMyCustomer().profiles?.height = items[index];
                  await PrefAssist.saveMyCustomer();
                },
                selectionOverlay: SizedBox(
                  height: _itemHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Divider(
                        color: ThemeUtils.getTextColor(),
                        height: 0.5,
                        thickness: 0.5,
                      ),
                      Divider(
                        color: ThemeUtils.getTextColor(),
                        height: 0.5,
                        thickness: 0.5,
                      ),
                    ],
                  ),
                ),
                children: List.generate(items.length, (index) => cellAt(index)),
              ),
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
                  _showInfo = !_showInfo;
                });
                PrefAssist.getMyCustomer().profiles?.showCommon.showHeight =
                    _showInfo;
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
                    _showInfo
                        ? SvgPicture.asset(
                            AppImages.ic_checkbox_selected,
                            width: 25,
                            height: 25,
                          )
                        : SvgPicture.asset(
                            AppImages.ic_checkbox_unselect,
                            width: 25,
                            height: 25,
                          ),
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
              selected: true,
              isShowRipple: true,
              buttonHeight: ThemeDimen.buttonHeightNormal,
              buttonWidth: double.infinity,
              onClick: () {
                widget.pageController.nextPage(
                    duration: const Duration(
                        milliseconds: ThemeDimen.animMillisDuration),
                    curve: Curves.easeIn);
              },
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

  Widget cellAt(int index) {
    return index < items.length
        ? Center(
            child: Text("${items[index].toInt().toString()} cm",
                style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio())),
          )
        : const SizedBox();
  }
}
