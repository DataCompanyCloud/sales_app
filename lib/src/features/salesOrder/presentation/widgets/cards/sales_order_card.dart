import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/sales_order_status.dart';

class SalesOrderCard extends ConsumerWidget {
  final SalesOrder order;

  const SalesOrderCard({
    super.key,
    required this.order
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final customer = order.customer;
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
                    decoration: BoxDecoration(
                      color: order.status == SalesOrderStatus.draft
                        ? Colors.yellow.shade900
                        :  order.status == SalesOrderStatus.confirmed
                        ? Colors.green.shade900
                        : Colors.red.shade900
                      ,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                      )
                    ),
                    alignment: Alignment.center,
                    child: Text("${order.orderCode}"),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    width: 75,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10)
                      ),
                      color: order.status == SalesOrderStatus.draft
                        ? Colors.orangeAccent
                        :  order.status == SalesOrderStatus.confirmed
                        ? Colors.green
                        : Colors.red
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
                            customer?.customerName ?? "--",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                          Text(
                            "${order.itemsCount.toString().padLeft(2, "0")} produtos",
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                          Text(
                            "R\$ ${order.total.decimalValue}",
                            style: TextStyle(
                              fontSize: 15
                            ),
                          ),
                        ],
                      )
                    ),
                    Icon(Icons.chevron_right, size: 28),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 6, right: 6),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: order.serverId == null
                                ? Colors.red
                                : Colors.cyan
                            ),
                          ),
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

}