import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _themePreferenceKey = 'isDarkMode';
  bool isDarkMode = false;

  ThemeController() {
    _loadThemePreference();
  }

  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
  );

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    _saveThemePreference(isDarkMode);
    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
    notifyListeners();
  }

  Future<void> _saveThemePreference(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themePreferenceKey, isDarkMode);
  }
}
