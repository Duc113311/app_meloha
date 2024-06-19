import 'dart:math' as math;

import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../general/constants/app_image.dart';

class WidgetGenerator {
  static Widget _pageViewDot(bool isActive, Color activeColor, Color normalColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
      margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingTiny),
      height: 8/667*AppConstants.height,
      width: 8/375*AppConstants.width,
      decoration: BoxDecoration(
        color: isActive ? activeColor : normalColor,
        shape: BoxShape.circle,
      ),
    );
  }

  static List<Widget> getPageViewIndicator(length, currentIndex, [Color activeColor = Colors.black, Color normalColor = Colors.black26]) {
    List<Widget> list = [];
    for (int i = 0; i < length; i++) {
      list.add(currentIndex == i ? _pageViewDot(true, activeColor, normalColor) : _pageViewDot(false, activeColor, normalColor));
    }
    return list;
  }

  static Widget _swipePageViewBar(bool isActive) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: ThemeDimen.animMillisDurationQuick),
        margin: EdgeInsets.symmetric(horizontal: ThemeDimen.paddingTiny),
        height: isActive ? 6 : 4,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: isActive ? Theme.of(Get.context!).hintColor : Colors.transparent),
          color: isActive ? Colors.white : Theme.of(Get.context!).hintColor,
          borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
        ),
      ),
    );
  }

  static List<Widget> getSwipePageIndicator(imagesLength, currentIndex) {
    List<Widget> list = [];
    if (imagesLength > 1) {
      for (int i = 0; i < imagesLength; i++) {
        list.add(i == currentIndex ? _swipePageViewBar(true) : _swipePageViewBar(false));
      }
    }

    return list;
  }

  static Container getDivider({Color? color, double? margin}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin ?? 0),
      height: 1,
      width: double.infinity,
      color: color ?? Theme.of(Get.context!).dividerColor,
    );
  }

  static Widget getSuperLike(BuildContext context) {
    return Container(
      height: 80/667*AppConstants.height,
      width: 160/375*AppConstants.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
        border: Border.all(width: 4, color: AppColors.color15AFC6),
      ),
      child: Center(
        child: Text(
          'S U P E R\nL I K E',
          textAlign: TextAlign.center,
          style: ThemeUtils.getTitleStyle(
            fontSize: ThemeTextStyle.txtSizeSuper,
            color: AppColors.color15AFC6,
          ),
        ),
      ),
    );
  }

  static Widget getLike(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 6,
      child: Padding(
        padding: EdgeInsets.only(top: 60/667*AppConstants.height,),
        child: Container(
          height: 80/667*AppConstants.height,
          width: 160/375*AppConstants.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
            border: Border.all(width: 4, color: AppColors.color3AD27C),
          ),
          child: Center(
            child: Text(
              'L I K E',
              textAlign: TextAlign.center,
              style: ThemeUtils.getTitleStyle(
                fontSize: ThemeTextStyle.txtSizeSuper,
                color: AppColors.color3AD27C,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getNope(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 6,
      child: Padding(
        padding:  EdgeInsets.only(top: 60/667*AppConstants.height,),
        child: Container(
          height: 80/667*AppConstants.height,
          width: 160/375*AppConstants.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(ThemeDimen.borderRadiusNormal)),
            border: Border.all(width: 4, color: AppColors.colorE95F3E),
          ),
          child: Center(
            child: Text(
              'N O P E',
              textAlign: TextAlign.center,
              style: ThemeUtils.getTitleStyle(
                fontSize: ThemeTextStyle.txtSizeSuper,
                color: AppColors.colorE95F3E,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget getWidgetAppIcon() {
    return Container(
      height: 120.toWidthRatio(),
      width: 120.toWidthRatio(),
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
      decoration: BoxDecoration(
        color: ThemeUtils.getPrimaryColor(),
        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius40)),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppImages.logoHeart,
          height: 55/667*AppConstants.height,
          width: 55/375*AppConstants.width,
          allowDrawingOutsideViewBox: true,
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget getWidgetAssetAppIcon() {
    return SizedBox(
      height: 120.toWidthRatio(),
      width: 120.toWidthRatio(),
      child: Center(
        child: Image.asset(
          AppImages.appIcon,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  static Widget getRippleButton({
    Color? colorBg,
    Color? borderColor,
    double? borderRadius,
    double? buttonHeight,
    double? buttonWidth,
    bool isShowRipple = true,
    required VoidCallback onClick,
    required Widget child,
    Widget? childBg,
  }) {
    borderRadius = borderRadius ?? ThemeDimen.borderRadiusNormal;
    buttonHeight = buttonHeight ?? ThemeDimen.buttonHeightNormal;
    buttonWidth = buttonWidth ?? ThemeDimen.buttonWidthNormal;
    return AnimatedContainer(
      duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
      decoration:
      colorBg == null
      ? BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        gradient: const LinearGradient(
          colors: ThemeColor.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.clamp,
        ),
      )
      : BoxDecoration(
        border: Border.all(color: borderColor ?? Colors.transparent, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: colorBg
      ),
      child: isShowRipple
          ? Stack(
              children: [
                childBg ?? const SizedBox(),
                Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(borderRadius),
                      onTap: onClick,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: buttonHeight,
                          minWidth: buttonWidth,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                childBg ?? const SizedBox(),
                InkWell(
                  onTap: onClick,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: buttonHeight,
                      minWidth: buttonWidth,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
    );
  }

  static Widget bottomButton({
    bool selected = false,
    double? borderRadius,
    double? buttonHeight,
    double? buttonWidth,
    bool isShowRipple = true,
    required VoidCallback onClick,
    required Widget child,
    Widget? childBg,
  }) {
    borderRadius = borderRadius ?? ThemeDimen.borderRadiusNormal;
    buttonHeight = buttonHeight ?? ThemeDimen.buttonHeightNormal;
    buttonWidth = buttonWidth ?? ThemeDimen.buttonWidthNormal;
    return AnimatedContainer(
      duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
      decoration:BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        gradient: LinearGradient(
          colors: selected ? ThemeColor.gradientColors : [Theme.of(Get.context!).hintColor, Theme.of(Get.context!).hintColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          tileMode: TileMode.clamp,
        ),
      ),
      child: isShowRipple
          ? Stack(
        children: [
          childBg ?? const SizedBox(),
          Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: onClick,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: buttonHeight,
                    minWidth: buttonWidth,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      )
          : Stack(
        children: [
          childBg ?? const SizedBox(),
          InkWell(
            onTap: onClick,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: buttonHeight,
                minWidth: buttonWidth,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  static Widget getRippleCircleButton({
    Color colorBg = Colors.transparent,
    double? buttonHeight,
    double? buttonWidth,
    bool isShowRipple = true,
    required VoidCallback onClick,
    required Widget child,
    Widget? childBg,
  }) {
    buttonHeight = buttonHeight ?? ThemeDimen.buttonHeightNormal;
    buttonWidth = buttonWidth ?? ThemeDimen.buttonWidthNormal;
    return AnimatedContainer(
      duration: const Duration(milliseconds: ThemeDimen.animMillisDuration),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorBg,
      ),
      child: isShowRipple
          ? Stack(
              children: [
                childBg ?? const SizedBox(),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: Ink(
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: InkWell(
                        onTap: onClick,
                        customBorder: const CircleBorder(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: buttonHeight,
                            minWidth: buttonWidth,
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                childBg ?? const SizedBox(),
                InkWell(
                  onTap: onClick,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: buttonHeight,
                      minWidth: buttonWidth,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
    );
  }
}
