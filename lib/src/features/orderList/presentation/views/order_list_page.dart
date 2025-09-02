import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';

class OrderListPage extends ConsumerWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerControllerProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        title: Text("Lista de Pedidos"),
        leading: IconButton(
          onPressed: () {
            context.goNamed(HomeRouter.home.name);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    "Últimos 20 Pedidos",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    indent: 12,
                    endIndent: 12,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: scheme.onTertiary, width: 2)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 75,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                    )
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("Código"),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  width: 75,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10)
                                    ),
                                    color: Colors.blue
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)
                                    ),
                                    child: Icon(
                                      Icons.unarchive_sharp,
                                      color: Colors.white,
                                      size: 38
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]
                        ),
                        Expanded(
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Nome do Cliente"
                                        ),
                                        Text(
                                          "Preço"
                                        ),
                                        Text(
                                          "QtdProduto"
                                        ),
                                      ],
                                    )
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 4, right: 4),
                                        child: Row(
                                          children: [
                                            Text("Não-Sincronizado"),
                                            SizedBox(width: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 6),
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.red
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: Icon(Icons.chevron_right, size: 28),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "Há 7 dias atrás",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      indent: 12,
                      endIndent: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scheme.onTertiary, width: 2)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 75,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade900,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                    )
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("Código"),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 8),
                                  width: 75,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10)
                                    ),
                                    color: Colors.blue
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)
                                    ),
                                    child: Icon(
                                      Icons.unarchive_sharp,
                                      color: Colors.white,
                                      size: 38
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ]
                        ),
                        Expanded(
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Nome do Cliente"
                                        ),
                                        Text(
                                          "Preço"
                                        ),
                                        Text(
                                          "QtdProduto"
                                        ),
                                      ],
                                    )
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 4, right: 4),
                                        child: Row(
                                          children: [
                                            Text("Sincronizado"),
                                            SizedBox(width: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 6),
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.cyan
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: Icon(Icons.chevron_right, size: 28),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left: 12),
            //       child: Text(
            //         "30 Dias atrás",
            //         style: TextStyle(
            //           fontSize: 18,
            //           color: Colors.grey
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: Divider(
            //         color: Colors.grey,
            //         indent: 12,
            //         endIndent: 12,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}