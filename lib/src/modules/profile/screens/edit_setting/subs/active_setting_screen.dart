import 'package:dating_app/src/components/widgets/switch_dart.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/pref_assist.dart';


class ActiveSettingScreen extends StatefulWidget {
  const ActiveSettingScreen({Key? key}) : super(key: key);

  @override
  State<ActiveSettingScreen> createState() => _ActiveSettingScreenState();
}

class _ActiveSettingScreenState extends State<ActiveSettingScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => RouteService.pop(),
          icon:  Icon(Icons.arrow_back_ios_new_rounded, color:  ThemeUtils.getTextColor(),),
        ),
        title: Text(
          S.current.recently_active_status,
          style:  ThemeUtils.getTextStyle(),
        ),
      ),
      body: SizedBox(
        height: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: ThemeUtils.getShadowColor(),
                borderRadius: BorderRadius.zero,
              ),
              child: WidgetGenerator.getRippleButton(
                colorBg: Colors.transparent,
                borderRadius: ThemeDimen.borderRadiusSmall,
                buttonHeight: ThemeDimen.buttonHeightNormal,
                buttonWidth: double.infinity,
                onClick: () {
                  PrefAssist.getMyCustomer().settings!.showActiveStatus = !PrefAssist.getMyCustomer().settings!.showActiveStatus!;
                  PrefAssist.saveMyCustomer();
                  setState(() {});
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: ThemeDimen.paddingNormal),
                    Expanded(
                      child: Text(
                        S.current.show_online_status,
                        style: ThemeUtils.getTextStyle(),
                      ),
                    ),
                    IgnorePointer(child: SwitchDart(!PrefAssist.getMyCustomer().settings!.showActiveStatus!)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ThemeDimen.paddingNormal),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      S.current.allow_heartlink_members_to_see,
                      style: ThemeUtils.getCaptionStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
