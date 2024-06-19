import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dating_app/src/components/widgets/dialogs/dating_gold_dialog.dart';
import 'package:dating_app/src/components/widgets/dialogs/dating_platium_dialog.dart';
import 'package:dating_app/src/components/widgets/dialogs/dating_silver_dialog.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../general/constants/app_color.dart';


class SlidePremiumPackage extends StatefulWidget {
  const SlidePremiumPackage({Key? key}) : super(key: key);

  @override
  State<SlidePremiumPackage> createState() => _SlidePremiumPackageState();
}

class _SlidePremiumPackageState extends State<SlidePremiumPackage> with WidgetsBindingObserver{
  int _currentPageSlider = 0;



  @override
  void initState() {
    super.initState();
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<_DatingPackage> listPacks = [
      _DatingPackage(0, [AppColors.color141414, AppColors.color585858, AppColors.color141414], SvgIcon(AppImages.icPlatinumPackage, 60, 60),
          S.current.profile_platinum_pack_title, S.current.profile_platinum_pack_content),
      _DatingPackage(1, [AppColors.colorF6A800, AppColors.colorF9CA66, AppColors.colorF6A800], SvgIcon(AppImages.icGoldPackage, 60, 60),
          S.current.profile_gold_pack_title, S.current.profile_gold_pack_content),
      _DatingPackage(2, [AppColors.color39685A, AppColors.colorA1BBB3, AppColors.color39685A], SvgIcon(AppImages.icSliverPackage, 60, 60),
          S.current.profile_silver_pack_title, S.current.profile_silver_pack_content),
      _DatingPackage(3, [AppColors.color00BA83, AppColors.color02E8A3, AppColors.color00BA83], SvgIcon(AppImages.icSuperLike, 60, 60),
          S.current.profile_super_like_pack_title, S.current.profile_super_like_pack_content),
      _DatingPackage(4, [AppColors.color940FD7, AppColors.colorBF5AF2, AppColors.color940FD7], SvgIcon(AppImages.icBoost, 60, 60), S.current.profile_boost_pack_title,
          S.current.profile_boost_pack_content),
      _DatingPackage(5, [AppColors.color0085FF, AppColors.color38B7FF, AppColors.color0085FF], SvgIcon(AppImages.icReadReceipts, 60, 60),
          S.current.profile_read_receipt_pack_title, S.current.profile_read_receipt_pack_content),
    ];
    return Stack(
      children: [
        CarouselSlider(
            items: listPacks.map((p) => buildPackageWidget(p)).toList(),
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 0.85,
              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.5,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPageSlider = index;
                });
              },
              scrollDirection: Axis.horizontal,
            )),
        // Container(
        //   height: 180,
        //   child: PageView(
        //     physics: const ClampingScrollPhysics(),
        //     controller: _pageController,
        //     onPageChanged: (int page) {
        //       setState(() {
        //         _lastChangePageTime = DateTime.now().millisecondsSinceEpoch;
        //         _currentPageSlider = page;
        //       });
        //     },
        //     children: listPacks.map((p) => buildPackageWidget(p)).toList(),
        //   ),
        // ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: ThemeDimen.paddingSmall),
              padding: EdgeInsets.only(bottom: ThemeDimen.paddingSmall),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: WidgetGenerator.getPageViewIndicator(listPacks.length, _currentPageSlider, Colors.white, Colors.white24),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildPackageWidget(_DatingPackage package) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
      child: GestureDetector(
        onTap: () {
          switch (package.id) {
            case 0:
              showDialog(context: Get.context!, builder: (BuildContext context) => const DatingPlatinumDialogPackage());
              break;
            case 1:
              showDialog(context: Get.context!, builder: (BuildContext context) => const DatingGoldDialogPackage());
              break;
            case 2:
              showDialog(context: Get.context!, builder: (BuildContext context) => const DatingSilverDialogPackage());
              break;
            case 3:
            case 4:
            case 5:
              Utils.toast(S.current.coming_soon);
              break;
            default:
              break;
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: package.listColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                package.packIcon.assetsFile,
                height: package.packIcon.height,
                width: package.packIcon.width,
                allowDrawingOutsideViewBox: true,
              ),
              SizedBox(height: ThemeDimen.paddingSmall),
              AutoSizeText(
                package.packTitle,
                style: ThemeUtils.getTitleStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ThemeDimen.paddingSmall),
              AutoSizeText(
                package.packSubTitle,
                style: ThemeUtils.getTextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ThemeDimen.paddingBig),
            ],
          ),
        ),
      ),
    );
  }
}

class _DatingPackage {
  late int _id;
  late List<Color> _listColors;
  late SvgIcon _packIcon;
  late String _packTitle;
  late String _packSubTitle;

  _DatingPackage(int id, List<Color> listColors, SvgIcon packIcon, String packTitle, String packSubTite) {
    _id = id;
    _listColors = listColors;
    _packIcon = packIcon;
    _packTitle = packTitle;
    _packSubTitle = packSubTite;
  }

  get id => _id;

  set id(value) => _id = value;

  get listColors => _listColors;

  set listColors(value) => _listColors = value;

  get packIcon => _packIcon;

  set packIcon(value) => _packIcon = value;

  get packTitle => _packTitle;

  set packTitle(value) => _packTitle = value;

  get packSubTitle => _packSubTitle;

  set packSubTitle(value) => _packSubTitle = value;
}

class SvgIcon {
  late String _assetsFile;
  late double _height;
  late double _width;

  SvgIcon(String assetsFile, double width, double height) {
    _assetsFile = assetsFile;
    _height = height;
    _width = width;
  }

  get assetsFile => _assetsFile;
  set assetsFile(value) => _assetsFile = value;

  get height => _height;
  set height(value) => _height = value;

  get width => _width;

  set width(value) => _width = value;
}
