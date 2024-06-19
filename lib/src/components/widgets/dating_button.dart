import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../general/constants/app_color.dart';

class DatingButton {
  static Widget button(text, isEnable, onPress) {
    return isEnable
        ? Container(
            width: double.infinity,
            height: Get.height / 18,
            decoration: BoxDecoration(
                // boxShadow: const [
                //   BoxShadow(
                //       color: Colors.black26, offset: Offset(0, 4), blurRadius: 2.0),
                // ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 1.0],
                  colors: [AppColors.color38B7FF, ThemeUtils.getPrimaryColor()],
                ),
                color: AppColors.colorff608e,
                borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal)),
            child: ElevatedButton(
              onPressed: onPress,
              style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
                    ),
                  ),
                  minimumSize: WidgetStateProperty.all(Size(Get.width, 40)),
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent)),
              child: Text(
                text,
                style: Theme.of(Get.context!).textTheme.displaySmall,
              ),
            ),
          )
        : SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                  // foregroundColor: Colors.blueGrey,
                  // backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal))),
              child: Text(
                text,
                style: ThemeUtils.getTextStyle(),
              ),
            ));
  }

  static Widget darkButton(text, isEnable, onPress) {
    return Container(
      width: double.infinity,
      height: ThemeDimen.buttonHeightNormal,
      decoration: BoxDecoration(
        color: isEnable ? ThemeUtils.getPrimaryColor() : ThemeUtils.getTextColor(),
        borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
      ),
      child: ElevatedButton(
        onPressed: isEnable ? onPress : null,
        style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
              ),
            ),
            minimumSize: WidgetStateProperty.all(Size(Get.width, 40)),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent)),
        child: Text(
          text,
          style: ThemeUtils.getTextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static Widget generalButton(text, color, textColor, onPress) {
    return Container(
      width: double.infinity,
      height: ThemeDimen.buttonHeightNormal,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal)),
      child: ElevatedButton(
        onPressed: onPress,
        style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeDimen.borderRadiusNormal),
              ),
            ),
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent)),
        child: Center(
          child: AutoSizeText(
            text,
            style: ThemeUtils.getTextStyle(),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
