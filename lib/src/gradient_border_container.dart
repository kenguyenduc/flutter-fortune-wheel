import 'package:flutter/material.dart';

class GradientBorderContainer extends StatelessWidget {
  GradientBorderContainer({
    Key? key,
    required gradient,
    required this.child,
    this.onPressed,
    this.strokeWidth = 4,
    this.borderRadius = 64,
    this.padding = 16,
    this.outlineWidth = 1,
    splashColor,
  })  : painter = _GradientPainter(
          gradient: gradient,
          strokeWidth: strokeWidth,
          borderRadius: borderRadius,
          outlineWidth: outlineWidth,
        ),
        splashColor = splashColor ?? gradient.colors.first,
        super(key: key);

  final _GradientPainter painter;
  final Widget child;
  final VoidCallback? onPressed;
  final double outlineWidth;
  final double strokeWidth;
  final double borderRadius;
  final double padding;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: painter,
      child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle),
          padding: EdgeInsets.zero,
          child: IntrinsicWidth(child: child)),
    );
  }
}

class _GradientPainter extends CustomPainter {
  _GradientPainter(
      {required this.gradient,
      required this.strokeWidth,
      required this.borderRadius,
      required this.outlineWidth});

  final Gradient gradient;
  final double strokeWidth;
  final double borderRadius;
  final double outlineWidth;
  final Paint paintObject = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    if (outlineWidth > 0) {
      _paintOutline(outlineWidth, size, canvas);
    }

    Rect innerRect = Rect.fromLTRB(strokeWidth, strokeWidth,
        size.width - strokeWidth, size.height - strokeWidth);
    RRect innerRoundedRect =
        RRect.fromRectAndRadius(innerRect, Radius.circular(borderRadius));

    Rect outerRect = Offset.zero & size;
    RRect outerRoundedRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(borderRadius));

    paintObject.shader = gradient.createShader(outerRect);
    Path borderPath = _calculateBorderPath(outerRoundedRect, innerRoundedRect);
    canvas.drawPath(borderPath, paintObject);
  }

  void _paintOutline(double outlineWidth, Size size, Canvas canvas) {
    Paint paint = Paint();
    Rect innerRectB = Rect.fromLTRB(
        strokeWidth + outlineWidth,
        strokeWidth + outlineWidth,
        size.width - strokeWidth - outlineWidth,
        size.height - strokeWidth - outlineWidth);
    RRect innerRRectB = RRect.fromRectAndRadius(
        innerRectB, Radius.circular(borderRadius - outlineWidth));

    Rect outerRectB = Rect.fromLTRB(-outlineWidth, -outlineWidth,
        size.width + outlineWidth, size.height + outlineWidth);
    RRect outerRRectB = RRect.fromRectAndRadius(
        outerRectB, Radius.circular(borderRadius + outlineWidth));

    Path borderBorderPath = _calculateBorderPath(outerRRectB, innerRRectB);
    paint.color = Colors.black;
    canvas.drawPath(borderBorderPath, paint);
  }

  Path _calculateBorderPath(RRect outerRRect, RRect innerRRect) {
    Path outerRectPath = Path()..addRRect(outerRRect);
    Path innerRectPath = Path()..addRRect(innerRRect);
    return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
