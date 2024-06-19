import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/bloc/static_info/static_info_data.dart';
import 'package:dating_app/src/domain/dtos/like_and_top_pick/customers_like_top_dto.dart';
import 'package:dating_app/src/domain/dtos/like_and_top_pick/filter_like_dto.dart';
import 'package:dating_app/src/domain/dtos/static_info/static_info.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/libs/sliders/sliders.dart';
import 'package:dating_app/src/requests/api_filter_like.dart';
import 'package:dating_app/src/utils/change_notifiers/premium_notifier.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/filter_manager.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'filter_select_interest.dart';

class FilterLikePage extends StatefulWidget {
  FilterLikePage({super.key, this.callback, this.selectedCode});

  String? selectedCode;
  void Function(List<CustomersLikeTopDto> users)? callback;

  @override
  State<FilterLikePage> createState() => _FilterLikePageState();
}

class _FilterLikePageState extends State<FilterLikePage> {
  bool isKm = Utils.getMyCustomerDistType() == Const.kDistTypeKm;
  double _milValue = 0;
  double _distanceRange = 0;
  double _minimumNumberOfPhoto = 0;

  int _startAgeRange = 0;
  int _endAgeRange = 0;
  bool verifiedPhoto = false;
  bool hasBio = false;

  final interestController = ScrollController(initialScrollOffset: 10);
  List<String> selectedInterestsCode = [];
  List<StaticInfoDto> _topInterests = [];
  List<StaticInfoDto> _fixedTopInterests = [];
  List<StaticInfoDto> listInterest = StaticInfoManager.shared().interests;

  FilterBodyDto filter = FilterLikeManager.shared.getFilter();

  void setupDefaultValue() async {
    _milValue = filter.distance.kmToMil();
    _distanceRange = filter.distance;
    _minimumNumberOfPhoto = filter.numberPhoto.toDouble();

    _startAgeRange = filter.ageMin;
    _endAgeRange = filter.ageMax;
    verifiedPhoto = filter.statusVerified;
    hasBio = filter.statusBio;

    if (widget.selectedCode != null) {
      selectedInterestsCode = [widget.selectedCode!];
      filter.interests = selectedInterestsCode;
      FilterLikeManager.shared.updateFilter(interests: selectedInterestsCode);
    } else {
      selectedInterestsCode = filter.interests;
    }

    final topInterests = listInterest.sublist(0, 5);
    _topInterests = [...topInterests];
    _fixedTopInterests = [...topInterests];
  }

  @override
  void initState() {
    setupDefaultValue();

    super.initState();
  }

