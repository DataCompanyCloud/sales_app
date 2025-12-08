import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';

class QuitDialog extends ConsumerWidget {

  const QuitDialog ({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return AlertDialog(
      title: Text("Deseja sair?"),
      content: Text("Ao sair todo o processo de cadastro será perdido."),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 120,
              child: FilledButton(
                onPressed: () {
                  context.pop();
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12)
                    )
                  ),
                  backgroundColor: Colors.grey
                ),
                child: Text(
                  "Não",
                  style: TextStyle(
                    fontSize: 14
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: FilledButton(
                onPressed: () {
                  context.goNamed(CustomerRouter.createCustomer.name);
                },
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12)
                    )
                  )
                ),
                child: Text(
                  "Sim",
                  style: TextStyle(
                    fontSize: 14
                  ),
                )
              ),
            )
          ],
        )
      ],
    );
  }
}