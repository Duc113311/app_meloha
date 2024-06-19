import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/widgets/switch_dart.dart';
import 'package:dating_app/src/libs/sliders/sliders.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../../../utils/utils.dart';

class SlideDistanceRange extends StatelessWidget {
  const SlideDistanceRange(
      {super.key,
      required this.onClick,
      required this.distanceRange,
      required this.onChanged,
      required this.isKm});

  final VoidCallback onClick;
  final void Function(dynamic) onChanged;
  final double distanceRange;
  final bool isKm;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: ThemeUtils.colorGrey1(), width: 1),
              borderRadius: BorderRadius.circular(12.toWidthRatio())),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.toWidthRatio(),
                  vertical: ThemeDimen.paddingSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      S.current.maximum_distance,
                      style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                    ),
                    const Expanded(child: SizedBox()),
                    AutoSizeText(
                      Utils.getMyCustomerDistType() == Const.kDistTypeKm
                          ? S.current.txt_km
                          : S.current.txt_mi,
                      style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              SfSliderTheme(
                data: SfSliderThemeData(
                    tooltipBackgroundColor: ThemeUtils.getPrimaryColor(), tooltipTextStyle: ThemeUtils.getTextStyle(color: Colors.white, fontSize: 11.toWidthRatio())),
                child: SfSlider(
                  activeColor: ThemeUtils.getPrimaryColor(),
                  inactiveColor: HexColor("E6E0E9"),
                  enableTooltip: true,
                  shouldAlwaysShowTooltip: true,
                  value: isKm ? distanceRange : distanceRange.kmToMil(),
                  onChangeEnd: (value) {

                  },
                  onChanged: (value) {
                    // if (isKm) {
                      onChanged(value);
                    // } else {
                    //   onChanged(value.milToKm());
                    // }
                  },
                  min: isKm ? Const.kSettingMinDistance : Const.kSettingMinDistance.kmToMil(),
                  max: isKm ? Const.kSettingMaxDistance : Const.kSettingMaxDistance.kmToMil(),
                  stepSize: 1,
                  tooltipShape: const SfPaddleTooltipShape(),
                ),
              ),
              WidgetGenerator.getRippleButton(
                colorBg: Colors.transparent,
                borderRadius: ThemeDimen.borderRadiusSmall,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: () {
                  onClick();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                  child: Row(
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          S.current.only_show_people_in_this_range,
                          style: ThemeUtils.getTextStyle(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(),
                      IgnorePointer(
                          child: HLSwitch(
                              value: PrefAssist.getMyCustomer()
                                  .settings!
                                  .distancePreference!
                                  .onlyShowInThis!)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

