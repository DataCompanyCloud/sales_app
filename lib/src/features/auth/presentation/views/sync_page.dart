import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/auth/presentation/controllers/sync_providers.dart';

class SyncPage extends ConsumerWidget {
  final String title;

  const SyncPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(syncViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Olá, vejo que é sua primeira vez aqui.\nDeseja sincronizar seus dados com a nuvem?",
              style: TextStyle(
                fontSize: 18
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    viewModelProvider.toggleOption(0);
                  },
                  icon: Icon(
                    viewModelProvider.isPressed == 0
                      ? Icons.check_box
                      : Icons.check_box_outline_blank
                  ),
                  color: viewModelProvider.isPressed == 0
                    ? Colors.cyan
                    : Colors.grey
                ),
                const Text("Recomendado"),
                IconButton(
                  onPressed: () {
                    viewModelProvider.toggleOption(1);
                  },
                  icon: Icon(
                    viewModelProvider.isPressed == 1
                      ? Icons.check_box
                      : Icons.check_box_outline_blank
                  ),
                  color: viewModelProvider.isPressed == 1
                    ? Colors.cyan
                    : Colors.grey
                ),
                const Text("Tudo"),
                // TODO Fazer a função de personalização para a página de sincronização. 
                IconButton(
                  onPressed: () {
                    viewModelProvider.toggleOption(2);
                  },
                  icon: Icon(
                    viewModelProvider.isPressed == 2
                      ? Icons.check_box
                      : Icons.check_box_outline_blank
                  ),
                  color: viewModelProvider.isPressed == 2
                    ? Colors.cyan
                    : Colors.grey
                ),
                const Text("Personalizado"),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12, left: 8, right: 8),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Icon(
                        viewModelProvider.isPressed == 1
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                        color: viewModelProvider.isPressed == 1
                          ? Colors.white
                          : Colors.blue.shade800
                      ),
                      Text(
                        "Produtos",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12, left: 8, right: 8),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Icon(
                        viewModelProvider.isPressed == 1 || viewModelProvider.isPressed == 0
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                        color: viewModelProvider.isPressed == 1 || viewModelProvider.isPressed == 0
                          ? Colors.white
                          : Colors.blue.shade800
                      ),
                      Text(
                        "Clientes",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12, left: 8, right: 8),
              child: Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Icon(
                        viewModelProvider.isPressed == 1
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                        color: viewModelProvider.isPressed == 1
                          ? Colors.white
                          : Colors.blue.shade800
                      ),
                      Text(
                        "Pedidos",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      ),
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