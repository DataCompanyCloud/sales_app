import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/presentation/widgets/payment/payment_row.dart';
import 'package:sales_app/src/features/order/providers.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final Order order;

  const OrderDetailsScreen({
    super.key,
    required this.order
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(orderControllerProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final payment = ['Débito', 'Crédito', 'PIX'];

    final orderNumber = faker.randomGenerator.integer(90000, min: 10000);
    final customerName = faker.person.name();
    final email = faker.internet.email();
    final phone = faker.phoneNumber.us();
    bool observations = faker.randomGenerator.boolean();
    String paymentMethod = faker.randomGenerator.element(payment);
    final salesman = faker.person.name();
    final details = faker.food.cuisine();

    return Scaffold(
      body: Center(
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
                      "#${orderNumber}",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Em Aberto",
                        style: TextStyle(
                          color: Colors.orange
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
                            Text(
                              "INFORMAÇÕES DO CLIENTE",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Divider(
                                thickness: 1.5,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              "Cliente: ${customerName}",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Email: ${email}",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Telefone: $phone",
                              style: TextStyle(
                                  fontSize: 15
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ),
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
                            Text(
                              "INFORMAÇÕES DO PEDIDO",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Divider(
                                thickness: 1.5,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              "Forma de Pagamento: $paymentMethod",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Vendendor: $salesman",
                              style: TextStyle(
                                fontSize: 15
                              ),
                            ),
                            SizedBox(height: 4),
                            if (observations == true)
                            RichText(
                              text: TextSpan(
                                text: "Observações: ",
                                style: TextStyle(fontSize: 15),
                                children: [
                                  TextSpan(
                                    text: details,
                                    style: TextStyle(fontSize: 15, color: Colors.grey)
                                  )
                                ]
                              ),
                            ),
                            if (observations == false)
                            RichText(
                              text: TextSpan(
                                text: "Observações: ",
                                style: TextStyle(fontSize: 15),
                                children: [
                                  TextSpan(
                                    text: "Nada informado.",
                                    style: TextStyle(fontSize: 15, color: Colors.grey)
                                  )
                                ]
                              ),
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
                      const PaymentRow(label: "Subtotal", value: "R\$100,00"),
                      const PaymentRow(label: "Desconto", value: "R\$0,00"),
                      const PaymentRow(label: "Frete", value: "R\$16,00"),
                      const PaymentRow(label: "Taxa", value: "R\$8,00"),
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