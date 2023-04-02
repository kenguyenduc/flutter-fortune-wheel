import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

///Used to configure the lucky wheel display
@immutable
class Wheel extends Equatable {
  const Wheel({
    required this.items,
    this.duration = const Duration(seconds: 10),
    this.isSpinByPriority = true,
    this.size,
    this.rotationCount = 50,
    this.childSpinButton,
    this.action,
    this.spinButtonStyle,
    this.titleSpinButton,
    this.textStyleTitleSpinButton,
    this.arrowView,
    this.colorIndicator,
  })  : assert(items.length >= 2),
        assert(rotationCount >= 0);

  ///List of lucky elements
  final List<Fortune> items;

  ///Spin time
  final Duration duration;

  ///For check mode
  ///[isSpinByPriority] = true :  According to priority value of the winning spin mode
  ///[isSpinByPriority] = false : Random spin mode
  final bool isSpinByPriority;

  ///Number of spins to reach the result
  ///Default value [rotationCount] = 50
  final int rotationCount;

  ///Size of the lucky wheel
  ///Default value [size] = 0.8 * The shortest length of the screen.
  final double? size;

  ///Widget spin button
  final Widget? childSpinButton;

  ///Widget Replace spin button
  final Widget? action;

  ///Spin Button Style
  final ButtonStyle? spinButtonStyle;

  ///title spin button
  final String? titleSpinButton;

  ///Button title style
  final TextStyle? textStyleTitleSpinButton;

  ///UI arrow
  final Widget? arrowView;

  ///Color arrow
  final Color? colorIndicator;

  Wheel copyWith({
    List<Fortune>? items,
    Duration? duration,
    bool? isSpinByPriority,
    int? rotationCount,
    double? radius,
    Widget? childSpinButton,
    Widget? action,
    ButtonStyle? spinButtonStyle,
    String? titleSpinButton,
    TextStyle? textStyleTitleSpinButton,
    Widget? arrowView,
    Color? colorIndicator,
  }) {
    return Wheel(
      items: items ?? this.items,
      duration: duration ?? this.duration,
      isSpinByPriority: isSpinByPriority ?? this.isSpinByPriority,
      rotationCount: rotationCount ?? this.rotationCount,
      size: radius ?? size,
      childSpinButton: childSpinButton ?? this.childSpinButton,
      action: action ?? this.action,
      spinButtonStyle: spinButtonStyle ?? this.spinButtonStyle,
      titleSpinButton: titleSpinButton ?? this.titleSpinButton,
      textStyleTitleSpinButton:
          textStyleTitleSpinButton ?? this.textStyleTitleSpinButton,
      arrowView: arrowView ?? this.arrowView,
      colorIndicator: colorIndicator ?? this.colorIndicator,
    );
  }

  @override
  List<Object?> get props => [
        items,
        duration,
        isSpinByPriority,
        rotationCount,
        childSpinButton,
        size,
        action,
        spinButtonStyle,
        titleSpinButton,
        textStyleTitleSpinButton,
        arrowView,
        colorIndicator,
      ];
}
