import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailsCard extends ConsumerWidget {

  const OrderDetailsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4),
        itemCount: 12,
        itemBuilder: (context, index) {

          final productName = "${faker.food.cuisine()}, ${faker.food.cuisine()}, ${faker.food.cuisine()}";
          final price = random.integer(100, min: 1);
          final quantity = random.integer(100, min: 1);

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
                                  productName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 24,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    children: List.generate(
                                      6,
                                      (index) => Container(
                                        padding: EdgeInsets.only(left: 8, right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: scheme.primary, width: 1),
                                          color: scheme.onSecondary,
                                        ),
                                        margin: const EdgeInsets.only(right: 8),
                                        child: Center(
                                          child: Text("Categoria ${index + 1}"),
                                        ),
                                      )
                                    ),
                                  ),
                                ),
                                Text(
                                  "Qtd: $quantity",
                                  style: TextStyle(
                                    fontSize: 15
                                  ),
                                ),
                                Text(
                                  "Preço: R\$${price * quantity}",
                                  style: TextStyle(
                                    fontSize: 15
                                  ),
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
    );
  }
}