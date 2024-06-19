// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const double _kMinCircularProgressIndicatorSize = 36.0;
const int _kIndeterminateLinearDuration = 1800;
const int _kIndeterminateCircularDuration = 1333 * 2222;

enum _ActivityIndicatorType { material, adaptive }

/// A base class for Material Design progress indicators.
///
/// This widget cannot be instantiated directly. For a linear progress
/// indicator, see [LinearGradientProgressIndicator]. For a circular progress indicator,
/// see [CircularProgressIndicator].
///
/// See also:
///
///  * <https://material.io/components/progress-indicators>
abstract class ProgressIndicator extends StatefulWidget {
  /// Creates a progress indicator.
  ///
  /// {@template flutter.material.ProgressIndicator.ProgressIndicator}
  /// The [value] argument can either be null for an indeterminate
  /// progress indicator, or a non-null value between 0.0 and 1.0 for a
  /// determinate progress indicator.
  ///
  /// ## Accessibility
  ///
  /// The [semanticsLabel] can be used to identify the purpose of this progress
  /// bar for screen reading software. The [semanticsValue] property may be used
  /// for determinate progress indicators to indicate how much progress has been made.
  /// {@endtemplate}
  const ProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.semanticsLabel,
    this.semanticsValue,
  });

  /// If non-null, the value of this progress indicator.
  ///
  /// A value of 0.0 means no progress and 1.0 means that progress is complete.
  /// The value will be clamped to be in the range 0.0-1.0.
  ///
  /// If null, this progress indicator is indeterminate, which means the
  /// indicator displays a predetermined animation that does not indicate how
  /// much actual progress is being made.
  final double? value;

  /// The progress indicator's background color.
  ///
  /// It is up to the subclass to implement this in whatever way makes sense
  /// for the given use case. See the subclass documentation for details.
  final Color? backgroundColor;

  /// {@template flutter.progress_indicator.ProgressIndicator.color}
  /// The progress indicator's color.
  ///
  /// This is only used if [ProgressIndicator.valueColor] is null.
  /// If [ProgressIndicator.color] is also null, then the ambient
  /// [ProgressIndicatorThemeData.color] will be used. If that
  /// is null then the current theme's [ColorScheme.primary] will
  /// be used by default.
  /// {@endtemplate}
  final Color? color;

  /// The progress indicator's color as an animated value.
  ///
  /// If null, the progress indicator is rendered with [color]. If that is null,
  /// then it will use the ambient [ProgressIndicatorThemeData.color]. If that
  /// is also null then it defaults to the current theme's [ColorScheme.primary].
  final Animation<Color?>? valueColor;

  /// {@template flutter.progress_indicator.ProgressIndicator.semanticsLabel}
  /// The [SemanticsProperties.label] for this progress indicator.
  ///
  /// This value indicates the purpose of the progress bar, and will be
  /// read out by screen readers to indicate the purpose of this progress
  /// indicator.
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@template flutter.progress_indicator.ProgressIndicator.semanticsValue}
  /// The [SemanticsProperties.value] for this progress indicator.
  ///
  /// This will be used in conjunction with the [semanticsLabel] by
  /// screen reading software to identify the widget, and is primarily
  /// intended for use with determinate progress indicators to announce
  /// how far along they are.
  ///
  /// For determinate progress indicators, this will be defaulted to
  /// [ProgressIndicator.value] expressed as a percentage, i.e. `0.1` will
  /// become '10%'.
  /// {@endtemplate}
  final String? semanticsValue;

  Color _getValueColor(BuildContext context, {Color? defaultColor}) {
    return valueColor?.value ??
        color ??
        ProgressIndicatorTheme.of(context).color ??
        defaultColor ??
        Theme.of(context).colorScheme.primary;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(PercentProperty('value', value,
        showName: false, ifNull: '<indeterminate>'));
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }
}

abstract class LinearProgressValueBuilderDelegate {
  LinearProgressValueBuilderDelegate({
    required this.context,
    this.textScaleFactor = 1.0,
  });

  final TextPainter _textPainter = TextPainter();

  final BuildContext context;
  final double textScaleFactor;

  double calculateVisualLeftPosition(double value);

  /// The position where the child should be placed.
  ///
  /// The `parentRect` is the Rect of the bar.
  ///
  /// Defaults to positioning the child in the upper left corner of the parent.
  Offset getPosition(Rect parentRect, double value) {
    return Offset(
      parentRect.left + calculateVisualLeftPosition(value) * parentRect.width,
      _getRect(parentRect.centerLeft).top,
    );
  }

  TextSpan buildText(double value);

  void _update(double value, TextDirection textDirection) {
    _textPainter.text = buildText(value);
    _textPainter.textDirection = textDirection;
    _textPainter.textScaleFactor = textScaleFactor;
    _textPainter.layout();
  }

  Rect _getRect(Offset center) {
    return Rect.fromCenter(
      center: center,
      width: _textPainter.size.width,
      height: _textPainter.size.height,
    );
  }

