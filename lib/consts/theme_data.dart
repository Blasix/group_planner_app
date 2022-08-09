import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: ThemeData().colorScheme.copyWith(
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
    );
  }
}
