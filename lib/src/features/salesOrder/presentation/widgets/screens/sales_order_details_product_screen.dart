import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/cards/sales_order_details_card.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/cards/sales_order_details_list.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrderDetailsProductScreen extends ConsumerStatefulWidget {
  final SalesOrder order;

  const SalesOrderDetailsProductScreen({
    super.key,
    required this.order,
  });

  @override
  ConsumerState createState() {
    return OrderDetailsProductScreenState();
  }
}

class OrderDetailsProductScreenState extends ConsumerState<SalesOrderDetailsProductScreen>{
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

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return order.items.isEmpty
      ? SingleChildScrollView(
        child: Center(
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
            onTap: () => ref.refresh(salesOrderControllerProvider.future),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                "Tentar novamente",
                style: TextStyle(
                  color: scheme.primary
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
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: onClick
                    ? SalesOrderDetailsCard(orderProduct: orderProduct)
                    : SalesOrderDetailsList(orderProduct: orderProduct)
                );
              }
            )
          ),
        ],
      )
    );
  }
}