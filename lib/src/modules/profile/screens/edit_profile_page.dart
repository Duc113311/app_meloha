import 'dart:async';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/components/widgets/dialogs/dating_silver_dialog.dart';
import 'package:dating_app/src/components/widgets/switch_dart.dart';
import 'package:dating_app/src/domain/dtos/customers/customers_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/domain/dtos/profiles/prompt_dto.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/modules/login/info/select_promts_page.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_address.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_basics.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_children.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_drug.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_education.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_ethnitity.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_gender.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_height.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_jobtitle.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_life_styles.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_school.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_sexual_orientation.dart';
import 'package:dating_app/src/modules/profile/screens/edit_profile/screens/components/edit_work.dart';
import 'package:dating_app/src/modules/profile/screens/media/add_new_media.dart';
import 'package:dating_app/src/modules/profile/widget/component_content.dart';
import 'package:dating_app/src/modules/profile/widget/component_header.dart';
import 'package:dating_app/src/requests/api_update_profile_setting.dart';
import 'package:dating_app/src/requests/auth_services.dart';
import 'package:dating_app/src/utils/cache_image_manager.dart';
import 'package:dating_app/src/utils/change_notifiers/edit_profile_notifier.dart';
import 'package:dating_app/src/utils/change_notifiers/verify_account_notifier.dart';
import 'package:dating_app/src/utils/emoji_convert.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:uuid/uuid.dart';

