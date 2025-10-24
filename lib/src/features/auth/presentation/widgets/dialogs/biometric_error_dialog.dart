import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthErrorDialog extends ConsumerWidget {
  const AuthErrorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text("Aviso"),
      content: Text("Biometria indisponível"),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text("Ok"),
        )
      ],
    );
  }


}