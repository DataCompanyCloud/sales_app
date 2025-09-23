import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/order/presentation/widgets/screens/order_details_product_screen.dart';
import 'package:sales_app/src/features/order/presentation/widgets/screens/order_details_screen.dart';
import 'package:sales_app/src/features/order/providers.dart';

class OrderDetails extends ConsumerWidget {
  final int orderId;

  const OrderDetails({
    super.key,
    required this.orderId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(orderDetailsControllerProvider(orderId));
    final List<String> produtos = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
    ];

    /// TODO: Resolver esse problema de 'type Null is not a subtype of 'int' in type cast'
    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => CircularProgressIndicator(),
      data: (order) {
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
                  Tab(child: _buildTabWithBadge("Produtos", produtos.length)),
                  Tab(text: "Detalhes"),
                ],
              ),
            ),
            body: TabBarView(
                children: [
                  OrderDetailsProductScreen(),
                  OrderDetailsScreen(order: order),
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
    );
  }
}

Widget _buildTabWithBadge(String title, int count) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(title),
      ),
      if (count > 0)
        Positioned(
          right: -16,
          top: -2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF2A364B),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ),
    ],
  );
}