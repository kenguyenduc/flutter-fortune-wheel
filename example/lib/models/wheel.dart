import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

@immutable
class Wheel {
  const Wheel({
    required this.fortuneValues,
    this.duration = const Duration(milliseconds: 5000),
    this.isGoByPriority = true,
  });

  final List<FortuneItem> fortuneValues;
  final Duration duration;
  final bool isGoByPriority;

  @override
  String toString() {
    return 'Wheel{fortuneValues: $fortuneValues, isGoByPriority: $isGoByPriority, duration:$duration}';
  }

  Wheel copyWith({
    List<FortuneItem>? fortuneValues,
    Duration? duration,
    bool? isGoByPriority,
  }) {
    return Wheel(
      fortuneValues: fortuneValues ?? this.fortuneValues,
      duration: duration ?? this.duration,
      isGoByPriority: isGoByPriority ?? this.isGoByPriority,
    );
  }
}
