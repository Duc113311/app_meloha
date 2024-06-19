import 'package:dating_app/src/components/widgets/switch_dart.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

class OnlineSettingScreen extends StatefulWidget {
  const OnlineSettingScreen({Key? key}) : super(key: key);

  @override
  State<OnlineSettingScreen> createState() => _OnlineSettingScreenState();
}

class _OnlineSettingScreenState extends State<OnlineSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () => RouteService.pop(),
          child: Ink(
            child: IconButton(
              onPressed: () => RouteService.pop(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ThemeUtils.getTextColor(),
              ),
            ),
          ),
        ),
        title: Text(
          S.current.online,
          style: ThemeUtils.getTextStyle(),
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
                  if (PrefAssist.getMyCustomer().settings == null) {
                    return;
                  }
                  PrefAssist.getMyCustomer().settings?.showOnlineStatus =
                      !PrefAssist.getMyCustomer().settings!.showOnlineStatus!;
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
                    IgnorePointer(
                        child: SwitchDart(!PrefAssist.getMyCustomer()
                            .settings!
                            .showOnlineStatus!)),
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
                      S.current.allow_online_status_to_be_displayed_online,
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
