import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/sync/presentation/controllers/sync_controller.dart';

class SyncPage extends ConsumerWidget {
  final String title;

  const SyncPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressCustomer = ref.watch(syncProgressCustomerProvider);
    // final processProducts = ref.watch(syncProgressProductsProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                "Bem-vindo ao SalesApp!",
                style: TextStyle(
                  color: Color(0xFF0081F5),
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Text(
              "Olá, vejo que é sua primeira vez aqui.\nDeseja sincronizar seus dados com a nuvem?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 12, left: 32, right: 32),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF0081F5)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Produtos",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12, left: 32, right: 32),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFF0081F5)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_box,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            "Clientes",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '${progressCustomer.round()} %',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(AppRoutes.home.name);
          // final user = ref.read(authControllerProvider);
          // ref.read(authControllerProvider.notifier).updateAuth(user.value!.copyWith(hasSynced: true));
          return;
          if (progressCustomer >= 100) {

            return;
          }
          final _ = ref.refresh(syncCustomerProvider);
          // context.goNamed(AppRoutes.home.name);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
        ),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }
}