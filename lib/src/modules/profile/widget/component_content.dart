import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../general/constants/app_image.dart';

class ComponentContent extends StatelessWidget {
  ComponentContent({super.key, this.iconData, this.stringSvgIcon,this.contentPrefix = '',this.contentSuffix = '',this.isShowArrowIcon = false, this.isShowCheckIcon = false, this.textSize, this.iconColor, this.prefixStyle});

  final IconData? iconData;
  final String? stringSvgIcon;
  final String contentPrefix ;
  final String contentSuffix ;
  final bool isShowArrowIcon ;
  final bool isShowCheckIcon;
  final double? textSize;
  final Color? iconColor;
  TextStyle? prefixStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: ThemeDimen.paddingSmall),
          iconData != null
              ? Icon(iconData, color: iconColor ?? ThemeUtils.getPrimaryColor())
              : const SizedBox(),
          stringSvgIcon != null
              ? SvgPicture.asset(stringSvgIcon!, allowDrawingOutsideViewBox: true)
              : const SizedBox(),
          (iconData != null || stringSvgIcon != null)
              ? SizedBox(width: ThemeDimen.paddingSmall)
              : const SizedBox(),
          contentSuffix.isEmpty
              ? Expanded(
                  child: Text(
                    contentPrefix,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: prefixStyle ?? ThemeUtils.getTextStyle(fontSize: textSize),
                  ),
                )
              : Expanded(
                child: Text(
                    contentPrefix,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: prefixStyle ?? ThemeUtils.getTextStyle(),
                  ),
              ),
          SizedBox(width: ThemeDimen.paddingTiny),
          contentSuffix.isNotEmpty
              ? Expanded(
                  child: Text(
                    contentSuffix,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: ThemeUtils.getCaptionStyle(fontSize: textSize),
                    textAlign: TextAlign.right,
                  ),
                )
              : const SizedBox(),
          SizedBox(width: ThemeDimen.paddingTiny),
          isShowArrowIcon
              ? Icon(
                  Icons.arrow_forward_ios,
                  color: ThemeUtils.headerColor(),
                  size: ThemeDimen.iconTiny,
                )
              : const SizedBox(),
          isShowCheckIcon
              ? SvgPicture.asset(
                  AppImages.icChecked,
                  allowDrawingOutsideViewBox: true,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
