import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:sales_app/src/features/settings/providers.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';

class MoreOptionsCustomerSection extends ConsumerStatefulWidget {
  const MoreOptionsCustomerSection({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MoreOptionsCustomerSectionState();

}

class MoreOptionsCustomerSectionState extends ConsumerState<MoreOptionsCustomerSection> {

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final scheme = theme.colorScheme;
    final requiredCnpj = ref.watch(isCnpjRequiredProvider);
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
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "CLIENTE",
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
                title: Text("CNPJ Obrigatório"),
                leading: InkWell(
                  onTap: () {
                    showInfoDialog(
                      context,
                      "CNPJ Obrigatório",
                      "No cadastro do cliente, o campo CNPJ deve ser preenchido.",
                      Icons.error_outline,
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(Icons.error),
                ),
                trailing: Switch(
                  value: requiredCnpj,
                  onChanged: !isEditable
                    ? (newValue) {
                    ref.read(isCnpjRequiredProvider.notifier).state = newValue;
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
