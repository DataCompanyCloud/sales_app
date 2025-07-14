import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/presentation/views/login_page.dart';
import 'package:sales_app/src/features/auth/presentation/views/sign_up_page.dart';
import 'package:sales_app/src/features/customer/presentation/views/customer_details.dart';
import 'package:sales_app/src/features/customer/presentation/views/customer_page.dart';
import 'package:sales_app/src/features/forgot_password/presentation/views/forgot_password_page.dart';
import 'package:sales_app/src/features/home/presentation/views/home_page.dart';
import 'package:sales_app/src/features/order/presentation/views/order_page.dart';
import 'package:sales_app/src/features/product/presentation/views/product_page.dart';
import 'package:sales_app/src/features/schedule/presentation/views/agenda_page.dart';

enum AppRoutes { login, signup, passwordRecovery, customer, customerDetails, home, order, product, schedule }

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
        )
      ]
    ),
    GoRoute(
      path: '/customer',
      builder: (context, state) => CustomerPage(title: "Clientes"),
      name: AppRoutes.customer.name,
      routes:  [
        GoRoute(
          path: 'customer_details',
          builder: (context, state) {
            final customerId = state.extra as int;
            return CustomerDetails(title: "", customerId: customerId);
          },
          name: AppRoutes.customerDetails.name,
        ),
      ]
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(title: "Início"),
      name: AppRoutes.home.name,
    ),
    GoRoute(
      path: '/order',
      builder: (context, state) => OrderPage(title: "Pedidos"),
      name: AppRoutes.order.name,
    ),
    GoRoute(
      path: '/product',
      builder: (context, state) => ProductPage(title: "Produtos"),
      name: AppRoutes.product.name,
    ),
    GoRoute(
      path: '/schedule',
      builder: (context, state) => AgendaPage(title: "Agenda"),
      name: AppRoutes.schedule.name,
    ),
  ],
);