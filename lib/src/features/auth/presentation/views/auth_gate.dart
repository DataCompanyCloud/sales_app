import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';

// 1) Cria um FutureProvider que retorna quantos clientes existem no local
final localCustomerCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final repo = await ref.read(customerRepositoryProvider.future);
  return repo.count();
});

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final countAsync = ref.watch(localCustomerCountProvider);

    return auth.when(
      error: (error, st) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => const Scaffold(
        body: Column(
          children: [
            Center(child: CircularProgressIndicator(color: Colors.red)),
            Text("Carregando")
          ],
        ),
      ),
      data: (user) {
        if (user == null) {
          // substitui a rota atual pela de login
          WidgetsBinding.instance.addPostFrameCallback(
            (duration) => context.goNamed(AppRoutes.login.name),
          );
          return const SizedBox.shrink();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (0 > 0) {
            // Já sincronizou antes
            context.goNamed(HomeRouter.home.name);
            return;
          }
          context.goNamed(AppRoutes.sync.name);
        });


        // 3) Se estiver logado, espera o count
        return countAsync.when(
          loading: () => const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Verificando sincronização…'),
                ],
              ),
            ),
          ),
          error: (e, st) => ErrorPage(
            exception: e is AppException
              ? e
              : AppException.errorUnexpected(e.toString()),
          ),
          data: (localCount) {
            // 4) Redireciona conforme o total
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (localCount > 0) {
                // Já sincronizou antes
                context.goNamed(HomeRouter.home.name);
                return;
              }
              context.goNamed(AppRoutes.sync.name);
            });
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

}