import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/presentation/router/order_router.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_list.dart';
import 'package:sales_app/src/features/order/presentation/widgets/skeleton/order_details_list_skeleton.dart';
import 'package:sales_app/src/features/order/providers.dart';

class OrderDetailsProductScreen extends ConsumerStatefulWidget {
  final Order order;

  const OrderDetailsProductScreen({
    super.key,
    required this.order
  });

  @override
  ConsumerState createState() {
    return OrderDetailsProductScreenState();
  }
}

class OrderDetailsProductScreenState extends ConsumerState<OrderDetailsProductScreen>{
  final onClickProvider = StateProvider<bool>((ref) => false);


  @override
  void initState() {
    super.initState();
  }

  bool onClick = false;
  void toggleProductScreen() {
    onClick = !onClick;
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final onClick = ref.watch(onClickProvider);
    final controller = ref.watch(orderControllerProvider);

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => OrderDetailsListSkeleton(),
      data: (orders) {
        if (orders.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Detalhes do Pedido"),
              leading: IconButton(
                onPressed: () {
                  context.goNamed(OrderRouter.order_list.name);
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
                        child: Text(
                          "Tentar novamente",
                          style: TextStyle(
                            color: Colors.blue
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12, right: 12),
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(onClickProvider.notifier).state = !onClick;
                        },
                        child: Icon(
                          onClick
                            ? Icons.view_list_sharp
                            : Icons.view_agenda
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final orderProduct = order.items[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: onClick
                          ? OrderDetailsCard(orderProduct: orderProduct)
                          : OrderDetailsList(orderProduct: orderProduct)
                      );
                    }
                  )
                ),
              ],
            )
          ),
        );
      }
    );
  }
}