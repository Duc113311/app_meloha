import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/domain/services/navigator/route_service.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddNewMedia extends StatefulWidget {
  const AddNewMedia({super.key});

  @override
  State<AddNewMedia> createState() => _AddNewMediaState();
}

class _AddNewMediaState extends State<AddNewMedia> {
  List<File> files = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
        child: Column(
          children: [
            const SizedBox(height: 16,),
            Row(
              children: [
                Text(
                  S.current.txt_select_source,
                  style: ThemeUtils.getTitleStyle()
                ),
              ],
            ),
            const SizedBox(height: 32,),
            _gallery(),
            _sizeBoxBtn(),
            _cameraImage(),
            _sizeBoxBtn(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget? _appBar() => AppBar(
    systemOverlayStyle: SystemUiOverlayStyle (
      statusBarColor: ThemeUtils.getScaffoldBackgroundColor(),
      statusBarIconBrightness: ThemeUtils.isDarkModeSetting() ? Brightness.light : Brightness.dark,
    ),
        leading: IconButton(
          onPressed: () async {
            await RouteService.pop(result: files);
          },
          icon: SvgPicture.asset(AppImages.icArrowBack, colorFilter: ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),),
        ),
      );

  Widget _sizeBoxBtn() => SizedBox(height: ThemeDimen.paddingSuper);

  Widget _gallery() => _btn(() async {
        await ImageUtils.pickImageFromGallery().then((pickedImage) async {
          if (pickedImage == null) return;
          // crop image
          await ImageUtils.cropSelectedImageUpFirebase(
                  pickedImage.path, context)
              .then((croppedFile) async {
            if (croppedFile == null) return;
            RouteService.pop(result: croppedFile);
            setState(() {});
          });
        });
      }, AppImages.ic_add_media_gallery, S.current.txtid_gallery);

  Widget _cameraImage() => _btn(() {
        openCamera();
      }, AppImages.ic_add_media_camera, S.current.txtid_camera);

  Widget _btn(void Function() onClick, String assetName, String textBtn) =>
      WidgetGenerator.getRippleButton(
        colorBg: HexColor("E2E2E4"),
        buttonWidth: double.infinity,
        buttonHeight: Get.height * 0.179,
        onClick: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(assetName, width: 24.toWidthRatio(), height: 24.toWidthRatio(), colorFilter: ColorFilter.mode(ThemeUtils.getAddNewButtonColor(), BlendMode.srcIn),),
            SizedBox(width: ThemeDimen.paddingSmall),
            AutoSizeText(
              textBtn,
              style: ThemeUtils.getTextStyle(color: ThemeUtils.getAddNewButtonColor(), fontSize: 15.toWidthRatio()),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  void openCamera() async {
    await ImageUtils.pickImageFromCamera().then((pickedImage) async {
      debugPrint("file path : ${pickedImage!.path}");

      // crop image
      await ImageUtils.cropSelectedImageUpFirebase(pickedImage.path, context)
          .then((croppedFile) async {
        if (croppedFile == null) return;
        RouteService.pop(result: croppedFile);
        setState(() {});
      });
    });
  }
}
