import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/widgets/switch_dart.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

class EnableGlobal extends StatelessWidget {
  const EnableGlobal(
      {super.key, required this.onClick, required this.isSwitch});

  final VoidCallback onClick;
  final bool isSwitch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WidgetGenerator.getRippleButton(
          colorBg: ThemeUtils.getShadowColor(),
          borderRadius: ThemeDimen.borderRadiusSmall,
          buttonHeight: ThemeDimen.buttonHeightNormal,
          buttonWidth: double.infinity,
          onClick: () {
            onClick();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
            child: Row(
              children: [
                AutoSizeText(
                  S.current.global,
                  style: ThemeUtils.getTextStyle(),
                ),
                const Expanded(child: SizedBox()),
                IgnorePointer(
                  child: SwitchDart(isSwitch),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ThemeDimen.paddingSmall),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
          child: AutoSizeText(S.current.going_global_will_allow_you,
              style: ThemeUtils.getCaptionStyle()),
        ),
      ],
    );
  }
}
