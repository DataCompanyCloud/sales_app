import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';

class DraggableCreateCustomer extends ConsumerWidget {
  const DraggableCreateCustomer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: scheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 12),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "Novo Cliente",
                      style: theme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),

              Divider(
                height: 2,
                thickness: 2,
                color: scheme.outline,
              ),

              // Conteúdo
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _createOptionTile(
                      context: context,
                      icon: Icons.apartment_rounded,
                      title: "Pessoa Jurídica",
                      subtitle: "Criar cliente PJ",
                      onTap: () async {
                        final newCustomer = await context.pushNamed<Customer?>( CustomerRouter.createCompanyCustomer.name );
                        if(!context.mounted) return;

                        context.pop(newCustomer);
                      },
                    ),
                    _createOptionTile(
                      context: context,
                      icon: Icons.person_rounded,
                      title: "Pessoa Física",
                      subtitle: "Criar cliente PF",
                      onTap: () async {
                        final newCustomer = await context.pushNamed<Customer?>( CustomerRouter.createPersonCustomer.name );
                        if (!context.mounted) return;

                        context.pop(newCustomer);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _createOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap
  }) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: scheme.primary.withValues(alpha: 31),
        child: Icon(
          icon,
          color: scheme.primary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}