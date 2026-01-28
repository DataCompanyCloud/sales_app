import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/widgets/fade_transition.dart';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';
import 'package:sales_app/src/features/auth/presentation/router/auth_router.dart';
import 'package:sales_app/src/features/auth/presentation/views/auth_gate.dart';
import 'package:sales_app/src/features/faq/presentation/router/faq_router.dart';
import 'package:sales_app/src/features/myProfile/presentation/router/my_profile_router.dart';
import 'package:sales_app/src/features/settings/presentation/router/settings_router.dart';
import 'package:sales_app/src/features/stockTransaction/presentation/router/transaction_router.dart';
import 'package:sales_app/src/features/storage/presentation/router/storage_router.dart';
import 'package:sales_app/src/features/sync/presentation/views/sync_page.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/error/presentation/router/error_router.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
import 'package:sales_app/src/features/schedule/presentation/router/schedule_router.dart';

enum AppRoutes {
  userType,
  login,
  sync,
  passwordRecovery,
  customer,
  customerDetails,
  createCustomer,
  home,
  order,
  product,
  productDetails,
  schedule,
  error,
  storage,
  storageDetails,
  auth,
  movement,
  faq,
  myProfile,
  settings,
}

class _AuthStateChange extends ChangeNotifier {
  _AuthStateChange(Ref ref) {
    ref.listen<AsyncValue<User?>>(authControllerProvider, (_, _) {
      notifyListeners();
    });
  }
}


final goRouterProvider = Provider((ref) {
  final authAsync = ref.watch(authControllerProvider);
  final authListener = _AuthStateChange(ref);


  return GoRouter(
    refreshListenable: authListener,        // aqui ele “ouve” o AuthController
    initialLocation: '/',                   // rota inicial
    redirectLimit: 10,
    redirect: (BuildContext context, GoRouterState state) {
      final user = authAsync.value;
      final fullPath = state.fullPath ?? "";

      final goingToLogin = fullPath == '/login' || fullPath.startsWith('/login');
      final goingToAuth = fullPath == '/auth' || fullPath.startsWith('/auth');
      final goingToSync = fullPath == '/sync' || fullPath.startsWith('/sync');

      final isLogged = user != null;
      final isSynced = user?.isSync ?? false;
      final biometricValidated = user?.isValidated ?? false;

      // Usuário não logado → envia para login
      if (!isLogged) {
        if (!goingToLogin) {
          return '/login';
        }
        return null;
      }

      // Usuário logado mas sem autenticação biométrica → envia para digitalAuth
      if (!biometricValidated) {
        if (!goingToAuth) {
          return '/auth';
        }
        return null;
      }

      // Usuário logado ou autenticado mas não sincronizado → envia para sincronização
      if (!isSynced) {
        if (!goingToSync) {
          return '/sync';
        }

        return null;
      }


      // Usuário logado ou autenticado e sincronizado → envia para home
      if (isSynced && biometricValidated) {
        if ((fullPath == '/' || goingToLogin || goingToAuth || goingToSync)) {
          return '/home';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (ctx, state) => fadePage(child: const AuthGate(), key: state.pageKey),
      ),
      GoRoute(
          path: '/sync',
          pageBuilder: (ctx, state) => fadePage(child: const SyncPage(), key: state.pageKey),
      ),
      ...authRoutes,
      customerRoutes,
      homeRoutes,
      orderRoutes,
      productRoutes,
      agendaRoutes,
      errorRoutes,
      storageRoutes,
      transactionRoutes,
      faqRoutes,
      myProfileRoutes,
      settingsRoutes,
    ],
  );
});