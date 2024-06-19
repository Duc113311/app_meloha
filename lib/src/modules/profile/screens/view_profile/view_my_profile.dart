import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:dating_app/src/utils/emoji_convert.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../../domain/dtos/customers/customers_dto.dart';
import '../../../../domain/dtos/profiles/avatar_dto.dart';
import '../../../../general/constants/app_image.dart';

class ViewMyProfile extends StatefulWidget {
  const ViewMyProfile({super.key});

  @override
  State<ViewMyProfile> createState() => _ViewMyProfileState();
}

class _ViewMyProfileState extends State<ViewMyProfile>
    with SingleTickerProviderStateMixin {
  CustomerDto myCustomer = PrefAssist.getMyCustomer();

  ScrollController scrollController = ScrollController();
  ScrollPhysics scrollPhysics = const ScrollPhysics();

  final kImageWidth = Get.width - ThemeDimen.paddingNormal * 2;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        controller: scrollController,
        physics: scrollPhysics,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${myCustomer.fullname}${myCustomer.profiles!.showCommon?.showAge == true ? ", ${myCustomer.getAge()}" : ""}",
                  style: ThemeUtils.getTitleStyle(),
                ),
                SizedBox(
                  width: ThemeDimen.paddingSmall,
                ),
                SvgPicture.asset(
                  myCustomer.myVerifyImage,
                  width: 30,
                  height: 30,
                ),
                const Spacer(),
              ],
            ),
            Row(
              children: [
                Text(_onlineLabel(myCustomer.onlineNow ?? false),
                    style: TextStyle(
                        fontFamily: ThemeNotifier.fontRegular,
                        fontWeight: FontWeight.normal,
                        fontSize: 14)),
                const Spacer(),
              ],
            ),
            SizedBox(
              height: ThemeDimen.paddingNormal,
            ),
            if (myCustomer.getAvatarModel != null)
              _image(myCustomer.getAvatarModel!),
            SizedBox(
              height: myCustomer.getListPrompts.isNotEmpty
                  ? ThemeDimen.paddingNormal
                  : 0,
            ),
            if (myCustomer.getListPrompts.isNotEmpty)
              buildPrompt(myCustomer.getListPrompts.first),
            SizedBox(
              height: ThemeDimen.paddingNormal,
            ),
            _moreInfo(),
            _datingPurpose(),
            SizedBox(
              height: ThemeDimen.paddingBig,
            ),
            _juniorImages(),
            if (myCustomer.getListPrompts.length > 1)
              buildPrompt(myCustomer.getListPrompts[1]),
            _basicWidget(),
            _middleImages(),
            if (myCustomer.getListPrompts.length > 2)
              buildPrompt(myCustomer.getListPrompts[2]),
            _lifestyleWidget(),
            _seniorImages(),
          ],
        ),
      ),
    );
  }

  ShowCommonDto get _showCommon {
    return myCustomer.profiles!.showCommon!;
  }

  bool get _displayShortInfo {
    return !((myCustomer.getGender.isEmpty || !_showCommon.showGender) &&
        (myCustomer.getHeight != -1 || !_showCommon.showHeight) &&
        (myCustomer.getFirstAddress.isEmpty) &&
        (myCustomer.getChildrenPlan.isEmpty || !_showCommon.showChildrenPlan) &&
        (myCustomer.getDrug.isEmpty || !_showCommon.showDrug));
  }

  Widget get _horDivider {
    return Container(width: 1, height: 25, color: ThemeUtils.borderColor);
  }

  Widget _shortInfo(bool showLine) {
    if (!_displayShortInfo) {
      return const SizedBox();
    }

    List<Widget> childs = [];

    if (myCustomer.getGender.isNotEmpty && _showCommon.showGender) {
      childs.add(buildImageInfo(
          AppImages.icGenderInfo, myCustomer.getGenderConvert,
          flexible: false));
    }

    if (myCustomer.getHeight != -1 && _showCommon.showHeight) {
      childs.add(Row(
        children: [
          childs.isNotEmpty ? _horDivider : const SizedBox(),
          buildImageInfo(AppImages.icHeightInfo, myCustomer.getHeightInfo,
              flexible: false),
        ],
      ));
    }

    if (myCustomer.getFirstAddress.isNotEmpty) {
      childs.add(Row(
        children: [
          childs.isNotEmpty ? _horDivider : const SizedBox(),
          buildImageInfo(AppImages.icLocationInfo, myCustomer.getFirstAddress,
              flexible: false),
        ],
      ));
    }

    if (myCustomer.getChildrenPlan.isNotEmpty && _showCommon.showChildrenPlan) {
      childs.add(Row(
        children: [
          childs.isNotEmpty ? _horDivider : const SizedBox(),
          buildImageInfo(
              AppImages.icChildrenPlan, myCustomer.getChildrenPlanConvert,
              flexible: false),
        ],
      ));
    }

    if (myCustomer.getDrug.isNotEmpty && _showCommon.showDrug) {
      childs.add(Row(
        children: [
          childs.isNotEmpty ? _horDivider : const SizedBox(),
          buildImageInfo(AppImages.icInfoDrug, myCustomer.getDrugConvert,
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
    if (myCustomer.getListAvatarModels.length <= 1) {
      return const SizedBox();
    }
    List<Widget> childs = [];

    childs.add(_image(myCustomer.getListAvatarModels[1]));
    childs.add(SizedBox(
      height: ThemeDimen.paddingBig,
    ));

    if (myCustomer.getListAvatarModels.length > 2) {
      childs.add(_image(myCustomer.getListAvatarModels[2]));
      childs.add(SizedBox(
        height: ThemeDimen.paddingBig,
      ));
    }

    return Column(
      children: childs,
    );
  }

  Widget _middleImages() {
    if (myCustomer.getListAvatarModels.length <= 3) {
      return const SizedBox();
    }
    List<Widget> childs = [];

    childs.add(_image(myCustomer.getListAvatarModels[3]));
    childs.add(SizedBox(
      height: ThemeDimen.paddingBig,
    ));

    return Column(
      children: childs,
    );
  }

  Widget _seniorImages() {
    if (myCustomer.getListAvatarModels.length <= 4) {
      return const SizedBox();
    }
    List<Widget> childs = [];

    childs.add(_image(myCustomer.getListAvatarModels[4]));
    childs.add(SizedBox(
      height: ThemeDimen.paddingBig,
    ));

    if (myCustomer.getListAvatarModels.length > 5) {
      childs.add(_image(myCustomer.getListAvatarModels[5]));
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
    if (myCustomer.getZodiac.isEmpty &&
        myCustomer.getFamilyPlan.isEmpty &&
        myCustomer.getCovidVaccine.isEmpty &&
        myCustomer.getPersonality.isEmpty &&
        myCustomer.getCommunicationType.isEmpty &&
        myCustomer.getLoveStyle.isEmpty) {
      return const SizedBox();
    }

    List<Widget> childs = [];
    if (myCustomer.getZodiac.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.nights_stay_outlined, myCustomer.getZodiacConvert));
    }
    if (myCustomer.getFamilyPlan.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.family_restroom_outlined, myCustomer.getFamilyPlanConvert));
    }
    if (myCustomer.getCovidVaccine.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.coronavirus_outlined, myCustomer.getCovidVaccineConvert));
    }
    if (myCustomer.getPersonality.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.extension_outlined, myCustomer.getPersonalityConvert));
    }
    if (myCustomer.getCommunicationType.isNotEmpty) {
      childs.add(_smailImageText(Icons.question_answer_outlined,
          myCustomer.getCommunicationTypeConvert));
    }

    if (myCustomer.getLoveStyle.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.favorite_outline, myCustomer.getLoveStyleConvert));
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
    if (myCustomer.getPetConvert.isEmpty &&
        myCustomer.getDrinkingConvert.isEmpty &&
        myCustomer.getSmokingConvert.isEmpty &&
        myCustomer.getWorkoutConvert.isEmpty &&
        myCustomer.getDietaryPreferenceConvert.isEmpty &&
        myCustomer.getSocialMediaConvert.isEmpty &&
        myCustomer.getSleepingHabitConvert.isEmpty) {
      return const SizedBox();
    }

    List<Widget> childs = [];
    if (myCustomer.getPetConvert.isNotEmpty) {
      childs
          .add(_smailImageText(Icons.pets_outlined, myCustomer.getPetConvert));
    }
    if (myCustomer.getDrinkingConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.coffee_outlined, myCustomer.getDrinkingConvert));
    }
    if (myCustomer.getSmokingConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.smoking_rooms_outlined, myCustomer.getSmokingConvert));
    }
    if (myCustomer.getWorkoutConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.fitness_center_outlined, myCustomer.getWorkoutConvert));
    }
    if (myCustomer.getDietaryPreferenceConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.local_pizza_outlined, myCustomer.getDietaryPreferenceConvert));
    }
    if (myCustomer.getSocialMediaConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.alternate_email, myCustomer.getSocialMediaConvert));
    }
    if (myCustomer.getSleepingHabitConvert.isNotEmpty) {
      childs.add(_smailImageText(
          Icons.hotel_outlined, myCustomer.getSleepingHabitConvert));
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

    if (myCustomer.getListOrientationSexuals.isNotEmpty &&
        myCustomer.showSexual) {
      total += 1;
    }

    if (myCustomer.getJobInCompany.isNotEmpty &&
        myCustomer.profiles.showCommon.showWork) {
      total += 1;
    }

    if (myCustomer.getSchool.isNotEmpty &&
        myCustomer.profiles.showCommon.showSchool) {
      total += 1;
    }

    if (myCustomer.getEducation.isNotEmpty &&
        myCustomer.profiles.showCommon.showEducation) {
      total += 1;
    }

    if (myCustomer.getEthnicities.isNotEmpty &&
        myCustomer.profiles.showCommon.showEthnicity) {
      total += 1;
    }

    if (myCustomer.getListLanguages.isNotEmpty) {
      total += 1;
    }

    if (myCustomer.getListInterests.isNotEmpty) {
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

    if (myCustomer.getListOrientationSexuals.isNotEmpty &&
        myCustomer.showSexual) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icSexualProfile,
              myCustomer.getListOrientationSexualsConvert.join(", ")),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (myCustomer.getJobInCompany.isNotEmpty &&
        myCustomer.profiles.showCommon.showWork) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(
              AppImages.icCompanyProfile, myCustomer.getJobInCompany),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (myCustomer.getSchool.isNotEmpty &&
        myCustomer.profiles.showCommon.showSchool) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icSchoolInfo, myCustomer.getSchool),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (myCustomer.getEducation.isNotEmpty &&
        myCustomer.profiles.showCommon.showEducation) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(
              AppImages.icInfoSchool, myCustomer.getEducationConvert),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (myCustomer.getEthnicities.isNotEmpty &&
        myCustomer.profiles.showCommon.showEthnicity) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icEthnicityInfo,
              myCustomer.getEthnicitiesConvert.join(", ")),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (myCustomer.getListLanguages.isNotEmpty) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icLanguageInfo,
              myCustomer.getListLanguagesConvert.join(", ")),
          if (tempIndex < total)
            Divider(
              color: ThemeUtils.borderColor,
            ),
        ],
      ));
    }

    if (myCustomer.getListInterests.isNotEmpty) {
      tempIndex += 1;
      childs.add(Column(
        children: [
          buildImageInfo(AppImages.icInterstInfo,
              myCustomer.getListInterestsConvert.join(", ")),
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
    if (myCustomer.getDatingPurpose.isEmpty && myCustomer.getAbout.isEmpty) {
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
              if (myCustomer.getAbout.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        myCustomer.getAbout,
                        style: ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio(),),
                      ),
                    ),
                  ],
                ),
              if (myCustomer.getDatingPurpose.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        EmojiUtils.getDatingPurposeEmoji(
                            myCustomer.getDatingPurpose),
                        textAlign: TextAlign.center,
                        style: ThemeUtils.getTitleStyle(fontSize: 39.toWidthRatio()),
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
                          style: ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio(),),
                        ),
                        Text(
                          myCustomer.getDatingPurposeConvert,
                          textAlign: TextAlign.left,
                          style: ThemeUtils.getTitleStyle(fontSize: 13.toWidthRatio()),
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
                    child: CachedNetworkImage(
                      imageUrl: myCustomer.getThumbnailAvatarUrl,
                      errorWidget: (context, url, error) => const SizedBox(),
                      placeholder: (context, imageProvider) =>
                          SvgPicture.asset(AppImages.icProfileTab),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
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
        Positioned(
          right: 0,
          bottom: 0,
          child: InkWell(
            onTap: () {},
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
                  style:
                      ThemeUtils.getTextStyle(fontSize: 13.toWidthRatio()),
                ),
        ],
      ),
    );
  }

  Widget _image(AvatarDto avatar) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: GestureDetector(
            onTap: () {
              print("url: ${avatar.url}");
            },
            child: CachedNetworkImage(
              cacheKey: avatar.cacheKeyId,
              fadeInDuration: const Duration(milliseconds: 100),
              fit: BoxFit.cover,
              imageUrl: avatar.url,
              width: kImageWidth,
              height: kImageWidth,
              placeholder: (context, url) {
                return CachedNetworkImage(
                    cacheKey: avatar.thumbnail.removeQuery,
                    fadeOutDuration: const Duration(milliseconds: 100),
                    fadeInDuration: const Duration(milliseconds: 100),
                    fit: BoxFit.cover,
                    imageUrl: avatar.thumbnail,
                    width: kImageWidth,
                    height: kImageWidth);
              },
              errorWidget: (context, error, stackTrace) {
                return placeHolderView(context);
              },
            ),
          ),
        ),
        //child: CachedNetworkImage(imageUrl: imgName)),
        Positioned(
          right: 0,
          bottom: 0,
          child: InkWell(
            onTap: () {},
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
      return S.current.offline;
    }
  }
}
