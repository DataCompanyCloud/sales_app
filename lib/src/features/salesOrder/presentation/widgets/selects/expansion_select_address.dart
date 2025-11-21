import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class ExpansionSelectCustomerAddress extends ConsumerStatefulWidget {
  final SalesOrder salesOrder;
  final Customer customer;

  const ExpansionSelectCustomerAddress({
    super.key,
    required this.salesOrder,
    required this.customer
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpansionSelectCustomerAddressState();

}

class _ExpansionSelectCustomerAddressState extends ConsumerState<ExpansionSelectCustomerAddress> with SingleTickerProviderStateMixin {
  final StateProvider<bool> isOpenProvider = StateProvider((ref) => false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = ref.watch(isOpenProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final customer = widget.customer;
    final salesOrder = widget.salesOrder;
    final salesCustomer = salesOrder.customer;

    if (customer.addresses.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 8),
          Icon(
            Icons.location_on_outlined,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              salesCustomer?.address?.formatted ?? 'Selecione um endereço',
            ),
          ),
          salesCustomer?.address == null
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Colors.red,
                ),
              )
            : SizedBox.shrink()
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // CABEÇALHO
        InkWell(
          onTap: () {
            ref.read(isOpenProvider.notifier).state = !isOpen;
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 8),
                Icon(
                  Icons.location_on_outlined,
                  size: 20
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    salesCustomer?.address?.formatted ?? 'Selecione um endereço',
                  ),
                ),
                salesCustomer?.address == null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.red,
                      ),
                    )
                  : customer.addresses.length == 1
                    ? SizedBox.shrink()
                    : Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: AnimatedRotation(
                        turns: isOpen ? 0.5 : 0.0, // gira o ícone
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(Icons.expand_more),
                      ),
                    )
              ],
            ),
          ),
        ),

        // CONTAINER ANIMADO
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: isOpen
            ? Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                border: Border(
                  top: BorderSide(
                   color: scheme.outline
                  )
                )
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: customer.addresses.map((address) {
                  return InkWell(
                    onTap: () {
                      final updated = salesOrder.updateCustomerAddress(address);
                      ref.read(salesOrderCreateControllerProvider(salesOrder.orderId).notifier).saveEdits(updated);
                      ref.read(isOpenProvider.notifier).state = false;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            address == salesCustomer?.address
                              ? Icons.check_box_rounded
                              : Icons.check_box_outline_blank_rounded
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              address.formatted,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
            : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
