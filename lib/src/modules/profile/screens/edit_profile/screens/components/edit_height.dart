import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/requests/api_update_profile_setting.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../utils/pref_assist.dart';

class EditHeight extends StatefulWidget {
  const EditHeight({super.key});

  @override
  State<EditHeight> createState() => _EditHeightState();
}

class _EditHeightState extends State<EditHeight> {
  bool _showInfo =
      PrefAssist.getMyCustomer().profiles?.showCommon.showHeight ?? false;

  static const double _itemHeight = 60;
  List<double> items = [];
  int selectedItemIndex = 0;
  List<GlobalKey> _key = [];

  @override
  void initState() {
    double minHeight = 100;
    for (int index = 1; index < 150; index++) {
      items.add(minHeight + index);
    }
    _key = List.generate(items.length, (index) => GlobalKey());

    final height = PrefAssist.getMyCustomer().getHeight;
    if (height != -1) {
      selectedItemIndex =
          items.indexWhere((element) => element.toInt() == height.toInt());
    } else {
      selectedItemIndex = items.indexWhere((element) => element.toInt() == 179);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
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
              PrefAssist.getMyCustomer().profiles?.height =
                  items[selectedItemIndex];
              PrefAssist.getMyCustomer().profiles?.showCommon.showHeight =
                  _showInfo;
              await PrefAssist.saveMyCustomer();
              int statusCode =
                  await ApiProfileSetting.updateMyCustomerProfile();
              debugPrint('update status: $statusCode');
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
            SizedBox(height: ThemeDimen.paddingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.icRuler),
                SizedBox(
                  width: ThemeDimen.paddingNormal,
                ),
                Text(
                  S.current.txt_how_tall_are_you,
                  style: ThemeUtils.getTitleStyle(),
                ),
              ],
            ),
            SizedBox(height: ThemeDimen.paddingSuper),
            Container(
              color: Colors.transparent,
              height: _itemHeight * 5,
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: selectedItemIndex),
                useMagnifier: true,
                itemExtent: _itemHeight,
                onSelectedItemChanged: (int index) async {
                  debugPrint("value: ${items[index]}");

                  setState(() {
                    selectedItemIndex = index;
                  });
                },
                selectionOverlay: SizedBox(
                  height: _itemHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Divider(
                        color: ThemeUtils.getTextColor(),
                        height: 0.5,
                        thickness: 0.5,
                      ),
                      Divider(
                        color: ThemeUtils.getTextColor(),
                        height: 0.5,
                        thickness: 0.5,
                      ),
                    ],
                  ),
                ),
                children: List.generate(items.length, (index) => cellAt(index)),
              ),
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
                  _showInfo = !_showInfo;
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
                    _showInfo
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
          SizedBox(
            height: ThemeDimen.paddingBig,
          ),
        ],
      ),
    );
  }

  Widget cellAt(int index) {
    return index < items.length
        ? Center(
            child: Text("${items[index].toInt().toString()} cm",
                style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio())),
          )
        : const SizedBox();
  }
}
