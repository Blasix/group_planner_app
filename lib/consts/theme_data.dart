import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primaryColor: const Color(0xFFFFC107),
      scaffoldBackgroundColor:
          isDarkTheme ? Colors.grey[900] : Colors.blueGrey[50],
      colorScheme: ThemeData().colorScheme.copyWith(
            primary: const Color(0xFFFFC107),
            secondary: const Color(0xFFFFC107),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
    );
  }
}
