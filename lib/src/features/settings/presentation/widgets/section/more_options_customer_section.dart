import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:sales_app/src/features/settings/providers.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';

class MoreOptionsCustomerSection extends ConsumerStatefulWidget {
  const MoreOptionsCustomerSection({super.key});

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
    final syncState = ref.watch(syncCustomersProvider);
    final isSync = syncState.isLoading;
    final cancelSync = ref.read(cancelSyncProvider);
    
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
              ListTile(
                title: Text(
                  cancelSync && isSync
                    ? "Cancelando processo..."
                    : isSync
                      ? "Sincronizando clientes"
                      : "Baixar clientes"
                ),
                leading: InkWell(
                  onTap: () {
                    showDialog(
                      context: context, 
                      builder: (_) => OptionsDescriptionDialog(
                        title: "Baixar clientes", 
                        description: "Baixa todos os clientes salvos no banco.", 
                        icon: Icons.error_outline,
                      )
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(Icons.error),
                ),
                trailing: Consumer(
                  builder: (context, ref, _) {
                    return isSync
                      ? SizedBox(
                        width: 30,
                        height: 30,
                        child: InkWell(
                          onTap: () async {
                            final ok = await showDialog(
                              context: context,
                              builder: (context) => ConfirmationDialog(
                                title: "Cancelar Download",
                                description: "Tem certeza que deseja cancelar o download?\n Todo o progresso será perdido.",
                              ),
                            ) ?? false;
                            if (!ok) return;
                            ref.read(cancelSyncProvider.notifier).state = true;
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Icon(Icons.close),
                        ),
                      )
                      : Icon(Icons.download);
                  }
                ),
                onTap: isSync
                  ? null
                  : () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: "ATENÇÃO!",
                        description: "Este é um processo lento e recomendamos que você esteja conectado a uma rede Wi-Fi.\n\nDeseja continuar?",
                      )
                    ) ?? false;

                    if (!ok) return;

                    await ref.read(syncCustomersProvider.notifier).syncCustomers();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Consumer(
                  builder: (context, ref, _) {
                    final count = syncState.value?.itemsSyncAmount ?? 0;
                    final total = syncState.value?.total ?? 0;
                    final progress = total == 0 ? 0.0 : count/total;

                    if (progress <= 0 || progress == 1.0) {
                      return SizedBox.shrink();
                    }

                    if (progress >= 1.0) {
                      return SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "$count/$total",
                                    textAlign: TextAlign.start,
                                  ),
                                  Text("${(progress * 100).toStringAsFixed(0)}%"),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: progress,
                                minHeight: 8,
                              ),
                              SizedBox(height: 8),
                              Consumer(
                                builder: (context, ref, _) {
                                  final customer = ref.watch(currentDownloadingCustomerProvider);

                                  if (customer == null) {
                                    return Text("Carregando clientes...");
                                  }

                                  return Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Colors.white
                                          ),
                                          child: Icon(Icons.person, size: 36),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                customer.runtimeType.toString(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "CÓDIGO: ${customer.customerCode}",
                                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                              )
                                            ],
                                          )
                                        )
                                      ],
                                    ),
                                  );
                                }
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
