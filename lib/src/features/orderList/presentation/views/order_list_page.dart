import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/orderList/presentation/router/order_list_router.dart';
import 'package:sales_app/src/features/orderList/presentation/widgets/buttons/order_status_buttons.dart';

class OrderListPage extends ConsumerStatefulWidget {
  const OrderListPage({super.key});

  @override ConsumerState<ConsumerStatefulWidget> createState() => OrderListPageState();
}

class OrderListPageState extends ConsumerState<OrderListPage>{
  final orderIndexProvider = StateProvider<int>((ref) => 1);

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(orderIndexProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
        child: Expanded(
          child: Builder(
            builder: (context) {
              int countAll = 0;
              int countActive = 0;
              int countBlocked = 0;
              int countSynced = 0;
              int countNotSynced = 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OrderStatusButtons(
                    countAll: countAll,
                    countActive: countActive,
                    countBlocked: countBlocked,
                    countSynced: countSynced,
                    countNotSynced: countNotSynced,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      itemCount: 24,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            context.pushNamed(OrderListRouter.order_details.name);
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
                                          child: Text("Código"),
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
                                                    "Nome do Cliente"
                                                ),
                                                Text(
                                                    "Preço"
                                                ),
                                                Text(
                                                    "QtdProduto"
                                                ),
                                              ],
                                            )
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(top: 4, right: 4),
                                                child: Row(
                                                  children: [
                                                    Text("Não-Sincronizado"),
                                                    SizedBox(width: 4),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 6),
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
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 12),
                                                child: Icon(Icons.chevron_right, size: 28),
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
              );
            }
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
    );
  }
}