  void _paint(Canvas canvas, Offset centerOffset) {
    _textPainter.paint(canvas, centerOffset);
  }

  bool shouldRelayout(covariant LinearProgressValueBuilderDelegate? oldDelegate) {
    return oldDelegate != null && textScaleFactor != oldDelegate.textScaleFactor;
  }

  void dispose() {
    _textPainter.dispose();
  }
}

class _LinearProgressIndicatorPainter extends CustomPainter {
  const _LinearProgressIndicatorPainter({
    // LinearProgressValueBuilderDelegate? valueBuilderDelegate,
    this.valueBuilderDelegate,
    required this.linearGradient,
    required this.backgroundColor,
    required this.imagePainter,
    required this.imageSize,
    required this.valueColor,
    this.value,
    required this.hasImageLoaded,
    this.imageVisualTopPosition = 0,
    required this.borderRadius,
    required this.animationValue,
    required this.textDirection,
  })/*, _valueBuilderDelegate = valueBuilderDelegate*/;

  final LinearGradient linearGradient;
  final Size? imageSize;
  final DecorationImagePainter? imagePainter;
  final double imageVisualTopPosition;
  final LinearProgressValueBuilderDelegate? valueBuilderDelegate;
  /*
  LinearProgressValueBuilderDelegate? _valueBuilderDelegate;
  LinearProgressValueBuilderDelegate? get valueBuilderDelegate => _valueBuilderDelegate;
  set valueBuilderDelegate(LinearProgressValueBuilderDelegate? newDelegate) {
    final LinearProgressValueBuilderDelegate? oldDelegate = _valueBuilderDelegate;
    if (newDelegate?.shouldRelayout(oldDelegate) == true) {
      newDelegate?._textPainter.markNeedsLayout();
    }

    _valueBuilderDelegate = newDelegate;
  }
   */
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color valueColor;
  final double? value;
  final double animationValue;
  final TextDirection textDirection;
  final bool hasImageLoaded;

  // The indeterminate progress animation displays two lines whose leading (head)
  // and trailing (tail) endpoints are defined by the following four curves.
  static const Curve line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ),
      paint,
    );

    paint.color = valueColor;

    void drawBar(double x, double width) {
      if (width <= 0.0) {
        return;
      }

      final double left;
      switch (textDirection) {
        case TextDirection.rtl:
          left = size.width - width - x;
          break;
        case TextDirection.ltr:
          left = x;
          break;
      }
      final Rect rect = Offset(left, 0.0) & Size(width, size.height);

      paint.shader =
          linearGradient.createShader(rect, textDirection: textDirection);

      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ),
        paint,
      );
    }

    if (value != null) {
      drawBar(0.0, clampDouble(value!, 0.0, 1.0) * size.width);
    } else {
      final double x1 = size.width * line1Tail.transform(animationValue);
      final double width1 =
          size.width * line1Head.transform(animationValue) - x1;

      final double x2 = size.width * line2Tail.transform(animationValue);
      final double width2 =
          size.width * line2Head.transform(animationValue) - x2;

      drawBar(x1, width1);
      drawBar(x2, width2);
    }

    valueBuilderDelegate?._update(value ?? 0, textDirection);
    valueBuilderDelegate?._paint(
      canvas,
      valueBuilderDelegate!.getPosition(
          rect, value ?? 0
      ),
    );

    if (imagePainter != null && imageSize != null) {
      // The visual position is the position of the thumb from 0 to 1 from left
      // to right. In left to right, this is the same as the value, but it is
      // reversed for right to left text.
      final double visualPosition;
      switch (textDirection) {
        case TextDirection.rtl:
          visualPosition = 1.0 - (value ?? 0);
          break;
        case TextDirection.ltr:
          visualPosition = value ?? 0;
          break;
      }

      final Offset thumbCenter =
      Offset(rect.left + visualPosition * rect.width, rect.center.dy + imageVisualTopPosition);
      final imageRRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: thumbCenter,
          width: imageSize!.width,
          height: imageSize!.height,
        ),
        Radius.zero,
      );
      Path imagePath = Path()..addRRect(imageRRect);
      imagePainter!.paint(
        canvas,
        imageRRect.outerRect,
        imagePath,
        ImageConfiguration(size: imageSize),
      );
    }
  }

  @override
  bool shouldRepaint(_LinearProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection || oldPainter.hasImageLoaded != hasImageLoaded;
  }
}

