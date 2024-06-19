import 'dart:ffi';

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


class EditSexualPage extends StatefulWidget {
  const EditSexualPage({super.key});

  @override
  State<EditSexualPage> createState() => _EditSexualPageState();
}

class _EditSexualPageState extends State<EditSexualPage> {

  bool isActive = false;
  bool _isCheckedShowMyOrientation =
      PrefAssist.getMyCustomer().profiles?.showCommon?.showSexual ?? false;
  List<StaticInfoDto> listOrientation = StaticInfoManager.shared().sexuals;
  List<String> mySexuals = [];
  bool _preferNotSay = false;

  bool checkSelectedByIndex(int i) {
    if (i == listOrientation.length) {
      return _preferNotSay;
    }
    if (mySexuals.contains(listOrientation[i].code)) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    final list = PrefAssist.getMyCustomer().profiles?.orientationSexuals ?? [];
    mySexuals = [...list];
    _preferNotSay = mySexuals.contains(StaticInfoDto.preferNotSay.code);
    super.initState();
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
              PrefAssist.getMyCustomer().profiles?.showCommon?.showSexual =
                  _isCheckedShowMyOrientation;

              PrefAssist.getMyCustomer().profiles?.orientationSexuals = mySexuals;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingBig),
            Text(
              S.current.my_sexual_oriental_is,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            Text(
              S.current.select_up_to_3,
              style: ThemeUtils.getCaptionStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            ListView.builder(
              reverse: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: listOrientation.length + 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (index == listOrientation.length) {
                          setState(() {
                            _preferNotSay = !_preferNotSay;
                            if (_preferNotSay) {
                              mySexuals = [StaticInfoDto.preferNotSay.code];
                            } else {
                              mySexuals = [];
                            }
                          });
                        } else {
                          setState(() {
                            mySexuals.removeWhere((element) => element == StaticInfoDto.preferNotSay.code);
                          });
                          if (checkSelectedByIndex(index)) {
                            setState(() {
                              mySexuals.remove(listOrientation[index].code);
                            });
                          } else if (mySexuals.length < 3) {
                            setState(() {
                              mySexuals.add(listOrientation[index].code);
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
                              child: AutoSizeText(index == listOrientation.length ? S.current.txt_prefer_not_say : listOrientation[index].value,
                                  style: ThemeUtils.getTextStyle(),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          checkSelectedByIndex(index)
                              ? SvgPicture.asset(AppImages.ic_checkbox_selected, width: 25, height: 25,)
                              : SvgPicture.asset(AppImages.ic_checkbox_unselect, width: 25, height: 25,),
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
                  _isCheckedShowMyOrientation = !_isCheckedShowMyOrientation;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSuper),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _isCheckedShowMyOrientation
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
        ],
      ),
    );
  }

  void onContinueHandle() {
    if (mySexuals.isNotEmpty || _preferNotSay) {

    }
  }
}
