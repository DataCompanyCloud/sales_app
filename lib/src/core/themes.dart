import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Tema claro
final ThemeData salesAppLightTheme = (() {
  // Paleta base
  const seed    = Color(0xFF0081F5); // primária
  const bg      = Color(0xFFF8FAFC); // slate-50
  const surf    = Color(0xFFFFFFFF); // surface clara
  const surfVar = Color(0xFFF1F5F9); // slate-100
  const outline = Color(0xFFD0D5DD); // borda sutil (slate-300)

  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
  ).copyWith(
    // Neutros / superfícies
    surface: surf,
    onSurface: const Color(0xFF0F172A),
    surfaceContainerHighest: surfVar,
    onSurfaceVariant: const Color(0xFF475569), // slate-600
    outline: outline,
    outlineVariant: const Color(0xFF94A3B8),   // slate-400
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: const Color(0xFF1E293B),  // dark surface

    // Primários (azul)
    primary: const Color(0xFF006AD5),
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFD6E3FF),
    onPrimaryContainer: const Color(0xFF001B3D),
    inversePrimary: const Color(0xFF66B2FF),

    // Secundários (acinzentado azulado)
    secondary: const Color(0xFF64748B),       // slate-500
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFE2E8F0),
    onSecondaryContainer: const Color(0xFF1E293B),

    // Terciários (teal suave para realces)
    tertiary: const Color(0xFF0D9488),
    onTertiary: Colors.white,
    tertiaryContainer: const Color(0xFF99F6E4),
    onTertiaryContainer: const Color(0xFF04201C),

    // Erros (M3 light)
    error: const Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: const Color(0xFFFFDAD6),
    onErrorContainer: const Color(0xFF410002),
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
  const seed    = Color(0xFF0081F5); // primária
  const bg      = Color(0xFF0F172A); // slate-900
  const surf    = Color(0xFF1E293B); // slate-800
  const surfVar = Color(0xFF273449); // ~slate-750
  const outline = Color(0xFF334155); // slate-700

  final scheme = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
  ).copyWith(
    // Neutros / superfícies
    surface: surf,
    onSurface: const Color(0xFFE2E8F0),
    surfaceContainerHighest: surfVar,
    onSurfaceVariant: const Color(0xFF94A3B8), // slate-400
    outline: outline,
    outlineVariant: const Color(0xFF475569),   // slate-600
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: const Color(0xFFE2E8F0),

    // Primários (azul)
    primary: const Color(0xFF66B2FF),          // azul claro p/ dark
    onPrimary: const Color(0xFF001A2E),
    primaryContainer: const Color(0xFF0E3A66), // navy container
    onPrimaryContainer: const Color(0xFFCAE6FF),
    inversePrimary: const Color(0xFF2A8BF2),

    // Secundários (acinzentado azulado)
    secondary: const Color(0xFF94A3B8),        // slate-400
    onSecondary: const Color(0xFF0B1220),
    secondaryContainer: const Color(0xFF2A364B),
    onSecondaryContainer: const Color(0xFFDDE4F0),

    // Terciários (teal suave p/ realces)
    tertiary: const Color(0xFF2DD4BF),
    onTertiary: const Color(0xFF06201C),
    tertiaryContainer: const Color(0xFF134E4A),
    onTertiaryContainer: const Color(0xFFB8FFF3),

    // Erros (M3 dark)
    error: const Color(0xFFFFB4AB),
    onError: const Color(0xFF690005),
    errorContainer: const Color(0xFF93000A),
    onErrorContainer: const Color(0xFFFFDAD6),
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