import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../general/constants/app_image.dart';
import 'cache_image_manager.dart';
import 'utils.dart';

class ImageUtils {
  // open image from gallery and pick an image
  static Future<XFile?> pickImageFromGallery() async {
    return await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        preferredCameraDevice: CameraDevice.front);
  }

  // open image from camera and pick an image
  static Future<XFile?> pickImageFromCamera() async {
    return await ImagePicker().pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
  }

  // pick an image from gallery / camera and return a file
  static Future<File?> cropSelectedImage(
      String filePath, BuildContext context) async {

    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        cropStyle:CropStyle.rectangle,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        maxWidth: 1024,
        maxHeight: 1024,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: S.current.app_title,
              toolbarColor: ThemeUtils.getPrimaryColor(),
              activeControlsWidgetColor: ThemeUtils.getPrimaryColor(),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              hideBottomControls: true,
              lockAspectRatio: true),
          IOSUiSettings(
            title: S.current.app_title,
          ),
        ]);
    return File(croppedFile!.path);
  }

  static Future<File?> cropSelectedImageUpFirebase(
      String filePath, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        cropStyle:CropStyle.rectangle,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        maxWidth: 1024,
        maxHeight: 1024,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: S.current.app_title,
              toolbarColor: ThemeUtils.getPrimaryColor(),
              activeControlsWidgetColor: ThemeUtils.getPrimaryColor(),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              hideBottomControls: true,
              lockAspectRatio: true),
          IOSUiSettings(
            title: S.current.app_title,
          ),
        ]);
    return File(croppedFile!.path);
  }
}

//Widget for image
class CacheImageView extends StatelessWidget {
  const CacheImageView(
      {super.key,
      this.imageURL,
      this.defaultImage,
      this.fit,
      this.width,
      this.height,
      this.centerLoading,
      this.placeholder,
      this.errorWidget,
      this.animationColor});

  final String? imageURL;
  final Image? defaultImage;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final bool? centerLoading;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final Color? animationColor;

  @override
  Widget build(BuildContext context) {
    return imageURL == null
        ? defaultImage ??
            SvgPicture.asset(
              AppImages.icAvtDefault,
              fit: fit ?? BoxFit.cover,
              allowDrawingOutsideViewBox: true,
              colorFilter: const ColorFilter.mode(
                  AppColors.color323232, BlendMode.srcIn),
            )
        : imageURL!.contains('http')
            ? CachedNetworkImage(
                width: width,
                height: height,
                placeholder: placeholder ??
                    (context, url) => (centerLoading ?? false)
                        ? Center(
                            child: CircularProgressIndicator(
                              color: animationColor,
                            ),
                          )
                        : width == height
                            ? CircularProgressIndicator(
                                color: animationColor,
                              )
                            : LinearProgressIndicator(
                                color: animationColor,
                              ),
                imageUrl: imageURL!,
                cacheKey: imageURL!.removeQuery,
                fit: fit ?? BoxFit.cover,
                errorWidget: errorWidget ??
                    (context, url, error) =>
                        defaultImage ??
                        SvgPicture.asset(
                          width: width,
                          height: height,
                          AppImages.icAvtDefault,
                          fit: fit ?? BoxFit.cover,
                          allowDrawingOutsideViewBox: true,
                          colorFilter: const ColorFilter.mode(
                              AppColors.color323232, BlendMode.srcIn),
                        ),
                cacheManager: BHCacheImageManager.shared().cacheManager,
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
  }
}
