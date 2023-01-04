import 'package:flutter/material.dart';
import '../services/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: ThemeData.dark().dialogBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      hourMinuteTextColor: Colors.white,
      dialHandColor: const Color(0xFFFFC107),
      dialTextColor: Colors.white,
      dialBackgroundColor: ThemeData.dark().scaffoldBackgroundColor,
      entryModeIconColor: Colors.white,
      dayPeriodTextColor: Colors.white,
    ),
    primaryColor: const Color(0xFFFFC107),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: Colors.white,
          secondary: const Color(0xFFFFC107),
          brightness: Brightness.dark,
        ),
    scaffoldBackgroundColor: Colors.grey[900],
  );

  final lightTheme = ThemeData(
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      dialHandColor: const Color(0xFFFFC107),
      hourMinuteColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? Colors.grey.shade400
              : Colors.grey.shade300),
      dayPeriodColor: MaterialStateColor.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? Colors.grey.shade400
              : Colors.grey.shade300),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    ),
    primaryColor: const Color(0xFFFFC107),
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: Colors.black,
          secondary: const Color(0xFFFFC107),
          brightness: Brightness.light,
        ),
    scaffoldBackgroundColor: const Color.fromARGB(255, 231, 231, 231),
    canvasColor: Colors.grey[100],
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
