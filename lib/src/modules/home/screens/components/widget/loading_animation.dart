import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/modules/profile/screens/edit_setting/setting_page.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

import '../../../../../general/constants/app_constants.dart';
import '../../../../../general/constants/app_image.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key, required this.isChangeSetting});

  final bool isChangeSetting;

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  var hHeight = Get.height / 1.3;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.center,
          child: Stack(
            children: [
              RippleAnimation(
                color: ThemeUtils.getPrimaryColor(),
                delay: const Duration(milliseconds: 10),
                repeat: true,
                minRadius: 200,
                ripplesCount: 2,
                duration: const Duration(seconds: 3),
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 0.9,
                  heightFactor: 0.75,
                  child: Image.asset(
                    AppImages.appIcon,
                    width: 100 / 375 * AppConstants.width,
                    height: 100 / 667 * AppConstants.height,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.isChangeSetting)
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: Padding(
              padding: EdgeInsets.fromLTRB(ThemeDimen.paddingSuper, ThemeDimen.paddingSmall, ThemeDimen.paddingSuper, ThemeDimen.paddingLarge),
              child: WidgetGenerator.getRippleButton(
                colorBg: ThemeUtils.getPrimaryColor(),
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: () async {
                  await RouteService.routeGoOnePage(SettingPage());
                  // if(result == true){
                  //
                  // }
                },
                child: Center(
                  child: Text(
                    S.current.txtid_go_to_setting,
                    style: ThemeUtils.getTitleStyle(color: ThemeUtils.getTextButtonColor()),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
