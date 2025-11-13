import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/core/themes.dart';
import 'package:sales_app/src/features/order/providers.dart';

class SalesApp extends ConsumerStatefulWidget {
  const SalesApp({super.key});

  @override
  ConsumerState<SalesApp> createState() => SalesAppState();
}

class SalesAppState extends ConsumerState<SalesApp> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // chama quando o app abre pela primeira vez
    _syncOrdersOnAppOpen();
  }

  Future<void> _syncOrdersOnAppOpen() async {
    try {
      // pega o OrderService via Riverpod
      final orderService = await ref.read(orderSyncServiceProvider.future);

      // aqui você chama o método que sincroniza e usa notificações
      await orderService.syncOrders(showNotification: true);
    } catch (e, st) {
      // log se quiser
      debugPrint('Erro ao sincronizar pedidos: $e\n$st');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // quando o usuário voltar pro app (de background pra foreground)
    if (state == AppLifecycleState.resumed) {
      _syncOrdersOnAppOpen();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
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
      routerConfig: goRouter,
      theme: salesAppLightTheme,
      darkTheme: salesAppDarkTheme,
      themeMode: ThemeMode.system,
    );
  }
}