import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Tema claro
final ThemeData salesAppLightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF0081F5),
    foregroundColor: Colors.white
  ),
  iconTheme: IconThemeData(color: Colors.black38),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black)
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF0081F5),     // Cor principal (ícones ativos, AppBar, botões)
    onPrimary: Colors.black38,      // Texto/ícone sobre a cor "primary"
    secondary: Color(0xFF0081F5),   // Cor secundária (badges, detalhes, etc.)
    onSecondary: Colors.white,      // Texto/ícone sobre a cor "secondary"
    tertiary: Color(0xFFFAFAFA),    // Cor terciária
    onTertiary: Color(0xFFD1D1D1),  // Texto/ícone sobre a cor "tertiary"
    surface: Color(0xFFFAFAFA),     // Fundo de Cards, BottomSheet, Dialogs
    onSurface: Colors.black,        // Texto/ícone sobre a cor "surface"
  ),
);

// Tema escuro
final ThemeData salesAppDarkTheme = ThemeData(
  brightness: Brightness.dark,
  extensions: const [
    SkeletonizerConfigData.dark(), // dark theme config
  ],
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF0081F5),
    foregroundColor: Colors.white
  ),
  iconTheme: IconThemeData(color: Colors.grey),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white)
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF0081F5),
    onPrimary: Colors.grey,
    secondary: Colors.white,
    onSecondary: Colors.black,
    tertiary: Color(0xFF3B3B3B),
    onTertiary: Color(0xFF4E4E4E),
    surface: Color(0xFF3B3B3B),
    onSurface: Colors.white,
  ),
);