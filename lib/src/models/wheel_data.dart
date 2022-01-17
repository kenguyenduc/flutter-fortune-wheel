import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter_fortune_wheel/src/helpers/helpers.dart';

class WheelData {
  final BoxConstraints constraints;
  final int itemCount;
  final TextDirection textDirection;

  late final double smallerSide = getSmallerSide(constraints);
  late final double largerSide = getLargerSide(constraints);
  late final double sideDifference = largerSide - smallerSide;
  late final Offset offset = calculateWheelOffset(constraints, textDirection);
  late final Offset dOffset = Offset(
    (constraints.maxHeight - smallerSide) / 2,
    (constraints.maxWidth - smallerSide) / 2,
  );
  late final double diameter = smallerSide;
  late final double radius = diameter / 2;
  late final double itemAngle = 2 * pi / itemCount;

  WheelData({
    required this.constraints,
    required this.itemCount,
    required this.textDirection,
  });
}