  bool checkSelected(StaticInfoDto interest) {
    if (selectedInterestsCode.contains(interest.code)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RouteService.pop();
      },
      child: Container(
        color: Colors.transparent,
        child: DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return GestureDetector(
              onTap: () {},
              child: Stack(
                children: [
                  Container(
                    color: ThemeUtils.getScaffoldBackgroundColor(),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        const SizedBox(
                          height: 66,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                S.current.txtid_maximum_distance,
                                style: ThemeUtils.getPopupTitleStyle(
                                    fontSize: 14.toWidthRatio()),
                              ),
                              const Spacer(),
                              Text(
                                '${isKm ? _distanceRange.toInt() : _milValue.toInt()} ${isKm ? S.current.txt_km : S.current.txt_mi}+',
                                style: ThemeUtils.getPopupTitleStyle(
                                    fontSize: 14.toWidthRatio()),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                        SfSliderTheme(
                          data: SfSliderThemeData(
                              tooltipBackgroundColor:
                                  ThemeUtils.getPrimaryColor()),
                          child: SfSlider(
                            activeColor: ThemeUtils.getPrimaryColor(),
                            inactiveColor: HexColor("E6E0E9"),
                            enableTooltip: false,
                            shouldAlwaysShowTooltip: false,
                            value: isKm ? _distanceRange : _milValue,
                            onChangeEnd: (value) {
                              setState(() {
                                if (isKm) {
                                  _distanceRange = value;
                                  _milValue = _distanceRange.kmToMil();
                                } else {
                                  _milValue = value;
                                  _distanceRange = _milValue.milToKm();
                                }
                              });
                              final range = isKm
                                  ? _distanceRange.toInt()
                                  : _milValue.milToKm().toInt();
                              final endValue = max(
                                  1,
                                  min(range,
                                      Const.kSettingMaxDistance.toInt()));
                              filter.distance = endValue.toDouble();
                              FilterLikeManager.shared
                                  .updateFilter(distance: endValue.toDouble());
                            },
                            onChanged: (value) {
                              setState(() {
                                if (isKm) {
                                  _distanceRange = value;
                                } else {
                                  _milValue = value;
                                }
                              });
                            },
                            min: Const.kSettingMinDistance,
                            max: Const.kSettingMaxDistance,
                            stepSize: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                S.current.age_range,
                                style: ThemeUtils.getPopupTitleStyle(
                                    fontSize: 14.toWidthRatio()),
                              ),
                              const Spacer(),
                              Text(
                                '$_startAgeRange-$_endAgeRange+',
                                style: ThemeUtils.getPopupTitleStyle(
                                    fontSize: 14.toWidthRatio()),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                        SfRangeSliderTheme(
                          data: SfRangeSliderThemeData(
                              tooltipBackgroundColor:
                                  ThemeUtils.getPrimaryColor()),
                          child: SfRangeSlider(
                            activeColor: ThemeUtils.getPrimaryColor(),
                            inactiveColor: HexColor("E6E0E9"),
                            enableTooltip: false,
                            shouldAlwaysShowTooltip: false,
                            values: SfRangeValues(
                                _startAgeRange.clamp(Const.kSettingMinAgeRange,
                                    Const.kSettingMaxAgeRange),
                                _endAgeRange.clamp(Const.kSettingMinAgeRange,
                                    Const.kSettingMaxAgeRange)),
                            onChanged: (change) {
                              if (change.end.toInt() - change.start.toInt() < 6) {
                                return;
                              }
                              setState(() {
                                _startAgeRange = change.start.toInt();
                                _endAgeRange = change.end.toInt();
                              });
                            },
                            onChangeEnd: (value) {
                              filter.ageMin = _startAgeRange;
                              filter.ageMax = _endAgeRange;
                              FilterLikeManager.shared
                                  .updateFilter(ageMin: _startAgeRange);
                              FilterLikeManager.shared
                                  .updateFilter(ageMax: _endAgeRange);
                            },
                            min: Const.kSettingMinAgeRange,
                            max: Const.kSettingMaxAgeRange,
                            stepSize: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                S.current.txtid_minimum_number_of_photos,
                                style: ThemeUtils.getPopupTitleStyle(
                                    fontSize: 14.toWidthRatio()),
                              ),
                              const Spacer(),
                              Text(
                                '${_minimumNumberOfPhoto.toInt()}+',
                                style: ThemeUtils.getPopupTitleStyle(
                                    fontSize: 14.toWidthRatio()),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                        SfSliderTheme(
                          data: SfSliderThemeData(
                              tooltipBackgroundColor:
                                  ThemeUtils.getPrimaryColor()),
                          child: SfSlider(
                            activeColor: ThemeUtils.getPrimaryColor(),
                            inactiveColor: HexColor("E6E0E9"),
                            enableTooltip: false,
                            showLabels: true,
                            shouldAlwaysShowTooltip: false,
                            showTicks: true,
                            value: _minimumNumberOfPhoto,
                            onChangeEnd: (value) {
                              filter.numberPhoto =
                                  _minimumNumberOfPhoto.toInt();
                              FilterLikeManager.shared.updateFilter(
                                  numberPhoto: _minimumNumberOfPhoto.toInt());
                            },
                            onChanged: (value) {
                              setState(() {
                                _minimumNumberOfPhoto = value;
                              });
                            },
                            min: Const.kNumberOfImagesRequired.toDouble(),
                            max: Const.kMaxImageNumber.toDouble(),
                            minorTicksPerInterval: 1,
                            stepSize: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                S.current.interests,
                                style: ThemeUtils.getPopupTitleStyle(
                                    fontSize: 14.toWidthRatio()),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Wrap(
                            children: [
                              ...List.generate(
                                  _topInterests.length,
                                  (index) => _getInterestWidgets(
                                      _topInterests[index])),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            TextButton(
                                onPressed: () async {
                                  final selected =
                                      await RouteService.presentPage(
                                          FilterSelectInterest(
                                    selectedInterestsCode:
                                        selectedInterestsCode,
                                  ));

                                  final array = listInterest
                                      .where((element) =>
                                          selected.contains(element.code))
                                      .toList();

                                  List<StaticInfoDto> newTops = [
                                    ..._fixedTopInterests
                                  ];
                                  for (var item in array) {
                                    if (_fixedTopInterests.contains(item)) {
                                      continue;
                                    }
                                    newTops.add(item);
                                  }
                                  setState(() {
                                    _topInterests = newTops;
                                    selectedInterestsCode = selected;
                                    filter.interests = selectedInterestsCode;
                                    FilterLikeManager.shared.updateFilter(
                                        interests: selectedInterestsCode);
                                  });
                                },
                                child: Text(
                                  S.current.txtid_see_more.toUpperCase(),
                                  style: ThemeUtils.getCaptionStyle(
                                      color: ThemeUtils.headerInfoColor,
                                      fontSize: 14.toWidthRatio()),
                                )),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () async {
                              setState(() => verifiedPhoto = !verifiedPhoto);
                              filter.statusVerified = verifiedPhoto;
                              FilterLikeManager.shared
                                  .updateFilter(statusVerified: verifiedPhoto);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ThemeDimen.paddingNormal),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  verifiedPhoto
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
                                      S.current.txt_verified_photos,
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
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: ThemeDimen.paddingNormal),
                          child: GestureDetector(
                            onTap: () async {
                              setState(() => hasBio = !hasBio);
                              filter.statusBio = hasBio;
                              FilterLikeManager.shared
                                  .updateFilter(statusBio: hasBio);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ThemeDimen.paddingNormal),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  hasBio
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
                                      S.current.txt_has_bio,
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
                        const SizedBox(
                          height: 66,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: ThemeUtils.getScaffoldBackgroundColor(),
                    height: 60,
                    child: AppBar(
                      bottom: const PreferredSize(
                        preferredSize: Size.fromHeight(1),
                        child: Divider(height: 0.5),
                      ),
                      leading: IconButton(
                          onPressed: () {
                            RouteService.pop();
                          },
                          icon: const Icon(Icons.close)),
                      title: Text(
                        S.current.txtid_filter,
                        style: ThemeUtils.getTitleStyle(),
                      ),
                      //automaticallyImplyLeading: false,//this prevents the appBar from having a close button (that button wouldn't work because of IgnorePointer)
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: ThemeUtils.getScaffoldBackgroundColor(),
                        child: Row(
                          children: [
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: WidgetGenerator.bottomButton(
                                selected: false,
                                isShowRipple: true,
                                buttonHeight: ThemeDimen.buttonHeightNormal,
                                buttonWidth: 100,
                                onClick: () {
                                  RouteService.pop();
                                },
                                child: Center(
                                  child: Text(
                                    S.current.str_cancel,
                                    style: ThemeUtils.getButtonStyle(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: WidgetGenerator.bottomButton(
                                selected: true,
                                isShowRipple: true,
                                buttonHeight: ThemeDimen.buttonHeightNormal,
                                buttonWidth: 100,
                                onClick: () async {
                                  int pageSize = PremiumNotifier.shared.isPremium ? -1 : 10;
                                  final users =
                                      await ApiFilterLike.filterUser(filter, pageSize: pageSize);
                                  if (widget.callback != null) {
                                    widget.callback!(users);
                                  }
                                  RouteService.pop();
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
                      )
                    ],
                  )
                ],
              ),
            );
          },
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
            filter.interests = selectedInterestsCode;
          });
          FilterLikeManager.shared
              .updateFilter(interests: selectedInterestsCode);
        } else if (selectedInterestsCode.length < 5) {
          setState(() {
            selectedInterestsCode.add(interest.code);
            filter.interests = selectedInterestsCode;
          });
          FilterLikeManager.shared
              .updateFilter(interests: selectedInterestsCode);
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
