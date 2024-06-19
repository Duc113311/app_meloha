import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../domain/dtos/static_info/static_info.dart';
import '../../../../../general/constants/app_image.dart';
import '../../../../../utils/pref_assist.dart';
import '../../../../../utils/utils.dart';

class ShowMe extends StatelessWidget {
  const ShowMe({super.key, required this.onClick});

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<List<StaticInfoDto>> snapshot) {
        final listShowMeGenders = snapshot.data;

        if (listShowMeGenders == null) {
          return const CircularProgressIndicator();
        }

        return Column(
          children: [
            Container(
              width: double.infinity,
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
                          S.current.show_me,
                          style: ThemeUtils.getTitleStyle(
                              fontSize: 16.toWidthRatio()),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(listShowMeGenders.length, (index) {
                      return WidgetGenerator.getRippleButton(
                        colorBg: Colors.transparent,
                        buttonHeight: ThemeDimen.buttonHeightNormal,
                        buttonWidth: double.infinity,
                        borderRadius: ThemeDimen.borderRadiusSmall,
                        onClick: () async {
                          PrefAssist.getMyCustomer().settings?.genderFilter =
                              listShowMeGenders[index].code;
                          await PrefAssist.saveMyCustomer();
                          onClick();
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 20.toWidthRatio()),
                                AutoSizeText(
                                  listShowMeGenders[index].value,
                                  style: ThemeUtils.getTextStyle(),
                                  textAlign: TextAlign.left,
                                ),
                                const Expanded(child: SizedBox()),
                                listShowMeGenders[index].code ==
                                        PrefAssist.getMyCustomer()
                                            .settings
                                            ?.genderFilter
                                    ? SvgPicture.asset(
                                        AppImages.ic_setting_checked,
                                        width: 27,
                                        height: 27,
                                        colorFilter: ColorFilter.mode(
                                            ThemeUtils.getPrimaryColor(),
                                            BlendMode.srcIn),
                                      )
                                    : SvgPicture.asset(
                                        AppImages.ic_setting_uncheck,
                                        width: 27,
                                        height: 27,
                                      ),
                                SizedBox(width: ThemeDimen.paddingNormal),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (index < listShowMeGenders.length - 1)
                      Padding(
                      padding: EdgeInsets.symmetric(
                      horizontal: 10.toWidthRatio()),
                      child: WidgetGenerator.getDivider())
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ThemeDimen.paddingSmall,
                  vertical: ThemeDimen.paddingSmall),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.current.dating_age_notice,
                  style: ThemeUtils.getTextStyle(fontSize: 10.toWidthRatio()),
                ),
              ),
            ),
          ],
        );
      },
      future: StaticInfoManager.shared().getValues(StaticInfoType.genderFilters),
    );
  }
}
