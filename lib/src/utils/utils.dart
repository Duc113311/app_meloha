import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/pref_assist.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/services/navigator/route_service.dart';
import 'utils.dart';

export 'package:dating_app/generated/l10n.dart';
export 'package:get/get.dart';
export 'package:logger/logger.dart';

export 'const.dart';
export 'date_time_utils.dart';
export 'image_utils.dart';
export 'theme_const.dart';
export 'theme_notifier.dart';
export 'widget_generator.dart';

class Utils {
  static Future<bool?> internetError() async {
    await Utils.toast(S.current.txt_check_your_internet_connection);
  }

  static Future<bool?> toast(String message) async {
    return await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: ThemeTextStyle.txtSizeBig);
  }

  static void logger([dynamic message]) {
    if (!kDebugMode) return;
    var logger = Logger(
      printer: PrettyPrinter(
          methodCount: 5,
          // number of method calls to be displayed
          errorMethodCount: 8,
          // number of method calls if stacktrace is provided
          lineLength: 12000,
          // width of the output
          colors: true,
          // Colorful log messages
          printEmojis: true,
          // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
          ),
    );
    logger.d('fatal $message');
  }

  static bool isConsiderOnline(int? mill) {
    if (mill == null) return false;
    return DateTime.now().millisecondsSinceEpoch - mill < 5 * 60 * 1000;
  }

  static bool isShowLoading = false;

  static Future<void> showLoading({String? text}) async {
    if (isShowLoading) return;
    isShowLoading = true;
    await EasyLoading.show(
        status: text ?? S.current.txtid_loading,
        maskType: EasyLoadingMaskType.black);
    if (!isShowLoading) EasyLoading.dismiss();
  }

  static Future<void> hideLoading() async {
    if (!isShowLoading) return;
    isShowLoading = false;
    await EasyLoading.dismiss();
  }


  static const kDialogNegativeValue = -1;
  static const kDialogNeutralValue = 0;
  static const kDialogPositiveValue = 1;

  static Future<int?> showMyActionsDialog(
      {bool barrierDismissible = false,
      String title = '',
      String content = '',
      String content2 = '',
      String negativeAction = '',
      String neutralAction = '',
      String positiveAction = ''}) async {
    List<Widget> actionButtons = [];
    if (negativeAction.isNotEmpty) {
      actionButtons.add(TextButton(
        child: Text(negativeAction, style: ThemeUtils.getPopupTitleStyle(fontSize: 14.toWidthRatio())),
        onPressed: () => RouteService.pop(result: Utils.kDialogNegativeValue),
      ));
    }
    if (neutralAction.isNotEmpty) {
      actionButtons.add(TextButton(
        child: Text(neutralAction, style: ThemeUtils.getPopupTitleStyle(fontSize: 14.toWidthRatio())),
        onPressed: () => RouteService.pop(result: Utils.kDialogNeutralValue),
      ));
    }
    if (positiveAction.isNotEmpty) {
      actionButtons.add(TextButton(
        child: Text(
          positiveAction,
          style: ThemeUtils.getPopupTitleStyle(fontSize: 14.toWidthRatio()),
        ),
        onPressed: () => RouteService.pop(result: Utils.kDialogPositiveValue),
      ));
    }
    return showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(ThemeDimen.paddingNormal),
          title: Text(title, style: ThemeUtils.getTitleStyle(fontSize: 16.toWidthRatio())),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(content, style: ThemeUtils.getTextStyle()),
              content2.isNotEmpty
                  ? Text(content2, style: ThemeUtils.getTextStyle())
                  : const SizedBox.shrink(),
            ],
          ),
          actions: actionButtons,
        );
      },
    );
  }

  static showDialogRemove(BuildContext context, Widget dialog) {
    showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }

  static String getMyCustomerDistType() {
    if (PrefAssist.getMyCustomer().settings?.distancePreference == null) {
      return Const.kDistTypeKm;
    }
    if (PrefAssist.getMyCustomer().settings?.distancePreference!.unit ==
        Const.kDistTypeMiles) {
      return Const.kDistTypeMiles;
    }
    return Const.kDistTypeKm;
  }

  static Object getDist(double km) {
    if (getMyCustomerDistType() == Const.kDistTypeMiles) {
      return kmToMile(km);
    } else {
      return km <= 0.01 ? 0 : km.toStringAsFixed(1);
    }
  }

  static Object kmToMile(double km) {
    return km <= 0.1 ? (0) : (km * 0.621371).toStringAsFixed(1);
  }

  //check internet
  static Future<bool> checkConnectionInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}

Future<String> getAssetPath(String asset) async {
  final path = await getLocalPath(asset);
  await Directory(dirname(path)).create(recursive: true);
  final file = File(path);
  if (!await file.exists()) {
    final byteData = await rootBundle.load(asset);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  return file.path;
}

Future<String> getLocalPath(String path) async {
  return '${(await getApplicationSupportDirectory()).path}/$path';
}

Future<dynamic> saveImage(File file) async {
  final result =
      await ImageGallerySaver.saveFile(file.path, isReturnPathOfIOS: true);
  return result;
}

Future<File> imageToFile(Uint8List bytes, String imageName) async {
  String tempPath = (await getTemporaryDirectory()).path;
  File file = File('$tempPath/$imageName');
  return file.writeAsBytes(bytes);
}
