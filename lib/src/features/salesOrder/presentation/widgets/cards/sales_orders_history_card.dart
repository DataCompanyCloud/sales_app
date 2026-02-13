import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';


class SalesOrdersHistoryCard extends ConsumerWidget {
  final SalesOrder salesOrder;

  const SalesOrdersHistoryCard({
    super.key,
    required this.salesOrder
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline, width: 2)
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
                    alignment: Alignment.center,
                    child: Text(
                      salesOrder.code ?? "--",
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
                      color: Colors.blue
                    ),
                    child: Icon(
                      Icons.sell,
                      size: 38,
                      color: scheme.onSurface,
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
                          Text(
                            "${salesOrder.items}",
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                          Text(
                            "${salesOrder.total.amount}",
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                          Text(
                            "${salesOrder.customerId}",
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                        ],
                      )
                    )
                  ],
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}


