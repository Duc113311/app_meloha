import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:flutter/material.dart';

class DefaultUserAvatar extends StatelessWidget {
  const DefaultUserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppImages.ic_userDefault,
      fit: BoxFit.cover,
    );
  }
}
