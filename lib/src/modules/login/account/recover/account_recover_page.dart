import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/login/account/recover/login_email_page.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../domain/services/navigator/route_service.dart';

class AccountRecoverPage extends StatefulWidget {
  const AccountRecoverPage({Key? key}) : super(key: key);

  @override
  State<AccountRecoverPage> createState() => _AccountRecoverPageState();
}

class _AccountRecoverPageState extends State<AccountRecoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => RouteService.pop(),
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: Get.height / 12),
              child: Center(
                child: Image.asset(
                  AppImages.logoAccountRecover,
                  height: Get.height / 8,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height / 12),
              child: Center(
                child: Text(S.current.account_recovery, style: ThemeUtils.getTitleStyle()),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Get.width / 12, top: Get.height / 25, right: Get.width / 12),
              child: Center(
                child: Text(
                  S.current.recover_alert,
                  style: ThemeUtils.getCaptionStyle(),
                  overflow: TextOverflow.clip,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(top: height / 5),
            //   child: DatingButton.darkButton(
            //       S.current.str_continue, true, onContinueLoginEmail),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(ThemeDimen.paddingSuper, ThemeDimen.paddingSmall, ThemeDimen.paddingSuper, ThemeDimen.paddingLarge),
        child: WidgetGenerator.getRippleButton(
          colorBg: ThemeUtils.getPrimaryColor(),
          buttonHeight: ThemeDimen.buttonHeightNormal,
          buttonWidth: double.infinity,
          onClick: onContinueLoginEmail,
          child: SizedBox(
            height: ThemeDimen.buttonHeightNormal,
            child: Center(
              child: Text(
                S.current.login_by_email,
                style: ThemeUtils.getTitleStyle(color: ThemeUtils.getTextButtonColor()),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onContinueLoginEmail() {
    RouteService.routeGoOnePage(const LoginByEmailPage());
  }
}
