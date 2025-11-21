import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/salesOrder/data/models/sales_order_model.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/indicator/pulsing_dot.dart';
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
    final isConnected = ref.watch(isConnectedProvider);

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
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  padding: EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: scheme.outline, width: 2)
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final selected = await context.pushNamed<List<SalesOrderProduct>?>(OrderRouter.select_products.name) ?? [];

                        if (selected.isEmpty) return;

                        if (order != null) {
                          final newOrder = order.updateItems(selected);

                          await ref
                              .read(salesOrderCreateControllerProvider(order.orderId).notifier)
                              .saveEdits(newOrder);
                          return;
                        }

                        final newOrder = await ref
                            .read(salesOrderCreateControllerProvider(order?.orderId).notifier)
                            .createNewOrder();

                        if (!context.mounted) return;
                        context.goNamed(OrderRouter.order_products_details.name, queryParameters: {"orderId": newOrder.orderId.toString()});
                      },
                      child: Text("Catalago"),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 2,
                thickness: 2,
                color: scheme.outline,
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: scheme.outline, width: 2)
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  color: Colors.red
                                ),
                              ),
                              Text(
                                item.quantity.toInt().toString().padLeft(2, "0"),
                                style: TextStyle(
                                  color: Colors.red
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Future<void> _selectProducts(SalesOrder? order) async{

  }
}