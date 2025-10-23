import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/domain/entities/user.dart';
import 'package:sales_app/src/features/auth/presentation/views/auth_gate.dart';
import 'package:sales_app/src/features/auth/presentation/views/digital_authenticator_page.dart';
import 'package:sales_app/src/features/auth/presentation/views/login_page.dart';
import 'package:sales_app/src/features/storage/presentation/router/storage_router.dart';
import 'package:sales_app/src/features/sync/presentation/views/sync_page.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/error/presentation/router/error_router.dart';
import 'package:sales_app/src/features/forgotPassword/presentation/views/forgot_password_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/order/presentation/router/order_router.dart';
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
  digitalAuth
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
      final goingToLogin = fullPath == '/login' || fullPath.startsWith('/login/');
      final goingToBiometric = fullPath == '/digitalAuth' || fullPath.startsWith('/digitalAuth/');
      final biometricValidated = user?.isValidated ?? false;

      // Usuário não logado → envia para login
      if (user == null && !goingToLogin) {
        return '/login';
      }

      // Usuário logado mas sem autenticação biométrica → envia para digitalAuth
      if (user != null && !goingToBiometric && !biometricValidated) {
        return '/digitalAuth';
      }

      // Usuário logado e biometria já validada → envia para home
      if (user != null && biometricValidated && (goingToLogin || goingToBiometric)) {
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
        builder: (context, state) => SyncPage(title: "Bem-vindo ao SalesApp"),
        name: AppRoutes.sync.name,
      ),
      GoRoute(
        path: '/digitalAuth',
        builder: (context, state) => DigitalAuthenticatorPage(),
        name: AppRoutes.digitalAuth.name,
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
        name: AppRoutes.login.name,
        routes: [
          GoRoute(
            path: 'password',
            builder: (context, state) => ForgotPasswordPage(title: "Esquecer senha"),
            name: AppRoutes.passwordRecovery.name,
          ),
          GoRoute(
            path: '/userType',
            builder: (context, state) => UserTypePage(),
            name: AppRoutes.userType.name,
          ),
        ]
      ),
      customerRoutes,
      homeRoutes,
      orderRoutes,
      productRoutes,
      agendaRoutes,
      errorRoutes,
      storageRoutes
    ],
  );
});