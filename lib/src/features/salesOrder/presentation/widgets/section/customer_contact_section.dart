import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class CustomerContactSection extends ConsumerWidget{
  final SalesOrder salesOrder;
  final Customer customer;

  const CustomerContactSection({
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
                  Icons.contacts
                ),
                SizedBox(width: 8,),
                Text(
                  "Contatos",
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
            itemCount: customer.contacts.length,
            separatorBuilder: (context, index) => Divider(
              height: 2,
              thickness: 2,
              color: scheme.outline,
            ),
            itemBuilder: (context, index) {
              final contact = customer.contacts[index];

              return RadioListTile<ContactInfo>(
                onChanged: (value) {
                  if (value == null) return;
                  final updated = salesOrder.updateCustomerContact(value);
                  ref.read(salesOrderCreateControllerProvider(salesOrder.orderId).notifier)
                      .saveEdits(updated)
                  ;
                },
                value: contact,
                groupValue: salesOrderCustomer?.contactInfo ?? customer.primaryContact,
                tileColor: scheme.surface,
                title: Text(contact.name),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact.phone?.value.toString() ?? "--"),
                    Text(contact.email?.value.toString() ?? "--"),
                  ],
                ),
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