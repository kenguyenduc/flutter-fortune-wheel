import 'package:flutter/material.dart';

///Giá tri may mắn phần tử vòng quay
class Luck {
  Luck(
    this.value,
    this.color, {
    this.icon,
  });

  final int value;
  final Color color;
  final Widget? icon;
}
