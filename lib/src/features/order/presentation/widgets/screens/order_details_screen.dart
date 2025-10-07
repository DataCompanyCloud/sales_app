import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/domain/valueObjects/order_status.dart';
import 'package:sales_app/src/features/order/presentation/widgets/payment/payment_row.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final Order order;

  const OrderDetailsScreen({
    super.key,
    required this.order
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final customer = order.customer;
    final contactInfo = customer?.contactInfo;
    final paymentMethod = order.paymentMethods;
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
              customer != null
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text(
                    "Nenhum cliente informado",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24
                    ),
                  ),
                ),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Card(
                        color: scheme.surface,
                        elevation: 3,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                        Icons.person,
                                        size: 18,
                                        color: Colors.grey
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "CLIENTE",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Divider(
                                    thickness: 1.5,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A364B),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "CÓDIGO",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      customer?.customerCode ?? "--",
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A364B),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "NOME",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      customer?.customerName ?? "--",
                                      style: TextStyle(
                                          fontSize: 15
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                  contactInfo != null && contactInfo.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Card(
                        color: scheme.surface,
                        elevation: 3,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                        Icons.phone,
                                        size: 18,
                                        color: Colors.grey
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "CONTATO",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Divider(
                                    thickness: 1.5,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: contactInfo.length,
                                    itemBuilder: (context, index) {
                                      final contact = contactInfo[index];
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF2A364B),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  "NOME",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                contact.name,
                                                style: TextStyle(
                                                    fontSize: 15
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF2A364B),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  "EMAIL",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                contact.email?.value ?? "--",
                                                style: TextStyle(
                                                    fontSize: 15
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF2A364B),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  "TELEFONE",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                contact.phone?.value ?? "--",
                                                style: TextStyle(
                                                    fontSize: 15
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    })
                              ],
                            ),
                          ),
                        )
                    ),
                  )
                      : SizedBox()
                  ,
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Card(
                  color: scheme.surface,
                  elevation: 3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.newspaper,
                                size: 18,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "PEDIDO",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Divider(
                              thickness: 1.5,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A364B),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "MÉTODO DE PAGAMENTO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                paymentMethod.isNotEmpty
                                  ? paymentMethod.map((m) => m.label).join(', ')
                                  : "--"
                                ,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A364B),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  "OBSERVAÇÕES",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              if (order.notes != null)
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  order.notes.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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