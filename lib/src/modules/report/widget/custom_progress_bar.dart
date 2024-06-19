import 'package:dating_app/src/utils/theme_notifier.dart';
import 'package:flutter/material.dart';

import '../../../general/constants/app_color.dart';
import '../../../general/constants/app_constants.dart';
import 'linear_gradient_progress_indicator.dart';

class ProgessBarPage extends StatefulWidget {
  const ProgessBarPage({Key? key, this.percent}) : super(key: key);
  final double? percent;

  @override
  State<ProgessBarPage> createState() => ProgessBarPageState();
}

class ProgessBarPageState extends State<ProgessBarPage> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  void fling() {
    animationController.repeat(max: animationController.value, min: animationController.value - 0.05);
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.percent == null) {
      animationController.forward();
    } else {
      animationController.animateTo(widget.percent!);
    }
    animationController.addStatusListener(animationListener);
  }

  void animationListener(status) {
    if (status == AnimationStatus.completed) {
      print('object');
    }
  }

  @override
  void didUpdateWidget(covariant ProgessBarPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.percent != null) {
      animationController.animateTo(widget.percent!, curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    animationController.removeStatusListener(animationListener);
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = AppConstants.height;
    var width = AppConstants.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (_, __) => LinearGradientProgressIndicator(
        linearGradient: LinearGradient(colors: [AppColors.color38B7FF, ThemeUtils.getPrimaryColor()]),
        value: animationController.value,
        minHeight: 5,
        backgroundColor: AppColors.color585858,
        borderRadius: const BorderRadius.all(Radius.zero),
      ),
    );
  }
}
