import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_customer.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrderCustomerSection extends ConsumerStatefulWidget {
  final SalesOrder?  order;

  const SalesOrderCustomerSection({
    super.key,
    required this.order,
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SalesOrderCustomerSectionState();
}

class SalesOrderCustomerSectionState extends ConsumerState<SalesOrderCustomerSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final order = widget.order;
    final customer = order?.customer;


    if (customer == null) {
      return InkWell(
        onTap: _selectCustomer,
        child: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.onTertiary, width: 2)
          ),
          child: SizedBox(
            height: 48,
            child: Center(
              child: Text(
                "Selecionar Cliente",
                style: TextStyle(
                    fontSize: 18
                ),
              ),
            ),
          ),
        ),
      );
    }

    final controller = ref.watch(customerDetailsControllerProvider(customer.customerId));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _selectCustomer,
          child: Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.onTertiary, width: 2)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.onPrimary,
                    borderRadius: BorderRadius.circular(40)
                  ),
                  child: Icon(
                    customer.cnpj != null
                      ? Icons.apartment
                      : Icons.person
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.customerName ?? "--"
                      ),
                      Text(
                        customer.customerCode ?? "--",
                        style: TextStyle(
                          fontSize: 12
                        ),
                      ),
                      Text(
                        customer.cnpj?.formatted ?? customer.cpf?.formatted ?? "--",
                        style: TextStyle(
                          fontSize: 12
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.menu,
                )
              ],
            )
          ),
        ),
        SizedBox(height: 8),
        controller.when(
          error: (error, stack) => Text("error"),
          loading: () => CircularProgressIndicator(),
          data: (customer) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customer.contacts.length,
              itemBuilder: (context, index) {
                final contact = customer.contacts[index];

                return Container(
                  width: double.infinity,
                  height: 20,
                  child: Text(
                    contact.name
                  ),
                );
              }
            );
          },
        )
      ],
    );
  }


  Future<void> _selectCustomer() async {
    final order = widget.order;
    final customer = order?.customer;

    final selected = await context.pushNamed<Customer?>(OrderRouter.select_customer.name);

    if (selected == null) return;

    if (order != null) {
      final newOrder = order.copyWith(
          customer: SalesOrderCustomer.fromCustomer(selected),
          updatedAt: DateTime.now()
      );

      await ref
          .read(salesOrderCreateControllerProvider(order.orderId).notifier)
          .saveEdits(newOrder);
      return;
    }

    final newOrder = await ref
        .read(salesOrderCreateControllerProvider(order?.orderId).notifier)
        .createNewOrder(customer: selected);

    if (!context.mounted) return;
    context.goNamed(OrderRouter.create.name, queryParameters: {"orderId": newOrder.orderId.toString()});
  }

}
