import 'package:flutter/material.dart';

class AppTheme {
  static const lightThemeString = 'light-theme';
  static const darkThemeString = 'dark-theme';

  static final lightTheme = ThemeData();

  static final _themes = <String, ThemeData>{
    lightThemeString: lightTheme,
    darkThemeString: lightTheme,
  };

  // ignore: avoid-unused-parameters
  static ThemeData? getTheme(String theme) => _themes[theme];
}
