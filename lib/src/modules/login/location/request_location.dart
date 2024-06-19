import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app_manager.dart';
import '../../../general/constants/app_constants.dart';
import '../../../general/constants/app_image.dart';
import '../../../utils/permission_dialog.dart';
import '../../../utils/utils.dart';

class RequestLocation extends StatefulWidget {
  const RequestLocation({super.key, required this.requestedCallback});

  final void Function(bool isGranted) requestedCallback;

  @override
  State<RequestLocation> createState() => _RequestLocationState();
}

class _RequestLocationState extends State<RequestLocation> {
  Future<void> requestPermission() async {
    final isPermanentlyDenied = await Permission.location.isPermanentlyDenied;
    final isDenied = await Permission.location.isDenied;

    if (isDenied ||
        isPermanentlyDenied) {
      int? result = await PermissionDialog.showDialog(
          AppManager.globalKeyRootMaterial.currentContext!,
          PermissionDialog.ACCESS_LOCATION_PERMISSION,
          false);
      if (result == Utils.kDialogPositiveValue) {
        openAppSettings();
      }
    } else {
      final status = await Permission.location.request();
      widget.requestedCallback(status == PermissionStatus.granted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingNormal),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: ThemeDimen.paddingSuper),
            SvgPicture.asset(
              AppImages.icArtLocation,
              height: 180 / 667 * AppConstants.height,
              width: 180 / 375 * AppConstants.width,
              allowDrawingOutsideViewBox: true,
            ),
            SizedBox(height: ThemeDimen.paddingSuper),
            Center(
              child: Text(
                S.current.enable_location,
                style: ThemeUtils.getTitleStyle(),
              ),
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            Text(
              S.current.your_location_need_allow_enabled,
              style: ThemeUtils.getTextStyle(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            Text(
              S.current.meet_people_nearby,
              style: ThemeUtils.getTitleStyle(),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ThemeDimen.paddingBig),
            Text(
              S.current.your_location_will_be_used_to_show,
              style: ThemeUtils.getTextStyle(),
              textAlign: TextAlign.center,
            ),
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
            child: WidgetGenerator.getRippleButton(
              colorBg: ThemeUtils.getPrimaryColor(),
              buttonHeight: ThemeDimen.buttonHeightNormal,
              buttonWidth: double.infinity,
              onClick: requestPermission,
              child: Center(
                child: Text(
                  S.current.allow_location,
                  style: ThemeUtils.getTitleStyle(
                    color: ThemeUtils.getTextButtonColor(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
