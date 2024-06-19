import 'package:auto_size_text/auto_size_text.dart';
import 'package:dating_app/src/utils/extensions/color_ext.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/extensions/string_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

class HLPopupPage extends StatelessWidget {
  const HLPopupPage(
      {required this.title,
      required this.message,
      required this.okTitle,
      required this.cancelTitle,
      required this.cancelAction,
      required this.okAction,
      super.key});

  final String title;
  final String message;
  final VoidCallback cancelAction;
  final VoidCallback okAction;
  final String okTitle;
  final String cancelTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cancelAction,
      child: Container(
        color: ThemeUtils.getTextColor().withOpacity(0.25),
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Container(
            width: Get.width - 32,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ThemeUtils.getScaffoldBackgroundColor(),
              // boxShadow: [BoxShadow (
              //   color: ThemeUtils.getTextColor().withOpacity(0.2),
              //   blurRadius: 5,
              //   offset: const Offset(4, 8),
              // )]
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          title.toCapitalized,
                          textAlign: TextAlign.center,
                          style: ThemeUtils.getPopupTitleStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          message.toCapitalized,
                          textAlign: TextAlign.center,
                          style: ThemeUtils.getTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: WidgetGenerator.bottomButton(
                    selected: true,
                    isShowRipple: true,
                    buttonHeight: ThemeDimen.buttonHeightNormal,
                    buttonWidth: double.infinity,
                    onClick: okAction,
                    child: Center(
                      child: Text(
                        okTitle,
                        style: ThemeUtils.getButtonStyle(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: WidgetGenerator.getRippleButton(
                    colorBg: HexColor("66829D"),
                    isShowRipple: true,
                    buttonHeight: ThemeDimen.buttonHeightNormal,
                    buttonWidth: double.infinity,
                    onClick: cancelAction,
                    child: Center(
                      child: Text(
                        cancelTitle,
                        style: ThemeUtils.getButtonStyle(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HLPopupNotification extends StatelessWidget {
  const HLPopupNotification(
      {required this.title,
      required this.message,
      this.highlightMessage,
      required this.okTitle,
      required this.okAction,
      super.key});

  final String title;
  final String message;
  final String? highlightMessage;
  final VoidCallback okAction;
  final String okTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeUtils.getTextColor().withOpacity(0.25),
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Container(
          width: Get.width - 32,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: ThemeUtils.getScaffoldBackgroundColor(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        title.toCapitalized,
                        textAlign: TextAlign.center,
                        style: ThemeUtils.getPopupTitleStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            message.toCapitalized,
                            textAlign: TextAlign.center,
                            style: ThemeUtils.getTextStyle(),
                          ),
                          if (highlightMessage != null)
                            AutoSizeText(
                              highlightMessage!.toCapitalized,
                              textAlign: TextAlign.center,
                              style: ThemeUtils.getTitleStyle(
                                  fontSize: 14.toWidthRatio()),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: WidgetGenerator.bottomButton(
                  selected: true,
                  isShowRipple: true,
                  buttonHeight: ThemeDimen.buttonHeightNormal,
                  buttonWidth: double.infinity,
                  onClick: okAction,
                  child: Center(
                    child: Text(
                      okTitle,
                      style: ThemeUtils.getButtonStyle(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
