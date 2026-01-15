import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address_type.dart';
import 'package:sales_app/src/widgets/draggable/address_draggable.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyCustomerInformation extends ConsumerWidget {
  final CompanyCustomer customer;

  const CompanyCustomerInformation({
    super.key,
    required this.customer
  });

  Future<void> _openMaps(String address) async {
    final encoded = Uri.encodeComponent(address);

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encoded',
    );

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final address = customer.addresses
      .where((a) => a.type == AddressType.delivery)
      .cast<Address?>()
      .firstWhere(
        (a) => true,
      orElse: () => customer.primaryAddress,
    );

    if (address == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Nenhum endereço cadastrado"),
      );
    }


    return Padding(
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
                  address.type.icon,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                "Endereço de Entrega",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            address.formatted,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openMaps(address.formatted),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.15,
                        child: Image.asset(
                          'assets/images/map_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_pin,
                            size: 36,
                            color: scheme.primary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Ver no Maps",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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