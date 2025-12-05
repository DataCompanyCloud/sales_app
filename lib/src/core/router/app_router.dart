import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';
import 'package:sales_app/src/features/auth/presentation/router/auth_router.dart';
import 'package:sales_app/src/features/auth/presentation/views/auth_gate.dart';
import 'package:sales_app/src/features/auth/presentation/views/auth_page.dart';
import 'package:sales_app/src/features/auth/presentation/views/login_page.dart';
import 'package:sales_app/src/features/faq/presentation/router/faq_router.dart';
import 'package:sales_app/src/features/myProfile/presentation/router/my_profile_router.dart';
import 'package:sales_app/src/features/settings/presentation/router/settings_router.dart';
import 'package:sales_app/src/features/stockTransaction/presentation/router/transaction_router.dart';
import 'package:sales_app/src/features/storage/presentation/router/storage_router.dart';
import 'package:sales_app/src/features/sync/presentation/views/sync_page.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/error/presentation/router/error_router.dart';
import 'package:sales_app/src/features/forgotPassword/presentation/views/forgot_password_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
import 'package:sales_app/src/features/schedule/presentation/router/schedule_router.dart';
import 'package:sales_app/src/features/userType/presentation/views/user_type_page.dart';

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
    redirect: (BuildContext context, GoRouterState state) {
      final user = authAsync.value;
      final fullPath = state.fullPath ?? "";
      final goingToLogin = fullPath == '/login' || fullPath.startsWith('/login');
      final goingToAuthBiometric = fullPath == '/auth' || fullPath.startsWith('/auth');
      final biometricValidated = user?.isValidated ?? false;

      // Usuário não logado → envia para login
      if (user == null && !goingToLogin) {
        return '/login';
      }

      // Usuário logado mas sem autenticação biométrica → envia para digitalAuth
      if (user != null && !goingToAuthBiometric && !biometricValidated) {
        return '/auth';
      }

      // Usuário logado e biometria já validada → envia para home
      if (user != null && biometricValidated && (goingToLogin || goingToAuthBiometric)) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (ctx, state) => AuthGate(),
      ),
      GoRoute(
          path: '/sync',
          builder: (ctx, state) => SyncPage(title: "Sincronização")
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