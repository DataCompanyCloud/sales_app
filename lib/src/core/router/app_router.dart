import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/presentation/views/login_page.dart';

enum AppRoutes { login, register, home, vehicleList, vehicleForm }

final goRouterProvider = GoRouter(
  initialLocation: '/login', // Rota inicial do app
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
      name: AppRoutes.login.name,
    ),
  ],
);