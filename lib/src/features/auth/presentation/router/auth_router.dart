import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/auth/presentation/views/auth_page.dart';
import 'package:sales_app/src/features/auth/presentation/views/login_page.dart';
import 'package:sales_app/src/features/forgotPassword/presentation/views/forgot_password_page.dart';
import 'package:sales_app/src/features/userType/presentation/views/user_type_page.dart';

enum AuthRouter {
  auth,
  login,
  forgotPassword,
  userType
}

final authRoutes = [
  GoRoute(
    path: '/auth',
    builder: (context, state) => AuthPage(),
    name: AuthRouter.auth.name,
  ),
  GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
      name: AuthRouter.login.name,
      routes: [
        GoRoute(
          path: 'forgotPassword',
          builder: (context, state) => ForgotPasswordPage(title: "Esquecer senha"),
          name: AuthRouter.forgotPassword.name,
        ),
        GoRoute(
          path: '/userType',
          builder: (context, state) => UserTypePage(),
          name: AuthRouter.userType.name,
        ),
      ]
  ),
];