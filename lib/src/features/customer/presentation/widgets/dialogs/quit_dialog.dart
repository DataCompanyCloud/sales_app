import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_providers.dart';

class QuitDialog extends ConsumerWidget {

  const QuitDialog ({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return AlertDialog(
      title: Text("Deseja sair?"),
      content: Text("Ao sair todo o progresso será perdido."),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                "Não",
                style: TextStyle(
                  fontSize: 14
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.goNamed(AppRoutes.createCustomer.name);
                ref.read(customerViewModelProvider.notifier).resetSteps();
              },
              child: Text(
                "Sim",
                style: TextStyle(
                  fontSize: 14
                ),
              )
            )
          ],
        )
      ],
    );
  }
}