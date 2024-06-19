import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

class PremiumView extends StatelessWidget {
  const PremiumView({super.key, this.showButton = true});

  final bool showButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: Get.width,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Image.asset(
              AppImages.premiumBanner,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: HexColor("E3C1C1")),
              ),
              const SizedBox(
                width: 16,
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: ThemeUtils.getTextColor()),
              ),
              const SizedBox(
                width: 16,
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: HexColor("E3C1C1")),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          if (showButton)
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
                onClick: () {},
                child: SizedBox(
                  height: ThemeDimen.buttonHeightNormal,
                  child: Center(
                    child: Text(
                      S.current.txt_get_premium,
                      style: ThemeUtils.getButtonStyle(),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
