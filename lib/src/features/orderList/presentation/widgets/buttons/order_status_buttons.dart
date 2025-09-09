import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderStatusButtons extends ConsumerWidget {
  final int countAll;
  final int countActive;
  final int countBlocked;
  final int countSynced;
  final int countNotSynced;

  const OrderStatusButtons({
    super.key,
    this.countAll = 0,
    this.countActive = 0,
    this.countBlocked = 0,
    this.countSynced = 0,
    this.countNotSynced = 0
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final status = ref.watch()

    final rawOptions = <_FilterOption>[
      _FilterOption(label: 'Todos', quantity: countAll),
      _FilterOption(label: 'Aberto', quantity: countActive),
      _FilterOption(label: 'Fechado', quantity: countBlocked),
    ];

    final options = rawOptions.where((opt) {
      if (opt.quantity <= 0) return false;

      // if (opt.status != OrderStatusFilter.all && opt.quantity == countAll) {
      //   return false;
      // }

      return true;
    }).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: options.length,
          separatorBuilder: (_, _) => const SizedBox(width: 1),
          itemBuilder: (context, index) {
            final opt = options[index];
            // final selected = status == opt.status;
            final isFirst = index == 0;
            final isLast = index == options.length - 1;

            return FilledButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                // selected
                //   ? scheme.primaryContainer
                //   : scheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                    left: isFirst ? Radius.circular(10) : Radius.zero,
                    right: isLast ? Radius.circular(10) : Radius.zero,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Row(
                children: [
                  Text(
                    opt.label,
                    style: TextStyle(
                      color: Colors.blue,
                      // selected
                      //   ? scheme.onPrimaryContainer
                      //   : scheme.onSurfaceVariant,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 12)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      // selected
                      //   ? scheme.secondaryContainer
                      //   : scheme.surfaceContainerHighest,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      opt.quantity.toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        // selected
                        //   ? scheme.onSecondaryContainer
                        //   : scheme.onSurface,
                      ),
                    ),
                  )
                ],
              )
            );
          },
        ),
      ),
    );
  }
}

class _FilterOption {
  final String label;
  // final OrderStatusFilter status;
  final int quantity;
  const _FilterOption({required this.label, required this.quantity});
}