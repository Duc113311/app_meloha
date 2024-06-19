import 'package:dating_app/src/utils/utils.dart';

extension FancyNum on num {
  static double designWidth = 360;
  static double designHeight = 800;

  double toWidthRatio() => this * Get.width / designWidth;
  double toHeightRatio() => this * Get.height / designHeight;


  String toTimeString() {
    int seconds = (this % 60).toInt();
    int minutes = ((this / 60) % 60).toInt();
    int hours = this ~/ 3600;
    if (hours > 0) {
      return "${hours.toTimeDigits()}:${minutes.toTimeDigits()}:${seconds.toTimeDigits()}";
    } else {
      return "${minutes.toTimeDigits()}:${seconds.toTimeDigits()}";
    }
  }

  String toTimeDigits() {
    if (this < 10) {
      return "0${toInt()}";
    } else {
      return toInt().toString();
    }
  }

  double kmToMil() => this * 0.621371;
  double milToKm() => this * 1.609344;

  double kmOrMil() {
    if (Utils.getMyCustomerDistType() == Const.kDistTypeKm) {
      return this * 1;
    } else {
      return this * 0.621371;
    }
  }
}