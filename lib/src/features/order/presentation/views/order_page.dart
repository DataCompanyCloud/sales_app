import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/presentation/router/order_router.dart';
import 'package:sales_app/src/features/order/presentation/widgets/buttons/order_status_buttons.dart';
import 'package:sales_app/src/features/order/presentation/widgets/skeleton/order_page_skeleton.dart';
import 'package:sales_app/src/features/order/providers.dart';

class OrderPage extends ConsumerStatefulWidget {
  final List<Order> orders;

  const OrderPage({
    super.key,
    required this.orders,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => OrderListPageState();
}

class OrderListPageState extends ConsumerState<OrderPage>{
  final orderIndexProvider = StateProvider<int>((ref) => 1);

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(orderIndexProvider);
    final controller = ref.watch(orderControllerProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => Scaffold(
        body: OrderPageSkeleton(),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
      ),
      data: (orders) {
        if(orders.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Lista de Pedidos"),
              leading: IconButton(
                onPressed: () {
                  context.goNamed(HomeRouter.home.name);
                },
                icon: Icon(Icons.arrow_back_ios_new, size: 22),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_rounded,
                      size: 96,
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    Text("Nenhum pedido para ser mostrado."),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    InkWell(
                      onTap: () => ref.refresh(orderControllerProvider.future),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("Tentar novamente", style: TextStyle(color: Colors.blue),),
                      )
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: scheme.onSurface,
            title: Text("Lista de Pedidos"),
            leading: IconButton(
              onPressed: () {
                context.goNamed(HomeRouter.home.name);
              },
              icon: Icon(Icons.arrow_back_ios_new, size: 22),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                OrderStatusButtons(),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];

                      return InkWell(
                        onTap: () {
                          context.pushNamed(OrderRouter.order_details.name);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: scheme.onTertiary, width: 2)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 75,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.yellow.shade900,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                          )
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("000${index + 1}"),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(bottom: 8),
                                        width: 75,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10)
                                          ),
                                          color: Colors.orangeAccent
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)
                                          ),
                                          child: Icon(
                                            Icons.unarchive_sharp,
                                            color: Colors.white,
                                            size: 38
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ]
                              ),
                              Expanded(
                                child: Container(
                                  height: 75,
                                  decoration: BoxDecoration(
                                    color: scheme.surface,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Cliente: ${order.customerName}",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                "Qtd. de Produtos: ${order.items}",
                                                style: TextStyle(
                                                    fontSize: 15
                                                ),
                                              ),
                                              Text(
                                                "Preço: R\$${order.grandTotal}",
                                                style: TextStyle(
                                                    fontSize: 15
                                                ),
                                              ),
                                            ],
                                          )
                                        ),
                                        Icon(Icons.chevron_right, size: 28),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 6, right: 6),
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.red
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            )
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
        );
      }
    );
  }
}