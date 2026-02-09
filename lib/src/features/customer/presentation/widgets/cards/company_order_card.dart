import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/widgets/badges/text_badge.dart';

class CompanyOrderCard extends ConsumerWidget {
  final CompanyCustomer customer;
  // final SalesOrder order;

  const CompanyOrderCard({
    super.key,
    required this.customer,
    // required this.order
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final name = faker.food.cuisine();
    final price = faker.randomGenerator.decimal(min: 10).toStringAsFixed(2);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline, width: 2),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 75,
                height: 75,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: const Icon(
                  Icons.image,
                  color: Colors.grey,
                  size: 38,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              height: 75,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)
                ),
                color: scheme.surface,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text("R\$$price"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextBadge(
                          text: "Finalizado",
                          color: Colors.green,
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}