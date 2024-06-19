import 'package:dating_app/src/utils/const.dart';
import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionResult extends StatelessWidget {
  ActionResult({super.key, required this.type});

  UserActionTypes type = UserActionTypes.nope;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeUtils.getScaffoldBackgroundColor(),
      child: Center(
        child: SvgPicture.asset(
          type.imageName,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
