import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConfirmationDialog extends ConsumerWidget {
  final String title;
  
  const ConfirmationDialog({
    super.key,
    required this.title,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    context.pop(false);
                  },
                  child: Text("Não")
                ),
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    context.pop(true);
                  },
                  child: Text("Sim")
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}