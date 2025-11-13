import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/domain/valueObjects/order_status.dart';
import 'package:sales_app/src/features/order/presentation/router/order_router.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_client_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_contact_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/cards/order_details_payment_card.dart';
import 'package:sales_app/src/features/order/presentation/widgets/payment/payment_row.dart';

class OrderDraftsScreen extends ConsumerWidget {
  final List<Order> orders;

  const OrderDraftsScreen({
    super.key,
    required this.orders
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];

            return InkWell(
              onTap: () {
                final loc = GoRouter.of(context).namedLocation(
                  OrderRouter.create.name,
                  queryParameters: {"orderId": order.orderId.toString()},
                );
                context.push(loc);
              },
              child: OrderCard(order: order)
            );
          }
        ),
      )
    );
  }
}