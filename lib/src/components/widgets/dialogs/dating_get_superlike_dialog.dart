
import 'package:dating_app/src/components/widgets/dating_button.dart';
import 'package:dating_app/src/components/widgets/dialogs/package_intro_data.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../general/constants/app_color.dart';
import '../../../general/constants/app_image.dart';

class DatingGetSuperLikeDialogPackage extends StatefulWidget {
  const DatingGetSuperLikeDialogPackage({
    Key? key,
  }) : super(key: key);

  @override
  State<DatingGetSuperLikeDialogPackage> createState() => _DatingGetSuperLikeDialogPackageState();
}

class _DatingGetSuperLikeDialogPackageState extends State<DatingGetSuperLikeDialogPackage> {
  showDialogContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 30, bottom: Get.height / 40),
      child: Container(
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.color252525, AppColors.color1E1E1E, AppColors.color151515],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              )
            ]),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingBig),
              child: Center(
                child: Text(
                  S.current.get_platinum_package,
                  style: Theme.of(Get.context!).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            slidePackage(listPackIntros),
            _packageMonthlyPrice(),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
              child: DatingButton.generalButton(S.current.str_continue, Colors.white, Colors.black, () {}),
            ),
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
              child: Center(
                child: Text(
                  S.current.recurring_billing_cancel,
                  style: ThemeTextStyle.kDatingMediumFontStyle(14, Colors.white70),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PackageIntroData> listPackIntros = [
    PackageIntroData(AppImages.icPlatinumPackage, 100, 100, S.current.platinum_pack_1, S.current.platinum_pack_1_content),
    PackageIntroData(AppImages.icPlatinumPackage, 100, 100, S.current.platinum_pack_2, S.current.platinum_pack_2_content),
    PackageIntroData(AppImages.icPlatinumPackage, 100, 100, S.current.platinum_pack_3, S.current.platinum_pack_3_content),
    PackageIntroData(AppImages.icPlatinumPackage, 100, 100, S.current.gold_pack_4, ""),
  ];
  int _currentPageSlider = 0;
  final PageController _pageController = PageController(initialPage: 0);
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
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: _buildPageIndicator()),
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
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
              child: SvgPicture.asset(
                // "assets/svg/ic_platium_package.svg",
                packIntro.icon,
                height: packIntro.iconH,
                width: packIntro.iconW,
                allowDrawingOutsideViewBox: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Text(
                packIntro.title,
                style: Theme.of(Get.context!).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                packIntro.subTitle,
                style: Theme.of(Get.context!).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageviewIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 8,
      width: 8,
      decoration: BoxDecoration(color: isActive ? Colors.white : Colors.white70, borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall))),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < listPackIntros.length; i++) {
      list.add(i == _currentPageSlider ? _pageviewIndicator(true) : _pageviewIndicator(false));
    }
    return list;
  }

  Widget _packageMonthlyPrice() {
    return Padding(
        padding: EdgeInsets.all(ThemeDimen.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(74, 80, 98, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Center(
                          child: Text(
                            "1",
                            style: Theme.of(Get.context!).textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          S.current.months,
                          style: ThemeTextStyle.kDatingMediumFontStyle(13, Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
                        child: Text(
                          "11.99",
                          style: ThemeTextStyle.kDatingMediumFontStyle(13, Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text(
                            "USD/Months",
                            style: ThemeTextStyle.kDatingMediumFontStyle(11, Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
                      //   child: Text(
                      //     "${DatString.strStringSave}50",
                      //     style: DatingTextStyle.kDatingMediumFontStyle(
                      //         14, Colors.red),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(74, 80, 98, 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
                      border: Border.all(color: Colors.white)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Center(
                          child: Text(
                            "6",
                            style: Theme.of(Get.context!).textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          S.current.months,
                          style: ThemeTextStyle.kDatingMediumFontStyle(13, Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
                        child: Text(
                          "5.99",
                          style: ThemeTextStyle.kDatingMediumFontStyle(13, Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "USD/Months",
                          style: ThemeTextStyle.kDatingMediumFontStyle(11, Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
                        child: Text(
                          "${S.current.save} 50%",
                          style: ThemeTextStyle.kDatingMediumFontStyle(11, Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0, right: 3),
                  child: Container(
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
                      ),
                      child: Center(
                        child: Text(
                          S.current.most_popular.toUpperCase(),
                          style: ThemeTextStyle.kDatingMediumFontStyle(8, Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
              ],
            ),
            Stack(
              children: [
                // Padding(
                //   padding: EdgeInsets.only(top: 3.0),
                //   child: Container(
                //       height: 24,
                //       decoration: BoxDecoration(
                //         color: HeartColor.goldColor,
                //         borderRadius:
                //              BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
                //       ),
                //       child: Text(DatString.strMostPopular)),
                // ),
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(74, 80, 98, 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
                    // border: Border.all(color: HeartColor.goldColor)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Center(
                          child: Text(
                            "12",
                            style: Theme.of(Get.context!).textTheme.displaySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          S.current.months,
                          style: ThemeTextStyle.kDatingMediumFontStyle(13, Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
                        child: Text(
                          "3.99",
                          style: ThemeTextStyle.kDatingMediumFontStyle(13, Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "USD/Months",
                          style: ThemeTextStyle.kDatingMediumFontStyle(11, Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
                      //   child: Text(
                      //     "${DatString.strStringSave}50",
                      //     style: DatingTextStyle.kDatingMediumFontStyle(
                      //         14, Colors.red),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), backgroundColor: Colors.transparent, child: showDialogContent(context));
  }
}
