import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/requests/api_update_profile_setting.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../domain/dtos/static_info/static_info.dart';


class EditLanguages extends StatefulWidget {
  const EditLanguages({Key? key, required this.selectedLanguagesCode}) : super(key: key);
  final List<String> selectedLanguagesCode;

  @override
  State<EditLanguages> createState() => _EditLanguageState();
}

class _EditLanguageState extends State<EditLanguages> {
  final controller = ScrollController(initialScrollOffset: 0);
  List<StaticInfoDto> listLanguage = StaticInfoManager.shared().languages;
  String searchText = '';
  final TextEditingController _textEditingController = TextEditingController();
  List<String> selectedLanguagesCode = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedLanguagesCode = widget.selectedLanguagesCode;
  }

  bool checkSelected(StaticInfoDto language) {
    if (selectedLanguagesCode.contains(language.code)) {
      return true;
    }
    return false;
  }

  _goBack() async {
    PrefAssist.getMyCustomer().profiles?.languages = selectedLanguagesCode;
    await PrefAssist.saveMyCustomer();
    int statusCode = await ApiProfileSetting.updateMyCustomerProfile();
    debugPrint('update status: $statusCode');
    RouteService.pop(result: true);
  }

  void scroll() {
    final double end = controller.position.maxScrollExtent;
    controller.animateTo(
        end, duration: const Duration(microseconds: 100), curve: Curves.easeInCubic);
  }

  @override
  Widget build(BuildContext context) {
    List<StaticInfoDto> selectedLanguages = [];
    for (var i = 0; i < selectedLanguagesCode.length; i++) {
      for (var j = 0; j < listLanguage.length; j++) {
        if (selectedLanguagesCode[i] == listLanguage[j].code) {
          selectedLanguages.add(listLanguage[j]);
        }
      }
    }
    List<StaticInfoDto> searchedLanguages =
    searchText.isEmpty ? listLanguage : listLanguage.where((language) => removeDiacritics(language.value.toLowerCase()).contains(searchText.toLowerCase())).toList();
    return PopScope(
      canPop: false,
      onPopInvoked: (pop) {},
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
              RouteService.pop(result: false);
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
                        S.current.languages,
                        style: ThemeUtils.getTitleStyle(),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                      child: Text(
                        '${selectedLanguagesCode.length} ${S.current.text_of} 5',
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
                      child: selectedLanguagesCode.isEmpty
                      ?  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(S.current.txtid_moresss),
                      )
                      : ListView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        children: selectedLanguages.map((tag) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                            child: WidgetGenerator.getRippleButton(
                              colorBg: ThemeUtils.getShadowColor(),
                              borderRadius: ThemeDimen.borderRadiusSmall,
                              buttonHeight: 60,
                              onClick: () {
                                setState(() {
                                  selectedLanguagesCode.remove(tag.code);
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
                      ...List.generate(searchedLanguages.length, (index) => _getLanguageWidgets(searchedLanguages[index])),
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

  Widget _getLanguageWidgets(StaticInfoDto language) {
    return GestureDetector(
      onTap: () {
        if (checkSelected(language)) {
          setState(() {
            selectedLanguagesCode.remove(language.code);
          });
        } else if (selectedLanguagesCode.length < 5) {
          setState(() {

            selectedLanguagesCode.add(language.code);
            if(selectedLanguagesCode.length > 2) {
              scroll();
            }
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.all(ThemeDimen.paddingSmall),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: checkSelected(language) ? ThemeUtils.getPrimaryColor() : ThemeUtils.borderColor),
            borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusSmall),
          ),
          padding: EdgeInsets.all(ThemeDimen.paddingSmall),
          child: Text(
            language.value,
            style: ThemeUtils.getTextStyle(color: checkSelected(language) ? ThemeUtils.getPrimaryColor() : ThemeUtils.color646465),
          ),
        ),
      ),
    );
  }
}
