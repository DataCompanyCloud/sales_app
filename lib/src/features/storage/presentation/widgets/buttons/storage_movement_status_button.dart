import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/storage/providers.dart';

class StorageMovementStatusButton extends ConsumerWidget {
  final int countAll;
  final int countEntry;
  final int countExit;
  final int countTransfer;
  final int countSynced;
  final int countNotSynced;

  const StorageMovementStatusButton({
    super.key,
    this.countAll = 0,
    this.countEntry = 0,
    this.countExit = 0,
    this.countTransfer = 0,
    this.countSynced = 0,
    this.countNotSynced = 0
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(storageMovementStatusFilterProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final rawOptions = <_FilterOption>[
      _FilterOption(label: 'Todos', status: StorageMovementStatusFilter.all, quantity: countAll),
      _FilterOption(label: 'Entrada', status: StorageMovementStatusFilter.entry, quantity: countEntry),
      _FilterOption(label: 'Saída', status: StorageMovementStatusFilter.exit, quantity: countExit),
      _FilterOption(label: 'Trasnferência', status: StorageMovementStatusFilter.transfer, quantity: countTransfer),
      _FilterOption(label: 'Sincronizados', status: StorageMovementStatusFilter.synced, quantity: countSynced),
      _FilterOption(label: 'Não Sincronizados', status: StorageMovementStatusFilter.notSynced, quantity: countNotSynced),
    ];


    final options = rawOptions.where((opt) {
      if (opt.quantity <= 0) return false;

      if (opt.status != StorageMovementStatusFilter.all && opt.quantity == countAll) {
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
                ref.read(storageMovementStatusFilterProvider.notifier).state = opt.status;
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
  final StorageMovementStatusFilter status;
  final int quantity;
  const _FilterOption({required this.label, required this.status, required this.quantity});
}