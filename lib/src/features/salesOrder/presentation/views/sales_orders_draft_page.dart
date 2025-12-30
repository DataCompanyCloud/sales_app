import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/cards/sales_order_card.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/popups/dialog_create_sales_order_draft.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/skeleton/sales_order_create_page_skeleton.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrdersDraftPage extends ConsumerWidget {
  const SalesOrdersDraftPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(salesOrderControllerProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
            ? error
            : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => SalesOrderCreatePageSkeleton(),
      data: (orders) {
        return  Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  "Pedidos Abertos"
                )
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              if (controller.isLoading) return;
              final _ = ref.refresh(salesOrderControllerProvider);
            },
            child: orders.items.isEmpty
              ? Center(
                  child: Text("Nenhum pedido em aberto"),
                )
              : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: orders.items.length,
                  itemBuilder: (context, index) {
                    final order = orders.items[index];

                    return InkWell(
                      onTap: () {
                        final loc = GoRouter.of(context).namedLocation(
                          SalesOrderRouter.create.name,
                          queryParameters: {"orderId": order.orderId.toString()},
                        );
                        context.push(loc);
                      },
                      child: SalesOrderCard(order: order)
                    );
                  }
                ),
              )
            )
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "btn-go",
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onSurface,
            onPressed: () async {
              if (orders.items.isNotEmpty) {
                final ok = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false, // obriga escolher uma ação
                  builder: (_) => DialogCreateSalesOrderDraft()
                ) ?? false;

                if (!ok) {
                  return;
                }
              }

              if (!context.mounted) return;
              context.goNamed(SalesOrderRouter.create.name);
            },
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
        );
      },
    );
  }
}
