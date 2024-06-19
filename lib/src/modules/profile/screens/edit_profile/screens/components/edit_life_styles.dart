import 'dart:async';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../domain/dtos/static_info/static_info.dart';
import '../../../../../../domain/services/navigator/route_service.dart';
import '../../../../../../requests/api_update_profile_setting.dart';

class EditLifeStyles extends StatefulWidget {
  const EditLifeStyles({Key? key, this.styles = ''}) : super(key: key);
  final String styles;

  @override
  State<EditLifeStyles> createState() => _EditLifeStylesState();
}

class _EditLifeStylesState extends State<EditLifeStyles>
    with SingleTickerProviderStateMixin {
  String selectedPetCode = PrefAssist.getMyCustomer().profiles?.pet ?? '';
  String selectedDrinkingCode =
      PrefAssist.getMyCustomer().profiles?.drinking ?? '';
  String selectedSmokingCode =
      PrefAssist.getMyCustomer().profiles?.smoking ?? '';
  String selectedWorkoutCode =
      PrefAssist.getMyCustomer().profiles?.workout ?? '';
  String selectedDietaryPreferenceCode =
      PrefAssist.getMyCustomer().profiles?.dietaryPreference ?? '';
  String selectedSocialMediaCode =
      PrefAssist.getMyCustomer().profiles?.socialMedia ?? '';
  String selectedSleepingHabitCode =
      PrefAssist.getMyCustomer().profiles?.sleepingHabit ?? '';

  List<StaticInfoDto> listPets = StaticInfoManager.shared().pets;
  List<StaticInfoDto> listDrinkings = StaticInfoManager.shared().drinkings;
  List<StaticInfoDto> listSmokings = StaticInfoManager.shared().smokings;
  List<StaticInfoDto> listWorkouts = StaticInfoManager.shared().workouts;
  List<StaticInfoDto> listFoodPreferences =
      StaticInfoManager.shared().foodPreferences;
  List<StaticInfoDto> listSocials = StaticInfoManager.shared().socials;
  List<StaticInfoDto> listSleepingStyles =
      StaticInfoManager.shared().sleepingStyles;

  _goBack() async {
    PrefAssist.getMyCustomer().profiles?.pet = selectedPetCode;
    PrefAssist.getMyCustomer().profiles?.drinking = selectedDrinkingCode;
    PrefAssist.getMyCustomer().profiles?.smoking = selectedSmokingCode;
    PrefAssist.getMyCustomer().profiles?.workout = selectedWorkoutCode;
    PrefAssist.getMyCustomer().profiles?.dietaryPreference =
        selectedDietaryPreferenceCode;
    PrefAssist.getMyCustomer().profiles?.socialMedia = selectedSocialMediaCode;
    PrefAssist.getMyCustomer().profiles?.sleepingHabit =
        selectedSleepingHabitCode;

    await PrefAssist.saveMyCustomer();

    int statusCode = await ApiProfileSetting.updateMyCustomerProfile();
    debugPrint('update status: $statusCode');
    RouteService.pop();
  }

  final Map<String, GlobalKey> addKey = {
    "pets": GlobalKey(),
    "coffee": GlobalKey(),
    "smoking": GlobalKey(),
    "fitness": GlobalKey(),
    "pizza": GlobalKey(),
    "alternate": GlobalKey(),
    "hotel": GlobalKey(),
  };

  //
  Timer? _timer;
  late AnimationController _animationController;

  //scroll
  Future<void> scroll(GlobalKey key) async {
    await Future.delayed(const Duration(milliseconds: 50), () {
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
      canPop: false,
      onPopInvoked: (pop) {},
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
                style: ThemeUtils.getRightButtonStyle())
            ),
          ],
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            controller: ScrollController(initialScrollOffset: 400),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ThemeDimen.paddingNormal),
                  child: Text(
                    S.current.lifestyle,
                    style: ThemeUtils.getTitleStyle(),
                  ),
                ),
                SizedBox(height: ThemeDimen.paddingSmall),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ThemeDimen.paddingNormal),
                  child: Text(
                    S.current
                        .put_your_best_self_forward_by_adding_your_lifestyle,
                    style: ThemeUtils.getCaptionStyle(),
                  ),
                ),
                SizedBox(height: ThemeDimen.paddingNormal),
                _getItemStaticInfo(LifeStyleType.pet),
                _getDivider(),
                _getItemStaticInfo(LifeStyleType.drinking),
                _getDivider(),
                _getItemStaticInfo(LifeStyleType.smoking),
                _getDivider(),
                _getItemStaticInfo(LifeStyleType.workout),
                _getDivider(),
                _getItemStaticInfo(LifeStyleType.dietaryPreference),
                _getDivider(),
                _getItemStaticInfo(LifeStyleType.socialMedia),
                _getDivider(),
                _getItemStaticInfo(LifeStyleType.sleepingHabit),
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

  Widget _getItemStaticInfo(LifeStyleType type) {
    final key = addKey[type.name];
    String title = '';
    List<StaticInfoDto> listStaticInfos = [];
    IconData iconData = Icons.question_answer_outlined;

    switch (type) {
      case LifeStyleType.pet:
        title = S.current.pets;
        iconData = Icons.pets_outlined;
        listStaticInfos = listPets;
        break;
      case LifeStyleType.drinking:
        title = S.current.drinking;
        iconData = Icons.coffee_outlined;
        listStaticInfos = listDrinkings;
        break;
      case LifeStyleType.smoking:
        title = S.current.how_often_do_you_smoke;
        iconData = Icons.smoking_rooms_outlined;
        listStaticInfos = listSmokings;
        break;
      case LifeStyleType.workout:
        title = S.current.workout;
        iconData = Icons.fitness_center_outlined;
        listStaticInfos = listWorkouts;
        break;
      case LifeStyleType.dietaryPreference:
        title = S.current.dietary_preference;
        iconData = Icons.local_pizza_outlined;
        listStaticInfos = listFoodPreferences;
        break;
      case LifeStyleType.socialMedia:
        title = S.current.social_media;
        iconData = Icons.alternate_email;
        listStaticInfos = listSocials;
        break;
      case LifeStyleType.sleepingHabit:
        title = S.current.sleeping_habits;
        iconData = Icons.hotel_outlined;
        listStaticInfos = listSleepingStyles;
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
          );
  }

  bool checkSelected(StaticInfoDto staticInfos, LifeStyleType type) {
    switch (type) {
      case LifeStyleType.pet:
        return selectedPetCode == staticInfos.code;
      case LifeStyleType.drinking:
        return selectedDrinkingCode == staticInfos.code;
      case LifeStyleType.smoking:
        return selectedSmokingCode == staticInfos.code;
      case LifeStyleType.workout:
        return selectedWorkoutCode == staticInfos.code;
      case LifeStyleType.dietaryPreference:
        return selectedDietaryPreferenceCode == staticInfos.code;
      case LifeStyleType.socialMedia:
        return selectedSocialMediaCode == staticInfos.code;
      case LifeStyleType.sleepingHabit:
        return selectedSleepingHabitCode == staticInfos.code;
    }
    return false;
  }

  Widget _getStaticInfosWidgets(StaticInfoDto staticInfos, LifeStyleType type) {
    return GestureDetector(
      onTap: () {
        switch (type) {
          case LifeStyleType.pet:
            setState(() {
              if (selectedPetCode == staticInfos.code) {
                selectedPetCode = '';
              } else {
                selectedPetCode = staticInfos.code;
              }
            });
            break;
          case LifeStyleType.drinking:
            setState(() {
              if (selectedDrinkingCode == staticInfos.code) {
                selectedDrinkingCode = '';
              } else {
                selectedDrinkingCode = staticInfos.code;
              }
            });
            break;
          case LifeStyleType.smoking:
            setState(() {
              if (selectedSmokingCode == staticInfos.code) {
                selectedSmokingCode = '';
              } else {
                selectedSmokingCode = staticInfos.code;
              }
            });
            break;
          case LifeStyleType.workout:
            setState(() {
              if (selectedWorkoutCode == staticInfos.code) {
                selectedWorkoutCode = '';
              } else {
                selectedWorkoutCode = staticInfos.code;
              }
            });
            break;
          case LifeStyleType.dietaryPreference:
            setState(() {
              if (selectedDietaryPreferenceCode == staticInfos.code) {
                selectedDietaryPreferenceCode = '';
              } else {
                selectedDietaryPreferenceCode = staticInfos.code;
              }
            });
            break;
          case LifeStyleType.socialMedia:
            setState(() {
              if (selectedSocialMediaCode == staticInfos.code) {
                selectedSocialMediaCode = '';
              } else {
                selectedSocialMediaCode = staticInfos.code;
              }
            });
            break;
          case LifeStyleType.sleepingHabit:
            setState(() {
              if (selectedSleepingHabitCode == staticInfos.code) {
                selectedSleepingHabitCode = '';
              } else {
                selectedSleepingHabitCode = staticInfos.code;
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
