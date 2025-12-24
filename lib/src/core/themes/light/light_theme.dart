import 'package:flutter/material.dart';
import 'package:sales_app/src/core/themes/foundations/app_colors.dart';
import 'package:sales_app/src/core/themes/foundations/app_text_styles.dart';

// Tema claro
class LightTheme {
  static ThemeData get theme => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    textTheme: TextTheme(
      titleLarge: AppTextStyles.title,
    ),
  );
}