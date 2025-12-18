import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';

class PersonCustomerCard extends ConsumerWidget {
  final PersonCustomer customer;

  const PersonCustomerCard({
    super.key,
    required this.customer
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
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10)
              ),
              color: customer.isActive ? Colors.green : Colors.red,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (customer.customerCode != null)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 75,
                    height: 20,
                    decoration: BoxDecoration(
                        color: customer.isActive
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                        )
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      customer.customerCode ?? "--",
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 38
                ),
              ],
            ),
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
                            customer.fullName ?? "--"
                          ),
                          Text(
                            customer.cpf?.formatted ?? "--"
                          ),
                          Text(
                            "${customer.primaryAddress?.city}, ${customer.primaryAddress?.uf}"
                          ),
                        ],
                      ),
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
                              color: customer.serverId != null
                                ? Colors.cyan
                                : Colors.red
                            ),
                          ),
                        ),
                      ],
                    ),
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