import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/order_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/popups/dialog_create_order_draft.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/screens/order_create_screen.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/screens/order_drafts_screen.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/skeleton/order_create_page_skeleton.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';
import 'package:collection/collection.dart';

class OrderCreatePage extends ConsumerWidget {
  final int? orderId;
  final bool showOrders;

  const OrderCreatePage({
    super.key,
    required this.orderId,
    required this.showOrders
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(orderCreateControllerProvider);

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
            ? error
            : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => OrderCreatePageSkeleton(),
      data: (orders) {
        final order = orders.length == 1
            ? orders.first
            : orders.firstWhereOrNull((o) => o.orderId == orderId);

        return  Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: order?.serverId == null
                            ? Colors.red
                            : Colors.cyan
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  order?.orderCode ?? "Novo Pedido"
                )
              ],
            ),
            automaticallyImplyLeading: false,
            actions: [
              !showOrders && orders.length > 1
                ? IconButton(
                    onPressed: () {
                      context.goNamed(OrderRouter.create.name, queryParameters: {"showOrders": "true"});
                    },
                    icon: Icon(Icons.change_circle_outlined),
                  )
                : SizedBox()
              ,
            ],
          ),
          body: showOrders && orders.length > 1
              ? RefreshIndicator(
                  onRefresh: () async {
                    if (controller.isLoading) return;
                    final _ = ref.refresh(orderCreateControllerProvider);
                  },
                  child: OrderDraftsScreen(orders: orders)
                )
              : OrderCreateScreen(order: order)
          ,
          floatingActionButton:
            showOrders && orders.length > 1
            ? FloatingActionButton(
                heroTag: "btn-go",
                backgroundColor: Color(0xFF0081F5),
                foregroundColor: Colors.white,
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false, // obriga escolher uma ação
                    builder: (_) => DialogCreateOrderDraft()
                  ) ?? false;

                  if (!ok) {
                    return;
                  }

                  // final newOrder = await ref.read(orderCreateControllerProvider.notifier).createNewOrder();

                  if (!context.mounted) return;
                  context.goNamed(OrderRouter.create.name);
                  // ref.refresh(orderCreateControllerProvider);
                },
                child: Icon(Icons.add),
              )
            : null,
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1),
        );
      },
    );
  }
}
