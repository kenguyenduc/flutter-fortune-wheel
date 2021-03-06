import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

///Dùng để cấu hình hiển thị vòng quay may mắn
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

  ///Danh sách các phần tử may mắn
  final List<Fortune> items;

  ///Thời gian quay
  final Duration duration;

  ///Kiểm tra đang là chế độ quay ngẫu nhiên hay theo giá trị ưu tiên quay trúng
  ///[isSpinByPriority] = true : theo giá trị ưu tiên quay trúng
  ///[isSpinByPriority] = false : quay ngẫu nhiên
  final bool isSpinByPriority;

  ///Số vòng quay đến kết quả
  ///Default value [rotationCount] = 50
  final int rotationCount;

  ///Kích thước bánh xe may mắn
  ///Default value [size] = 0.8 * độ dài ngắn nhất của màn hình
  final double? size;

  ///Widget child của nút quay
  final Widget? childSpinButton;

  ///Widget thay thế nút quay
  final Widget? action;

  ///ButtonStyle của nút quay
  final ButtonStyle? spinButtonStyle;

  ///Tiêu đề nút quay
  final String? titleSpinButton;

  ///style của Tiêu đề nút quay
  final TextStyle? textStyleTitleSpinButton;

  ///UI mũi tên chỉ kết quả vòng quay
  final Widget? arrowView;

  ///Màu của mũi tên kết quả vòng quay
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
      size: radius ?? this.size,
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
