import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OptionsDescriptionDialog extends ConsumerWidget {
  const OptionsDescriptionDialog({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("CNPJ Obrigatório"),
      content: Text("No cadastro do cliente, o campo CNPJ deve ser preenchido"),
    );
  }
}