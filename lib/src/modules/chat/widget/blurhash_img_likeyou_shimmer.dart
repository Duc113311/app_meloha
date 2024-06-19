import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../generated/l10n.dart';
import '../../../utils/theme_notifier.dart';

class BlurHashChatShimmer extends StatelessWidget {
  const BlurHashChatShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50 / 667 * AppConstants.height,
                width: 60 / 375 * AppConstants.width,
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: AppColors.white),
                  shape: BoxShape.circle,
                  color: AppColors.color1E1E1E,
                ),
                  child: Container(
                    height: 60 / 667 * AppConstants.height,
                    width: 60 / 375 * AppConstants.width,
                    decoration: BoxDecoration(
                      border: Border.all(width: 3, color: AppColors.black),
                      shape: BoxShape.circle,
                      color: AppColors.color00BA83,
                    ),
                  ),
              ),

            ],
          ),
        ),
        const Spacer(),
        Text(
          S.current.txtid_likes,
          style: ThemeUtils.getTextStyle(),
        ),
      ],
    );
  }
}
