import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailsCard extends ConsumerWidget {
  const OrderDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 4),
          itemCount: 6,
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
                            padding: EdgeInsets.only(bottom: 8),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Colors.white54
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)
                              ),
                            ),
                          )
                        ],
                      ),
                    ]
                  ),
                  Expanded(
                    child: Container(
                      height: 90,
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
                                    "Nome do Produto"
                                  ),
                                  Text(
                                    "Categoria"
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
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(Icons.chevron_right, size: 28),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}