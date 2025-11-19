import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/contact_info.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/section/customer_address_section.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/section/customer_contact_section.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
    final salesOrder = widget.order;
    final salesOrderCustomer = salesOrder?.customer;


    if (salesOrderCustomer == null || salesOrder == null) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            InkWell(
              onTap: _selectCustomer,
              child: Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outline, width: 2)
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
            ),
          ],
        ),
      );
    }

    final controller = ref.watch(customerDetailsControllerProvider(salesOrderCustomer.customerId));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
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
                  border: Border.all(color: scheme.outline, width: 2)
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
                       salesOrderCustomer.cnpj != null
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
                            salesOrderCustomer.customerName ?? "--"
                          ),
                          Text(
                            salesOrderCustomer.customerCode ?? "--",
                            style: TextStyle(
                              fontSize: 12
                            ),
                          ),
                          Text(
                            salesOrderCustomer.cnpj?.formatted ?? salesOrderCustomer.cpf?.formatted ?? "--",
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
            SizedBox(height: 12),
            controller.when(
              error: (error, stack) => Text("error"),
              loading: () => CircularProgressIndicator(),
              data: (customer) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomerAddressSection(salesOrder: salesOrder, customer: customer),
                    SizedBox(height: 12),
                    customer.contacts.isEmpty
                      ? SizedBox()
                      : CustomerContactSection(salesOrder: salesOrder, customer: customer)
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectCustomer() async {
    final order = widget.order;
    final selected = await context.pushNamed<Customer?>(OrderRouter.select_customer.name);

    if (selected == null) return;

    if (order != null) {
      final newOrder = order.updateCustomer(selected);

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
