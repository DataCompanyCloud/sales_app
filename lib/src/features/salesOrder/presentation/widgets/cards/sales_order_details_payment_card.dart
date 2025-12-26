import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';

class SalesOrderDetailsPaymentCard extends ConsumerWidget {
  final SalesOrder order;

  const SalesOrderDetailsPaymentCard ({
    super.key,
    required this.order
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final paymentMethod = order.orderPaymentMethods;
    final description = order.notes;
    return Card(
      color: scheme.surface,
      elevation: 3,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.newspaper,
                    size: 18,
                    color: scheme.secondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "PEDIDO",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: scheme.secondary
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Divider(
                  thickness: 1.5,
                  color: scheme.secondary,
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: scheme.onSurface,
                      border: Border.all(
                        color: scheme.shadow,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "MÉTODO DE PAGAMENTO",
                      style: TextStyle(
                        color: scheme.onSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  if (paymentMethod.isNotEmpty)
                  Text(
                    paymentMethod.map((p) => p.paymentMethod.label).join(", "),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              if (description != null && description.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      "OBSERVAÇÕES",
                      style: TextStyle(
                        color: scheme.onSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    description.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: scheme.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}