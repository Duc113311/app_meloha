import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/widgets/switch_dart.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/utils.dart';

class EnableDarkMode extends StatelessWidget {
  const EnableDarkMode({super.key, required this.onClick, required this.isSwitch});

  final VoidCallback onClick;
  final bool isSwitch;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: ThemeUtils.borderColor, width: 1),
          borderRadius: BorderRadius.circular(12.toWidthRatio())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ThemeDimen.paddingTiny),
          GestureDetector(
            onTap: () {
              onClick();
            },
            child: Row(
              children: [
                SizedBox(width: ThemeDimen.paddingSmall),
                Text(
                  S.current.txt_dark_theme,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                ),
                const Spacer(),
                HLSwitch(
                  value: isSwitch, onToggle: (value) {
                    onClick();
                },
                ),
                const SizedBox(width: 8)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
            child: Text(
              S.current.txtid_choose_the_theme_you_like_most,
              style: ThemeUtils.getTextStyle(),
            ),
          ),
          SizedBox(height: ThemeDimen.paddingNormal),
        ],
      ),
    );
  }
}
