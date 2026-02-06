import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/widgets/badges/text_badge.dart';

class PersonCustomerHeader extends ConsumerWidget {
  final PersonCustomer customer;

  const PersonCustomerHeader({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = customer.primaryAddress;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: customer.isActive ? Colors.green : Colors.red,
            child: const Icon(Icons.person),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.fullName ?? '--',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.perm_contact_cal,// address.type.icon,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      customer.cpf?.formatted ?? "--",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '•',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 6),
                    TextBadge(
                      text: customer.isActive ? "Ativo" : "Bloqueado",
                      color: customer.isActive ? Colors.green: Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (address != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on,// address.type.icon,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${address.city}, ${address.state.name}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
