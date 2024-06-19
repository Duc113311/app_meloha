import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../general/constants/app_color.dart';
import '../../../general/constants/app_image.dart';

class DatingPlatinumDialogPackage extends StatefulWidget {
  const DatingPlatinumDialogPackage({Key? key}) : super(key: key);

  @override
  State<DatingPlatinumDialogPackage> createState() => _DatingPlatinumDialogPackageState();
}

class _DatingPlatinumDialogPackageState extends State<DatingPlatinumDialogPackage> {
  List<_PackageIntro> listPackIntros = [
    _PackageIntro(AppImages.icPlatinumPackage, 100, 100, S.current.platinum_pack_1, S.current.platinum_pack_1_content),
    _PackageIntro(AppImages.icPlatinumPackage, 100, 100, S.current.platinum_pack_2, S.current.platinum_pack_2_content),
    _PackageIntro(AppImages.icPlatinumPackage, 100, 100, S.current.platinum_pack_3, S.current.platinum_pack_3_content),
    _PackageIntro(AppImages.icPlatinumPackage, 100, 100, "", S.current.platinum_pack_4_content),
  ];
  int _currentPageSlider = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall, vertical: ThemeDimen.paddingSuper),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal)),
      backgroundColor: Colors.transparent,
      child: showDialogContent(context),
    );
  }

  showDialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.color252525, AppColors.color1E1E1E, AppColors.color151515],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
        ),
        borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ThemeDimen.paddingBig),
            Center(
              child: Text(
                S.current.get_platinum_package,
                style: ThemeUtils.getTitleStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            slidePackage(listPackIntros),
            _packageMonthlyPrice(),
            SizedBox(height: ThemeDimen.paddingSuper),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
              child: WidgetGenerator.getRippleButton(
                colorBg: Colors.white,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: () {
                  Utils.toast(S.current.coming_soon);
                },
                child: Center(
                  child: Text(
                    S.current.str_continue,
                    style: ThemeUtils.getButtonStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Center(
              child: Text(
                S.current.recurring_billing_cancel,
                style: ThemeUtils.getTextStyle(color: AppColors.color323232),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
          ],
        ),
      ),
    );
  }

  Widget slidePackage(List<_PackageIntro> listIntros) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(ThemeDimen.paddingSmall),
          child: Container(
            height: Get.height / 3.5,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: PageView(
              physics: const ClampingScrollPhysics(),
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPageSlider = page;
                });
              },
              children: listIntros.map((p) => widgetPageItem(p)).toList(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(top: Get.height / 4),
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: WidgetGenerator.getPageViewIndicator(listPackIntros.length, _currentPageSlider, Colors.white, Colors.white24),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget widgetPageItem(_PackageIntro packIntro) {
    return Container(
      margin: EdgeInsets.all(ThemeDimen.paddingNormal),
      child: Center(
        child: Column(
          children: [
            SvgPicture.asset(
              packIntro._icon,
              height: packIntro.iconH,
              width: packIntro.iconW,
              allowDrawingOutsideViewBox: true,
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Text(
              packIntro.title,
              style: ThemeUtils.getTextStyle().copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            Text(
              packIntro.subTitle,
              style: ThemeUtils.getTextStyle(color: AppColors.color323232),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _packageMonthlyPrice() {
    return Row(
      children: [
        SizedBox(width: ThemeDimen.paddingTiny),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingTiny, vertical: ThemeDimen.paddingSmall),
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.color323232,
                  borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "1",
                      style: ThemeUtils.getTitleStyle(
                        color: AppColors.color7B7B7B,
                        fontSize: ThemeTextStyle.txtSizeSuper,
                      ),
                    ),
                    SizedBox(height: ThemeDimen.paddingTiny),
                    Text(
                      S.current.months,
                      style: ThemeUtils.getTextStyle(
                        color: AppColors.color7B7B7B,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                    Text(
                      "11.99",
                      style: ThemeUtils.getTextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Center(
                        child: Text(
                          "USD/Months",
                          style: ThemeUtils.getTextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
                      child: Text(
                        "",
                        style: ThemeUtils.getTextStyle(color: ThemeUtils.getPrimaryColor()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingTiny, vertical: ThemeDimen.paddingSmall),
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color:  AppColors.color323232,
                  borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
                  border: Border.all(width: 2, color: Colors.white),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "6",
                      style: ThemeUtils.getTitleStyle(
                        color: Colors.white,
                        fontSize: ThemeTextStyle.txtSizeSuper,
                      ),
                    ),
                    SizedBox(height: ThemeDimen.paddingTiny),
                    Text(
                      S.current.months,
                      style: ThemeUtils.getTextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                    Text(
                      "5.99",
                      style: ThemeUtils.getTextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "USD/Months",
                      style: ThemeUtils.getTextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
                      child: Text(
                        "${S.current.save} 50%",
                        style: ThemeUtils.getTextStyle(color: ThemeUtils.getPrimaryColor()),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingTiny, vertical: ThemeDimen.paddingTiny),
                      child: Text(
                        S.current.most_popular.toUpperCase(),
                        style: ThemeUtils.getTextStyle(fontSize: ThemeTextStyle.txtSizeSmall, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingTiny, vertical: ThemeDimen.paddingSmall),
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.color323232,
                  borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
                  // border: Border.all(color: HeartColor.goldColor)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "12",
                      style: ThemeUtils.getTitleStyle(
                        fontSize: ThemeTextStyle.txtSizeSuper,
                        color: AppColors.color7B7B7B,
                      ),
                    ),
                    SizedBox(height: ThemeDimen.paddingTiny),
                    Text(
                      S.current.months,
                      style: ThemeUtils.getTextStyle(
                        color: AppColors.color7B7B7B,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                    Text(
                      "3.99",
                      style: ThemeUtils.getTextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "USD/Months",
                      style: ThemeUtils.getTextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
                      child: Text(
                        "${S.current.save} 66%",
                        style: ThemeUtils.getTextStyle(color: ThemeUtils.getPrimaryColor()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: ThemeDimen.paddingTiny),
      ],
    );
  }
}

class _PackageIntro {
  late String _icon;
  late double _iconH;
  late double _iconW;
  late String _title;
  late String _subTitle;

  _PackageIntro(String icon, double iconH, double iconW, String title, String subTitle) {
    _icon = icon;
    _iconH = iconH;
    _iconW = iconW;
    _title = title;
    _subTitle = subTitle;
  }

  get icon => _icon;

  set icon(value) => _icon = value;

  get iconH => _iconH;

  set iconH(value) => _iconH = value;

  get iconW => _iconW;

  set iconW(value) => _iconW = value;

  get title => _title;

  set title(value) => _title = value;

  get subTitle => _subTitle;

  set subTitle(value) => _subTitle = value;
}
