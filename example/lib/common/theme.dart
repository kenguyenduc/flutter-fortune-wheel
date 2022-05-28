import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: Colors.green,
  scaffoldBackgroundColor: const Color(0xFFC8E6C9),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
      .copyWith(secondary: Colors.green),
);
