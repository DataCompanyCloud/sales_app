import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class OrderStatusButtons extends ConsumerWidget {
  final int countAll;
  final int countFinished;
  final int countNotFinished;
  final int countCancelled;
  final int countSynced;
  final int countNotSynced;

  const OrderStatusButtons({
    super.key,
    this.countAll = 0,
    this.countFinished = 0,
    this.countNotFinished = 0,
    this.countCancelled = 0,
    this.countSynced = 0,
    this.countNotSynced = 0
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(orderStatusFilterProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final rawOptions = <_FilterOption>[
      _FilterOption(label: 'Todos', status: OrderStatusFilter.all, quantity: countAll),
      _FilterOption(label: 'Em Aberto', status: OrderStatusFilter.notFinished, quantity: countNotFinished),
      _FilterOption(label: 'Concluídos', status: OrderStatusFilter.finished, quantity: countFinished),
      _FilterOption(label: 'Cancelados', status: OrderStatusFilter.cancelled, quantity: countCancelled),
      _FilterOption(label: 'Sincronizados', status: OrderStatusFilter.synced, quantity: countSynced),
      _FilterOption(label: 'Não Sincronizados', status: OrderStatusFilter.notSynced, quantity: countNotSynced),
    ];


    final options = rawOptions.where((opt) {
      if (opt.quantity <= 0) return false;

      if (opt.status != OrderStatusFilter.all && opt.quantity == countAll) {
        return false;
      }

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
            final selected = status == opt.status;
            final isFirst = index == 0;
            final isLast = index == options.length - 1;


            return FilledButton(
              onPressed: () {
                ref.read(orderStatusFilterProvider.notifier).state = opt.status;
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selected
                  ? scheme.primaryContainer
                  : scheme.surface,
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
                      color: selected
                        ? scheme.onPrimaryContainer
                        : scheme.onSurfaceVariant,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 12)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: selected
                        ? scheme.secondaryContainer
                        : scheme.surfaceContainerHighest,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      opt.quantity.toString(),
                      style: TextStyle(
                        color: selected
                          ? scheme.onSecondaryContainer
                          : scheme.onSurface,
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

class _FilterOption {
  final String label;
  final OrderStatusFilter status;
  final int quantity;
  const _FilterOption({required this.label, required this.status, required this.quantity});
}