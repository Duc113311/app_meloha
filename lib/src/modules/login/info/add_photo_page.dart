import 'dart:io';
import 'package:dating_app/src/domain/dtos/profiles/avatar_dto.dart';
import 'package:dating_app/src/requests/auth_services.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/services/navigator/route_service.dart';
import '../../../general/constants/app_constants.dart';
import '../../../general/constants/app_image.dart';
import '../../profile/screens/media/add_new_media.dart';

import 'package:image/image.dart' as img;

class AddPhotoPage extends StatefulWidget {
  final PageController pageController;

  const AddPhotoPage(this.pageController, {Key? key}) : super(key: key);

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;


  //Số hình yêu cầu tối thiêu
  int MIN_NUMBER_IMAGES = Const.kNumberOfImagesRequired;
  List<AvatarDto> listUserPhotos = [];
  List<int> loadingCells = [];
  bool loadingdata = false;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadImages() async {
    setState(() {
      loadingdata = true;
    });
    final avatars = PrefAssist.getMyCustomer().profiles?.avatars ?? [];

    setState(() {
      listUserPhotos = avatars;
      loadingdata = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loadingdata) {
      Utils.showLoading();
    } else {
      Utils.hideLoading();
    }
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
          statusBarIconBrightness: ThemeUtils.isDarkModeSetting()
              ? Brightness.light
              : Brightness.dark,
        ),
        leading: IconButton(
          onPressed: () => widget.pageController.previousPage(
              duration:
                  const Duration(milliseconds: ThemeDimen.animMillisDuration),
              curve: Curves.easeIn),
          icon: SvgPicture.asset(
            AppImages.icArrowBack,
            colorFilter:
                ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingBig),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingBig),
            Text(
              S.current.add_photo,
              style: ThemeUtils.getTitleStyle(),
            ),
            SizedBox(height: ThemeDimen.paddingSmall),
            Text(
              S.current.add_at_least_2_photos,
              style: ThemeUtils.getCaptionStyle(
                  color: ThemeUtils.getTextColor(), fontSize: 14),
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            _gridImagesWidget(),
          ],
        ),
      ),
      bottomNavigationBar: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingSmall,
                ThemeDimen.paddingSuper,
                ThemeDimen.paddingLarge),
            child: WidgetGenerator.bottomButton(
              selected: listUserPhotos.length >= MIN_NUMBER_IMAGES,
              isShowRipple:
                  listUserPhotos.length >= MIN_NUMBER_IMAGES ? true : false,
              buttonHeight: ThemeDimen.buttonHeightNormal,
              buttonWidth: double.infinity,
              onClick: onContinueLocation,
              child: Center(
                child: Text(
                  S.current.str_continue,
                  style: ThemeUtils.getButtonStyle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widgets
  Widget _gridImagesWidget() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: ThemeDimen.paddingTiny,
      mainAxisSpacing: ThemeDimen.paddingTiny,
      childAspectRatio: 1,
      children: List.generate(
        Const.kMaxImageNumber,
        (index) {
          if (index < listUserPhotos.length) {
            return SizedBox(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(ThemeDimen.paddingTiny),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ThemeDimen.borderRadiusNormal),
                      child: CacheImageView(
                        imageURL: listUserPhotos[index].thumbnail,
                        fit: BoxFit.cover,
                        width: context.width / 3,
                        height: context.width / 3,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: InkWell(
                      child: SvgPicture.asset(
                        AppImages.icDeleteImage,
                        width: 30,
                        height: 30,
                      ),
                      onTap: () async {
                        final avatar = listUserPhotos[index];
                        setState(() {
                          listUserPhotos.removeWhere(
                              (item) => item == listUserPhotos[index]);
                        });

                        PrefAssist.getMyCustomer().profiles!.avatars =
                            listUserPhotos;
                        await PrefAssist.saveMyCustomer();
                        AuthServices().deleteImage(avatar.url);
                        AuthServices().deleteImage(avatar.thumbnail);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Stack(
              children: [
                Container(
                  child: WidgetGenerator.getRippleButton(
                    colorBg: ThemeUtils.getShadowColor(),
                    buttonWidth: double.infinity,
                    onClick: () {
                      if (loadingCells.contains(index) ||
                          listUserPhotos.length >= Const.kMaxImageNumber) {
                        return;
                      }
                      final maxIndex = loadingCells.isNotEmpty
                          ? loadingCells.last + 1
                          : listUserPhotos.length;
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
        },
      ),
    );
  }

  Future _onAddImageClick(int index) async {
    var result = await RouteService.presentPage(const AddNewMedia());
    if (result is File) {
      setState(() {
        loadingCells.add(index);
      });

      final imageUrl = await AuthServices().uploadMedia(
          result, FireStorePathType.profiles, ProfilePathType.images);
      print("imageUrl: $imageUrl");

      final image = img.decodeImage(result.readAsBytesSync())!;
      if (image.width <= Get.width || image.height <= Get.height) {
        uploadCompletedHandle(imageUrl, imageUrl, index);
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

        print("thumbnailUrl: $thumbnailUrl");
        uploadCompletedHandle(imageUrl, thumbnailUrl, index);
      }
    }
  }

  Future<void> uploadCompletedHandle(
      String? url, String? thumbnailUrl, int index) async {
    if (url != null) {
      final meta = ImageMetaDto(url: url!, thumbnails: [thumbnailUrl ?? url!]);

      final avatarModel =
          AvatarDto(meta: meta, reviewerViolateOption: [], aiViolateOption: []);
      setState(() {
        listUserPhotos.add(avatarModel);
        loadingCells.removeWhere((element) => element == index);
      });
      PrefAssist.getMyCustomer().profiles!.avatars = listUserPhotos;
      await PrefAssist.saveMyCustomer();
    } else {
      setState(() {
        loadingCells.removeWhere((element) => element == index);
      });
    }
  }

  void onContinueLocation() async {
    if (listUserPhotos.length < Const.kNumberOfImagesRequired) return;
    widget.pageController.nextPage(
        duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
        curve: Curves.easeIn);
  }
}
