import 'package:dating_app/src/app_manager.dart';
import 'package:dating_app/src/requests/api_update_customer_info.dart';
import 'package:dating_app/src/utils/permission_dialog.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService{

static void checkInitLocationEnabled() async {
  if (await Permission.location.isGranted &&
      await Geolocator.isLocationServiceEnabled()) {
    Utils.showLoading();
    await onRequestEnableLocation();
    Utils.hideLoading();
  }
}

static Future<void> onRequestEnableLocation() async {
  if (await Permission.location.request().isGranted) {
    // Either the permission was already granted before or the user just granted it.
  } else {
    if (await Permission.location.isDenied &&
        await Permission.locationWhenInUse.isDenied &&
        await Permission.locationAlways.isDenied) {
      // print(await Permission.location.isPermanentlyDenied);
      // print(await Permission.location.shouldShowRequestRationale);
      if (await Permission.location.isPermanentlyDenied ||
          await Permission.location.shouldShowRequestRationale) {
        int? result = await PermissionDialog.showDialog(
            AppManager.globalKeyRootMaterial.currentContext!,
            PermissionDialog.ACCESS_LOCATION_PERMISSION,
            false);
        if (result == Utils.kDialogPositiveValue) {
          openAppSettings();
        }
        return Future.error('Location permission are denied');
      } else {
        int? result = await PermissionDialog.showDialog(
            AppManager.globalKeyRootMaterial.currentContext!,
            PermissionDialog.ACCESS_LOCATION_PERMISSION,
            true);
        if (result == Utils.kDialogPositiveValue) {
          openAppSettings();
        }
        return Future.error(
            'Location permission are permanently denied, we can not request permission');
      }
    }
  }
  if (!await Geolocator.isLocationServiceEnabled()) {
    int? callback = await Utils.showMyActionsDialog(
      title: S.current.new_txtid_gps_not_enabled,
      content:
      '${S.current.new_txtid_gps_not_enabled_content}\n${S.current.new_txtid_you_can_change_anytime}',
      negativeAction: S.current.str_cancel,
      positiveAction: S.current.txtid_allow,
    );
    if (callback == Utils.kDialogPositiveValue) {
      await openAppSettings();
    }
    return Future.error('Location Service are disabled');
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  debugPrint(
      "LOCATION LAT : ${position.latitude}  LON : ${position.longitude}");
  int codeSuccess = await ApiUpdateCustomerInfo.updateMyCustomerGPS(
      position.latitude, position.longitude);
  if (codeSuccess == 200) {
  } else {
    Utils.toast('Đã có lỗi xảy ra');
  }
}
}