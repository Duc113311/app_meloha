import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialog {
  static const ACCESS_CAMERA_PERMISSION = 1;
  static const ACCESS_STORAGE_PERMISSION_TO_SCAN = 2;
  static const ACCESS_STORAGE_PERMISSION_TO_SAVE = 3;
  static const ACCESS_CONTACTS_PERMISSION_TO_IMPORT = 4;
  static const ACCESS_CONTACTS_PERMISSION_TO_SAVE = 5;
  static const ACCESS_LOCATION_PERMISSION = 6;
  static const POST_NOTIFICATIONS = 7;
  static const ACCESS_BACKGROUND_LOCATION_PERMISSION = 8;

  static Future<int?> showDialog(BuildContext context, int type, bool isPermanentDenied) async {
    switch (type) {
      case ACCESS_LOCATION_PERMISSION:
        int? callback = await Utils.showMyActionsDialog(
          title: S.current.new_txtid_request_access_title,
          content: S.current.new_txtid_request_access_location_body,
          content2: isPermanentDenied ? S.current.new_txtid_request_access_never_ask_again : '',
          negativeAction: S.current.str_cancel,
          positiveAction: S.current.txtid_allow,
        );
        if (callback == Utils.kDialogPositiveValue && isPermanentDenied) await openAppSettings();
        return callback;
    }
    return null;
  }
}
