import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/services/navigator/route_service.dart';
import '../setting_page.dart';

class EditShowMePage extends StatefulWidget {
  const EditShowMePage({super.key});

  @override
  State<EditShowMePage> createState() => _EditShowMePageState();
}

class _EditShowMePageState extends State<EditShowMePage> {
  List<String> genders = [S.current.man, S.current.women, S.current.everyone];

  int indexSelected = 10;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            RouteService.routeGoOnePage( SettingPage());
          },
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
      ),
      body: Container(
        width: Get.width,
        height: Get.height,
        color: ThemeColor.darkMainColor,
        padding: EdgeInsets.only(top: ThemeDimen.paddingNormal),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(S.current.show_me, style: ThemeUtils.getTextStyle()),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ThemeDimen.paddingSmall),
              child: ListView.builder(
                  itemCount: genders.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: Container(
                        width: Get.width,
                        height: 50,
                        padding: EdgeInsets.all(ThemeDimen.paddingSmall),
                        color: const Color.fromRGBO(74, 80, 98, 1.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              indexSelected = index;
                              PrefAssist.getMyCustomer().settings?.genderFilter = genders[index];
                              PrefAssist.saveMyCustomer();
                            });
                            RouteService.routeGoOnePage(SettingPage());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    genders[index],
                                    style: ThemeTextStyle.kDatingMediumFontStyle(13, Colors.white),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              (PrefAssist.getMyCustomer().settings!.genderFilter!.toLowerCase() == genders[index].toLowerCase())
                                  ? Padding(
                                      padding: EdgeInsets.only(right: 20.0),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(Icons.check_rounded, color: ThemeUtils.getPrimaryColor()),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
