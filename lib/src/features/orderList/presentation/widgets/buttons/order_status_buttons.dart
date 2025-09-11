import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderStatusButtons extends ConsumerWidget {
  const OrderStatusButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(width: 1),
          itemBuilder: (context, index) {
            return FilledButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10),
                    right: Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Row(
                children: [
                  Text(
                    "Opção",
                    style: TextStyle(
                      color: scheme.onPrimaryContainer
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 12)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "12",
                      style: TextStyle(
                        color: scheme.onSecondaryContainer
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}