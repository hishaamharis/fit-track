import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _showNotifications = true;
  int _waterGoal = 8;
  ThemeMode _themeMode = ThemeMode.light;

  bool get isDarkMode => _isDarkMode;
  bool get showNotifications => _showNotifications;
  int get waterGoal => _waterGoal;
  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    _showNotifications = prefs.getBool('notifications') ?? true;
    _waterGoal = prefs.getInt('waterGoal') ?? 8;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    _themeMode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _showNotifications = !_showNotifications;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _showNotifications);
    notifyListeners();
  }

  Future<void> setWaterGoal(int goal) async {
    _waterGoal = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('waterGoal', goal);
    notifyListeners();
  }
}