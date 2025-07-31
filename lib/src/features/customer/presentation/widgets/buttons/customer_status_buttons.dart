import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/customer_filter.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerStatusButtons extends ConsumerWidget {

  const CustomerStatusButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(customerFilterProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: 10, left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                FilledButton(
                  onPressed: () {
                    ref.read(customerFilterProvider.notifier).state = filter.copyWith(status: CustomerStatusFilter.all);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filter.status == CustomerStatusFilter.all
                        ? colorScheme.onTertiary
                        : colorScheme.tertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)
                        ),
                      )
                  ),
                  child: Text(
                    "Todos",
                    style: TextStyle(
                     color: filter.status == CustomerStatusFilter.all
                      ? colorScheme.onSurface
                      : Colors.grey
                    ),
                  )
                ),
                FilledButton(
                  onPressed: () {
                    ref.read(customerFilterProvider.notifier).state = filter.copyWith(status: CustomerStatusFilter.active);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: filter.status == CustomerStatusFilter.active
                      ? colorScheme.onTertiary
                      : colorScheme.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)
                    )
                  ),
                  child: Text(
                    "Ativos",
                    style: TextStyle(
                      color: filter.status == CustomerStatusFilter.active
                        ? colorScheme.onSurface
                        : Colors.grey
                    ),
                  )
                ),
                FilledButton(
                  onPressed: () {
                    ref.read(customerFilterProvider.notifier).state = filter.copyWith(status: CustomerStatusFilter.blocked);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: filter.status == CustomerStatusFilter.blocked
                          ? colorScheme.onTertiary
                          : colorScheme.tertiary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          )
                      )
                  ),
                  child: Text(
                    "Bloqueados",
                    style: TextStyle(
                      color: filter.status == CustomerStatusFilter.blocked
                        ? colorScheme.onSurface
                        : Colors.grey
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}