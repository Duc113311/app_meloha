import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:dating_app/src/components/widgets/dating_button.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/modules/verify/screens/enable_camera.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../general/constants/app_image.dart';
import '../../../verify/screens/lets_you_verified.dart';

class PhotoVerifyPage extends StatefulWidget {
  const PhotoVerifyPage({Key? key}) : super(key: key);

  @override
  State<PhotoVerifyPage> createState() => _PhotoVerifyPageState();
}

class _PhotoVerifyPageState extends State<PhotoVerifyPage> {
  int step = 0;
  bool canPop = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [HexColor('972aed'), HexColor("0782fe")],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle (
            statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
            statusBarIconBrightness: ThemeUtils.isDarkModeSetting() ? Brightness.light : Brightness.dark,
          ),
          leading: IconButton(
            onPressed: () {
              if (!canPop) {
                return;
              }
              RouteService.pop();
            },
            icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),),
          ),
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 30,
              ),
              SvgPicture.asset(
                AppImages.icVerifiedEnable,
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 5,
              ),
              AutoSizeText(
                S.current.txtid_photo_verified,
                style: ThemeUtils.getTitleStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        body: Center(child: boxVerify()),
      ),
    );
  }

  Widget boxVerify() => Container(
        //height: Get.height / 2.2,
        width: Get.width - 16,
        decoration: BoxDecoration(
          color: ThemeColor.darkMainColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Center(
                child: SvgPicture.asset(
                  AppImages.icVerifiedEnable,
                  width: 60,
                  height: 60,
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
              child: AutoSizeText(
                _getTitle(),
                style: ThemeUtils.getTextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Center(
                child: AutoSizeText(
                  _getDescription(),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  overflow: TextOverflow.clip,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
              child: DatingButton.darkButton(
                S.current.str_continue,
                true,
                () async {
                  if (step >= 1) {

                    final isGranted = await Permission.camera.status.isGranted;

                    if (isGranted) {
                      await RouteService.routeGoOnePage(const LetYouVerified());
                    } else {
                      await RouteService.routeGoOnePage(const EnableCamera());
                    }
                    RouteService.pop();
                  } else {
                    setState(() {
                      step += 1;
                    });
                  }

                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingBig),
              child: InkWell(
                onTap: () {
                  RouteService.pop();
                },
                child: AutoSizeText(
                  S.current.may_be_later.toUpperCase(),
                  style:
                      ThemeTextStyle.kDatingMediumFontStyle(15, Colors.white),
                ),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingBig),
          ],
        ),
      );

  String _getDescription() {
    switch (step) {
      case 0:
        return S.current.get_verified_notice;
      // case 1:
      //   return "You are almost there! If you quit now, you will start over from the beginning next time";
      case 1:
        return S.current.txt_verify_capture_complete_message;
      default: return "";
    }
  }

  String _getTitle() {
    switch (step) {
      case 0:
        return S.current.get_verified;
      // case 1:
      //   return "Are you sure want to quit verification?";
      case 1:
        return S.current.txt_how_it_work;
      default: return "";
    }
  }
}
