import 'package:flutter/material.dart';

class SliderThumbImage extends SliderComponentShape {
  final double thumbSize;
  final double dotSize;
  final Color thumbColor;
  final Color dotColor;

  SliderThumbImage(
    this.thumbSize,
    this.dotSize, {
    required this.thumbColor,
    required this.dotColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(0, 0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final canvas = context.canvas;

    final rectInner =
        Rect.fromCenter(center: center, width: dotSize, height: dotSize);
    final rect =
        Rect.fromCenter(center: center, width: thumbSize, height: thumbSize);

    Paint thumbPaint = Paint()
      ..filterQuality = FilterQuality.high
      ..style = PaintingStyle.fill
      ..color = thumbColor
      ..isAntiAlias = true;

    Paint dotPaint = Paint()
      ..filterQuality = FilterQuality.high
      ..style = PaintingStyle.fill
      ..color = dotColor
      ..isAntiAlias = true;

    canvas.drawOval(rect, thumbPaint);
    canvas.drawOval(rectInner, dotPaint);
  }
}
