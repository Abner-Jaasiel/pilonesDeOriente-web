import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  String _textTheme = "dark";

  ThemeController() {
    _loadTheme();
  }

  ThemeMode getTheme() => _themeMode;
  String getTextTheme() => _textTheme;

  void setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    _textTheme = _themeMode == ThemeMode.dark ? "dark" : "light";
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('theme', _themeMode == ThemeMode.dark ? 1 : 2);
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themePreference = prefs.getInt('theme') ?? 1;
    print("AQUIIII QUERES PELEAR $themePreference");
    if (themePreference == 1) {
      _themeMode = ThemeMode.dark;
      _textTheme = "dark";
    } else {
      _themeMode = ThemeMode.light;
      _textTheme = "light";
    }

    notifyListeners();
  }
}
