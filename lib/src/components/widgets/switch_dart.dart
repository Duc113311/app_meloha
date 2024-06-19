import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:dating_app/src/general/constants/app_image.dart';
import 'package:dating_app/src/utils/extensions/number_ext.dart';
import 'package:dating_app/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../libs/flutter_switch.dart';

class SwitchDart extends StatefulWidget {
  final bool value;

  const SwitchDart(this.value, {super.key});

  @override
  State<SwitchDart> createState() => _SwitchDartState();
}

class _SwitchDartState extends State<SwitchDart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: FittedBox(
          child: FlutterSwitch(
        value: widget.value,
        onToggle: (bool value) {},
        toggleSize: 45,
        activeColor: ThemeUtils.getPrimaryColor(),
        inactiveColor: AppColors.color323232,
      )),
    );
  }
}

class HLSwitch extends StatefulWidget {
  HLSwitch({super.key, this.value = false, this.onToggle, this.thumbIcon});

  final bool value;
  ValueChanged<bool>? onToggle;
  WidgetStateProperty<Icon?>? thumbIcon;

  @override
  HLSwitchState createState() => HLSwitchState();
}

class HLSwitchState extends State<HLSwitch> {
  @override
  Widget build(BuildContext context) {

    final WidgetStateProperty<Icon?> thumbIcon =
    WidgetStateProperty.resolveWith<Icon?>(
          (Set<WidgetState> states) {
        return const Icon(Icons.cached, color: Colors.transparent,);
      },
    );
    
    return SizedBox(
      width: 48.toWidthRatio(),
      height: 48.toWidthRatio(),
      child: FittedBox(
          child: Switch(
        trackOutlineColor:
            const WidgetStatePropertyAll<Color>(Colors.transparent),
        value: widget.value,
        thumbIcon: thumbIcon,

        //activeThumbImage: SvgPicture.asset(AppImages.icSwitchThumb),
        activeTrackColor: ThemeUtils.getPrimaryColor(),
        activeColor: Colors.white,
        inactiveTrackColor: ThemeUtils.colorGrey1(),
        inactiveThumbColor: Colors.white,
        //ThemeUtils.getScaffoldBackgroundColor(),
        onChanged: widget.onToggle ?? (bool value) {},
      )),
    );
  }
}
