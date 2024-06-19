import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../utils/theme_notifier.dart';

class CircularPercentIndicatorCustom extends StatefulWidget {
  const CircularPercentIndicatorCustom({Key? key, this.percent}) : super(key: key);
  final double? percent;

  @override
  State<CircularPercentIndicatorCustom> createState() => CircularPercentIndicatorCustomState();
}

class CircularPercentIndicatorCustomState extends State<CircularPercentIndicatorCustom>
    with SingleTickerProviderStateMixin {

  late final AnimationController animationController;

  void fling() {
    animationController.repeat(
        max: animationController.value, min: animationController.value - 0.05);
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
  void didUpdateWidget(covariant CircularPercentIndicatorCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.percent != null) {
      animationController.animateTo(widget.percent!, curve: Curves.easeIn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // precacheImage(image, context);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(animationListener);
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return AnimatedBuilder(
      animation: animationController,
      builder: (_, __) => CircularPercentIndicator(
        animationDuration: 1000,
        animateFromLastPercent: true,
        animation: true,
        radius: 75,
        startAngle: 180,
        progressColor: ThemeUtils.getPrimaryColor(),
        percent: widget.percent!,
        circularStrokeCap: CircularStrokeCap.round,
      ),
    );
  }
}

