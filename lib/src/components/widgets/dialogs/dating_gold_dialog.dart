import 'package:dating_app/src/components/widgets/dialogs/package_intro_data.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../general/constants/app_color.dart';
import '../../../general/constants/app_image.dart';

class DatingGoldDialogPackage extends StatefulWidget {
  const DatingGoldDialogPackage({Key? key}) : super(key: key);

  @override
  State<DatingGoldDialogPackage> createState() => _DatingGoldDialogPackageState();
}

class _DatingGoldDialogPackageState extends State<DatingGoldDialogPackage> {
  List<PackageIntroData> listPackIntros = [
    PackageIntroData(AppImages.icPlatinumPackage, 100, 100, S.current.gold_pack_1, S.current.gold_pack_1_content),
    PackageIntroData(AppImages.icTopPickDialog, 100, 100, S.current.gold_pack_2, S.current.gold_pack_2_content),
    PackageIntroData(AppImages.icLikeDialog, 100, 100, S.current.gold_pack_3, S.current.gold_pack_3_content),
    PackageIntroData(AppImages.icBoostDialog, 100, 100, S.current.gold_pack_4, S.current.gold_pack_4_content),
    PackageIntroData(AppImages.icControlDialog, 100, 100, S.current.gold_pack_5, S.current.gold_pack_5_content),
    PackageIntroData(AppImages.icChoosePeopleDialog, 100, 100, S.current.gold_pack_6, S.current.gold_pack_6_content),
    PackageIntroData(AppImages.icPassportDialog, 100, 100, S.current.gold_pack_7, S.current.gold_pack_7_content),
    PackageIntroData(AppImages.icSuperLikeDialog, 100, 100, S.current.gold_pack_8, S.current.gold_pack_8_content),
    PackageIntroData(AppImages.icRewindDialog, 100, 100, S.current.gold_pack_9, S.current.gold_pack_9_content),
    PackageIntroData(AppImages.icNoAdsDialog, 100, 100, S.current.gold_pack_10, S.current.gold_pack_10_content),
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
          colors: [AppColors.colorF3BA48, AppColors.colorFAE3AD, AppColors.colorFDFDFB],
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
                S.current.get_gold_package,
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
                colorBg: ThemeColor.goldColor,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: () {
                  Utils.toast(S.current.coming_soon);
                  RouteService.pop();
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
                style: ThemeUtils.getTextStyle(color: Colors.black87),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
          ],
        ),
      ),
    );
  }

  Widget slidePackage(List<PackageIntroData> listIntros) {
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
                children: WidgetGenerator.getPageViewIndicator(listPackIntros.length, _currentPageSlider),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget widgetPageItem(PackageIntroData packIntro) {
    return Container(
      margin: EdgeInsets.all(ThemeDimen.paddingNormal),
      child: Center(
        child: Column(
          children: [
            SvgPicture.asset(
              packIntro.icon,
              height: packIntro.iconH,
              width: packIntro.iconW,
              allowDrawingOutsideViewBox: true,
            ),
            SizedBox(height: ThemeDimen.paddingNormal),
            Text(
              packIntro.title,
              style: ThemeUtils.getTextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            Text(
              packIntro.subTitle,
              style: ThemeUtils.getTextStyle(color: Colors.black87),
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
                  color: ThemeColor.goldPackColor,
                  borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "1",
                      style: ThemeUtils.getTitleStyle(fontSize: ThemeTextStyle.txtSizeSuper, color: Colors.black),
                    ),
                    SizedBox(height: ThemeDimen.paddingTiny),
                    Text(
                      S.current.months,
                      style: ThemeUtils.getTextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                    Text(
                      "7.99",
                      style: ThemeUtils.getTextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Center(
                      child: Text(
                        "USD/Months",
                        style: ThemeUtils.getTextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
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
                    color: ThemeColor.goldPackColor,
                    borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
                    border: Border.all(width: 2, color: ThemeColor.goldColor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "6",
                      style: ThemeUtils.getTitleStyle(fontSize: ThemeTextStyle.txtSizeSuper, color: Colors.black),
                    ),
                    SizedBox(height: ThemeDimen.paddingTiny),
                    Text(
                      S.current.months,
                      style: ThemeUtils.getTextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                    Text(
                      "3.99",
                      style: ThemeUtils.getTextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "USD/Months",
                      style: ThemeUtils.getTextStyle(color: Colors.black),
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
                          color: ThemeColor.goldColor,
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
                  color: ThemeColor.goldPackColor,
                  borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
                  // border: Border.all(color: HeartColor.goldColor)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "12",
                      style: ThemeUtils.getTitleStyle(fontSize: ThemeTextStyle.txtSizeSuper, color: Colors.black),
                    ),
                    SizedBox(height: ThemeDimen.paddingTiny),
                    Text(
                      S.current.months,
                      style: ThemeUtils.getTextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                    Text(
                      "2.99",
                      style: ThemeUtils.getTextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "USD/Months",
                      style: ThemeUtils.getTextStyle(color: Colors.black),
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
