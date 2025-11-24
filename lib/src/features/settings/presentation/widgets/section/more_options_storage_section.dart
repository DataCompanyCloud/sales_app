import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:sales_app/src/features/settings/providers.dart';

class MoreOptionsStorageSection extends ConsumerWidget {
  const MoreOptionsStorageSection ({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockSelling = ref.watch(isBlockSellingProvider);
    final hideItems = ref.watch(isHideItemProvider);
    final isEditable = ref.watch(isMoreOptionsEditableProvider);

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
              "Estoque".toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey
              ),
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text("Bloquear venda sem estoque"),
                leading: InkWell(
                  onTap: () {
                    showInfoDialog(
                      context,
                      "Bloquear venda sem estoque",
                      "Bloqueia a venda do produto que esteja sem estoque.",
                      Icons.error_outline,
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(Icons.error),
                ),
                trailing: Switch(
                  value: blockSelling,
                  onChanged: !isEditable
                      ? (newValue) {
                    ref.read(isBlockSellingProvider.notifier).state = newValue;
                  }
                      : null,
                ),
              ),
              ListTile(
                title: Text("Ocultar itens sem estoque"),
                leading: InkWell(
                  onTap: () {
                    showInfoDialog(
                      context,
                      "Ocultar itens sem estoque",
                      "Oculta todos os produtos que não estão em estoque.",
                      Icons.error_outline,
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(Icons.error),
                ),
                trailing: Switch(
                  value: hideItems,
                  onChanged: !isEditable
                      ? (newValue) {
                    ref.read(isHideItemProvider.notifier).state = newValue;
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