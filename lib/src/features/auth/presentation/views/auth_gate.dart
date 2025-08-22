import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/schedule/presentation/router/schedule_router.dart';

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
    // final countAsync = ref.watch(localCustomerCountProvider);

    return auth.when(
      error: (error, st) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () =>  const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Carregando...'),
            ],
          ),
        ),
      ),
      data: (user) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => context.goNamed(
            user != null
              ? ScheduleRouter.schedule.name
              : AppRoutes.login.name
          ),
        );

       return const Scaffold(
         body: Center(
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               CircularProgressIndicator(),
               SizedBox(height: 8),
               Text('Carregando…'),
             ],
           ),
         ),
       );
      },
    );
  }
}