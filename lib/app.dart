import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/core/themes.dart';

class SalesApp extends ConsumerWidget {
  const SalesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Sales App',
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        // Locale('en'), // English
        Locale('pt'), // Portuguese
        //Locale('es'), // Spanish
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      routerConfig: goRouterProvider,
      theme: salesAppLightTheme,
      darkTheme: salesAppDarkTheme,
      themeMode: ThemeMode.system,
    );
  }
}