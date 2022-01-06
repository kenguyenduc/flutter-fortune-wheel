import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

///Xử lý tạo danh sách kết quả theo giá trị ưu tiên
List<FortuneItem> getFortuneValuesByPriority(List<FortuneItem> items) {
  List<FortuneItem> result = [];
  for (FortuneItem item in items) {
    result.addAll(List.generate(item.priority, (_) => item));
  }
  return result;
}
