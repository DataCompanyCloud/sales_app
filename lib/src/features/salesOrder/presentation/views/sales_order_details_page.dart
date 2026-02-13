import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/popup/dialog_sales_order_printer.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/screens/sales_order_details_product_screen.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/screens/sales_order_details_screen.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/skeleton/sales_order_details_screen_skeleton.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrderDetailsPage extends ConsumerWidget {
  final int orderId;
  final _tabBarIndexProvider = StateProvider((ref) => 0);

  SalesOrderDetailsPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(salesOrderDetailsControllerProvider(orderId));
    final tabBarIndex = ref.watch(_tabBarIndexProvider);


    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => SalesOrderDetailsScreenSkeleton(),
      data: (order) {
        return DefaultTabController(
          length: 2,
          initialIndex: tabBarIndex,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Detalhes do Pedido"),
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(Icons.arrow_back_ios_new, size: 22)
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => DialogSalesOrderPrinter()
                    );
                  },
                  icon: Icon(Icons.print, size: 22),
                ),
                IconButton(
                  onPressed: () {
                    if (controller.isLoading) return;
                    final _ = ref.refresh(salesOrderDetailsControllerProvider(order.id));
                  },
                  icon: Icon(Icons.refresh, size: 22,)
                ),
              ],
              bottom: TabBar(
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.tab,
                unselectedLabelColor: Colors.grey,
                onTap: (index) => ref.watch(_tabBarIndexProvider.notifier).state = index,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Produtos"
                        ),
                        SizedBox(width: 4),
                        Container(
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
                            order.items.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(text: "Informações"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SalesOrderDetailsProductScreen(order: order),
                SalesOrderDetailsScreen(order: order),
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
                          "Total do pedido",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          "R\$${order.calcGrandTotal.decimalValue}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                        ),
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