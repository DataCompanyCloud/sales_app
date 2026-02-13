import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';

class SalesOrderProductsSection extends ConsumerStatefulWidget {
  final SalesOrder?  order;

  const SalesOrderProductsSection({
    super.key,
    required this.order,
  });


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SalesOrderProductsSectionState();
}

class SalesOrderProductsSectionState extends ConsumerState<SalesOrderProductsSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final salesOrder = widget.order;
    final salesOrderProduct = salesOrder?.items;
    final quantityItems = salesOrderProduct == null || salesOrderProduct.isEmpty ? 0 : salesOrderProduct.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Produtos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
        SizedBox(height: 4),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(width: 2, color: scheme.outline),
          ),
          child: InkWell(
            onTap: () {
              context.pushNamed(SalesOrderRouter.products_details.name, queryParameters: {"orderId": salesOrder?.id.toString()});
            },
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                // color: scheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.outline, width: 2)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: scheme.onPrimary,
                          borderRadius: BorderRadius.circular(40)
                        ),
                        child: Icon(
                            Icons.add_box_outlined
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Adicionar Produtos",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              quantityItems == 0
                                ? "Selecione produtos para esse pedido"
                                : "${quantityItems.toString().padLeft(2, "0")} selecionado",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.keyboard_arrow_right,
                      )
                    ],
                  ),
                ],
              )
            ),
          ),
        )
      ],
    );
  }

}