/// A Material Design linear progress indicator, also known as a progress bar.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=O-rhXZLtpv0}
///
/// A widget that shows progress along a line. There are two kinds of linear
/// progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
///    value at each point in time and instead indicate that progress is being
///    made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
///
/// The indicator line is displayed with [valueColor], an animated value. To
/// specify a constant color value use: `AlwaysStoppedAnimation<Color>(color)`.
///
/// The minimum height of the indicator can be specified using [minHeight].
/// The indicator can be made taller by wrapping the widget with a [SizedBox].
///
/// {@tool dartpad}
/// This example shows a [LinearGradientProgressIndicator] with a changing value.
///
/// ** See code in examples/api/lib/material/progress_indicator/linear_progress_indicator.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows the creation of a [LinearGradientProgressIndicator] with a changing value.
/// When toggling the switch, [LinearGradientProgressIndicator] uses a determinate value.
/// As described in: https://m3.material.io/components/progress-indicators/overview
///
/// ** See code in examples/api/lib/material/progress_indicator/linear_progress_indicator.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CircularProgressIndicator], which shows progress along a circular arc.
///  * [RefreshIndicator], which automatically displays a [CircularProgressIndicator]
///    when the underlying vertical scrollable is overscrolled.
///  * <https://material.io/design/components/progress-indicators.html#linear-progress-indicators>
class LinearGradientProgressIndicator extends ProgressIndicator {
  /// Creates a linear progress indicator.
  ///
  /// {@macro flutter.material.ProgressIndicator.ProgressIndicator}
  const
  LinearGradientProgressIndicator({
    this.valueBuilderDelegate,
    super.key,
    super.value,
    required this.linearGradient,
    this.image,
    this.imageSize,
    this.imageVisualTopPosition = 0,
    this.borderRadius = BorderRadius.zero,
    super.backgroundColor,
    super.color,
    super.valueColor,
    this.minHeight,
    super.semanticsLabel,
    super.semanticsValue,
  }) : assert(minHeight == null || minHeight > 0);

  final LinearGradient linearGradient;
  final DecorationImage? image;
  final Size? imageSize;
  final BorderRadius borderRadius;
  final double imageVisualTopPosition;
  final LinearProgressValueBuilderDelegate? valueBuilderDelegate;

  /// {@template flutter.material.LinearProgressIndicator.trackColor}
  /// Color of the track being filled by the linear indicator.
  ///
  /// If [LinearGradientProgressIndicator.backgroundColor] is null then the
  /// ambient [ProgressIndicatorThemeData.linearTrackColor] will be used.
  /// If that is null, then the ambient theme's [ColorScheme.background]
  /// will be used to draw the track.
  /// {@endtemplate}
  @override
  Color? get backgroundColor => super.backgroundColor;

  /// {@template flutter.material.LinearProgressIndicator.minHeight}
  /// The minimum height of the line used to draw the linear indicator.
  ///
  /// If [LinearGradientProgressIndicator.minHeight] is null then it will use the
  /// ambient [ProgressIndicatorThemeData.linearMinHeight]. If that is null
  /// it will use 4dp.
  /// {@endtemplate}
  final double? minHeight;

  @override
  State<LinearGradientProgressIndicator> createState() =>
      _LinearProgressIndicatorState();
}

class _LinearProgressIndicatorState
    extends State<LinearGradientProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool hasImageLoaded = false;
  late final DecorationImagePainter? imagePainter =
  widget.image?.createPainter(update);

  void update() => setState(() {
    hasImageLoaded = true;
  });

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(LinearGradientProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.valueBuilderDelegate?.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, double animationValue,
      TextDirection textDirection) {
    final ProgressIndicatorThemeData defaults = Theme.of(context).useMaterial3
        ? _LinearProgressIndicatorDefaultsM3(context)
        : _LinearProgressIndicatorDefaultsM2(context);

    final ProgressIndicatorThemeData indicatorTheme =
    ProgressIndicatorTheme.of(context);
    final Color trackColor = widget.backgroundColor ??
        indicatorTheme.linearTrackColor ??
        defaults.linearTrackColor!;
    final double minHeight = widget.minHeight ??
        indicatorTheme.linearMinHeight ??
        defaults.linearMinHeight!;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: minHeight,
        ),
        child: CustomPaint(
          painter: _LinearProgressIndicatorPainter(
            hasImageLoaded: hasImageLoaded,
            imageVisualTopPosition: widget.imageVisualTopPosition,
            borderRadius: widget.borderRadius,
            imageSize: widget.imageSize,
            valueBuilderDelegate: widget.valueBuilderDelegate,
            linearGradient: widget.linearGradient,
            imagePainter: imagePainter,
            backgroundColor: trackColor,
            valueColor:
            widget._getValueColor(context, defaultColor: defaults.color),
            value: widget.value,
            // may be null
            animationValue: animationValue,
            // ignored if widget.value is not null
            textDirection: textDirection,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (widget.value != null) {
      return _buildIndicator(context, _controller.value, textDirection);
    }

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _controller.value, textDirection);
      },
    );
  }
}

class _LinearProgressIndicatorDefaultsM3 extends ProgressIndicatorThemeData {
  _LinearProgressIndicatorDefaultsM3(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.surfaceVariant;

  @override
  double get linearMinHeight => 4.0;
}

class _LinearProgressIndicatorDefaultsM2 extends ProgressIndicatorThemeData {
  _LinearProgressIndicatorDefaultsM2(this.context);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color get color => _colors.primary;

  @override
  Color get linearTrackColor => _colors.background;

  @override
  double get linearMinHeight => 4.0;
}

// END GENERATED TOKEN PROPERTIES - ProgressIndicator
