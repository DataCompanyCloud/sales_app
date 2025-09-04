import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/orderList/presentation/widgets/screens/order_details_product_screen.dart';
import 'package:sales_app/src/features/orderList/presentation/widgets/screens/order_details_screen.dart';

class OrderDetailsPage extends ConsumerWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> produtos = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "11",
      "12",
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detalhes do Pedido"),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 22)
          ),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "Detalhes"),
              Tab(text: "Produtos (${produtos.length})"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderDetailsScreen(),
            OrderDetailsProductScreen(),
          ]
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              thickness: 1,
              height: 1,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "R\$500,00",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}