import 'package:dating_app/src/components/widgets/dating_button.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/verify/screens/lets_you_verified.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class EnableCamera extends StatefulWidget {
  const EnableCamera({super.key});

  @override
  State<EnableCamera> createState() => _EnableCameraState();
}

class _EnableCameraState extends State<EnableCamera> {
  final String assetSvg = AppImages.icArtCamera;
  bool fireOnce = false;

  @override
  void initState() {
    super.initState();
    parseSVG(assetSvg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle (
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting() ? Brightness.light : Brightness.dark,
        ),
        leading: GestureDetector(
          child: Icon(
            Icons.close_rounded,
            color: ThemeUtils.getTextColor(),
            size: 30,
          ),
          onTap: () {
            RouteService.pop();
          },
        ),
      ),
      body: Container(
        color: ThemeUtils.getScaffoldBackgroundColor(),
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(top: Get.height / 12),
              child: SvgPicture.asset(
                assetSvg,
                height: 152.0,
                width: 150.0,
                allowDrawingOutsideViewBox: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingBig),
              child: Center(
                child: Text(
                  S.current.enable_camera,
                  style: TextStyle(color: ThemeUtils.getTextColor()),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
              child: Center(
                child: Text(
                  S.current.enable_cam_notice,
                  style:
                      ThemeTextStyle.kDatingMediumFontStyle(15, ThemeUtils.getTextColor().withOpacity(0.8)),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          color: ThemeUtils.getScaffoldBackgroundColor(),
          child: SizedBox(
              width: double.infinity,
              height: 40,
              child: DatingButton.darkButton(
                  S.current.enable_camera, true, onEnableCamera))),
    );
  }

  onEnableCamera() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      await RouteService.routeGoOnePage(const LetYouVerified());
      await RouteService.pop();
    }

  }

  Future<void> parseSVG(String assetName) async {
    // final SvgParser parser = SvgParser();
    // final svgString = await rootBundle.loadString(assetName);
    // try {
    //   await parser.parse(svgString, warningsAsErrors: true);
    //   debugPrint('SVG is supported');
    // } catch (e) {
    //   debugPrint('SVG contains unsupported features');
    //   debugPrint(e.toString());
    // }
  }
}
