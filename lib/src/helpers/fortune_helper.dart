import 'dart:ui';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

///Xử lý tạo danh sách kết quả theo giá trị ưu tiên
List<Fortune> getFortuneValuesByPriority(List<Fortune> items) {
  List<Fortune> result = [];
  for (Fortune item in items) {
    result.addAll(List.generate(item.priority, (_) => item));
  }
  return result;
}

///Xử lý kiểm tra màu sáng hoặc tối
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
