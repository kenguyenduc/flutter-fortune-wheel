import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class Wheel {
  const Wheel({
    required this.wheelValues,
    this.isGoByPriority = true,
  });

  final List<FortuneItem> wheelValues;
  final bool isGoByPriority;

  @override
  String toString() {
    return 'Wheel{wheelValues: $wheelValues, isGoByPriority: $isGoByPriority}';
  }

  Wheel copyWith({
    List<FortuneItem>? wheelValues,
    bool? isGoByPriority,
  }) {
    return Wheel(
      wheelValues: wheelValues ?? this.wheelValues,
      isGoByPriority: isGoByPriority ?? this.isGoByPriority,
    );
  }
}
