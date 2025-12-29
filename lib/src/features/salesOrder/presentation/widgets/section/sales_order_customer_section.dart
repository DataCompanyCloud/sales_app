import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/selects/expansion_select_address.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/selects/expansion_select_contact.dart';
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
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Cliente",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
          ),
          SizedBox(height: 4),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(width: 2, color: scheme.outline),
            ),
            child: InkWell(
              onTap: _selectCustomer,
              child: Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  // color: scheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outline, width: 2)
                ),
                child: Column(
                  children: [
                    Row(
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
                            Icons.person
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Adicionar Cliente",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                "Selecione um cliente para esse pedido",
                                style: TextStyle(
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_right,
                        )
                      ],
                    ),
                  ],
                )
              ),
            ),
          )
        ],
      );
    }

    final controller = ref.watch(customerDetailsControllerProvider(salesOrderCustomer.customerId));
    return controller.when(
      error: (error, stack) => Text("error"),
      loading: _skeleton,
      data: (customer) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Cliente",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.outline, width: 2)
              ),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: InkWell(
                      onTap: _selectCustomer,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
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
                                    salesOrderCustomer.customerName
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
                          IconButton(
                            onPressed: () {
                              final updated = salesOrder.updateCustomer(null);
                              ref.read(salesOrderCreateControllerProvider(salesOrder.orderId).notifier).saveEdits(updated);
                            },
                            icon: Icon(
                              Icons.delete_outline,
                              color: scheme.error,
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Divider(
                    height: 2,
                    thickness: 2,
                    color: scheme.outline,
                  ),
                  SizedBox(height: 12),
                  ExpansionSelectCustomerAddress(salesOrder: salesOrder, customer: customer),
                  SizedBox(height: 12),
                  Divider(
                    height: 2,
                    thickness: 2,
                    color: scheme.outline,
                  ),
                  SizedBox(height: 12),
                  ExpansionSelectCustomerContact(salesOrder: salesOrder, customer: customer),
                ],
              )
            )
          ],
        );
      },
    );

  }

  Widget _skeleton() {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone.text(width: 80, fontSize: 15),
          SizedBox(height: 4),
          Card(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 38),
                    title: Bone.text(width: 200),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Bone.text(width: 300, fontSize: 15),
                        SizedBox(height: 4),
                        Bone.text(width: 80, fontSize: 15),
                        SizedBox(height: 4),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                  ),
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.arrow_forward),
                  title: Bone.text(width: 200),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                Divider(),
                ListTile(
                  leading: const Icon(Icons.arrow_forward),
                  title: Bone.text(width: 120),
                  trailing: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Future<void> _selectCustomer() async {
    final order = widget.order;
    final router = GoRouter.of(context);
    final selected = await context.pushNamed<Customer?>(SalesOrderRouter.select_customer.name);

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
    router.goNamed(SalesOrderRouter.create.name, queryParameters: {"orderId": newOrder.orderId.toString()});
  }
}
