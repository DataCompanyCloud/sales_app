import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Tema claro

final ThemeData salesAppLightTheme = (() {
  // Paleta base
  const seed     = Color(0xFF0081F5);  // sua cor primária (brand)
  const bg       = Color(0xFFF8FAFC);  // fundo (clean)
  const surface  = Color(0xFFFFFFFF);  // card/surface
  const surfVar  = Color(0xFFF1F5F9);  // surfaceVariant (inputs, chips)
  const outline  = Color(0xFFE5E7EB);  // borda sutil

  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  ).copyWith(
    background: bg,
    surface: surface,
    surfaceVariant: surfVar,
    outline: outline,
  );

  final radius = BorderRadius.circular(16);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,

    // Skeletonizer no light
    extensions: const [SkeletonizerConfigData()],

    // AppBar clean (sem tint/elevation)
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: scheme.onSurface),
      titleTextStyle: TextStyle(
        color: scheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,      // deixa ver o fundo
        statusBarIconBrightness: Brightness.dark, // ANDROID: ícones escuros
        statusBarBrightness: Brightness.light,    // iOS: conteúdo escuro
      ),
    ),

    // Ícones em tom secundário
    iconTheme: IconThemeData(color: scheme.onSurfaceVariant),

    // Cards minimalistas
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: scheme.outline),
      ),
      margin: EdgeInsets.zero,
    ),

    // Divisores / bordas
    dividerTheme: DividerThemeData(
      color: scheme.outline,
      thickness: 1,
      space: 1,
    ),

    // Inputs "filled" discretos
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceVariant,
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      labelStyle: TextStyle(color: scheme.onSurface),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
    ),

    // Botões
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: radius),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(borderRadius: radius),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),

    // Texto: deixe o scheme cuidar; só garantimos contraste suave
    textTheme: Typography.blackMountainView.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),

    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide(color: scheme.outline),
      labelStyle: TextStyle(color: scheme.onSurface),
      backgroundColor: scheme.surfaceContainerHighest,
      selectedColor: scheme.primary.withOpacity(.18),
      disabledColor: scheme.surfaceContainerHighest.withOpacity(.6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
  );
})();


// Tema escuro
final ThemeData salesAppDarkTheme = (() {
  // Paleta base
  const seed = Color(0xFF0081F5);       // sua cor primária
  const bg   = Color(0xFF0F172A);       // fundo (slate-900)
  const surf = Color(0xFF1E293B);       // card/surface (slate-800)
  const surfVar = Color(0xFF273449);    // surfaceVariant (um tom acima)
  const outline = Color(0xFF334155);    // borda sutil (slate-700)

  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  ).copyWith(
    background: bg,
    surface: surf,
    surfaceVariant: surfVar,
    outline: outline,
  );

  final radius = BorderRadius.circular(16);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,

    extensions: const [SkeletonizerConfigData.dark()],

    // AppBar clean (sem overlay/tint)
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: scheme.onSurface),
      titleTextStyle: TextStyle(
        color: scheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // ANDROID
        statusBarBrightness: Brightness.dark,      // iOS
      ),
    ),

    // Ícones em tom secundário legível
    iconTheme: IconThemeData(color: scheme.onSurfaceVariant),

    // Cards minimalistas
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: scheme.outline.withOpacity(.4)),
      ),
      margin: EdgeInsets.zero,
    ),

    // Divisores/bordas suaves
    dividerTheme: DividerThemeData(
      color: scheme.outline.withOpacity(.4),
      thickness: 1,
      space: 1,
    ),

    // Campos de texto “filled” discretos
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceVariant.withOpacity(.55),
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      labelStyle: TextStyle(color: scheme.onSurface),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.outline.withOpacity(.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.outline.withOpacity(.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
    ),

    // Botões consistentes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: radius),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(borderRadius: radius),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),

    // Textos: deixe o ColorScheme resolver (sem forçar branco)
    // Se quiser um leve ajuste de legibilidade:
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),

    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide(color: scheme.outline.withOpacity(.5)),
      labelStyle: TextStyle(color: scheme.onSurface),
      backgroundColor: scheme.surfaceContainerHighest.withOpacity(.55),
      selectedColor: scheme.primary.withOpacity(.24),
      disabledColor: scheme.surfaceContainerHighest.withOpacity(.35),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
  );
})();