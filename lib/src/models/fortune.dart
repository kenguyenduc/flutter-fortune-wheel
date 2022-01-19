import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///Giá tri may mắn phần tử vòng quay
@immutable
class Fortune extends Equatable {
  const Fortune({
    required this.id,
    this.titleName,
    required this.backgroundColor,
    this.priority = 1,
    this.icon,
    this.textStyle,
  })  : assert(priority >= 0),
        assert(titleName != null || icon != null);

  ///id giá trị mat mắn dùng để xác định phần tử trong danh sách random
  final int id;

  ///Tiêu đề giá trị may mắn
  final String? titleName;

  ///Màu nền của giá trị may mắn
  final Color backgroundColor;

  ///Hệ số ưu tiên quay trúng - là số lần xuất hiện trong danh sách xoay trúng
  ///Mặc định [priority] = 1
  final int priority;

  ///Icon giá trị may mắn
  final Widget? icon;

  ///style của tiêu đề
  final TextStyle? textStyle;

  @override
  List<Object?> get props => [id, titleName, priority, backgroundColor, icon];

  Fortune copyWith({
    String? titleName,
    Color? backgroundColor,
    int? priority,
    Widget? icon,
  }) {
    return Fortune(
      id: id,
      titleName: titleName ?? this.titleName,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      priority: priority ?? this.priority,
      icon: icon ?? this.icon,
    );
  }
}
