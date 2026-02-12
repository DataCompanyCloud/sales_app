import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address.dart';
import 'package:sales_app/src/features/customer/domain/valueObjects/address_type.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';
import 'package:sales_app/src/widgets/draggable/address_draggable.dart';
import 'package:url_launcher/url_launcher.dart';

final personExpandedProvider = StateProvider.family<bool, String>((ref, customerId) {
  return false;
});

class PersonCustomerInformation extends ConsumerWidget {
  final PersonCustomer customer;

  const PersonCustomerInformation({
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
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final expanded = ref.watch(personExpandedProvider(customer.uuid));

    final address = customer.addresses
      .where((a) => a.type == AddressType.delivery)
      .cast<Address?>()
      .firstWhere(
        (a) => true,
      orElse: () => customer.primaryAddress,
    );

    final email = customer.contacts
      .map((c) => c.email?.value)
      .whereType<String>()
      .firstOrNull;

    if (address == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Nenhum endereço cadastrado'),
      );
    }


    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
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
                    'Endereço de Entrega',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Endereço
              Text(
                address.formatted,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
        
              // Preview de mapa (moderno, sem SDK)
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
                        // Fake map background
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
                                'Ver no Maps',
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
              SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.phone,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Contato de Entrega',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  ref.read(personExpandedProvider(customer.uuid).notifier).state = !expanded;
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: scheme.onPrimary,
                                borderRadius: BorderRadius.circular(40)
                              ),
                              child: Icon(
                                Icons.person
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${customer.fullName}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text("$email"),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ConfirmationDialog(
                                        title: "Tem certeza que deseja ligar para (47) 91234-5678?",
                                        cancelIcon: Icons.close,
                                        confirmIcon: Icons.check,
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.call)
                                ),
                                const SizedBox(width: 12),
                                AnimatedRotation(
                                  duration: const Duration(milliseconds: 200),
                                  turns: expanded ? 0.5 : 0,
                                  child: const Icon(Icons.keyboard_arrow_down),
                                ),
                              ],
                            ),
                          ],
                        ),
                        AnimatedSize(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: expanded
                              ? Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Column(
                                  children: [
                                    _phoneItem(context, "(47) 98888-1111"),
                                    _phoneItem(context, "(47) 97777-2222"),
                                    _phoneItem(context, "(47) 96666-3333"),
                                  ],
                                ),
                              ) : SizedBox.shrink()
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
                child: Divider(thickness: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _phoneItem(BuildContext context, String phone) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: scheme.secondary,
            width: 1
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: const Icon(Icons.smartphone, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  phone,
                  style: TextStyle(fontSize: 15),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.message)
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.call)
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}