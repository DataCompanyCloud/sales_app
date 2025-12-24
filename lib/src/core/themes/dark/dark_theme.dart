import 'package:flutter/material.dart';
import 'package:sales_app/src/core/themes/foundations/app_colors.dart';

// Tema escuro

class DarkTheme {
  static ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
  );
}