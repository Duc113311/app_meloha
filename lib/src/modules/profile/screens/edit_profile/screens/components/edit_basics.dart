import 'dart:async';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/requests/api_update_profile_setting.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../domain/dtos/static_info/static_info.dart';
import '../../../../../../domain/services/navigator/route_service.dart';
import '../../../../../../requests/api_utils.dart';

class EditBasics extends StatefulWidget {
  const EditBasics({Key? key, this.styles = ''}) : super(key: key);
  final String styles;

  @override
  State<EditBasics> createState() => _EditBasicsState();
}

class _EditBasicsState extends State<EditBasics>
    with SingleTickerProviderStateMixin {
  String selectedZodiacsCode =
      PrefAssist.getMyCustomer().profiles?.zodiac ?? '';
  String selectedEducationCode =
      PrefAssist.getMyCustomer().profiles?.education ?? '';
  String selectedFamilyPlanCode =
      PrefAssist.getMyCustomer().profiles?.familyPlan ?? '';
  String selectedCovidVaccineCode =
      PrefAssist.getMyCustomer().profiles?.covidVaccine ?? '';
  String selectedPersonalityCode =
      PrefAssist.getMyCustomer().profiles?.personality ?? '';
  String selectedCommunicationTypeCode =
      PrefAssist.getMyCustomer().profiles?.communicationType ?? '';
  String selectedLoveStyleCode =
      PrefAssist.getMyCustomer().profiles?.loveStyle ?? '';

  List<StaticInfoDto> listZodiacs = StaticInfoManager.shared().zodiacs;
  List<StaticInfoDto> listEducations = StaticInfoManager.shared().educations;
  List<StaticInfoDto> listFamilyPlans = StaticInfoManager.shared().familyPlans;
  List<StaticInfoDto> listCovidVaccines =
      StaticInfoManager.shared().covidVaccines;
  List<StaticInfoDto> listPersonalities =
      StaticInfoManager.shared().personalities;
  List<StaticInfoDto> listCommunicationTypes =
      StaticInfoManager.shared().communicationStyles;
  List<StaticInfoDto> listLoveStyles = StaticInfoManager.shared().loveStyles;

  _goBack() async {
    PrefAssist.getMyCustomer().profiles?.zodiac = selectedZodiacsCode;
    PrefAssist.getMyCustomer().profiles?.education = selectedEducationCode;
    PrefAssist.getMyCustomer().profiles?.familyPlan = selectedFamilyPlanCode;
    PrefAssist.getMyCustomer().profiles?.covidVaccine =
        selectedCovidVaccineCode;
    PrefAssist.getMyCustomer().profiles?.personality = selectedPersonalityCode;
    PrefAssist.getMyCustomer().profiles?.communicationType =
        selectedCommunicationTypeCode;
    PrefAssist.getMyCustomer().profiles?.loveStyle = selectedLoveStyleCode;

    await PrefAssist.saveMyCustomer();
    int statusCode = await ApiProfileSetting.updateMyCustomerProfile();
    debugPrint('update status: $statusCode');
    RouteService.pop();
  }

  final Map<String, GlobalKey> addKey = {
    "nights": GlobalKey(),
    "school": GlobalKey(),
    "family": GlobalKey(),
    "coronavirus": GlobalKey(),
    "extension": GlobalKey(),
    "question": GlobalKey(),
    "favorite": GlobalKey(),
  };

  //
  Timer? _timer;
  late AnimationController _animationController;

  //scroll
  Future<void> scroll(GlobalKey key) async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // after the scroll animation finishes, start the blinking
      _animationController.repeat(reverse: true);
      // the duration of the blinking
      _timer = Timer(const Duration(milliseconds: 800), () {
        setState(() {
          _animationController.stop();
          _timer?.cancel();
        });
      });
    });
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scroll(addKey[widget.styles]!);
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
            statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
                ? Brightness.light
                : Brightness.dark,
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
            controller: ScrollController(initialScrollOffset: 100),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ThemeDimen.paddingNormal),
                  child: Text(
                    S.current.basics,
                    style: ThemeUtils.getTitleStyle(),
                  ),
                ),
                SizedBox(height: ThemeDimen.paddingSmall),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ThemeDimen.paddingNormal),
                  child: Text(
                    S.current
                        .put_your_best_self_forward_by_adding_more_about_you,
                    style: ThemeUtils.getCaptionStyle(),
                  ),
                ),
                SizedBox(height: ThemeDimen.paddingNormal),
                _getItemStaticInfo(BasicInfoType.zodiac),
                _getDivider(),
                _getItemStaticInfo(BasicInfoType.education),
                _getDivider(),
                _getItemStaticInfo(BasicInfoType.familyPlan),
                _getDivider(),
                _getItemStaticInfo(BasicInfoType.covidVaccine),
                _getDivider(),
                _getItemStaticInfo(BasicInfoType.personality),
                _getDivider(),
                _getItemStaticInfo(BasicInfoType.communicationType),
                _getDivider(),
                _getItemStaticInfo(BasicInfoType.loveStyle),
                SizedBox(height: ThemeDimen.paddingNormal),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getDivider() {
    return Column(
      children: [
        SizedBox(height: ThemeDimen.paddingSmall),
        WidgetGenerator.getDivider(),
        SizedBox(height: ThemeDimen.paddingSmall),
      ],
    );
  }

  Widget _getItemStaticInfo(BasicInfoType type) {
    final key = addKey[type.name];
    String title = '';
    List<StaticInfoDto> listStaticInfos = [];
    IconData iconData = Icons.question_answer_outlined;

    switch (type) {
      case BasicInfoType.zodiac:
        title = S.current.whats_your_star_sign;
        iconData = Icons.nights_stay_outlined;
        listStaticInfos = listZodiacs;
        break;
      case BasicInfoType.education:
        title = S.current.what_is_your_education_level;
        iconData = Icons.school_outlined;
        listStaticInfos = listEducations;
        break;
      case BasicInfoType.familyPlan:
        title = S.current.do_you_want_children;
        iconData = Icons.family_restroom_outlined;
        listStaticInfos = listFamilyPlans;
        break;
      case BasicInfoType.covidVaccine:
        title = S.current.are_you_vaccinated;
        iconData = Icons.coronavirus_outlined;
        listStaticInfos = listCovidVaccines;
        break;
      case BasicInfoType.personality:
        title = S.current.whats_your_personality_type;
        iconData = Icons.extension_outlined;
        listStaticInfos = listPersonalities;
        break;
      case BasicInfoType.communicationType:
        title = S.current.whats_your_communication_type;
        iconData = Icons.question_answer_outlined;
        listStaticInfos = listCommunicationTypes;
        break;
      case BasicInfoType.loveStyle:
        title = S.current.how_do_you_receive_love;
        iconData = Icons.favorite_outline;
        listStaticInfos = listLoveStyles;
        break;
    }
    return key == addKey[widget.styles] && _animationController.isDismissed
        ? FadeTransition(
            opacity: _animationController,
            child: Column(
              key: key,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ThemeDimen.paddingSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: ThemeDimen.paddingNormal),
                    Icon(iconData, color: ThemeUtils.getPrimaryColor()),
                    SizedBox(width: ThemeDimen.paddingSmall),
                    Expanded(
                        child: Text(title, style: ThemeUtils.getPopupTitleStyle(fontSize: 14.toWidthRatio(), color: ThemeUtils.headerColor()))),
                  ],
                ),
                SizedBox(height: ThemeDimen.paddingSmall),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                  child: Wrap(
                    children: [
                      ...List.generate(
                          listStaticInfos.length,
                          (index) => _getStaticInfosWidgets(
                              listStaticInfos[index], type)),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Column(
            key: key,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ThemeDimen.paddingSmall),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: ThemeDimen.paddingNormal),
                  Icon(iconData, color: ThemeUtils.headerColor()),
                  SizedBox(width: ThemeDimen.paddingSmall),
                  Expanded(
                      child: Text(title, style: ThemeUtils.getPopupTitleStyle(fontSize: 14.toWidthRatio(), color: ThemeUtils.headerColor()))),
                ],
              ),
              SizedBox(height: ThemeDimen.paddingSmall),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                child: Wrap(
                  children: [
                    ...List.generate(
                        listStaticInfos.length,
                        (index) => _getStaticInfosWidgets(
                            listStaticInfos[index], type)),
                  ],
                ),
              ),
            ],
          );
  }

  bool checkSelected(StaticInfoDto staticInfos, BasicInfoType type) {
    switch (type) {
      case BasicInfoType.zodiac:
        return selectedZodiacsCode == staticInfos.code;
      case BasicInfoType.education:
        return selectedEducationCode == staticInfos.code;
      case BasicInfoType.familyPlan:
        return selectedFamilyPlanCode == staticInfos.code;
      case BasicInfoType.covidVaccine:
        return selectedCovidVaccineCode == staticInfos.code;
      case BasicInfoType.personality:
        return selectedPersonalityCode == staticInfos.code;
      case BasicInfoType.communicationType:
        return selectedCommunicationTypeCode == staticInfos.code;
      case BasicInfoType.loveStyle:
        return selectedLoveStyleCode == staticInfos.code;
    }
    return false;
  }

  Widget _getStaticInfosWidgets(StaticInfoDto staticInfos, BasicInfoType type) {
    return GestureDetector(
      onTap: () {
        switch (type) {
          case BasicInfoType.zodiac:
            setState(() {
              if (selectedZodiacsCode == staticInfos.code) {
                selectedZodiacsCode = '';
              } else {
                selectedZodiacsCode = staticInfos.code;
              }
            });
            break;
          case BasicInfoType.education:
            setState(() {
              if (selectedEducationCode == staticInfos.code) {
                selectedEducationCode = '';
              } else {
                selectedEducationCode = staticInfos.code;
              }
            });
            break;
          case BasicInfoType.familyPlan:
            setState(() {
              if (selectedFamilyPlanCode == staticInfos.code) {
                selectedFamilyPlanCode = '';
              } else {
                selectedFamilyPlanCode = staticInfos.code;
              }
            });
            break;
          case BasicInfoType.covidVaccine:
            setState(() {
              if (selectedCovidVaccineCode == staticInfos.code) {
                selectedCovidVaccineCode = '';
              } else {
                selectedCovidVaccineCode = staticInfos.code;
              }
            });
            break;
          case BasicInfoType.personality:
            setState(() {
              if (selectedPersonalityCode == staticInfos.code) {
                selectedPersonalityCode = '';
              } else {
                selectedPersonalityCode = staticInfos.code;
              }
            });
            break;
          case BasicInfoType.communicationType:
            setState(() {
              if (selectedCommunicationTypeCode == staticInfos.code) {
                selectedCommunicationTypeCode = '';
              } else {
                selectedCommunicationTypeCode = staticInfos.code;
              }
            });
            break;
          case BasicInfoType.loveStyle:
            setState(() {
              if (selectedLoveStyleCode == staticInfos.code) {
                selectedLoveStyleCode = '';
              } else {
                selectedLoveStyleCode = staticInfos.code;
              }
            });
            break;
        }
      },
      child: Padding(
        padding: EdgeInsets.all(ThemeDimen.paddingSmall),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: checkSelected(staticInfos, type)
                    ? ThemeUtils.getPrimaryColor()
                    : ThemeUtils.borderColor),
            borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusSmall),
          ),
          padding: EdgeInsets.all(ThemeDimen.paddingSmall),
          child: Text(
            staticInfos.value,
            style: ThemeUtils.getTextStyle(
                color: checkSelected(staticInfos, type)
                    ? ThemeUtils.getPrimaryColor()
                    : ThemeUtils.color646465),
          ),
        ),
      ),
    );
  }
}
