import 'package:flutter/material.dart';
import '../services/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primaryColor: const Color(0xFFFFC107),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color(0xFFFFC107),
          secondary: const Color(0xFFFFC107),
          brightness: Brightness.dark,
        ),
    scaffoldBackgroundColor: Colors.grey[900],
  );

  final lightTheme = ThemeData(
    primaryColor: const Color(0xFFFFC107),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color(0xFFFFC107),
          secondary: const Color(0xFFFFC107),
          brightness: Brightness.light,
        ),
    scaffoldBackgroundColor: Colors.grey[50],
  );

  ThemeData _themeData = ThemeData();
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      // print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        // print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
