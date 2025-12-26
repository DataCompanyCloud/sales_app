import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:sales_app/src/features/settings/providers.dart';

class MoreOptionsOrderSection extends ConsumerWidget {
  const MoreOptionsOrderSection ({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablePrice = ref.watch(isTablePriceProvider);
    final adjustTablePrice = ref.watch(isTablePriceAdjustedProvider);
    final sellingTable = ref.watch(isSellingTableFixedProvider);
    final isEditable = ref.watch(isMoreOptionsEditableProvider);

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    void showInfoDialog(BuildContext context, String title, String description, IconData icon) {
      showDialog(
          context: context,
          builder: (_) => OptionsDescriptionDialog(
            title: title,
            description: description,
            icon: icon,
          )
      );
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 12),
            child: Text(
              "PEDIDO",
              style: TextStyle(
                fontSize: 16,
                color: scheme.onSurfaceVariant
              ),
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text("Tabela de Preço"),
                leading: InkWell(
                  onTap: () {
                    showInfoDialog(
                      context,
                      "Tabela de Preço",
                      "Sempre utilizar a Tabela de Preço.",
                      Icons.error_outline,
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(Icons.error),
                ),
                trailing: Switch(
                  value: tablePrice,
                  onChanged: !isEditable
                      ? (newValue) {
                    ref.read(isTablePriceProvider.notifier).state = newValue;
                  }
                      : null,
                ),
              ),
              ListTile(
                title: Text("Ajustar tabela de preço automaticamente"),
                leading: InkWell(
                  onTap: () {
                    showInfoDialog(
                      context,
                      "Ajustar tabela de preço \nautomaticamente",
                      "Altera automaticamente a tabela de preço ao modificar a quantidade vendida.",
                      Icons.error_outline,
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(Icons.error),
                ),
                trailing: Switch(
                  value: adjustTablePrice,
                  onChanged: !isEditable
                      ? (newValue) {
                    ref.read(isTablePriceAdjustedProvider.notifier).state = newValue;
                  }
                      : null,
                ),
              ),
              ListTile(
                title: Text("Fixar tabela na venda"),
                leading: InkWell(
                  onTap: () {
                    showInfoDialog(
                      context,
                      "Fixar tabela na venda",
                      "Mantém a tabela vinculada à condição de pagamento e aplica automaticamente os descontos/acréscimos da subtabela nos produtos.",
                      Icons.error_outline,
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(Icons.error),
                ),
                trailing: Switch(
                  value: sellingTable,
                  onChanged: !isEditable
                      ? (newValue) {
                    ref.read(isSellingTableFixedProvider.notifier).state = newValue;
                  }
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}