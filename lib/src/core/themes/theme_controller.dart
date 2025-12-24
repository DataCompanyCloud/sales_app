import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme() {
    themeMode =
    themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}