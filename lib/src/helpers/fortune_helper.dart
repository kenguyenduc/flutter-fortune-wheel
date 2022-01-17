import 'dart:ui';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:math' as _math;
import 'package:flutter/widgets.dart';

///Xử lý tạo danh sách kết quả theo giá trị ưu tiên
List<Fortune> getFortuneValuesByPriority(List<Fortune> items) {
  List<Fortune> result = [];
  for (Fortune item in items) {
    result.addAll(List.generate(item.priority, (_) => item));
  }
  return result;
}

bool isColorDark(Color color) {
  double darkness = 1 -
      ((0.299 * color.red) + (0.587 * color.green) + (0.114 * color.blue)) /
          255;
  if (darkness < 0.5) {
    return false; // It's a light color
  } else {
    return true; // It's a dark color
  }
}

double getSmallerSide(BoxConstraints constraints) {
  return _math.min(constraints.maxWidth, constraints.maxHeight);
}

double getLargerSide(BoxConstraints constraints) {
  return _math.max(constraints.maxWidth, constraints.maxHeight);
}

Offset getCenteredMargins(BoxConstraints constraints) {
  final smallerSide = getSmallerSide(constraints);
  return Offset(
    (constraints.maxWidth - smallerSide) / 2,
    (constraints.maxHeight - smallerSide) / 2,
  );
}

double convertRange(
  double value,
  double minA,
  double maxA,
  double minB,
  double maxB,
) {
  return (((value - minA) * (maxB - minB)) / (maxA - minA)) + minB;
}

extension PointX on _math.Point<double> {
  /// Rotates a [vector] by [angle] radians around the origin.
  ///
  /// See also:
  ///  * [Mathemical proof](https://matthew-brett.github.io/teaching/rotation_2d.html), for a detailed explanation
  _math.Point<double> rotate(double angle) {
    return _math.Point(
      _math.cos(angle) * x - _math.sin(angle) * y,
      _math.sin(angle) * x + _math.cos(angle) * y,
    );
  }
}

Offset calculateWheelOffset(
    BoxConstraints constraints, TextDirection textDirection) {
  final smallerSide = getSmallerSide(constraints);
  var offsetX = constraints.maxWidth / 2;
  if (textDirection == TextDirection.rtl) {
    offsetX = offsetX * -1 + smallerSide / 2;
  }
  return Offset(offsetX, constraints.maxHeight / 2);
}

double calculateSliceAngle(int index, int itemCount) {
  final anglePerChild = 2 * _math.pi / itemCount;
  final childAngle = anglePerChild * index;
  // first slice starts at 90 degrees, if 0 degrees is at the top.
  // The angle offset puts the center of the first slice at the top.
  final angleOffset = -(_math.pi / 2 + anglePerChild / 2);
  return childAngle + angleOffset;
}

double calculateAlignmentOffset(Alignment alignment) {
  if (alignment == Alignment.topRight) {
    return _math.pi * 0.25;
  }

  if (alignment == Alignment.centerRight) {
    return _math.pi * 0.5;
  }

  if (alignment == Alignment.bottomRight) {
    return _math.pi * 0.75;
  }

  if (alignment == Alignment.bottomCenter) {
    return _math.pi;
  }

  if (alignment == Alignment.bottomLeft) {
    return _math.pi * 1.25;
  }

  if (alignment == Alignment.centerLeft) {
    return _math.pi * 1.5;
  }

  if (alignment == Alignment.topLeft) {
    return _math.pi * 1.75;
  }

  return 0;
}
