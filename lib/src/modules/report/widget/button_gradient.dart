import 'package:dating_app/src/general/constants/app_color.dart';
import 'package:flutter/material.dart';

import '../../../utils/theme_notifier.dart';

class ButtonGradient extends StatefulWidget {
  const ButtonGradient({Key? key, this.isOffBtn, this.onTap, this.textBtn = 'Next', this.widthBtn = double.maxFinite, this.isOffOnTap = true}) : super(key: key);
  final bool? isOffBtn;
  final bool? isOffOnTap;
  final String? textBtn;
  final double? widthBtn;
  final void Function()? onTap;

  @override
  State<ButtonGradient> createState() => _ButtonGradientState();
}

class _ButtonGradientState extends State<ButtonGradient> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isOffBtn == true && widget.isOffOnTap == true ? () {} : widget.onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: widget.widthBtn,
        height: 48,
        decoration: widget.isOffBtn == true
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.color7B7B7B,
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: LinearGradient(colors: [AppColors.color38B7FF, ThemeUtils.getPrimaryColor(), AppColors.color38B7FF]),
              ),
        child: Center(
          child: Text(
            widget.textBtn!,
            style: TextStyle(color: widget.isOffBtn == true ? AppColors.white : AppColors.white),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
