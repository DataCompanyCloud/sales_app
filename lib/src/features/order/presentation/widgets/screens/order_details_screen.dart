import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/domain/valueObjects/order_status.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_client_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_contact_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_payment_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/payment/payment_row.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final Order order;

  const OrderDetailsScreen({
    super.key,
    required this.order
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final customer = order.customer;
    final contactInfo = customer?.contactInfo;
    return Center(
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
                    "#${order.orderCode}",
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
                        color: order.status == OrderStatus.draft
                          ? Colors.orangeAccent
                          : order.status == OrderStatus.confirmed
                          ? Colors.green
                          : Colors.red
                        ,
                        width: 2
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      order.status == OrderStatus.draft
                        ? "Em Aberto"
                        : order.status == OrderStatus.confirmed
                        ? "Concluído"
                        : "Cancelado"
                      ,
                      style: TextStyle(
                        color: order.status == OrderStatus.draft
                          ? Colors.orangeAccent
                          : order.status == OrderStatus.confirmed
                          ? Colors.green
                          : Colors.red
                      ),
                    ),
                  )
                ],
              ),
              Text(
                "23 de Março, 2025",
                style: TextStyle(
                  color: Colors.grey
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
                    color: Colors.grey,
                    radius: Radius.circular(8),
                    child: Center(
                      child: Text(
                        "Nenhum cliente informado",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey
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
                    child: OrderDetailsClientCard(order: order)
                  ),
                  contactInfo != null && contactInfo.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: OrderDetailsContactCard(order: order)
                )
                    : SizedBox()
                  ,
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: OrderDetailsPaymentCard(order: order)
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
                    PaymentRow(label: "Frete", value: "R\$${order.freight.decimalValue}"),
                    PaymentRow(label: "Taxa", value: "R\$${order.calcTaxTotal.decimalValue}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}