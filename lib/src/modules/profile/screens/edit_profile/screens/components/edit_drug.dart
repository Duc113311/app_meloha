import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/dtos/static_info/static_info.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditDrug extends StatefulWidget {

  const EditDrug({Key? key}) : super(key: key);

  @override
  State<EditDrug> createState() => _EditDrugState();
}

class _EditDrugState extends State<EditDrug> {
  List<StaticInfoDto> listDrugs = StaticInfoManager.shared().drugs;
  String myDrug = PrefAssist.getMyCustomer().profiles?.drug ?? '';

  bool _isCheckedShowDrug =
      PrefAssist.getMyCustomer().profiles?.showCommon?.showDrug ?? false;
  int selectedIndex = -1;
  bool _preferNotSay = false;

  @override
  void initState() {
    _preferNotSay = myDrug.contains(StaticInfoDto.preferNotSay.code);
    selectedIndex = _preferNotSay
        ? listDrugs.length
        : listDrugs.indexWhere((element) => element.code == myDrug);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => RouteService.pop(),
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              PrefAssist.getMyCustomer().profiles?.drug = myDrug;
              PrefAssist.getMyCustomer().profiles?.showCommon?.showDrug =
                  _isCheckedShowDrug;
              await PrefAssist.saveMyCustomer();
              RouteService.pop();
            },
            child: Text(
              S.current.done,
              style: ThemeUtils.getRightButtonStyle(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ThemeDimen.paddingSmall),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppImages.icInfoDrug),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: ThemeDimen.paddingNormal,
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        S.current.how_often_do_you_drug.toCapitalized,
                        style: ThemeUtils.getTitleStyle(),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            ListView.builder(
              reverse: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: listDrugs.length + 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (index == listDrugs.length) {
                          setState(() {
                            _preferNotSay = !_preferNotSay;
                            if (_preferNotSay) {
                              myDrug = StaticInfoDto.preferNotSay.code;
                            } else {
                              myDrug = '';
                            }
                          });
                        } else {
                          setState(() {
                            myDrug = listDrugs[index].code;
                            _preferNotSay = false;
                          });
                        }
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 30,
                                child: AutoSizeText(
                                    index == listDrugs.length
                                        ? S.current.txt_prefer_not_say
                                        : listDrugs[index].value,
                                    style: ThemeUtils.getTextStyle(),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            SizedBox(width: ThemeDimen.paddingNormal),
                            SizedBox(
                                width: ThemeDimen.paddingNormal,
                                height: ThemeDimen.buttonHeightNormal),
                            selectedIndex == index
                                ? SvgPicture.asset(AppImages.icRadioChecked, width: 30, height: 30,)
                                : SvgPicture.asset(AppImages.icRadioOff, width: 30, height: 30,),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                  ],
                );
              },
            ),
            SizedBox(height: ThemeDimen.paddingBig),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: ThemeDimen.paddingNormal),
            child: GestureDetector(
              onTap: () async {
                setState(() => _isCheckedShowDrug = !_isCheckedShowDrug);
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSuper),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _isCheckedShowDrug
                        ? SvgPicture.asset(AppImages.ic_checkbox_selected, width: 25, height: 25,)
                        : SvgPicture.asset(AppImages.ic_checkbox_unselect, width: 25, height: 25,),
                    SizedBox(width: ThemeDimen.paddingTiny),
                    Flexible(
                      child: AutoSizeText(
                        S.current.txt_show_on_my_profile,
                        style: ThemeUtils.getTextStyle(),
                        overflow: TextOverflow.clip,
                        maxLines: 1,
                        minFontSize: 7,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: ThemeDimen.paddingBig,),
        ],
      ),
    );
  }

}
