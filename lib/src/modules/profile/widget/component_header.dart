import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:flutter/material.dart';

import '../../../utils/theme_const.dart';
import '../../../utils/theme_notifier.dart';

class ComponentHeader extends StatelessWidget {
  const ComponentHeader({super.key, required this.title, this.percent = 0});
  final String title;
  final int? percent;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: ThemeDimen.paddingNormal),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: ThemeUtils.getHeaderStyle()),
            Text(
              percent! > 0 ? '+$percent%' : '',
              style: ThemeUtils.getTextStyle(
                  color: ThemeUtils.headerInfoColor),
            )
          ],
        ),
        SizedBox(height: ThemeDimen.paddingSmall),
      ],
    );
  }
}
