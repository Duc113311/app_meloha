import 'dart:math';

import 'package:flutter/material.dart';

import 'bubble_type.dart';

/// This class is a sample of a custom clipper that creates a visually
/// appealing chat bubble.
///
/// The chat bubble is shaped as shown in the following illustration:
/// ![Image](https://user-images.githubusercontent.com/25680329/218024881-5b3d2bc2-f0aa-47e3-b9b0-5286e3f92b8b.png)
class ChatBubbleClipper extends CustomClipper<Path> {
  ///The values assigned to the clipper types [BubbleType.sendBubble] and
  ///[BubbleType.receiverBubble] are distinct.
  final BubbleType? type;

  ///The radius, which creates the curved appearance of the chat widget,
  ///has a default value of 15.
  final double radius;

  /// This displays the radius for the bottom corner curve of the widget,
  /// with a default value of 2.
  final double secondRadius;

  final bool firstMessageInGroup;
  final bool lastMessageInGroup;
  final bool onlyMessageInGroup;

  ChatBubbleClipper(
      {this.type,
      this.radius = 15,
      this.secondRadius = 0,
      this.firstMessageInGroup = false,
      this.lastMessageInGroup = false,
      this.onlyMessageInGroup = false});

  @override
  Path getClip(Size size) {
    var path = Path();

    double rValue = min(size.height / 2, 15);
    final radiusValue = Radius.circular(rValue);

    if (onlyMessageInGroup) {
      path.addRRect(RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, size.height),
          topLeft: radiusValue,
          bottomLeft: radiusValue,
          topRight: radiusValue,
          bottomRight: radiusValue));
    } else if (firstMessageInGroup) {
      if (type == BubbleType.sendBubble) {
        path.addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, size.width, size.height),
            topLeft: radiusValue,
            topRight: radiusValue,
            bottomLeft: radiusValue));
      } else {
        path.addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, size.width, size.height),
            topLeft: radiusValue,
            topRight: radiusValue,
            bottomRight: radiusValue));
      }
    } else if (lastMessageInGroup) {
      if (type == BubbleType.sendBubble) {
        path.addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, size.width, size.height),
            topLeft: radiusValue,
            bottomRight: radiusValue,
            bottomLeft: radiusValue));
      } else {
        path.addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, size.width, size.height),
            topRight: radiusValue,
            bottomLeft: radiusValue,
            bottomRight: radiusValue));
      }
    } else {
      //
      if (type == BubbleType.sendBubble) {
        path.addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, size.width, size.height),
            topLeft: radiusValue,
            bottomLeft: radiusValue));
      } else {
        path.addRRect(RRect.fromRectAndCorners(
            Rect.fromLTWH(0, 0, size.width, size.height),
            topRight: radiusValue,
            bottomRight: radiusValue));
      }
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
