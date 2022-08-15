import 'package:flutter/material.dart';
import '../services/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primaryColor: const Color(0xFFFFC107),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: Colors.white,
          secondary: const Color(0xFFFFC107),
          brightness: Brightness.dark,
        ),
    scaffoldBackgroundColor: Colors.grey[900],
  );

  final lightTheme = ThemeData(
    primaryColor: const Color(0xFFFFC107),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: Colors.black,
          secondary: const Color(0xFFFFC107),
          brightness: Brightness.light,
        ),
    scaffoldBackgroundColor: Colors.grey[300],
  );

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode getTheme() => _themeMode;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      // print('value read from storage: ' + value.toString());
      var themeMode = value ?? 'system';
      if (themeMode == 'light') {
        _themeMode = ThemeMode.light;
      } else if (themeMode == 'dark') {
        // print('setting dark theme');
        _themeMode = ThemeMode.dark;
      } else if (themeMode == 'system') {
        // print('setting dark theme');
        _themeMode = ThemeMode.system;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeMode = ThemeMode.dark;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeMode = ThemeMode.light;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  void setSystemMode() async {
    _themeMode = ThemeMode.system;
    StorageManager.saveData('themeMode', 'system');
    notifyListeners();
  }
}
