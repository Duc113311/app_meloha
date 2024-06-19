import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/utils/theme_const.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:dating_app/src/utils/widget_generator.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../generated/l10n.dart';

class DisableLocation extends StatelessWidget {
  const DisableLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          S.current.txtid_enable_location,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: AutoSizeText(
            S.current.txtid_need_to_enable_location_to_use_app,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(ThemeDimen.paddingSuper, ThemeDimen.paddingSmall, ThemeDimen.paddingSuper, ThemeDimen.paddingLarge),
          child: WidgetGenerator.getRippleButton(
            colorBg: ThemeUtils.getPrimaryColor(),
            buttonHeight: ThemeDimen.buttonHeightNormal,
            buttonWidth: double.infinity,
            onClick: () async {
              await openAppSettings();
            },
            child: Center(
              child: Text(
                S.current.txtid_go_to_setting,
                style: ThemeUtils.getTitleStyle(color: ThemeUtils.getTextButtonColor()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
