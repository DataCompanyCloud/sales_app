import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/presentation/views/login_page.dart';
import 'package:sales_app/src/features/auth/presentation/views/sign_up_page.dart';
import 'package:sales_app/src/features/auth/presentation/views/sync_page.dart';
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

final goRouterProvider = GoRouter(
  initialLocation: '/login', // Rota inicial do app
  routes: [
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