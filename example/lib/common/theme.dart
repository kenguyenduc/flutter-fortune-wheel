import 'package:flutter/material.dart';

//https://materialui.co/colors
class AppColors {
  static const MaterialColor green =
      MaterialColor(_greenPrimaryValue, <int, Color>{
    50: Color(0xFFE8F5E9),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(_greenPrimaryValue),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF558B2F),
    900: Color(0xFF33691E),
  });

  static const int _greenPrimaryValue = 0xFF4CAF50;

  static const MaterialColor blue =
      MaterialColor(_bluePrimaryValue, <int, Color>{
    50: Color(0xFFE7F0FC),
    100: Color(0xFFC3DBF8),
    200: Color(0xFF9BC3F4),
    300: Color(0xFF73AAF0),
    400: Color(0xFF5598EC),
    500: Color(_bluePrimaryValue),
    600: Color(0xFF317EE6),
    700: Color(0xFF2A73E3),
    800: Color(0xFF2369DF),
    900: Color(0xFF1656D9),
  });
  static const int _bluePrimaryValue = 0xFF3786E9;

  static const MaterialColor blueAccent =
      MaterialColor(_blueAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_blueAccentValue),
    400: Color(0xFFA4BFFF),
    700: Color(0xFF8BADFF),
  });
  static const int _blueAccentValue = 0xFFD7E3FF;

  static const MaterialColor gold =
      MaterialColor(_goldPrimaryValue, <int, Color>{
    50: Color(0xFFFCF3E7),
    100: Color(0xFFF8E2C4),
    200: Color(0xFFF4CE9D),
    300: Color(0xFFF0BA75),
    400: Color(0xFFECAC58),
    500: Color(_goldPrimaryValue),
    600: Color(0xFFE69534),
    700: Color(0xFFE38B2C),
    800: Color(0xFFDF8125),
    900: Color(0xFFD96F18),
  });
  static const int _goldPrimaryValue = 0xFFE99D3A;

  static const MaterialColor goldAccent =
      MaterialColor(_goldAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_goldAccentValue),
    400: Color(0xFFFFCBA6),
    700: Color(0xFFFFBC8C),
  });
  static const int _goldAccentValue = 0xFFFFE9D9;

  static const MaterialColor blueDark =
      MaterialColor(_blueDarkPrimaryValue, <int, Color>{
    50: Color(0xFFF3F8FE),
    100: Color(0xFFE1EDFC),
    200: Color(0xFFCDE1FA),
    300: Color(0xFFB9D5F7),
    400: Color(0xFFAACCF6),
    500: Color(_blueDarkPrimaryValue),
    600: Color(0xFF93BDF3),
    700: Color(0xFF89B5F1),
    800: Color(0xFF7FAEEF),
    900: Color(0xFF6DA1EC),
  });
  static const int _blueDarkPrimaryValue = 0xFF9BC3F4;

  static const MaterialColor blueDarkAccent =
      MaterialColor(_blueDarkAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_blueDarkAccentValue),
    400: Color(0xFFFCFDFF),
    700: Color(0xFFE3EEFF),
  });
  static const int _blueDarkAccentValue = 0xFFFFFFFF;
}

final ThemeData appTheme = ThemeData(
  primaryColor: Colors.green,
  scaffoldBackgroundColor: const Color(0xFFC8E6C9),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
      .copyWith(secondary: Colors.green),
);
