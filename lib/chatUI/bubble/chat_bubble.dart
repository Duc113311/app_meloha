library flutter_chat_bubble;

import 'package:flutter/material.dart';



/// This class represents the ultimate Flutter widget for creating diverse chat
/// UI designs, similar to those found in apps like WhatsApp and Telegram.
///
/// With its customizable properties, developers can create stunning chat UI
/// that elevates the user experience in their messaging app.
class ChatBubble extends StatelessWidget {
  /// A custom clipper for clipping and shaping widgets in Flutter.
  ///
  /// This clipper can be used to create custom shapes and clips for widgets,
  /// giving you the ability to create unique and visually appealing user interfaces.
  /// To use this clipper, extend the [CustomClipper] class and override the getClip method
  /// to define the shape you wish to clip to.
  ///
  /// This package includes various custom clipper options for creating chat bubbles,
  /// including [ChatBubbleClipper1], [ChatBubbleClipper2], [ChatBubbleClipper3],
  /// [ChatBubbleClipper4], [ChatBubbleClipper5], [ChatBubbleClipper6], [ChatBubbleClipper7],
  /// [ChatBubbleClipper8], [ChatBubbleClipper9], and [ChatBubbleClipper10].
  ///
  /// Additionally, you can customize other clippers based on your specific requirements.
  final CustomClipper? clipper;

  /// The `child` property of the `ChatBubble` is used to specify the widget
  /// contained within the bounds.
  final Widget? child;

  /// Empty space to surround [child].
  final EdgeInsetsGeometry? margin;

  /// The z-coordinate relative to the parent at which to place this physical
  /// object.
  ///
  /// The value is non-negative.
  final double? elevation;

  /// The color used for the background.
  final Color? backGroundColor;

  /// Specifies the color to use for the shadow when the `elevation` is non-zero.
  final Color? shadowColor;

  /// Aligns the `child` widget within the bounds of the `Container`.
  final Alignment? alignment;

  /// Empty space to inscribe inside the [child], if any, is placed inside this
  /// padding.
  ///
  /// If padding is not specified, the default space will be calculated based on
  /// the selected clipper type.
  final EdgeInsetsGeometry? padding;

  const ChatBubble(
      {super.key, this.clipper,
        this.child,
        this.margin,
        this.elevation,
        this.backGroundColor,
        this.shadowColor,
        this.alignment,
        this.padding,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.topLeft,
      margin: margin ?? const EdgeInsets.all(8),
      child: PhysicalShape(
        clipper: clipper as CustomClipper<Path>,
        elevation: elevation ?? 2,
        color: backGroundColor ?? Colors.transparent,
        shadowColor: shadowColor ?? Colors.transparent,
        child: Padding(
          padding: padding ?? setPadding(),
          child: child ?? Container(),
        ),
      ),
    );
  }

  /// Determines the amount of padding to use in the `Container`, based on the
  /// selected `clipper` type.
  EdgeInsets setPadding() {
    return const EdgeInsets.all(8);
  }

}