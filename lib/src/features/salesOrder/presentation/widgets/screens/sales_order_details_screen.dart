import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/sales_order_status.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/cards/sales_order_details_client_card.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/cards/sales_order_details_contact_card.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/cards/sales_order_details_payment_card.dart';
import 'package:sales_app/src/features/salesOrder/presentation/widgets/payment/payment_row.dart';

class SalesOrderDetailsScreen extends ConsumerWidget {
  final SalesOrder order;

  const SalesOrderDetailsScreen({
    super.key,
    required this.order
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final customer = order.customerId;
    final contactInfo = customer?.contactInfo;
    return SingleChildScrollView(
      child: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "#${order.code}",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Container(
                      width: 120,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: order.status == SalesOrderStatus.draft
                            ? Colors.orangeAccent
                            : order.status == SalesOrderStatus.confirmed
                            ? scheme.tertiary
                            : scheme.error
                          ,
                          width: 2
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        order.status == SalesOrderStatus.draft
                          ? "Em Aberto"
                          : order.status == SalesOrderStatus.confirmed
                          ? "Concluído"
                          : "Cancelado"
                        ,
                        style: TextStyle(
                          color: order.status == SalesOrderStatus.draft
                            ? Colors.orangeAccent
                            : order.status == SalesOrderStatus.confirmed
                            ? scheme.tertiary
                            : scheme.error
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  "23 de Março, 2025",
                  style: TextStyle(
                    color: scheme.secondary
                  ),
                ),
                customer == null
                ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: DottedBorder(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      borderType: BorderType.RRect,
                      strokeWidth: 1,
                      dashPattern: [6, 3],
                      color: scheme.secondary,
                      radius: Radius.circular(8),
                      child: Center(
                        child: Text(
                          "Nenhum cliente informado",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: scheme.secondary
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SalesOrderDetailsClientCard(order: order)
                    ),
                    contactInfo != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: SalesOrderDetailsContactCard(order: order)
                        )
                      : SizedBox()
                    ,
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: SalesOrderDetailsPaymentCard(order: order)
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          "Pagamento",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                      ),
                      PaymentRow(label: "Subtotal", value: "R\$${order.calcItemsSubtotal.decimalValue}"),
                      PaymentRow(label: "Desconto", value: "R\$${order.calcDiscountTotal.decimalValue}"),
                      PaymentRow(label: "Frete", value: "R\$${order.freight?.decimalValue}"),
                      PaymentRow(label: "Taxa", value: "R\$0.0"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}