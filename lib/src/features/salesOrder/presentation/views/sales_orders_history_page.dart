import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/money.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/currency.dart' as c;
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_company_group.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_payment.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/cards/sales_orders_history_card.dart';

class SalesOrdersHistoryPage extends ConsumerWidget {
  const SalesOrdersHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final ordersHistory = genSalesOrders(20);
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de Pedidos"),
        leading: IconButton(
          onPressed: () {
            context.goNamed(AppRoutes.home.name);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search)
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: ordersHistory.length,
          itemBuilder: (context, index) {
            final salesOrder = ordersHistory[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: SalesOrdersHistoryCard(
                salesOrder: salesOrder,
              ),
            );
          }
        ),
      ),
    );
  }
}

List<SalesOrder> genSalesOrders (int max) {
  List<SalesOrder> output = [];
  for (int i=0; i<max; i++) {
    output.add(
      SalesOrder(
        id: i+1,
        uuid: "",
        code: (i+1).toString().padLeft(5, "0"),
        createdAt: DateTime.now(),
        itemsCount: random.integer(100, min: 1),
        total: getFakeMoney(),
        orderPaymentMethods: getPaymentMethods(),
        companyGroup: getCompanyGroup()
      )
    );
  }

  return output;
}

Money getFakeMoney() {
  return Money(
    amount: random.integer(1000, min: 1),
    currency: c.Currency.BRL
  );
}

List<SalesOrderPayment> getPaymentMethods() {
  List<SalesOrderPayment> output = [];

  return output;
}

List<SalesOrderCompanyGroup> getCompanyGroup() {
  List<SalesOrderCompanyGroup> output = [];

  return output;
}
