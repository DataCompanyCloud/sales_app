import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class CustomerAddressSection extends ConsumerWidget {
  final SalesOrder salesOrder;
  final Customer customer;

  const CustomerAddressSection({
    super.key,
    required this.salesOrder,
    required this.customer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final salesOrderCustomer = salesOrder.customer;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(width: 2, color: scheme.outline),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest
            ),
            child: Row(
              children: [
                Icon(
                  Icons.home_outlined
                ),
                SizedBox(width: 8,),
                Text(
                  "Endereços",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 2,
            thickness: 2,
            color: scheme.outline,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: customer.addresses.length,
            separatorBuilder: (context, index) => Divider(
              height: 2,
              thickness: 2,
              color: scheme.outline,
            ),
            itemBuilder: (context, index) {
              final address = customer.addresses[index];
              return RadioListTile<Address>(
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(salesOrderCreateControllerProvider(salesOrder.orderId).notifier)
                    .saveEdits(salesOrder.updateCustomerAddress(value));
                },
                value: address,
                groupValue: salesOrderCustomer?.address ?? customer.primaryAddress,
                tileColor: scheme.surface,
                title: Text(address.formatted),
                subtitle: Text(address.type.label),
                splashRadius: 10,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              );
            },
          ),
        ],
      ),
    );
  }

}