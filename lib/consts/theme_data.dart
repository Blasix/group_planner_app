import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:
          isDarkTheme ? Colors.grey[900] : Colors.blueGrey[50],
      primarySwatch: Colors.orange,
      colorScheme: ThemeData().colorScheme.copyWith(
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
    );
  }
}
