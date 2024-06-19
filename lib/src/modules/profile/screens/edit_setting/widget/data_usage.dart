import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/utils.dart';

class DataUsage extends StatelessWidget {
  const DataUsage({super.key, required this.onClick});
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ThemeDimen.paddingSmall,
              vertical: ThemeDimen.paddingSmall),
          child: Text(
            S.current.data_usage.toUpperCase(),
            style: ThemeUtils.getTextStyle(color: ThemeUtils.getPrimaryColor()),
          ),
        ),
        WidgetGenerator.getRippleButton(
          colorBg: ThemeUtils.getShadowColor(),
          borderRadius: ThemeDimen.borderRadiusSmall,
          buttonHeight: ThemeDimen.buttonHeightNormal,
          buttonWidth: double.infinity,
          onClick: () {
           onClick();
          },
          child: Padding(
            padding: EdgeInsets.all(ThemeDimen.paddingSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.current.autoplay_videos,
                    style: ThemeUtils.getTextStyle()),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.color323232,
                  size: ThemeDimen.iconTiny,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
