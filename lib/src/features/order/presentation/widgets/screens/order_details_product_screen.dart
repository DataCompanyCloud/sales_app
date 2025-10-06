import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_list.dart';
import 'package:sales_app/src/features/order/providers.dart';

class OrderDetailsProductScreen extends ConsumerStatefulWidget {
  final Order order;

  const OrderDetailsProductScreen({
    super.key,
    required this.order,
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

    return order.items.isEmpty
      ? Center(
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
  )
      : SafeArea(
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
                  final orderCustomer = order.customer;
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
      );
  }
}