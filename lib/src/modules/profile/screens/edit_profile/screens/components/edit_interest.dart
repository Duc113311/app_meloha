import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/requests/api_update_profile_setting.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../domain/dtos/static_info/static_info.dart';
import '../../../../../../utils/pref_assist.dart';


class EditInterest extends StatefulWidget {
  const EditInterest({Key? key}) : super(key: key);

  @override
  State<EditInterest> createState() => _EditInterestState();
}

class _EditInterestState extends State<EditInterest> {
  final controller = ScrollController(initialScrollOffset: 10);
  final TextEditingController _textEditingController = TextEditingController();
  List<StaticInfoDto> listInterest = StaticInfoManager.shared().interests;
  List<String> selectedInterestsCode = List.of(PrefAssist.getMyCustomer().profiles?.interests ?? []);

  //text search => ''
  String searchText = '';

  bool checkSelected(StaticInfoDto interest) {
    if (selectedInterestsCode.contains(interest.code)) {
      return true;
    }
    return false;
  }

  _goBack() async {
    PrefAssist.getMyCustomer().profiles?.interests = selectedInterestsCode;
    await PrefAssist.saveMyCustomer();
    int statusCode = await ApiProfileSetting.updateMyCustomerProfile();
    debugPrint('update customer status code: $statusCode');
    RouteService.pop();
  }

  void scroll() {
    final double end = controller.position.maxScrollExtent;
    controller.animateTo(
        end, duration: const Duration(microseconds: 100), curve: Curves.easeInCubic);
  }

  @override
  Widget build(BuildContext context) {
    List<StaticInfoDto> selectedInterests = [];
    for (var i = 0; i < selectedInterestsCode.length; i++) {
      for (var j = 0; j < listInterest.length; j++) {
        if (selectedInterestsCode[i] == listInterest[j].code) {
          selectedInterests.add(listInterest[j]);
        }
      }
    }
    List<StaticInfoDto> searchedInterests =
        searchText.isEmpty ? listInterest : listInterest.where((interest) => removeDiacritics(interest.value.toLowerCase()).contains(searchText.toLowerCase())).toList();
    return PopScope(
      canPop: false,
      onPopInvoked: (pop) {
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle (
            statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
            statusBarIconBrightness: ThemeUtils.isDarkModeSetting() ? Brightness.light : Brightness.dark,
          ),
          leading: IconButton(
            onPressed: () {
              RouteService.pop();
            },
            icon: const Icon(Icons.close_rounded),
          ),
          actions: [
            TextButton(
              onPressed: _goBack,
              child: Text(
                S.current.done,
                style: ThemeUtils.getRightButtonStyle(),
              ),
            ),
          ],
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                      child: Text(
                        S.current.interests,
                        style: ThemeUtils.getTitleStyle(),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                      child: Text(
                        '${selectedInterestsCode.length} ${S.current.text_of} 5',
                        style: ThemeUtils.getTextStyle(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                    child: Scrollbar(
                      controller: controller,
                      child: selectedInterestsCode.isEmpty
                          ?  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.current.txtid_moresss),
                      )
                          : ListView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        children: selectedInterests.map((tag) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                            child: WidgetGenerator.getRippleButton(
                              colorBg: ThemeUtils.getShadowColor(),
                              borderRadius: ThemeDimen.borderRadiusSmall,
                              //buttonHeight: 50,
                              onClick: () {
                                setState(() {
                                  selectedInterestsCode.remove(tag.code);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(width: 1, color: Colors.red),
                                  borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(child: Text(tag.value, style: ThemeUtils.getTextStyle())),
                                    const SizedBox(width: 2,),
                                    const Center(child: Icon(size: 20, Icons.close_rounded)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall, vertical: ThemeDimen.paddingSmall),
                  decoration: BoxDecoration(
                    color: ThemeUtils.getShadowColor(),
                    borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
                  ),
                  child: TextField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    maxLines: null,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(ThemeDimen.paddingSmall),
                      hintText: S.current.search,
                      hintStyle: ThemeUtils.getPlaceholderTextStyle(),
                    ),
                    style: ThemeUtils.getTextStyle(),
                    controller: _textEditingController,
                    textAlign: TextAlign.left,
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    onChanged: (String text) {
                      setState(() {
                        searchText = removeDiacritics(text);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                  child: Wrap(
                    children: [
                      ...List.generate(searchedInterests.length, (index) => _getInterestWidgets(searchedInterests[index])),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getInterestWidgets(StaticInfoDto interest) {
    return GestureDetector(
      onTap: () {
        if (checkSelected(interest)) {
          setState(() {
            selectedInterestsCode.remove(interest.code);
          });
        } else if (selectedInterestsCode.length < 5) {
          setState(() {
            selectedInterestsCode.add(interest.code);
            if(selectedInterestsCode.length > 2){
              scroll();
            }
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.all(ThemeDimen.paddingSmall),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: checkSelected(interest) ? ThemeUtils.getPrimaryColor() : ThemeUtils.borderColor),
            borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusSmall),
          ),
          padding: EdgeInsets.all(ThemeDimen.paddingSmall),
          child: Text(
            interest.value,
            style: ThemeUtils.getTextStyle(color: checkSelected(interest) ? ThemeUtils.getPrimaryColor() : ThemeUtils.color646465),
          ),
        ),
      ),
    );
  }
}
