import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

@immutable
class Wheel extends Equatable {
  const Wheel({
    required this.fortuneValues,
    this.duration = const Duration(milliseconds: 10000),
    this.isGoByPriority = true,
    this.rotationCount = 50,
    this.childSpinButton,
    this.radius,
  })  : assert(
          fortuneValues.length >= 2,
          'Not enough active slices. Fortune values need to activate at least 2 unique slices to be able to spin th wheel',
        ),
        assert(
            rotationCount >= 0, 'rotationCount need to activate at least 0 ');

  final List<Fortune> fortuneValues;
  final Duration duration;
  final bool isGoByPriority;
  final int rotationCount;
  final Widget? childSpinButton;
  final double? radius;

  @override
  String toString() {
    return 'Wheel{fortuneValues: $fortuneValues, isGoByPriority: $isGoByPriority, duration:$duration}';
  }

  Wheel copyWith({
    List<Fortune>? fortuneValues,
    Duration? duration,
    bool? isGoByPriority,
    int? rotationCount,
  }) {
    return Wheel(
      fortuneValues: fortuneValues ?? this.fortuneValues,
      duration: duration ?? this.duration,
      isGoByPriority: isGoByPriority ?? this.isGoByPriority,
    );
  }

  @override
  List<Object?> get props => [
        fortuneValues,
        duration,
        isGoByPriority,
        rotationCount,
        childSpinButton,
        radius,
      ];
}
