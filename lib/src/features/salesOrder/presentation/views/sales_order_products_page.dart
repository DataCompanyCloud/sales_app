import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/cards/sales_order_product_card.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/skeleton/sales_order_create_page_skeleton.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';


class SalesOrderProductsPage extends ConsumerStatefulWidget {
  final int? orderId;

  const SalesOrderProductsPage({
    super.key,
    required this.orderId
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SalesOrderProductsPageState();
}

class SalesOrderProductsPageState extends ConsumerState<SalesOrderProductsPage> {

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(salesOrderCreateControllerProvider(widget.orderId));

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    // final isConnected = ref.watch(isConnectedProvider);

    return controller.when(
      error: (error, stack ) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => SalesOrderCreatePageSkeleton(),
      data: (order) {
        final items = order?.items ?? [];

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  "Produtos",
                  textAlign: TextAlign.center,
                )
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: scheme.outline, // cor da linha
                height: 1.0,                 // espessura da linha
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: scheme.outline, width: 2)
                      ),
                      child: InkWell(
                        onTap: () async {
                          await context.pushNamed<List<SalesOrderProduct>?>(OrderRouter.select_products.name) ?? [];
                          // final selected = await context.pushNamed<List<SalesOrderProduct>?>(OrderRouter.select_products.name) ?? [];
                          //
                          // if (selected.isEmpty) return;
                          //
                          // if (order != null) {
                          //   final newOrder = order.updateItems(selected);
                          //
                          //   await ref
                          //       .read(salesOrderCreateControllerProvider(order.orderId).notifier)
                          //       .saveEdits(newOrder);
                          //   return;
                          // }
                          //
                          // final newOrder = await ref
                          //     .read(salesOrderCreateControllerProvider(order?.orderId).notifier)
                          //     .createNewOrder();
                          //
                          // if (!context.mounted) return;
                          // context.goNamed(OrderRouter.order_products_details.name, queryParameters: {"orderId": newOrder.orderId.toString()});
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: scheme.outline,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_box_outlined
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Catálago"
                              ),
                            ],
                          )
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: scheme.outline, width: 2)
                      ),
                      child: InkWell(
                        onTap: () {
                          // final selected = await context.pushNamed<List<SalesOrderProduct>?>(OrderRouter.select_products.name) ?? [];
                          //
                          // if (selected.isEmpty) return;
                          //
                          // if (order != null) {
                          //   final newOrder = order.updateItems(selected);
                          //
                          //   await ref
                          //       .read(salesOrderCreateControllerProvider(order.orderId).notifier)
                          //       .saveEdits(newOrder);
                          //   return;
                          // }
                          //
                          // final newOrder = await ref
                          //     .read(salesOrderCreateControllerProvider(order?.orderId).notifier)
                          //     .createNewOrder();
                          //
                          // if (!context.mounted) return;
                          // context.goNamed(OrderRouter.order_products_details.name, queryParameters: {"orderId": newOrder.orderId.toString()});
                        },
                        child: Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: scheme.outline,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Center(
                                    child: Icon(
                                        Icons.add_chart_outlined
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Histórico"
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: scheme.outline,
              ),
              SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SalesOrderProductCard(item: item),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  // Future<void> _selectProducts(SalesOrder? order) async{}
}