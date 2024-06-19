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

class EditEthnicity extends StatefulWidget {
  const EditEthnicity({Key? key}) : super(key: key);

  @override
  State<EditEthnicity> createState() => _EditEthnicityState();
}

class _EditEthnicityState extends State<EditEthnicity> {
  @override
  bool _isCheckedShowMyInfo =
      PrefAssist.getMyCustomer().profiles?.showCommon?.showEthnicity ?? false;
  List<StaticInfoDto> listEthnicities = StaticInfoManager.shared().ethnicities;
  List<String> myEthnicities =
      PrefAssist.getMyCustomer().profiles?.ethnicitys ?? [];

  bool _preferNotSay = false;

  bool checkSelectedByIndex(int i) {
    if (i == listEthnicities.length) {
      return _preferNotSay;
    }
    if (myEthnicities.contains(listEthnicities[i].code)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _preferNotSay = myEthnicities.contains(StaticInfoDto.preferNotSay.code);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            RouteService.pop();
          },
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
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
              PrefAssist.getMyCustomer().profiles?.showCommon?.showEthnicity =
                  _isCheckedShowMyInfo;
              PrefAssist.getMyCustomer().profiles?.ethnicitys =
                  List.from(myEthnicities);

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
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icEthnicityInfo),
                SizedBox(
                  width: ThemeDimen.paddingNormal,
                ),
                Text(
                  S.current.txt_what_is_your_ethnicity.toCapitalized,
                  style: TextStyle(
                      color: ThemeUtils.getTextColor(),
                      fontWeight: FontWeight.bold,
                      fontFamily: ThemeNotifier.fontBold,
                      fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            SizedBox(height: ThemeDimen.paddingBig),
            ListView.builder(
              reverse: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: listEthnicities.length + 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (index == listEthnicities.length) {
                          setState(() {
                            _preferNotSay = !_preferNotSay;
                            if (_preferNotSay) {
                              myEthnicities = [StaticInfoDto.preferNotSay.code];
                            } else {
                              myEthnicities = [];
                            }
                          });
                        } else {
                          setState(() {
                            myEthnicities.removeWhere((element) =>
                                element == StaticInfoDto.preferNotSay.code);
                          });
                          if (checkSelectedByIndex(index)) {
                            setState(() {
                              myEthnicities.remove(listEthnicities[index].code);
                            });
                          } else {
                            setState(() {
                              myEthnicities.add(listEthnicities[index].code);
                              _preferNotSay = false;
                            });
                          }
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 30,
                              child: AutoSizeText(
                                  index == listEthnicities.length
                                      ? S.current.txt_prefer_not_say
                                      : listEthnicities[index].value,
                                  style: ThemeUtils.getTextStyle(),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          checkSelectedByIndex(index)
                              ? SvgPicture.asset(
                                  AppImages.ic_checkbox_selected,
                                  width: 25,
                                  height: 25,
                                )
                              : SvgPicture.asset(
                                  AppImages.ic_checkbox_unselect,
                                  width: 25,
                                  height: 25,
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: ThemeDimen.paddingNormal),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: ThemeDimen.paddingNormal,
                horizontal: ThemeDimen.paddingTiny),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  _isCheckedShowMyInfo = !_isCheckedShowMyInfo;
                });
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSuper),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _isCheckedShowMyInfo
                        ? SvgPicture.asset(
                            AppImages.ic_checkbox_selected,
                            width: 25,
                            height: 25,
                          )
                        : SvgPicture.asset(
                            AppImages.ic_checkbox_unselect,
                            width: 25,
                            height: 25,
                          ),
                    SizedBox(width: ThemeDimen.paddingTiny),
                    Flexible(
                      child: AutoSizeText(
                        S.current.txt_show_on_my_profile,
                        style: ThemeUtils.getTextStyle(),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        minFontSize: 8,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: ThemeDimen.paddingBig,
          ),
        ],
      ),
    );
  }
}
