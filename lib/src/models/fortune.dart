import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

///Giá tri may mắn phần tử vòng quay
@immutable
class Fortune extends Equatable {
  const Fortune({
    required this.id,
    required this.titleName,
    required this.backgroundColor,
    this.priority = 1,
    this.icon,
  }) : assert(
          priority >= 0,
          'Priority value should be greater than or equal to 0.',
        );
  final int id;
  final String titleName;
  final Color backgroundColor;

  ///Hệ số ưu tiên quay trúng - là số lần xuất hiện trong danh sách xoay trúng
  ///Mặc định [priority] = 1
  final int priority;
  final Widget? icon;

  @override
  List<Object?> get props => [id, titleName, priority];

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
