import 'package:flutter/material.dart';

import '../../../../../utils/utils.dart';

class OpacityText extends StatelessWidget {
  const OpacityText({Key? key, required this.index, required this.opacity, required this.alignment, required this.get, required this.currentIndex}) : super(key: key);
  final int index;
  final int currentIndex;
  final double opacity;
  final int get;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: index == currentIndex ? opacity : 0,
      // opacity: 1,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.only(left: ThemeDimen.paddingNormal, top: ThemeDimen.paddingBig),
          child: _get(get,context),
        ),
      ),
    );
  }

  _get(int get, BuildContext context) {
    switch (get) {
      case 0:
        return WidgetGenerator.getLike(context);
      case 1:
        return WidgetGenerator.getSuperLike(context);
      case 2:
        return WidgetGenerator.getNope(context);
    }
  }
}
