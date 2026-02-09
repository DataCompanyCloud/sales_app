import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/person_order_card.dart';

class PersonCustomerOrders extends ConsumerWidget {
  final PersonCustomer customer;

  const PersonCustomerOrders ({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.archive,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Últimos Pedidos",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
      
      
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: PersonOrderCard(customer: customer),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
