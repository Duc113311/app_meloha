import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/utils.dart';

class AccountDiscoverSetting extends StatelessWidget {
  const AccountDiscoverSetting({super.key, required this.onClick});

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ThemeDimen.paddingNormal),
        WidgetGenerator.getRippleButton(
          colorBg: ThemeUtils.getShadowColor(),
          borderRadius: ThemeDimen.borderRadiusSmall,
          buttonHeight: ThemeDimen.buttonHeightNormal,
          buttonWidth: double.infinity,
          onClick: onClick,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
            child: Row(
              children: [
                AutoSizeText(
                  S.current.location,
                  style: ThemeUtils.getTextStyle(),
                ),
                const Expanded(child: SizedBox()),
                PrefAssist.getMyCustomer().profiles?.address != null &&
                        (PrefAssist.getMyCustomer().profiles?.address ?? '')
                            .isNotEmpty
                    ? Column(
                        children: [
                          AutoSizeText(
                            S.current.my_current_location,
                            style: ThemeUtils.getCaptionStyle().copyWith(
                                fontSize: ThemeTextStyle.txtSizeSmall,
                                color: Colors.blue),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: ThemeDimen.paddingTiny),
                          AutoSizeText(
                            PrefAssist.getMyCustomer().profiles?.address ?? '',
                            style: ThemeUtils.getCaptionStyle().copyWith(
                                fontSize: ThemeTextStyle.txtSizeSmall,
                                color: Colors.blue),
                            textAlign: TextAlign.right,
                          )
                        ],
                      )
                    : AutoSizeText(
                        S.current.my_current_location,
                        style: ThemeUtils.getTextStyle(color: Colors.blue),
                        textAlign: TextAlign.right,
                      ),
                SizedBox(width: ThemeDimen.paddingSmall),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.color323232,
                  size: ThemeDimen.iconTiny,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ThemeDimen.paddingSmall),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
          child: AutoSizeText(
              S.current.change_your_location_to_see_dating_member,
              style: ThemeUtils.getCaptionStyle()),
        ),
      ],
    );
  }
}
