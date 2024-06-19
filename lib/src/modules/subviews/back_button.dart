import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:flutter/material.dart';

import '../../utils/theme_notifier.dart';

class HLBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const HLBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: SvgPicture.asset(
          AppImages.icArrowBack,
          height: 30,
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(ThemeUtils.getTextColor(), BlendMode.srcIn),
        ));
  }
}
