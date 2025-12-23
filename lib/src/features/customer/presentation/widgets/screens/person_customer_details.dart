import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/customer_sales_orders_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/headers/person_customer_header.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/tabBars/person_customer_information.dart';

class PersonCustomerDetails extends ConsumerWidget {
  final PersonCustomer customer;

  const PersonCustomerDetails({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(customer.customerCode ?? ""),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 22)
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          ],
        ),
        body: Column(
          children: [
            PersonCustomerHeader(customer: customer),
            const SizedBox(height: 12),
            CustomerSalesOrdersCard(customer: customer),
            const SizedBox(height: 12),
            TabBar(
              indicatorColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Informações'),
                Tab(text: 'Pedidos'),
              ],
            ),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                children: [
                  PersonCustomerInformation(customer: customer),
                  const Center(child: Text('Nenhum pedido para mostrar'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