import '../../../components/bloc/static_info/static_info_data.dart';
import 'edit_profile/screens/components/edit_dating_purpose.dart';
import 'edit_profile/screens/components/edit_interest.dart';
import 'edit_profile/screens/components/edit_languages.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage(
      {super.key,
      required this.showLoading});

  final bool showLoading;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        WidgetsBindingObserver {
  bool isHaveLoading = false;
  bool popupShowing = false;
  bool isChanging = false;

  final _scrollController = ScrollController();
  var _gridViewKey = GlobalKey();

  List<int> loadingCells = [];
  List<AvatarDto> _currentImages =
      PrefAssist.getMyCustomer().getListAvatarModels;
  List<PromptDto> myPrompts =
      PrefAssist.getMyCustomer().profiles?.prompts ?? [];

  //check current
  final TextEditingController _aboutMeController =
      TextEditingController(text: PrefAssist.getMyCustomer().profiles?.about);
  final TextEditingController _jobEditingController = TextEditingController(
      text: PrefAssist.getMyCustomer().profiles?.jobTitle);
  final TextEditingController _companyEditingController =
      TextEditingController(text: PrefAssist.getMyCustomer().profiles?.company);
  final TextEditingController _schoolEditingController =
      TextEditingController(text: PrefAssist.getMyCustomer().profiles?.school);
  final TextEditingController _livingEditingController =
      TextEditingController(text: PrefAssist.getMyCustomer().profiles?.address);

  CustomerDto currentUser = PrefAssist.getMyCustomer();
  int selectedImageIndex = 0;
  bool _animationLoaded = false;
  bool showLoading = false;

  @override
  void initState() {
    showLoading = widget.showLoading;
    super.initState();

    if (widget.showLoading) {
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          _animationLoaded = true;
        });
      });
    }

    VerifyAccountNotifier.shared.addListener(() async {
      if(mounted) {
        setState(() {
          currentUser = PrefAssist.getMyCustomer();
          _currentImages =
              PrefAssist.getMyCustomer().getListAvatarModels;
          _gridViewKey = GlobalKey();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          key: const Key("_editProfile"),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _gridImagesWidget(),
                const SizedBox(height: 32),
                _photoOptionWidget(),
                _addPrompt(),
                _aboutMeWidget(),
                _interestsWidget(),
                _relationshipGoalsWidget(),
                _languagesIKnowWidget(),
                _basicsWidget(),
                _lifestyleWidget(),
                Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          S.current.txt_my_persional_info,
                          style: ThemeUtils.getTextStyle(
                              fontSize: 15.toWidthRatio()),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _commonCellWidget(
                    S.current.txt_school,
                    currentUser.getSchool.isEmpty
                        ? S.current.txt_add_a_school
                        : currentUser.getSchool,
                    currentUser.getSchool.isEmpty
                        ? "+${Const.kCustomerMaxPercentSchool}%"
                        : currentUser.profiles!.showCommon.showSchool
                            ? S.current.txt_visible
                            : S.current.txt_hidden, () async {
                  await RouteService.routeGoOnePage(const EditSchoolPage());

                  setState(() {});
                }),
                _commonCellWidget(
                    S.current.profile_edit_job_title,
                    currentUser.getJobTitle.isEmpty
                        ? S.current.profile_edit_job_title
                        : currentUser.getJobTitle,
                    currentUser.getJobTitle.isEmpty
                        ? "+${Const.kCustomerMaxPercentJobTitle}%"
                        : '', () async {
                  await RouteService.routeGoOnePage(const EditJobTitlePage());

                  setState(() {});
                }),
                _commonCellWidget(
                    S.current.profile_edit_company,
                    currentUser.getCompany.isEmpty
                        ? S.current.profile_edit_company
                        : currentUser.getCompany,
                    currentUser.getCompany.isEmpty
                        ? "+${Const.kCustomerMaxPercentCompany}%"
                        : currentUser.profiles!.showCommon.showWork
                            ? S.current.txt_visible
                            : S.current.txt_hidden, () async {
                  await RouteService.routeGoOnePage(const EditWorkPage());

                  setState(() {});
                }),
                _commonCellWidget(
                    S.current.profile_edit_living_in,
                    currentUser.getAddress.isEmpty
                        ? S.current.profile_edit_living_in
                        : currentUser.getAddress,
                    currentUser.getAddress.isEmpty
                        ? "+${Const.kCustomerMaxPercentAddress}%"
                        : '', () async {
                  await RouteService.routeGoOnePage(const EditAddressPage());

                  setState(() {});
                }),
                _commonCellWidget(
                    S.current.txt_height,
                    currentUser.getHeight == -1
                        ? S.current.txt_not_answered_yet
                        : currentUser.getHeightValue,
                    currentUser.profiles!.showCommon.showHeight
                        ? S.current.txt_visible
                        : S.current.txt_hidden, () async {
                  await RouteService.routeGoOnePage(const EditHeight());
                  setState(() {});
                }),
                _commonCellWidget(
                    S.current.txt_childrens,
                    currentUser.getChildrenPlan.isEmpty
                        ? S.current.txt_not_answered_yet
                        : currentUser.getChildrenPlanConvert,
                    currentUser.profiles!.showCommon.showChildrenPlan
                        ? S.current.txt_visible
                        : S.current.txt_hidden, () async {
                  await RouteService.routeGoOnePage(const EditChildren());
                  setState(() {});
                }),
                _commonCellWidget(
                    S.current.profile_edit_gender,
                    currentUser.getGenderValue.isEmpty
                        ? S.current.txt_not_answered_yet
                        : currentUser.getGenderValue,
                    currentUser.profiles!.showCommon.showGender
                        ? S.current.txt_visible
                        : S.current.txt_hidden, () async {
                  await RouteService.routeGoOnePage(const EditGender());
                  setState(() {});
                }),
                _commonCellWidget(
                    S.current.txt_ethnicity,
                    currentUser.getEthnicities.isEmpty
                        ? S.current.txt_not_answered_yet
                        : currentUser.getEthnicitiesConvert.join(", "),
                    currentUser.profiles!.showCommon.showEthnicity
                        ? S.current.txt_visible
                        : S.current.txt_hidden, () async {
                  await RouteService.routeGoOnePage(const EditEthnicity());
                  setState(() {});
                }),
                _commonCellWidget(
                    S.current.txt_drugs,
                    currentUser.getDrug.isEmpty
                        ? S.current.txt_not_answered_yet
                        : currentUser.getDrugConvert,
                    currentUser.profiles!.showCommon.showDrug
                        ? S.current.txt_visible
                        : S.current.txt_hidden, () async {
                  await RouteService.routeGoOnePage(const EditDrug());
                  setState(() {});
                }),
                _commonCellWidget(
                    S.current.profile_edit_school,
                    currentUser.getEducation.isEmpty
                        ? S.current.txt_not_answered_yet
                        : currentUser.getEducationConvert,
                    currentUser.profiles!.showCommon.showEducation
                        ? S.current.txt_visible
                        : S.current.txt_hidden, () async {
                  await RouteService.routeGoOnePage(const EditEducation());
                  setState(() {});
                }),
                _sexualOrientationWidget(),
                _controlProfileWidget(),
                SizedBox(height: ThemeDimen.paddingBig),
              ],
            ),
          ),
        ),
        if (popupShowing)
          Container(
            color: ThemeUtils.getTextColor().withOpacity(0.39),
            width: Get.width,
            height: double.infinity,
          ),
        AnimatedPositioned(
            bottom: popupShowing
                ? (Get.height / 2) - (Get.height / 3)
                : Get.height + 200,
            left: (Get.width / 2) - (Get.width * 0.45),
            width: Get.width * 0.9,
            curve: Curves.bounceOut,
            duration: const Duration(milliseconds: 900),
            child: Container(
              decoration: BoxDecoration(
                color: ThemeUtils.getScaffoldBackgroundColor(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: Get.width * 0.39,
                    width: Get.width * 0.39,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CacheImageView(
                        fit: BoxFit.cover,
                        imageURL: currentUser
                            .getListAvatarThumbnailUrls[selectedImageIndex],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      isChanging
                          ? S.current.txt_change_verify_image_title
                          : S.current.txt_delete_verify_image_title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ThemeUtils.getTextColor(),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      isChanging
                          ? S.current.txt_change_verify_image_message
                          : S.current.txt_delete_verify_image_message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ThemeUtils.getTextColor(),
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(ThemeDimen.paddingSuper, 16,
                        ThemeDimen.paddingSuper, 8),
                    child: WidgetGenerator.getRippleButton(
                      colorBg: Colors.red,
                      buttonHeight: ThemeDimen.buttonHeightNormal,
                      buttonWidth: double.infinity,
                      borderRadius: ThemeDimen.buttonHeightNormal / 2,
                      onClick: () {
                        setState(() {
                          popupShowing = false;
                        });
                        Future.delayed(const Duration(milliseconds: 1000));
                        if (isChanging) {
                          _onChangeImage(selectedImageIndex,
                              removeVerified: true);
                        } else {
                          _onDeleteImage(selectedImageIndex,
                              removeVerified: true);
                        }
                        isChanging = false;
                      },
                      child: Center(
                        child: Text(
                          isChanging
                              ? S.current.txt_change_image
                              : S.current.txt_delete_image.toUpperCase(),
                          style: ThemeUtils.getTitleStyle(
                              color: ThemeUtils.getTextButtonColor(),
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        ThemeDimen.paddingSuper, 4, ThemeDimen.paddingSuper, 4),
                    child: WidgetGenerator.getRippleButton(
                      colorBg: Colors.transparent,
                      buttonHeight: ThemeDimen.buttonHeightNormal,
                      buttonWidth: double.infinity,
                      onClick: () {
                        setState(() {
                          popupShowing = false;
                        });
                        isChanging = false;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    ThemeUtils.getTextColor().withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(
                                ThemeDimen.buttonHeightNormal / 2)),
                        child: Center(
                          child: Text(
                            S.current.str_cancel.toUpperCase(),
                            style: ThemeUtils.getTitleStyle(
                              color: ThemeUtils.getTextColor(),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            )),
        if (!_animationLoaded && showLoading)
          Container(
            color: ThemeUtils.getScaffoldBackgroundColor(),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }

  Widget _componentHeader(String title, [int percent = 0]) {
    return ComponentHeader(
      title: title,
      percent: percent,
    );
  }

  Widget _componentContent(
      {IconData? iconData,
      String? stringSvgIcon,
      String contentPrefix = '',
      String contentSuffix = '',
      bool isShowArrowIcon = false,
      bool isShowCheckIcon = false,
      double? textSize,
      Color? color,
      TextStyle? prefixStyle}) {
    return ComponentContent(
      iconData: iconData,
      stringSvgIcon: stringSvgIcon,
      contentPrefix: contentPrefix,
      contentSuffix: contentSuffix,
      isShowArrowIcon: isShowArrowIcon,
      isShowCheckIcon: isShowCheckIcon,
      textSize: textSize,
      iconColor: color,
      prefixStyle: prefixStyle,
    );
  }

  Widget _gridImagesWidget() {
    return SizedBox(
      height: ((context.width / 3)) * 2,
      child: ReorderableGridView.count(
        key: Key(_gridViewKey.toString()),
        onDragStart: (index) {},
        onDragUpdate: (int dragIndex, Offset position, Offset delta) {},
        crossAxisSpacing: ThemeDimen.paddingTiny,
        mainAxisSpacing: ThemeDimen.paddingTiny,
        crossAxisCount: 3,
        children: List.generate(Const.kMaxImageNumber, (index) {
          if (index < _currentImages.length) {
            return SizedBox(
              key: Key(_currentImages[index].url.toString()),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(ThemeDimen.paddingTiny),
                    child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(ThemeDimen.borderRadiusNormal),
                      child: CacheImageView(
                        width: context.width / 3,
                        height: context.width / 3,
                        imageURL: _currentImages[index].thumbnail,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (loadingCells.contains(index)) {
                        return;
                      }
                      _showBottomSheet(index);
                    },
                    child: _currentImages[index].reviewerStatus == 2
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                          ThemeDimen.borderRadiusNormal),
                      child: Container(
                        color: Colors.red.withOpacity(0.7),
                        child: Center(
                          child: Text(
                            S.current.txt_rejected,
                            style: ThemeUtils.getTitleStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                        : Container(
                      width: context.width / 3,
                      height: context.width / 3,
                      color: Colors.transparent,
                    ),
                  ),
                  if (_currentImages.length > Const.kNumberOfImagesRequired)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        child: SvgPicture.asset(
                          AppImages.icDeleteImage,
                          width: 30,
                          height: 30,
                        ),
                        onTap: () async {
                          if (loadingCells.contains(index)) {
                            return;
                          }
                          _showBottomSheet(index);
                        },
                      ),
                    ),
                  if (loadingCells.contains(index))
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            );
          } else {
            return Stack(
              key: ValueKey(index),
              children: [
                Container(
                  child: WidgetGenerator.getRippleButton(
                    colorBg: ThemeUtils.getShadowColor(),
                    buttonWidth: double.infinity,
                    onClick: () {
                      if (loadingCells.contains(index) ||
                          _currentImages.length >= Const.kMaxImageNumber) {
                        return;
                      }
                      final maxIndex = loadingCells.isNotEmpty
                          ? loadingCells.last + 1
                          : _currentImages.length;
                      _onAddImageClick(maxIndex);
                    },
                    child: Container(
                      padding: EdgeInsets.all(ThemeDimen.paddingSmall),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImages.icAddImage,
                          height: 30,
                          width: 30,
                          colorFilter: ColorFilter.mode(
                              ThemeUtils.getCaptionColor(), BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
                if (loadingCells.contains(index))
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          }
        }),
        onReorder: (oldIndex, newIndex) {
          final inValid = oldIndex >= _currentImages.length || newIndex >= _currentImages.length;

          if (inValid) {
            setState(() {});
            return;
          }

          final image = _currentImages.removeAt(oldIndex);
          _currentImages.insert(newIndex, image);

          EditProfileNotifier.shared.updateProfile();
          setState(() {});
        },
      ),
    );
  }

  Future _onDeleteImage(int index, {bool removeVerified = false}) async {

    final avatar = _currentImages[index];
    final imageUrl = avatar.url;
    final thumbnailUrl = avatar.thumbnail;
    setState(() {
      _currentImages.removeAt(index);
      currentUser.profiles!.avatars = _currentImages;
      selectedImageIndex = 0;
    });

    if (removeVerified) {
      PrefAssist.getMyCustomer().explore?.verified = Const.kVerifyAccountNewly;
    }

    await PrefAssist.saveMyCustomer();
    final code = await ApiProfileSetting.updateMyCustomerProfile();
    debugPrint("update image: $code");
    _deleteFirebaseImage([imageUrl, thumbnailUrl]);

    EditProfileNotifier.shared.updateProfile();
  }

  Future<void> _deleteFirebaseImage(List<String> imageUrls) async {
    for (String url in imageUrls) {
      AuthServices().deleteImage(url);
    }
  }

  Future _onChangeImage(int index, {bool removeVerified = false}) async {
    _onAddImageClick(index, isChange: true, removeVerified: removeVerified);
  }

  Future _onCheckChangeImage(int index) async {
    final allVerifies = currentUser.getListAvatarModels
        .where((element) => element.getVerified)
        .toList()
        .length;

    final avatar = _currentImages[index];
    if (avatar.getVerified && allVerifies == 1) {
      setState(() {
        isChanging = true;
        popupShowing = true;
        selectedImageIndex = index;
      });
    } else {
      _onChangeImage(index);
    }
  }

  Future _onCheckDeleteImage(int index) async {
    final allVerifies = currentUser.getListAvatarModels
        .where((element) => element.getVerified)
        .toList()
        .length;

    final avatar = _currentImages[index];
    if (avatar.getVerified && allVerifies == 1) {
      setState(() {
        isChanging = false;
        popupShowing = true;
        selectedImageIndex = index;
      });
    } else {
      _onDeleteImage(index);
    }
  }

  Future _showBottomSheet(int index) async {
    List<BottomSheetAction> actions = [];

    if (currentUser.getListAvatarModels.length >
        Const.kNumberOfImagesRequired) {
      final delete = BottomSheetAction(
          leading: const Icon(Icons.delete_forever),
          title: Text(
            S.current.txt_delete_image,
            textAlign: TextAlign.start,
            style: ThemeUtils.getTextStyle(),
          ),
          onPressed: (aContext) {
            Navigator.pop(aContext);
            _onCheckDeleteImage(index);
          });

      actions.add(delete);
    }

    final replace = BottomSheetAction(
        leading: const Icon(Icons.replay),
        title: Text(
          S.current.txt_change_image,
          textAlign: TextAlign.start,
          style: ThemeUtils.getTextStyle(),
        ),
        onPressed: (aContext) {
          Navigator.pop(aContext);
          _onCheckChangeImage(index);
        });
    actions.add(replace);

    showAdaptiveActionSheet(
      bottomSheetColor: ThemeUtils.getScaffoldBackgroundColor(),
      context: context,
      androidBorderRadius: 30,
      actions: actions,
      cancelAction: Platform.isIOS
          ? CancelAction(title: Text(S.current.str_cancel))
          : null,
    );
  }

  Future _onAddImageClick(int index,
      {bool isChange = false, bool removeVerified = false}) async {
    final result = await RouteService.routeGoOnePage(const AddNewMedia());

    if (result is File) {
      setState(() {
        loadingCells.add(index);
      });
      BHCacheImageManager.shared().pauseCache();
      final imageUrl = await AuthServices().uploadMedia(
          result, FireStorePathType.profiles, ProfilePathType.images);
      debugPrint("imageUrl: $imageUrl");

      final image = img.decodeImage(result.readAsBytesSync())!;
      if (image.width <= Get.width || image.height <= Get.height) {
        uploadCompletedHandle(imageUrl, imageUrl, index,
            isChange: isChange, removeVerified: removeVerified);
      } else {
        final thumbnailWidth = Get.width;
        final heightRatio = (image.height) / (image.width);
        final imageHeight = thumbnailWidth * heightRatio;

        img.Image resizedImage = img.copyResize(image,
            height: imageHeight.toInt(), width: thumbnailWidth.toInt());

        final bytes = img.encodeJpg(resizedImage);

        String tempPath = (await getTemporaryDirectory()).path;
        final thumbnailName = "${const Uuid().v1()}.jpg";
        File resizedFile = File('$tempPath/$thumbnailName')
          ..writeAsBytesSync(bytes);

        final thumbnailUrl = await AuthServices().uploadMedia(
            resizedFile, FireStorePathType.profiles, ProfilePathType.images,
            child: ChildProfilePathType.thumbnails);

        debugPrint("thumbnailUrl: $thumbnailUrl");
        uploadCompletedHandle(imageUrl, thumbnailUrl, index,
            isChange: isChange, removeVerified: removeVerified);
      }
    } else {
      debugPrint("Khong phai anh");
    }
  }

  Future<void> uploadCompletedHandle(
      String? url, String? thumbnailUrl, int index,
      {bool isChange = false, bool removeVerified = false}) async {
    if (url != null) {
      final meta = ImageMetaDto(url: url!, thumbnails: [thumbnailUrl ?? url!]);

      final avatarModel =
          AvatarDto(meta: meta, reviewerViolateOption: [], aiViolateOption: []);

      String deleteImageUrl = '';
      String deleteThumbnailUrl = '';

      if (isChange) {
        deleteImageUrl = _currentImages[index].url;
        deleteThumbnailUrl = _currentImages[index].thumbnail;
      }

      setState(() {
        if (isChange) {
          _currentImages[index] = avatarModel;
        } else {
          _currentImages.add(avatarModel);
        }
        loadingCells.removeWhere((element) => element == index);
      });

      if (removeVerified) {
        PrefAssist.getMyCustomer().explore?.verified =
            Const.kVerifyAccountNewly;
      }
      PrefAssist.getMyCustomer().profiles!.avatars = _currentImages;

      await PrefAssist.saveMyCustomer();

      final code = await ApiProfileSetting.updateMyCustomerProfile();
      debugPrint("update image: $code");

      EditProfileNotifier.shared.updateProfile();

      if (deleteThumbnailUrl.isNotEmpty) {
        _deleteFirebaseImage([deleteImageUrl, deleteThumbnailUrl]);
      }
      BHCacheImageManager.shared().continueCacheIfNeed();
    } else {
      debugPrint("upload anh fail");
      setState(() {
        loadingCells.removeWhere((element) => element == index);
      });
    }
  }

  Widget _photoOptionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ThemeDimen.paddingNormal),
        _btnRipple(
            borderColor: ThemeUtils.colorGrey1(),
            borderRadius: 12.toWidthRatio(),
            onClick: () {
              currentUser.profiles.smartPhoto =
                  !currentUser.profiles.smartPhoto!;
              setState(() {});
            },
            contentPrefix: S.current.profile_edit_smart_photo,
            valSwitch: currentUser.profiles!.smartPhoto!,
            prefixStyle: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio())),
        SizedBox(height: ThemeDimen.paddingSmall),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingSmall),
          child: Text(
            S.current.profile_edit_smart_photo_note,
            style: ThemeUtils.getCaptionStyle(),
          ),
        ),
        SizedBox(height: ThemeDimen.paddingNormal),
      ],
    );
  }

  Widget _addPrompt() {
    final missingPrompts =
        AppConstants.MAX_NUMBER_PROMPT - currentUser.getListPrompts.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: ThemeDimen.paddingSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              S.current.txt_write_your_profile_answers.toCapitalized,
              style: ThemeUtils.getHeaderStyle(),
            ),
            if (missingPrompts > 0)
              Text(
                ' ($missingPrompts)',
                style: ThemeUtils.getTextStyle(
                    color: ThemeUtils.headerColor(),
                    fontSize: 14.toWidthRatio()),
              ),
          ],
        ),
        SizedBox(height: ThemeDimen.paddingNormal),
        ListView.builder(
          reverse: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: AppConstants.MAX_NUMBER_PROMPT,
          itemBuilder: (context, index) {
            return Column(
              children: [
                DottedBorder(
                  color: ThemeUtils.borderColor,
                  strokeWidth: 1,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 10],
                  borderType: BorderType.RRect,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        _addPromptHandle(index);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      AutoSizeText(
                                        (index < myPrompts.length)
                                            ? StaticInfoManager.shared()
                                                .convertPrompt(myPrompts[index]
                                                    .codePrompt!)
                                            : S.current.txt_select_a_prompt,
                                        style: TextStyle(
                                            color: ThemeUtils.getCaptionColor(),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.toWidthRatio()),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        (index < myPrompts.length)
                                            ? myPrompts[index].answer!
                                            : S.current
                                                .txt_and_write_your_own_answer,
                                        style: TextStyle(
                                            color: ThemeUtils.color646465,
                                            fontWeight: FontWeight.normal,
                                            fontFamily:
                                                ThemeNotifier.fontRegular,
                                            fontSize: 17),
                                        maxLines: 3,
                                        softWrap: true,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: GestureDetector(
                                onTap: () {
                                  if (index < myPrompts.length) {
                                    _deletePromptHandle(index);
                                  } else {
                                    _addPromptHandle(index);
                                  }
                                },
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: index < myPrompts.length
                                      ? SvgPicture.asset(
                                          AppImages.icDeleteImage,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : SvgPicture.asset(
                                          AppImages.icAddPrompt,
                                          fit: BoxFit.fitWidth,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ThemeDimen.paddingBig),
              ],
            );
          },
        ),
        SizedBox(height: ThemeDimen.paddingNormal),
      ],
    );
  }

  Widget _aboutMeWidget() {
    return Column(
      children: [
        _componentHeader(
            S.current.about_me,
            _aboutMeController.text.isEmpty
                ? Const.kCustomerMaxPercentAbout
                : 0),
        Container(
          decoration: BoxDecoration(
            color: ThemeUtils.getShadowColor(),
            borderRadius:
                BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusSmall)),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 100,
              maxHeight: 200,
            ),
            child: TextField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(ThemeDimen.paddingSmall),
                hintText: S.current.about_me_hint,
                hintStyle: ThemeUtils.getPlaceholderTextStyle(),
              ),
              style: ThemeUtils.getTextFieldLabelStyle(),
              controller: _aboutMeController,
              textAlign: TextAlign.left,
              inputFormatters: [LengthLimitingTextInputFormatter(500)],
              onChanged: (v) async {
                _aboutMeController.text = _aboutMeController.text.removeLines;
                PrefAssist.getMyCustomer().profiles?.about =
                    _aboutMeController.text;
                await PrefAssist.saveMyCustomer();
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _interestsWidget() {
    String textInterests = S.current.txt_add_interests;
    if (PrefAssist.getMyCustomer().getListInterests.isNotEmpty) {
      textInterests =
          PrefAssist.getMyCustomer().getListInterestsConvert.join(', ');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _componentHeader(
            S.current.interests,
            PrefAssist.getMyCustomer().getListInterests.length < 3
                ? Const.kCustomerMaxPercentInterests
                : 0),
        WidgetGenerator.getRippleButton(
          colorBg: ThemeUtils.getShadowColor(),
          buttonHeight: ThemeDimen.buttonHeightNormal,
          buttonWidth: double.infinity,
          borderRadius: ThemeDimen.borderRadiusSmall,
          onClick: () async {
            await RouteService.routeGoOnePage(const EditInterest());
            setState(() {});
          },
          child: _componentContent(
              contentPrefix: textInterests,
              isShowArrowIcon: true,
              textSize: 15),
        ),
      ],
    );
  }

  Widget _relationshipGoalsWidget() {
    String contentSuffix = S.current.add;
    if (PrefAssist.getMyCustomer().getDatingPurpose.isNotEmpty) {
      contentSuffix =
          '${EmojiUtils.getDatingPurposeEmoji(currentUser.getDatingPurpose)} ${PrefAssist.getMyCustomer().getDatingPurposeConvert}';
    }

    return Column(
      children: [
        _componentHeader(
            S.current.relationship_goals,
            contentSuffix == S.current.add
                ? Const.kCustomerMaxPercentDatingPurpose
                : 0),
        SizedBox(height: ThemeDimen.paddingTiny),
        Container(
          decoration: BoxDecoration(
              color: ThemeUtils.getShadowColor(),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeDimen.borderRadiusSmall))),
          child: _btnSVGScroll(
            () async {
              await showCupertinoModalBottomSheet(
                context: context,
                barrierColor: ThemeColor.modalBackgroundColor,
                builder: (context) {
                  return const Wrap(
                    children: [EditDatingPurpose()],
                  );
                },
              );
              setState(() {});
            },
            AppImages.icLookingforInfo,
            S.current.looking_for,
            contentSuffix,
          ),
        ),
      ],
    );
  }

  Widget _languagesIKnowWidget() {
    String contentSuffix = S.current.add;
    if (PrefAssist.getMyCustomer().getListLanguages.isNotEmpty) {
      final languages = PrefAssist.getMyCustomer().getListLanguagesConvert;
      contentSuffix = languages.length > 2
          ? '${languages.sublist(0, 2).join(", ")}, ...'
          : languages.join(", ");
    }
    return Column(
      children: [
        _componentHeader(
            S.current.languages_i_know,
            contentSuffix == S.current.add
                ? Const.kCustomerMaxPercentLanguages
                : 0),
        Container(
          decoration: BoxDecoration(
              color: ThemeUtils.getShadowColor(),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeDimen.borderRadiusSmall))),
          child: _btnSVGScroll(
            () async {
              List<String> selectedLanguagesCode =
                  List.of(PrefAssist.getMyCustomer().profiles?.languages ?? []);
              await RouteService.routeGoOnePage(EditLanguages(
                selectedLanguagesCode: selectedLanguagesCode,
              ));
              setState(() {});
            },
            AppImages.icLanguageInfo,
            S.current.add_languages,
            contentSuffix,
          ),
        ),
      ],
    );
  }

  Widget _basicsWidget() {
    callEditBasics(String styles) async {
      await RouteService.routeGoOnePage(EditBasics(styles: styles));
      setState(() {});
    }

    final profiles = PrefAssist.getMyCustomer().profiles!;

    String contentSuffixZodiac =
        (profiles?.zodiac != null && profiles.zodiac!.isNotEmpty)
            ? StaticInfoManager.shared().convertZodiac(profiles!.zodiac!)
            : S.current.add;
    String contentSuffixEducation =
        (profiles?.education != null && profiles.education!.isNotEmpty)
            ? StaticInfoManager.shared()
                .convertEducations([profiles!.education!]).first
            : S.current.add;
    String contentSuffixFamilyPlan =
        (profiles?.familyPlan != null && profiles.familyPlan!.isNotEmpty)
            ? StaticInfoManager.shared()
                .convertFamilyPlans([profiles!.familyPlan!]).first
            : S.current.add;
    String contentSuffixCovidVaccine =
        (profiles?.covidVaccine != null && profiles.covidVaccine!.isNotEmpty)
            ? StaticInfoManager.shared()
                .convertCovidVaccines([profiles!.covidVaccine!]).first
            : S.current.add;
    String contentSuffixPersonality =
        (profiles?.personality != null && profiles.personality!.isNotEmpty)
            ? StaticInfoManager.shared()
                .convertPersonalities([profiles!.personality!]).first
            : S.current.add;
    String contentSuffixCommunicationType = (profiles?.communicationType !=
                null &&
            profiles.communicationType!.isNotEmpty)
        ? StaticInfoManager.shared()
            .convertCommunicationStyles([profiles!.communicationType!]).first
        : S.current.add;
    String contentSuffixLoveStyle =
        (profiles?.loveStyle != null && profiles.loveStyle!.isNotEmpty)
            ? StaticInfoManager.shared()
                .convertLoveStyles([profiles!.loveStyle!]).first
            : S.current.add;

    int percent = Const.kCustomerMaxPercentBasics;
    final suffixList = [
      contentSuffixZodiac,
      contentSuffixEducation,
      contentSuffixFamilyPlan,
      contentSuffixCovidVaccine,
      contentSuffixPersonality,
      contentSuffixCommunicationType,
      contentSuffixLoveStyle,
    ];
    if (suffixList.any((suffix) => suffix != S.current.add)) {
      percent = 0;
    }
    return Column(
      children: [
        _componentHeader(S.current.basics, percent),
        Container(
          decoration: BoxDecoration(
              color: ThemeUtils.getShadowColor(),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeDimen.borderRadiusSmall))),
          child: Column(
            children: [
              _btnScroll(
                  () => callEditBasics('nights'),
                  Icons.nights_stay_outlined,
                  S.current.zodiac,
                  contentSuffixZodiac,
                  color: AppColors.iconInfoColor),
              _btnScroll(() => callEditBasics('school'), Icons.school_outlined,
                  S.current.education, contentSuffixEducation,
                  color: AppColors.iconInfoColor),
              _btnScroll(
                  () => callEditBasics('family'),
                  Icons.family_restroom_outlined,
                  S.current.family_plans,
                  contentSuffixFamilyPlan,
                  color: AppColors.iconInfoColor),
              _btnScroll(
                  () => callEditBasics('coronavirus'),
                  Icons.coronavirus_outlined,
                  S.current.covid_vaccine,
                  contentSuffixCovidVaccine,
                  color: AppColors.iconInfoColor),
              _btnScroll(
                  () => callEditBasics('extension'),
                  Icons.extension_outlined,
                  S.current.personality_type,
                  contentSuffixPersonality,
                  color: AppColors.iconInfoColor),
              _btnScroll(
                  () => callEditBasics('question'),
                  Icons.question_answer_outlined,
                  S.current.communication_type,
                  contentSuffixCommunicationType,
                  color: AppColors.iconInfoColor),
              _btnScroll(
                  () => callEditBasics('favorite'),
                  Icons.favorite_outline,
                  S.current.love_type,
                  contentSuffixLoveStyle,
                  color: AppColors.iconInfoColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _lifestyleWidget() {
    callEditLifeStyles(String styles) async {
      await RouteService.routeGoOnePage(EditLifeStyles(
        styles: styles,
      ));
      setState(() {});
    }

    final profiles = PrefAssist.getMyCustomer().profiles!;

    String contentSuffixPet =
        (profiles?.pet != null && profiles.pet!.isNotEmpty)
            ? StaticInfoManager.shared().convertPet(profiles!.pet!)
            : S.current.add;
    String contentSuffixDrinking =
        (profiles?.drinking != null && profiles.drinking!.isNotEmpty)
            ? StaticInfoManager.shared().convertDrinking(profiles!.drinking!)
            : S.current.add;
    String contentSuffixSmoking =
        (profiles?.smoking != null && profiles.smoking!.isNotEmpty)
            ? StaticInfoManager.shared().convertSmoking(profiles!.smoking!)
            : S.current.add;
    String contentSuffixWorkout =
        (profiles?.workout != null && profiles.workout!.isNotEmpty)
            ? StaticInfoManager.shared().convertWorkout(profiles!.workout!)
            : S.current.add;
    String contentSuffixDietaryPreference =
        (profiles?.dietaryPreference != null &&
                profiles.dietaryPreference!.isNotEmpty)
            ? StaticInfoManager.shared()
                .convertFoodPreferences(profiles!.dietaryPreference!)
            : S.current.add;
    String contentSuffixSocialMedia =
        (profiles?.socialMedia != null && profiles.socialMedia!.isNotEmpty)
            ? StaticInfoManager.shared().convertSocials(profiles!.socialMedia!)
            : S.current.add;
    String contentSuffixSleepingHabit =
        (profiles?.sleepingHabit != null && profiles.sleepingHabit!.isNotEmpty)
            ? StaticInfoManager.shared()
                .convertSleepingStyle(profiles!.sleepingHabit!)
            : S.current.add;

    int percent = Const.kCustomerMaxPercentLifestyle;
    final suffixList = [
      contentSuffixPet,
      contentSuffixDrinking,
      contentSuffixSmoking,
      contentSuffixWorkout,
      contentSuffixDietaryPreference,
      contentSuffixSocialMedia,
      contentSuffixSleepingHabit,
    ];
    if (suffixList.any((suffix) => suffix != S.current.add)) {
      percent = 0;
    }
    return Column(
      children: [
        _componentHeader(S.current.lifestyle, percent),
        Container(
          decoration: BoxDecoration(
              color: ThemeUtils.getShadowColor(),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeDimen.borderRadiusSmall))),
          child: Column(
            children: [
              _btnScroll(
                () => callEditLifeStyles('pets'),
                Icons.pets_outlined,
                S.current.pets,
                contentSuffixPet,
                color: AppColors.iconInfoColor,
              ),
              _btnScroll(
                () => callEditLifeStyles('coffee'),
                Icons.coffee_outlined,
                S.current.drinking,
                contentSuffixDrinking,
                color: AppColors.iconInfoColor,
              ),
              _btnScroll(
                () => callEditLifeStyles('smoking'),
                Icons.smoking_rooms_outlined,
                S.current.how_often_do_you_smoke,
                contentSuffixSmoking,
                color: AppColors.iconInfoColor,
              ),
              _btnScroll(
                () => callEditLifeStyles('fitness'),
                Icons.fitness_center_outlined,
                S.current.workout,
                contentSuffixWorkout,
                color: AppColors.iconInfoColor,
              ),
              _btnScroll(
                () => callEditLifeStyles('pizza'),
                Icons.local_pizza_outlined,
                S.current.dietary_preference,
                contentSuffixDietaryPreference,
                color: AppColors.iconInfoColor,
              ),
              _btnScroll(
                () => callEditLifeStyles('alternate'),
                Icons.alternate_email,
                S.current.social_media,
                contentSuffixSocialMedia,
                color: AppColors.iconInfoColor,
              ),
              _btnScroll(
                () => callEditLifeStyles('hotel'),
                Icons.hotel_outlined,
                S.current.sleeping_habits,
                contentSuffixSleepingHabit,
                color: AppColors.iconInfoColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _commonCellWidget(String title, String leftContent,
      String rightContent, VoidCallback? callback) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: callback,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toCapitalized,
                          maxLines: 1,
                          style: ThemeUtils.getPopupTitleStyle(
                              fontSize: 14.toWidthRatio(),
                              color: ThemeUtils.chatFullnameColor),
                        ),
                        Text(
                          leftContent.toCapitalized,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeUtils.getTextStyle(
                              color: ThemeUtils.headerInfoColor,
                              fontSize: 14.toWidthRatio()),
                        )
                      ],
                    ),
                  ),
                  Text(
                    rightContent.toCapitalized,
                    style: ThemeUtils.getTextStyle(
                        color: ThemeUtils.headerInfoColor,
                        fontSize: 10.toWidthRatio()),
                  )
                ],
              ),
            ),
          ),
          Divider(
            color: ThemeUtils.borderColor,
          ),
        ],
      ),
    );
  }

  void onJobTitleTextChange(v) {
    PrefAssist.getMyCustomer().profiles?.jobTitle = _jobEditingController.text;
    PrefAssist.saveMyCustomer();
  }

  void onCompanyTextChange(v) {
    PrefAssist.getMyCustomer().profiles?.company =
        _companyEditingController.text;
    PrefAssist.saveMyCustomer();
  }

  void onSchoolTextChange(v) {
    PrefAssist.getMyCustomer().profiles?.school = _schoolEditingController.text;
    PrefAssist.saveMyCustomer();
  }

  void onLivingTextChange(v) {
    PrefAssist.getMyCustomer().profiles?.address =
        _livingEditingController.text;
    PrefAssist.saveMyCustomer();
  }

  Widget _sexualOrientationWidget() {
    String contentSuffix = S.current.add_sexual_orientation;
    final textSexualOrientation =
        PrefAssist.getMyCustomer().getListOrientationSexualsConvert;
    if (textSexualOrientation.isNotEmpty) {
      contentSuffix = textSexualOrientation.join(", ");
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _componentHeader(S.current.sexual_orientation),
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: ThemeUtils.borderColor, width: 1),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeDimen.borderRadiusSmall))),
          child: WidgetGenerator.getRippleButton(
            colorBg: Colors.transparent,
            buttonHeight: ThemeDimen.buttonHeightNormal,
            buttonWidth: double.infinity,
            borderRadius: ThemeDimen.borderRadiusSmall,
            onClick: () async {
              await RouteService.routeGoOnePage(const EditSexualPage());
              setState(() {});
            },
            child: _componentContent(
                contentPrefix: contentSuffix, isShowArrowIcon: true),
          ),
        ),
      ],
    );
  }

  Widget _controlProfileWidget() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _componentHeader(S.current.profile_edit_control),
            SizedBox(width: ThemeDimen.paddingSmall),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const DatingSilverDialogPackage());
              },
              child: Container(
                margin: EdgeInsets.only(top: 12.toWidthRatio()),
                padding: EdgeInsets.all(ThemeDimen.paddingTiny),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.color5B7A6F,
                      AppColors.colorA4B5AA,
                      AppColors.color5B7A6F
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    tileMode: TileMode.clamp,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ThemeDimen.borderRadiusTiny)),
                ),
                child: Text(
                  S.current.profile_silver_pack_title,
                  style: ThemeUtils.getTextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: ThemeUtils.borderColor),
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeDimen.borderRadiusSmall))),
          child: Column(
            children: [
              _btnRipple(
                  onClick: () async {
                    PrefAssist.getMyCustomer().profiles?.showCommon?.showAge =
                        !PrefAssist.getMyCustomer()
                            .profiles!
                            .showCommon!
                            .showAge!;
                    setState(() {});
                    await PrefAssist.saveMyCustomer();
                  },
                  contentPrefix: S.current.profile_edit_control_age,
                  valSwitch: !PrefAssist.getMyCustomer()
                      .profiles!
                      .showCommon!
                      .showAge!),
              _btnRipple(
                  onClick: () async {
                    PrefAssist.getMyCustomer()
                            .profiles
                            ?.showCommon!
                            .showDistance =
                        !PrefAssist.getMyCustomer()
                            .profiles!
                            .showCommon!
                            .showDistance!;
                    setState(() {});
                    await PrefAssist.saveMyCustomer();
                  },
                  contentPrefix: S.current.profile_edit_control_distance,
                  valSwitch: !PrefAssist.getMyCustomer()
                      .profiles!
                      .showCommon!
                      .showDistance!),

              //TODO: show anythings
            ],
          ),
        ),
      ],
    );
  }

  Widget _btnScroll(VoidCallback callback, IconData? iconData,
          String contentPrefix, String contentSuffixPet,
          {Color? color}) =>
      WidgetGenerator.getRippleButton(
        colorBg: ThemeUtils.getShadowColor(),
        buttonHeight: ThemeDimen.buttonHeightNormal,
        buttonWidth: double.infinity,
        borderRadius: ThemeDimen.borderRadiusSmall,
        onClick: () {
          callback();
        },
        child: _componentContent(
            iconData: iconData,
            contentPrefix: contentPrefix,
            contentSuffix: contentSuffixPet,
            isShowArrowIcon: true,
            color: color),
      );

  Widget _btnSVGScroll(VoidCallback callback, String? stringSvgIcon,
          String contentPrefix, String contentSuffixPet,
          {Color? color}) =>
      WidgetGenerator.getRippleButton(
        colorBg: ThemeUtils.getShadowColor(),
        buttonHeight: ThemeDimen.buttonHeightNormal,
        buttonWidth: double.infinity,
        borderRadius: ThemeDimen.borderRadiusSmall,
        onClick: () {
          callback();
        },
        child: _componentContent(
            stringSvgIcon: stringSvgIcon,
            contentPrefix: contentPrefix,
            contentSuffix: contentSuffixPet,
            isShowArrowIcon: true,
            color: color),
      );

  Widget _btnRipple({
    Color? borderColor,
    double? borderRadius,
    required void Function() onClick,
    required String contentPrefix,
    required bool valSwitch,
    TextStyle? prefixStyle,
  }) =>
      WidgetGenerator.getRippleButton(
        colorBg: Colors.transparent,
        borderColor: borderColor,
        borderRadius: borderRadius ?? ThemeDimen.borderRadiusSmall,
        buttonHeight: ThemeDimen.buttonHeightNormal,
        buttonWidth: double.infinity,
        onClick: onClick,
        child: Row(
          children: [
            Expanded(
                child: _componentContent(
                    contentPrefix: contentPrefix, prefixStyle: prefixStyle)),
            IgnorePointer(
                child: HLSwitch(
              value: valSwitch,
            )),
            const SizedBox(width: 8)
          ],
        ),
      );

  Future<void> _addPromptHandle(int index) async {
    var result = await RouteService.presentPage(const SelectPromptsPage());

    if (result is PromptDto) {
      if (myPrompts.length > index) {
        result.id = myPrompts[index].id;
      }

      final resultModel = await ApiProfileSetting.updatePrompt(result);
      debugPrint("update prompt: ${resultModel?.answer}");

      if (resultModel != null) {
        if (myPrompts.length > index) {
          setState(() {
            myPrompts[index] = resultModel!;
          });
        } else {
          setState(() {
            myPrompts.add(resultModel!);
          });
        }
      }

      PrefAssist.getMyCustomer().profiles?.prompts = myPrompts;
      await PrefAssist.saveMyCustomer();
    } else {
      debugPrint("cancel add prompt");
    }
  }

  Future<void> _deletePromptHandle(int index) async {
    if (index >= myPrompts.length) {
      return;
    }
    final prompt = myPrompts[index];
    final resultCode = await ApiProfileSetting.deletePrompt(prompt);
    debugPrint("delete prompt: $resultCode");
    setState(() {
      myPrompts.removeAt(index);
    });

    PrefAssist.getMyCustomer().profiles?.prompts = myPrompts;
    await PrefAssist.saveMyCustomer();
  }


  @override
  bool get wantKeepAlive => true;
}
