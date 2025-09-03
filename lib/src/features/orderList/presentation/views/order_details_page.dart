import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsPage extends ConsumerWidget {
  const OrderDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    ///TODO: Melhorar essa página
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do Pedido"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
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
                  "23 de Março, 2025"
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Card(
                    color: scheme.surface,
                    elevation: 3,
                    child: Column(
                      children: [
                        Align(
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
                      ],
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Card(
                    color: scheme.surface,
                    child: Column(
                      children: [
                        Align(
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
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Valor Total",
                style: TextStyle(
                  fontSize: 18
                ),
              ),
              Text(
                "R\$500,00",
                style: TextStyle(
                  fontSize: 18
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}