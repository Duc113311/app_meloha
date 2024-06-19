import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/libs/sliders/sliders.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../../../../../components/widgets/switch_dart.dart';
import '../../../../../utils/pref_assist.dart';
import '../../../../../utils/utils.dart';
import 'package:flutter/foundation.dart';

class SlideAgeRange extends StatelessWidget {
  const SlideAgeRange(
      {super.key,
      required this.onClick,
      required this.onChanged,
      required this.startAgeRange,
      required this.endAgeRange});

  final VoidCallback onClick;
  final void Function(int start, int end) onChanged;
  final int startAgeRange;
  final int endAgeRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: ThemeUtils.borderColor, width: 1),
              borderRadius: BorderRadius.circular(12.toWidthRatio())),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12.toWidthRatio()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      S.current.age_range,
                      style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio()),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              SfRangeSliderTheme(
                data: SfRangeSliderThemeData(
                    tooltipBackgroundColor: ThemeUtils.getPrimaryColor(), tooltipTextStyle: ThemeUtils.getTextStyle(color: Colors.white, fontSize: 11.toWidthRatio())),
                child: SfRangeSlider(
                  activeColor: ThemeUtils.getPrimaryColor(),
                  inactiveColor: HexColor("E6E0E9"),
                  enableTooltip: true,
                  shouldAlwaysShowTooltip: true,
                  values: SfRangeValues(
                      startAgeRange
                          .clamp(Const.kSettingMinAgeRange,
                              Const.kSettingMaxAgeRange),
                      endAgeRange
                          .clamp(Const.kSettingMinAgeRange,
                              Const.kSettingMaxAgeRange)),
                  onChanged: (change) {
                    onChanged(change.start.toInt(), change.end.toInt());
                  },
                  min: Const.kSettingMinAgeRange,
                  max: Const.kSettingMaxAgeRange,
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
                                  .agePreference!
                                  .onlyShowInThis!)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
