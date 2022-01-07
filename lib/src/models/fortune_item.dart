import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///Giá tri may mắn phần tử vòng quay
@immutable
class FortuneItem extends Equatable {
  const FortuneItem(
    this.titleName,
    this.backgroundColor, {
    this.priority = 1,
    this.icon,
  }) : assert(
          priority >= 0,
          'Priority value should be greater than or equal to 0.',
        );

  final String titleName;
  final Color backgroundColor;

  ///Dộ ưu tiên quay trúng - là số lần xuất hiện trong danh sách xoay trúng
  ///Mặc định [priority] = 1
  final int priority;
  final Widget? icon;

  @override
  List<Object?> get props => [titleName, priority, icon];

  FortuneItem copyWith({
    String? titleName,
    Color? backgroundColor,
    int? priority,
    Widget? icon,
  }) {
    return FortuneItem(
      titleName ?? this.titleName,
      backgroundColor ?? this.backgroundColor,
      priority: priority ?? this.priority,
      icon: icon ?? this.icon,
    );
  }
}
