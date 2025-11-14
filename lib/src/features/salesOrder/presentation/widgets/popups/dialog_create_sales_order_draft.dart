import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DialogCreateSalesOrderDraft extends ConsumerWidget{

  const DialogCreateSalesOrderDraft({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("Criar nova Order?"),
      content: Text("Tem certeza que deseja criar um novo pedido (rascunho)?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("Cancelar"),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text("Criar"),
        ),
      ],
    );
  }
}