import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/dtos/static_info/static_info.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterSelectInterest extends StatefulWidget {
  FilterSelectInterest({super.key, required this.selectedInterestsCode});

  List<String> selectedInterestsCode;

  @override
  State<FilterSelectInterest> createState() => _FilterSelectInterestState();
}

class _FilterSelectInterestState extends State<FilterSelectInterest> {
  List<StaticInfoDto> listInterest = StaticInfoManager.shared().interests;
  late List<String> selectedInterestsCode;
  late List<String> originalSelectedCode;
  @override
  void initState() {
    selectedInterestsCode = [...widget.selectedInterestsCode];
    originalSelectedCode = [...widget.selectedInterestsCode];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () async {
            setState(() {
              selectedInterestsCode = [];
            });
            RouteService.pop(result: originalSelectedCode);
          },
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
        ),
        title: Text(
          S.current.interests,
          style: ThemeUtils.getTitleStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Wrap(
                children: [
                  ...List.generate(listInterest.length,
                      (index) => _getInterestWidgets(listInterest[index])),
                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Column (
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Spacer(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: WidgetGenerator.bottomButton(
                  selected: true,
                  isShowRipple: true,
                  buttonHeight: ThemeDimen.buttonHeightNormal,
                  buttonWidth: 100,
                  onClick: () async {
                    RouteService.pop(result: selectedInterestsCode);
                  },
                  child: Center(
                    child: Text(
                      S.current.done,
                      style: ThemeUtils.getButtonStyle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool checkSelected(StaticInfoDto interest) {
    if (selectedInterestsCode.contains(interest.code)) {
      return true;
    }
    return false;
  }

  Widget _getInterestWidgets(StaticInfoDto interest) {
    return GestureDetector(
      onTap: () {
        if (checkSelected(interest)) {
          setState(() {
            selectedInterestsCode.remove(interest.code);
          });
        } else {
          setState(() {
            selectedInterestsCode.add(interest.code);
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: checkSelected(interest)
                    ? ThemeUtils.getPrimaryColor()
                    : ThemeUtils.borderColor),
            borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
          ),
          padding: EdgeInsets.all(ThemeDimen.paddingSmall),
          child: Text(
            interest.value,
            style: ThemeUtils.getTextStyle(
                color: checkSelected(interest)
                    ? ThemeUtils.getPrimaryColor()
                    : ThemeUtils.borderColor),
          ),
        ),
      ),
    );
  }
}
