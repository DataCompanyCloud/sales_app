import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';

class SalesOrderDetailsClientCard extends ConsumerWidget {
  final SalesOrder order;

  const SalesOrderDetailsClientCard ({
    super.key,
    required this.order
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final customer = order.customer;
    return Card(
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
                    color: scheme.onSurface
                  ),
                  SizedBox(width: 4),
                  Text(
                    "CLIENTE",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: scheme.onSurface
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Divider(
                  thickness: 1.5,
                  color: scheme.onSurface,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      border: Border.all(
                        color: scheme.shadow,
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
                      color: scheme.secondaryContainer,
                      border: Border.all(
                        color: scheme.shadow,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "NOME",
                      style: TextStyle(
                        color: scheme.onSurface,
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
    );
  }
}