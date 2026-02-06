import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/customer_sales_orders_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/headers/company_customer_header.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/tabBars/company_customer_information.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/tabBars/company_customer_orders.dart';

class CompanyCustomerDetails extends ConsumerWidget {
  final CompanyCustomer customer;

  const CompanyCustomerDetails({
    super.key,
    required this.customer
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(customer.customerCode ?? ""),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(text: "Informações"),
              Tab(text: "Pedidos"),
              Tab(text: "Fiscal"),
            ],
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    CompanyCustomerHeader(customer: customer),
                    const SizedBox(height: 12),
                    CustomerSalesOrdersCard(customer: customer),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              CompanyCustomerInformation(customer: customer),

              CompanyCustomerOrders(customer: customer),

              const Center(
                child: Text("Nenhum pedido para mostrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}