import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/domain/entites/user.dart';
import 'package:sales_app/src/features/auth/presentation/views/auth_gate.dart';
import 'package:sales_app/src/features/auth/presentation/views/login_page.dart';
import 'package:sales_app/src/features/auth/presentation/views/sign_up_page.dart';
import 'package:sales_app/src/features/auth/presentation/views/sync_page.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/error_page/presentation/router/error_router.dart';
import 'package:sales_app/src/features/forgot_password/presentation/views/forgot_password_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/order/presentation/router/order_router.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
import 'package:sales_app/src/features/schedule/presentation/router/schedule_router.dart';

enum AppRoutes {
  login,
  signup,
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
  error
}


class _AuthStateChange extends ChangeNotifier {
  _AuthStateChange(Ref ref) {
    ref.listen<AsyncValue<User?>>(authControllerProvider, (_, __) {
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

      // se não autenticado e não estiver indo pra /login, manda pra /login
      if (user == null && !goingToLogin) {
        return '/login';
      }
      // se autenticado e estiver em /login, manda pra /home
      if (user != null && goingToLogin) {
        return '/home';
      }
      // senão, continua onde está
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (ctx, state) => AuthGate(),
      ),
      GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(title: "Login"),
          name: AppRoutes.login.name,
          routes: [
            GoRoute(
              path: 'signup',
              builder: (context, state) => SignUpPage(title: "Cadastre-se"),
              name: AppRoutes.signup.name,
            ),
            GoRoute(
              path: 'password',
              builder: (context, state) => ForgotPasswordPage(title: "Esquecer senha"),
              name: AppRoutes.passwordRecovery.name,
            ),
            GoRoute(
              path: 'sync',
              builder: (context, state) => SyncPage(title: "Bem-vindo ao SalesApp"),
              name: AppRoutes.sync.name,
            ),
          ]
      ),
      customerRoutes,
      homeRoutes,
      orderRoutes,
      productRoutes,
      agendaRoutes,
      errorRoutes
    ],
  );
});




