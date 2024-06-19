import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/login/register/my_number_page.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/pref_assist.dart';

class EditPhonePage extends StatefulWidget {
  const EditPhonePage({super.key});

  @override
  State<EditPhonePage> createState() => _EditPhonePageState();
}

class _EditPhonePageState extends State<EditPhonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
          onPressed: () {
            RouteService.pop();
          },
        ),
        title: AutoSizeText(S.current.phone_number, style: ThemeUtils.getTitleStyle()),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(S.current.phone_number.toUpperCase(), style: ThemeUtils.getTextStyle()),
          ),
          Padding(
            padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
            child: Container(
              decoration: BoxDecoration(color: AppColors.color323232, borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall))),
              padding: EdgeInsets.all(ThemeDimen.paddingNormal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      PrefAssist.getMyCustomer().phone ?? "",
                      style: Theme.of(Get.context!).textTheme.displaySmall,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                S.current.txtid_your_phone_number_is_verified,
                style: ThemeTextStyle.kDatingMediumFontStyle(12, AppColors.color323232),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
            child: Container(
              decoration: BoxDecoration(color: AppColors.color323232, borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall))),
              padding: EdgeInsets.all(ThemeDimen.paddingNormal),
              child: GestureDetector(
                onTap: () {
                  RouteService.routeGoOnePage( MyNumberPage());
                },
                child: Center(
                  child: AutoSizeText(
                    S.current.txtid_update_my_phone_number,
                    style: ThemeTextStyle.kDatingMediumFontStyle(14, ThemeUtils.getPrimaryColor()),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
