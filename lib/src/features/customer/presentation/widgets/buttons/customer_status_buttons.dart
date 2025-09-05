import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerStatusButtons extends ConsumerWidget {
  final int countAll;
  final int countActive;
  final int countBlocked;
  final int countSynced;
  final int countNotSynced;

  const CustomerStatusButtons({
    super.key,
    this.countAll = 0,
    this.countActive = 0,
    this.countBlocked = 0,
    this.countSynced = 0,
    this.countNotSynced = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(customerStatusFilterProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // Defina seus itens de forma declarativa
    final rawOptions = <_FilterOption>[
      _FilterOption(label: 'Todos', status: CustomerStatusFilter.all, quantity: countAll),
      _FilterOption(label: 'Ativos', status: CustomerStatusFilter.active,  quantity: countActive),
      _FilterOption(label: 'Bloqueados', status: CustomerStatusFilter.blocked, quantity: countBlocked),
      _FilterOption(label: 'Sincronizados', status: CustomerStatusFilter.synced, quantity: countSynced),
      _FilterOption(label: 'Não Sincronizados', status: CustomerStatusFilter.notSynced, quantity: countNotSynced),
    ];

    final options = rawOptions.where((opt) {
      // 1) Nunca mostra quantidades negativas
      if (opt.quantity <= 0) return false;

      // 2) Se não for “Todos” e a quantidade for igual ao total, também não mostra
      if (opt.status != CustomerStatusFilter.all && opt.quantity == countAll) {
        return false;
      }

      // 3) Caso contrário, exibe
      return true;
    }).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 12),
      // Constrói uma ListView horizontal de tamanho fixo
      child: SizedBox(
        height: 40, // altura do chip
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
                ref.read(customerStatusFilterProvider.notifier).state = opt.status;
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
                      border: Border.all(color: Colors.black), // cor e espessura da borda
                      borderRadius: BorderRadius.circular(4),  // cantos arredondados
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
  final CustomerStatusFilter status;
  final int quantity;
  const _FilterOption({required this.label, required this.status, required this.quantity});
}