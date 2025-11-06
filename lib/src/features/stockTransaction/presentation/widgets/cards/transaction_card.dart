import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionCard extends ConsumerWidget {
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final bool isActive = faker.randomGenerator.boolean();
    final randomCode = faker.randomGenerator.integer(99999, min: 10000);
    final price = faker.randomGenerator.decimal(min: 1, scale: 100).toStringAsFixed(2);
    final product = faker.randomGenerator.integer(999, min: 1);
    final month = [
      "Jan",
      "Fev",
      "Mar",
      "Abr",
      "Maio",
      "Jun",
      "Jul",
      "Ago",
      "Set",
      "Out",
      "Nov",
      "Dez",
    ];
    final transactionType = ["Venda", "Devolução", "Entrada", "Saída"];

    final randomDay = faker.randomGenerator.integer(31, min: 1);
    final randomMonth = month[faker.randomGenerator.integer(month.length)];
    final randomTransactionType = transactionType[faker.randomGenerator.integer(transactionType.length)];

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
                      color: Colors.blue[800],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$randomCode",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    width: 75,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10)
                      ),
                      color: Colors.blue,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      ),
                      child: Icon(
                        Icons.compare_arrows,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  )
                ],
              )
            ],
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
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                randomTransactionType,
                                style: TextStyle(
                                  fontSize: 15
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: Row(
                                  children: [
                                    Icon(
                                      isActive ? Icons.archive : Icons.unarchive,
                                      color: isActive ? Colors.greenAccent : Colors.redAccent,
                                      size: 18
                                    ),
                                    Text(
                                      "$product",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isActive ? Colors.greenAccent : Colors.redAccent
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$randomDay/$randomMonth/2025",
                                style: TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18),
                                child: Text(
                                  "R\$$price",
                                  style: TextStyle(
                                    fontSize: 15,
                                    // fontWeight: FontWeight.bold,
                                    color: isActive ? Colors.greenAccent : Colors.redAccent
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}