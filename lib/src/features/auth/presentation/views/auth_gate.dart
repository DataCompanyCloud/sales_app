import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);

    return auth.when(
      error: (error, st) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => const Scaffold(
        body: Column(
          children: [
            Center(child: CircularProgressIndicator(color: Colors.red,)),
            Text("Carregando")
          ],
        ),
      ),
      data: (user) {
        // Se não estiver logado, vai para /login
        if (user == null) {
          // substitui a rota atual pela de login
          WidgetsBinding.instance.addPostFrameCallback(
            (duration) => context.goNamed(AppRoutes.login.name),
          );
          return const SizedBox.shrink();
        }
        // Se estiver logado, vai para /home
        WidgetsBinding.instance.addPostFrameCallback(
          (duration) => context.goNamed(HomeRouter.home.name),
        );
        return const SizedBox.shrink();
      },
    );
  }

}