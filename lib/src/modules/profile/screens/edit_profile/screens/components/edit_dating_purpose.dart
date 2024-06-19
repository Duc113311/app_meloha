import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:flutter/material.dart';

import '../../../../../../domain/dtos/static_info/static_info.dart';
import '../../../../../../requests/api_update_profile_setting.dart';
import '../../../../../../utils/emoji_convert.dart';
import '../../../../../../utils/utils.dart';

class EditDatingPurpose extends StatefulWidget {
  const EditDatingPurpose({Key? key}) : super(key: key);

  @override
  State<EditDatingPurpose> createState() => _EditDatingPurposeState();
}

class _EditDatingPurposeState extends State<EditDatingPurpose> {

  @override
  Widget build(BuildContext context) {
    List<StaticInfoDto> datingPurposes =
        StaticInfoManager.shared().datingPurposes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: ThemeDimen.paddingBig),
        Text(
          S.current.im_looking_for,
          style: ThemeUtils.getTitleStyle(),
        ),
        SizedBox(height: ThemeDimen.paddingNormal),
        Text(
          S.current.increase_compatibility_by_sharing_yours,
          style: ThemeUtils.getCaptionStyle(),
        ),
        SizedBox(height: ThemeDimen.paddingBig),
        SizedBox(
          child: GridView.count(
            childAspectRatio: 0.8,
            shrinkWrap: true,
            crossAxisCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(datingPurposes.length, (index) {
              return Padding(
                padding: EdgeInsets.all(ThemeDimen.paddingTiny),
                child: WidgetGenerator.getRippleButton(
                  colorBg: ThemeUtils.getShadowColor(),
                  borderRadius: ThemeDimen.borderRadiusNormal,
                  buttonHeight: ThemeDimen.buttonHeightNormal,
                  buttonWidth: double.infinity,
                  onClick: () async {
                    PrefAssist.getMyCustomer().profiles?.datingPurpose =
                        datingPurposes[index].code;

                    await PrefAssist.saveMyCustomer();
                    final status = await ApiProfileSetting.updateMyCustomerProfile();
                    debugPrint('update status: $status');
                    RouteService.pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color:
                            PrefAssist.getMyCustomer().profiles?.datingPurpose ==
                                    datingPurposes[index].code
                                ? ThemeUtils.getPrimaryColor()
                                : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(ThemeDimen.borderRadiusNormal)),
                    ),
                    padding: EdgeInsets.all(ThemeDimen.paddingTiny),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          EmojiUtils.getDatingPurposeEmoji(datingPurposes[index].code),
                          textAlign: TextAlign.center,
                          style: ThemeUtils.getTitleStyle().copyWith(fontSize: 50),
                        ),
                        AutoSizeText(
                          datingPurposes[index].value,
                          textAlign: TextAlign.center,
                          style: ThemeUtils.getTextStyle(fontSize: 14.toWidthRatio(),),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: ThemeDimen.paddingBig),
      ],
    );
  }
}
