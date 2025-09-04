import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
                      "#12345/10",
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
                              "Informações do Cliente",
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                            Text("NomeDoCliente"),
                            Text("Email"),
                            Text("Telefone")
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
                              "Informações do Pedido",
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            Text("Forma de Pagamento:"),
                            Text("Vendendor:"),
                            Text("Observações:")
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subtotal",
                              style: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                            Text(
                              "R\$100,00"
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Desconto",
                              style: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                            Text(
                              "R\$0,00"
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Frete",
                              style: TextStyle(
                                color: Colors.grey
                              ),
                            ),
                            Text(
                              "R\$16,00"
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Taxa",
                            style: TextStyle(
                              color: Colors.grey
                            ),
                          ),
                          Text(
                            "R\$2,00"
                          )
                        ],
                      ),
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