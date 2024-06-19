import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:dating_app/src/modules/report/report_user_page.dart';
import 'package:dating_app/src/modules/subviews/default_user_avatar.dart';
import 'package:dating_app/src/utils/cache_image_manager.dart';
import 'package:dating_app/src/utils/emoji_convert.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../../../general/constants/app_image.dart';

enum HingeCardOptions { remove, report }

class HingeCard extends StatefulWidget {
  HingeCard({
    super.key,
    required this.customer,
    this.cardActionHandle,
    this.backCardHandle,
    required this.canBackCard,
    this.actionImage,
    this.isFriend = false,
    this.showBackCard = true,
    this.nextUser,
    this.scrollOffset
  });

  CustomerDto customer;
  final void Function(CustomerDto customer, int action,
      {AvatarDto? avatar, PromptDto? promptDto})? cardActionHandle;
  final void Function()? backCardHandle;
  final bool canBackCard;
  final String? actionImage;
  final bool isFriend;
  final bool showBackCard;
  final CustomerDto? nextUser;
  final void Function(double offset)? scrollOffset;

  @override
  State<HingeCard> createState() => _HingeCardState();
}

class _HingeCardState extends State<HingeCard>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  ScrollPhysics scrollPhysics = const ScrollPhysics();

  final kImageWidth = Get.width - ThemeDimen.paddingNormal * 2;
  double titleOpacity = 1;
  int maxImageIndex = 1;
  int maxPromptIndex = 1;
  late bool _animationLoaded;
  double _animatedHeight = 0;
  double _animatedImageHeight = 0;
  HingeCardOptions? selectedOption;

  Timer? preloadUser;

  @override
  void dispose() {
    preloadUser?.cancel();
    preloadUser = null;
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final url = widget.nextUser?.getAvatarUrl ?? '';
    if (url.isNotEmpty) {
      precacheImage(
          CachedNetworkImageProvider(url,
              cacheKey: url.removeQuery,
              cacheManager: BHCacheImageManager.shared().cacheManager),
          context,
          size: Size(kImageWidth, kImageWidth));
    }
  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(_scrollListener);

    _animationLoaded = widget.actionImage == null ? true : false;
    maxImageIndex = 1;

    startAnimation();

    preloadUser?.cancel();
    preloadUser = Timer(const Duration(seconds: 2), () async {
      final url = widget.nextUser?.getAvatarUrl ?? '';
      if (url.isNotEmpty) {
        await DefaultCacheManager()
            .downloadFile(url, key: url.removeQuery)
            .then((value) async {
          debugPrint("cache success: key: ${url.removeQuery}");
          preloadUser?.cancel();
        }).onError((error, stackTrace) {
          debugPrint("Cache error: ${error} - key ${url.removeQuery} - ");
          preloadUser?.cancel();
        });
      }
    });
  }

  _scrollListener() {
    if (widget.scrollOffset != null && mounted) {
      widget.scrollOffset!(scrollController.offset);
    }
    setState(() {
      titleOpacity = 1 - min(scrollController.offset / 15, 1);
    });

  }

  void startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 239), () {
      if (mounted) {
        setState(() {
          _animatedHeight = widget.actionImage != null ? 239.0 : 0;
        });
      }
    });

    await Future.delayed(const Duration(milliseconds: 99), () {
      if (mounted) {
        setState(() {
          _animatedImageHeight = widget.actionImage != null ? 100.0 : 0;
        });
      }
    });

    await Future.delayed(const Duration(milliseconds: 99), () {});

    await Future.delayed(const Duration(milliseconds: 339), () {
      if (mounted) {
        setState(() {
          _animatedImageHeight = 0;
        });
      }
    });

    await Future.delayed(const Duration(milliseconds: 99), () {
      if (mounted) {
        setState(() {
          _animatedHeight = 0;
          _animationLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: SingleChildScrollView(
        controller: scrollController,
        physics: scrollPhysics,
        child: Column(
          children: [
            if (widget.actionImage != null)
              AnimatedContainer(
                duration: const Duration(milliseconds: 99),
                height: _animatedHeight,
                width: _animatedHeight,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 139),
                    height: _animatedImageHeight,
                    width: _animatedImageHeight,
                    child: SvgPicture.asset(
                      widget.actionImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            AnimatedOpacity(
              opacity: _animationLoaded ? 1 : 0,
              duration: const Duration(milliseconds: 179),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Opacity(
                    opacity: titleOpacity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: Get.width - 150,
                          ),
                          child: Text(
                            widget.customer.getNameForHinge,
                            maxLines: 1,
                            style: ThemeUtils.getTitleStyle(fontSize: 18)
                                .copyWith(overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        SizedBox(
                          width: ThemeDimen.paddingSmall,
                        ),
                        SvgPicture.asset(
                          widget.customer.verifyImage,
                          width: 30,
                          height: 30,
                        ),
                        const Spacer(),
                        if (!widget.isFriend && widget.showBackCard)
                          Opacity(
                            opacity: widget.canBackCard ? 1 : 0.5,
                            child: InkWell(
                              onTap: () {
                                if (widget.canBackCard &&
                                    widget.backCardHandle != null) {
                                  widget.backCardHandle!();
                                }
                              },
                              child: SvgPicture.asset(
                                AppImages.icUndoCardAction,
                                width: 25.toWidthRatio(),
                                height: 25.toWidthRatio(),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    ThemeUtils.getTextColor(), BlendMode.srcIn),
                              ),
                            ),
                          ),
                        if (!widget.isFriend)
                          PopupMenuButton(
                            color: ThemeUtils.getScaffoldBackgroundColor(),
                            onSelected: (HingeCardOptions item) async {
                              if (item == HingeCardOptions.remove) {
                                if (widget.cardActionHandle != null) {
                                  widget.cardActionHandle!(
                                      widget.customer, Const.kNopeAction);
                                }
                              } else {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return ReportUserPage(
                                      userId: widget.customer.id,
                                      callback: (success) {
                                        if (widget.cardActionHandle != null) {
                                          widget.cardActionHandle!(
                                              widget.customer, Const.kReportAction);
                                        }
                                      },
                                    );
                                  },
                                  backgroundColor:
                                      ThemeUtils.getScaffoldBackgroundColor(),
                                  isScrollControlled: true,
                                );
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<HingeCardOptions>>[
                              PopupMenuItem<HingeCardOptions>(
                                value: HingeCardOptions.remove,
                                child: Text(
                                  S.current.remove.toCapitalized,
                                  style:
                                      TextStyle(color: ThemeUtils.getTextColor()),
                                ),
                              ),
                              PopupMenuItem<HingeCardOptions>(
                                value: HingeCardOptions.report,
                                child: Text(
                                  S.current.report.toCapitalized,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Text(_onlineLabel(widget.customer.onlineNow ?? false),
                          style: ThemeUtils.getCaptionStyle(fontSize: 14)),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: ThemeDimen.paddingNormal,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        if (widget.customer.getAvatarModel != null)
                          _image(widget.customer.getAvatarModel!,
                              showThumbnail: false),
                        SizedBox(
                          height: widget.customer.getListPrompts.isNotEmpty
                              ? ThemeDimen.paddingNormal
                              : 0,
                        ),
                        if (widget.customer.getListPrompts.isNotEmpty)
                          buildPrompt(widget.customer.getListPrompts.first),
                        SizedBox(
                          height: ThemeDimen.paddingNormal,
                        ),
                        _moreInfo(),
                        _datingPurpose(),
                        SizedBox(
                          height: ThemeDimen.paddingBig,
                        ),
                        _juniorImages(),
                        if (widget.customer.getListPrompts.length > 1)
                          buildPrompt(widget.customer.getListPrompts[1]),
                        _basicWidget(),
                        _middleImages(),
                        if (widget.customer.getListPrompts.length > 2)
                          buildPrompt(widget.customer.getListPrompts[2]),
                        _lifestyleWidget(),
                        _seniorImages(),
                        const SizedBox(
                          height: 66,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ShowCommonDto get _showCommon {
    return widget.customer.profiles!.showCommon!;
  }

  bool get _displayShortInfo {
    return !((widget.customer.getGender.isEmpty || !_showCommon.showGender) &&
        (widget.customer.getHeight != -1 || !_showCommon.showHeight) &&
        (widget.customer.getFirstAddress.isEmpty) &&
        (widget.customer.getChildrenPlan.isEmpty ||
            !_showCommon.showChildrenPlan) &&
        (widget.customer.getDrinking.isEmpty || !_showCommon.showDrinking) &&
        (widget.customer.getSmoking.isEmpty || !_showCommon.showSmoking) &&
        (widget.customer.getDrug.isEmpty || !_showCommon.showDrug));
  }

  Widget get _horDivider {
    return Container(
      width: 1,
      height: 25,
      color: ThemeUtils.borderColor,
    );
  }

  Widget _shortInfo(bool showLine) {
    if (!_displayShortInfo) {
      return const SizedBox();
    }

    List<Widget> childs = [];

    if (widget.customer.getGender.isNotEmpty && _showCommon.showGender) {
      childs.add(buildImageInfo(
          AppImages.icGenderInfo, widget.customer.getGenderConvert,
          flexible: false));
    }

    if (widget.customer.getHeight != -1 && _showCommon.showHeight) {
      childs.add(Row(
        children: [
          childs.isNotEmpty ? _horDivider : const SizedBox(),
          buildImageInfo(AppImages.icHeightInfo, widget.customer.getHeightInfo,
              flexible: false),
        ],
      ));
    }

    if (widget.customer.getFirstAddress.isNotEmpty) {
      childs.add(Row(
        children: [
          childs.isNotEmpty ? _horDivider : const SizedBox(),
          buildImageInfo(
              AppImages.icLocationInfo, widget.customer.getFirstAddress,
              flexible: false),
        ],
      ));
    }

    if (widget.customer.getChildrenPlan.isNotEmpty &&
        _showCommon.showChildrenPlan) {
      childs.add(Row(
        children: [
          childs.isNotEmpty ? _horDivider : const SizedBox(),
          buildImageInfo(
              AppImages.icChildrenPlan, widget.customer.getChildrenPlanConvert,
              flexible: false),
        ],
      ));
    }

    if (widget.customer.getDrug.isNotEmpty && _showCommon.showDrug) {
      childs.add(Row(
        children: [
          childs.isNotEmpty ? _horDivider : const SizedBox(),
          buildImageInfo(AppImages.icInfoDrug, widget.customer.getDrugConvert,
              flexible: false),
        ],
      ));
    }

    return SizedBox(
      width: kImageWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: childs,
            ),
          ),
          if (showLine)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ),
    );
  }

  Widget _juniorImages() {
    if (widget.customer.getListAvatarModels.length <= 1) {
      return const SizedBox();
    }
    List<Widget> childs = [];

    childs.add(_image(widget.customer.getListAvatarModels[1]));
    childs.add(SizedBox(
      height: ThemeDimen.paddingBig,
    ));

    if (widget.customer.getListAvatarModels.length > 2) {
      childs.add(_image(widget.customer.getListAvatarModels[2]));
      childs.add(SizedBox(
        height: ThemeDimen.paddingBig,
      ));
    }

    return Column(
      children: childs,
    );
  }

  Widget _middleImages() {
    if (widget.customer.getListAvatarModels.length <= 3) {
      return const SizedBox();
    }
    List<Widget> childs = [];

    childs.add(_image(widget.customer.getListAvatarModels[3]));
    childs.add(SizedBox(
      height: ThemeDimen.paddingBig,
    ));

    return Column(
      children: childs,
    );
  }

  Widget _seniorImages() {
    if (widget.customer.getListAvatarModels.length <= 4) {
      return const SizedBox();
    }
    List<Widget> childs = [];

    childs.add(_image(widget.customer.getListAvatarModels[4]));
    childs.add(SizedBox(
      height: ThemeDimen.paddingBig,
    ));

    if (widget.customer.getListAvatarModels.length > 5) {
      childs.add(_image(widget.customer.getListAvatarModels[5]));
      childs.add(SizedBox(
        height: ThemeDimen.paddingBig,
      ));
    }

    return Column(
      children: childs,
    );
  }

  Widget _smailImageText(IconData iconData, String text) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: ThemeUtils.borderColor,
          ),
          borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusSmall),
        ),
        padding: EdgeInsets.all(ThemeDimen.paddingSmall),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: ThemeUtils.getTextColor(),
              size: 20,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _basicWidget() {
    if (widget.customer.getZodiac.isEmpty &&
        widget.customer.getFamilyPlan.isEmpty &&
        widget.customer.getCovidVaccine.isEmpty &&
        widget.customer.getPersonality.isEmpty &&
        widget.customer.getCommunicationType.isEmpty &&
        widget.customer.getLoveStyle.isEmpty) {
      return const SizedBox();
    }

    List<Widget> childs = [];
    if (widget.customer.getZodiac.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.nights_stay_outlined, widget.customer.getZodiacConvert));
    }
    if (widget.customer.getFamilyPlan.isNotEmpty) {
      childs.add(_smailImageText(Icons.family_restroom_outlined,
          widget.customer.getFamilyPlanConvert));
    }
    if (widget.customer.getCovidVaccine.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.coronavirus_outlined, widget.customer.getCovidVaccineConvert));
    }
    if (widget.customer.getPersonality.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.extension_outlined, widget.customer.getPersonalityConvert));
    }
    if (widget.customer.getCommunicationType.isNotEmpty) {
      childs.add(_smailImageText(Icons.question_answer_outlined,
          widget.customer.getCommunicationTypeConvert));
    }

    if (widget.customer.getLoveStyle.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.favorite_outline, widget.customer.getLoveStyleConvert));
    }

    return Column(
      children: [
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            border: Border.all(color: ThemeUtils.borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: ThemeDimen.paddingSmall),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(S.current.basics, style: ThemeUtils.getTextMediumStyle(fontSize: 13.toWidthRatio())),
              ),
              SizedBox(height: ThemeDimen.paddingSmall),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                child: Wrap(
                  children: [
                    ...List.generate(childs.length, (index) => childs[index]),
                  ],
                ),
              ),
              SizedBox(height: ThemeDimen.paddingSmall),
            ],
          ),
        ),
        SizedBox(height: ThemeDimen.paddingNormal),
      ],
    );
  }

  Widget _lifestyleWidget() {
    if (widget.customer.getPetConvert.isEmpty &&
        widget.customer.getDrinkingConvert.isEmpty &&
        widget.customer.getSmokingConvert.isEmpty &&
        widget.customer.getWorkoutConvert.isEmpty &&
        widget.customer.getDietaryPreferenceConvert.isEmpty &&
        widget.customer.getSocialMediaConvert.isEmpty &&
        widget.customer.getSleepingHabitConvert.isEmpty) {
      return const SizedBox();
    }

    List<Widget> childs = [];
    if (widget.customer.getPetConvert.isNotEmpty) {
      childs.add(
          _smailImageText(Icons.pets_outlined, widget.customer.getPetConvert));
    }
    if (widget.customer.getDrinkingConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.coffee_outlined, widget.customer.getDrinkingConvert));
    }
    if (widget.customer.getSmokingConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.smoking_rooms_outlined, widget.customer.getSmokingConvert));
    }
    if (widget.customer.getWorkoutConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.fitness_center_outlined, widget.customer.getWorkoutConvert));
    }
    if (widget.customer.getDietaryPreferenceConvert.isNotEmpty) {
      childs.add(_smailImageText(Icons.local_pizza_outlined,
          widget.customer.getDietaryPreferenceConvert));
    }
    if (widget.customer.getSocialMediaConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.alternate_email, widget.customer.getSocialMediaConvert));
    }
    if (widget.customer.getSleepingHabitConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.hotel_outlined, widget.customer.getSleepingHabitConvert));
    }

    return Column(
      children: [
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            border: Border.all(color: ThemeUtils.borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: ThemeDimen.paddingSmall),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:
                    Text(S.current.lifestyle, style: ThemeUtils.getTextMediumStyle(fontSize: 13.toWidthRatio())),
              ),
              SizedBox(height: ThemeDimen.paddingSmall),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
                child: Wrap(
                  children: [
                    ...List.generate(childs.length, (index) => childs[index]),
                  ],
                ),
              ),
              SizedBox(height: ThemeDimen.paddingSmall),
            ],
          ),
        ),
        SizedBox(height: ThemeDimen.paddingNormal),
      ],
    );
  }

  Widget _moreInfo() {
    int total = 0;

    if (_displayShortInfo) {
      total += 1;
    }

    if (widget.customer.getListOrientationSexuals.isNotEmpty &&
        widget.customer.showSexual) {
      total += 1;
    }

    if (widget.customer.getJobInCompany.isNotEmpty &&
        widget.customer.profiles.showCommon.showWork) {
      total += 1;
    }

    if (widget.customer.getSchool.isNotEmpty &&
        widget.customer.profiles.showCommon.showSchool) {
      total += 1;
    }

    if (widget.customer.getEducation.isNotEmpty &&
        widget.customer.profiles.showCommon.showEducation) {
      total += 1;
    }

    if (widget.customer.getEthnicities.isNotEmpty &&
        widget.customer.profiles.showCommon.showEthnicity) {
      total += 1;
    }

    if (widget.customer.getListLanguages.isNotEmpty) {
      total += 1;
    }

    if (widget.customer.getListInterests.isNotEmpty) {
      total += 1;
    }

    if (total == 0) {
      return const SizedBox();
    }

    int tempIndex = 0;
    List<Widget> childs = [];

    if (_displayShortInfo) {
      tempIndex += 1;
      childs.add(_shortInfo(total > 1));
    }

    if (widget.customer.getListOrientationSexuals.isNotEmpty &&
        widget.customer.showSexual) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icSexualProfile,
              widget.customer.getListOrientationSexualsConvert.join(", ")),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (widget.customer.getJobInCompany.isNotEmpty &&
        widget.customer.profiles.showCommon.showWork) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(
              AppImages.icCompanyProfile, widget.customer.getJobInCompany),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (widget.customer.getSchool.isNotEmpty &&
        widget.customer.profiles.showCommon.showSchool) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icSchoolInfo, widget.customer.getSchool),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (widget.customer.getEducation.isNotEmpty &&
        widget.customer.profiles.showCommon.showEducation) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(
              AppImages.icInfoSchool, widget.customer.getEducationConvert),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (widget.customer.getEthnicities.isNotEmpty &&
        widget.customer.profiles.showCommon.showEthnicity) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icEthnicityInfo,
              widget.customer.getEthnicitiesConvert.join(", ")),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (widget.customer.getListLanguages.isNotEmpty) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icLanguageInfo,
              widget.customer.getListLanguagesConvert.join(", ")),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (widget.customer.getListInterests.isNotEmpty) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icInterstInfo,
              widget.customer.getListInterestsConvert.join(", ")),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeUtils.borderColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.symmetric(
          vertical: ThemeDimen.paddingSmall,
          horizontal: ThemeDimen.paddingNormal),
      child: Column(
        children: childs,
      ),
    );
  }

  Widget _datingPurpose() {
    if (widget.customer.getDatingPurpose.isEmpty &&
        widget.customer.getAbout.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ThemeUtils.borderColor,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(
              vertical: ThemeDimen.paddingSmall,
              horizontal: ThemeDimen.paddingNormal),
          child: Column(
            children: [
              if (widget.customer.getAbout.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        widget.customer.getAbout,
                        style: ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio()),
                      ),
                    ),
                  ],
                ),
              if (widget.customer.getDatingPurpose.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        EmojiUtils.getDatingPurposeEmoji(
                            widget.customer.getDatingPurpose),
                        textAlign: TextAlign.center,
                        style: ThemeUtils.getTitleStyle().copyWith(fontSize: 39),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.looking_for,
                          textAlign: TextAlign.left,
                          style: ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio()),
                        ),
                        Text(
                          widget.customer.getDatingPurposeConvert,
                          textAlign: TextAlign.left,
                          style: ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio(),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPrompt(PromptDto prompt) {
    return Stack(
      children: [
        Container(
          width: kImageWidth,
          padding: EdgeInsets.symmetric(
              vertical: ThemeDimen.paddingSmall,
              horizontal: ThemeDimen.paddingTiny),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: widget.customer.getAvatarUrl.isEmpty
                        ? const DefaultUserAvatar()
                        : CachedNetworkImage(
                            cacheKey: widget.customer.getAvatarCacheKeyId,
                            imageUrl: widget.customer.getAvatarUrl,
                            errorWidget: (context, url, error) =>
                                const SizedBox(),
                            placeholder: (context, imageProvider) =>
                                SvgPicture.asset(AppImages.icProfileTab),
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 20,
                              backgroundImage: imageProvider,
                            ),
                          ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: kImageWidth - 56,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        )),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          prompt.getQuestion,
                          style: ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio(), color: Colors.white),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        AutoSizeText(
                          prompt.answer ?? '',
                          style: ThemeUtils.getPopupTitleStyle(fontSize: 16.toWidthRatio(), color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
        if (!widget.isFriend)
          Positioned(
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                if (widget.cardActionHandle != null) {
                  widget.cardActionHandle!(widget.customer, Const.kLikeAction,
                      promptDto: prompt);
                }
              },
              child: SvgPicture.asset(
                AppImages.getButtonLike,
                width: 56.toWidthRatio(),
                height: 56.toWidthRatio(),
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }

  Widget buildImageInfo(String svgName, String text, {bool flexible = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ThemeDimen.paddingSmall,
          horizontal: ThemeDimen.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            svgName,
            width: 22,
            height: 22,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
          const SizedBox(
            width: 8,
          ),
          flexible
              ? Flexible(
                  child: Text(
                    text.toCapitalized,
                    style: ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio()),
                  ),
                )
              : Text(
                  text.toCapitalized,
                  style: ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio()),
                ),
        ],
      ),
    );
  }

  Widget _image(AvatarDto avatar, {bool showThumbnail = true}) {
    //debugPrint("cache display: ${avatar.url.removeQuery}");
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GestureDetector(
            onTap: () {
              //debugPrint("url: ${avatar.url}");
            },
            child: CachedNetworkImage(
              cacheKey: avatar.cacheKeyId,
              fit: BoxFit.cover,
              imageUrl: avatar.url,
              width: kImageWidth,
              height: kImageWidth,
              placeholder: (context, url) {
                return showThumbnail
                    ? CachedNetworkImage(
                        cacheKey: avatar.thumbnail.split('?').first,
                        fit: BoxFit.cover,
                        imageUrl: avatar.thumbnail,
                        width: kImageWidth,
                        height: kImageWidth)
                    : const SizedBox();
              },
              errorWidget: (context, error, stackTrace) {
                return placeHolderView(context);
              },
            ),
          ),
        ),
        if (!widget.isFriend)
          Positioned(
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                if (widget.cardActionHandle != null) {
                  widget.cardActionHandle!(widget.customer, Const.kLikeAction,
                      avatar: avatar);
                }
              },
              child: SvgPicture.asset(
                AppImages.getButtonLike,
                width: 56.toWidthRatio(),
                height: 56.toWidthRatio(),
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }

  Widget placeHolderView(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
      child: Image.asset(
        AppImages.bgBlurImage,
        fit: BoxFit.cover,
        width: context.width,
        height: context.width,
      ),
    );
  }

  Widget errorWidget(context, url, obj) => placeHolderView(context);

  String _onlineLabel(bool onlineNow) {
    if (onlineNow) {
      return S.current.online;
    } else {
      return '';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
