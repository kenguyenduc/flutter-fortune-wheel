import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

///Generating a list of results based on priority values
List<Fortune> getFortuneValuesByPriority(List<Fortune> items) {
  List<Fortune> result = [];
  for (Fortune item in items) {
    result.addAll(List.generate(item.priority, (_) => item));
  }
  return result;
}

///Processing the rotation angle of the lucky value
double getRotateOfItem(int itemsCount, int index) =>
    (index / itemsCount) * 2 * math.pi + math.pi / 2;

///Handling check for light or dark mode
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
