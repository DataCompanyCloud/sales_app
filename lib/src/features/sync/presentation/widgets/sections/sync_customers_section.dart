import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_status.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:sales_app/src/features/settings/providers.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';

class SyncCustomersSection extends ConsumerStatefulWidget {
  const SyncCustomersSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SyncCustomerSectionState();

}

class SyncCustomerSectionState extends ConsumerState<SyncCustomersSection> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final syncState = ref.watch(syncCustomersProvider);
    final cancelSync = ref.read(cancelCustomerSyncProvider);

    final isSync = syncState.value?.status == SyncStatus.syncing;
    final isCancel = cancelSync || syncState.value?.status == SyncStatus.cancel;
    final isComplete = syncState.value?.status == SyncStatus.complete;

    final titleText = isCancel
      ? "Cancelando processo..."
      : isSync
      ? "Sincronizando produtos"
      : "Baixar produtos";

    // 1) Cor da borda do card conforme estado
    final borderColor = isSync && isCancel
      ? scheme.tertiary          // "cancelando" → um alerta suave (ex: amarelo/âmbar do tema)
      : isSync
      ? scheme.primary       // sincronizando → cor principal
      : isCancel
      ? scheme.error     // cancelado → erro
      : isComplete
      ? scheme.primary
      : scheme.outline;

// 2) Cor de fundo do card conforme estado
    final backgroundColor = isSync && isCancel
      ? scheme.tertiaryContainer.withOpacity(0.3)
      : isSync
      ? scheme.primaryContainer.withOpacity(0.35)
      : isCancel
      ? scheme.errorContainer.withOpacity(0.25)
      : isComplete
      ? scheme.primaryContainer.withOpacity(0.25)
      : scheme.surface; // estado "normal"

// 3) Cor da borda do "produto atual" (bloco lá embaixo)
    final itemBorderColor = isSync && isCancel
      ? scheme.tertiary
      : isSync
      ? scheme.primary
      : isCancel
      ? scheme.error
      : isComplete
      ? scheme.primary
      : scheme.outline;

// 4) Cores dos ícones principais
    final leadingIconColor = isComplete
      ? scheme.primary
      : isSync && isCancel
      ? scheme.tertiary
      : isCancel
      ? scheme.error
      : scheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: 2
        )
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                child: Text(
                  isSync && isCancel
                    ? "Cancelando..."
                    : isSync
                    ? "Sincronizando clientes..."
                    : isCancel
                    ? "Cancelado"
                    : isComplete
                    ? "Finalizado"
                    : "Baixar clientes",
                  textAlign: TextAlign.start,
                  key: ValueKey(titleText),
                ),
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: isComplete
                    ? Icon(
                      Icons.check_circle,
                      key: const ValueKey('done'),
                      color: leadingIconColor,
                    )
                    : isSync && isCancel
                    ? Icon(
                      Icons.cancel,
                      key: const ValueKey('cancel'),
                      color: leadingIconColor,
                    )
                    : isCancel
                    ? Icon(
                      Icons.cancel,
                      key: const ValueKey('cancelled'),
                      color: leadingIconColor,
                    )
                    : Icon(
                      Icons.cloud_download,
                      key: const ValueKey('download'),
                      color: leadingIconColor,
                  ),
                ),
              ),
              trailing: Consumer(
                builder: (context, ref, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                    child: isComplete
                      ? SizedBox.shrink()
                      : isCancel && isSync
                        ? SizedBox.shrink()
                        : isSync
                    ? SizedBox(
                      key: const ValueKey('close'),
                      width: 30,
                      height: 30,
                      child: InkWell(
                        onTap: () async {
                          final ok = await showDialog(
                            context: context,
                            builder: (context) => const ConfirmationDialog(
                              title: "Cancelar Download",
                              description:
                              "Tem certeza que deseja cancelar o download?\nTodo o progresso será perdido.",
                            ),
                          ) ?? false;
                          if (!ok) return;
                          ref.read(cancelCustomerSyncProvider.notifier).state = true;
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Icon(
                          Icons.close,
                          color: leadingIconColor
                        ),
                      ),
                    )
                    : Icon(
                      Icons.download,
                      key: ValueKey('download'),
                      color: leadingIconColor,
                    ),
                  );
                },
              ),
              onTap: (isSync || isComplete)
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
                  final progress = syncState.value?.progress ?? 0;
                  final count = syncState.value?.itemsSyncAmount ?? 0;
                  final total = syncState.value?.total ?? 0;

                  if (progress <= 0) return SizedBox.shrink();

                  if (progress >= 1.0) return SizedBox.shrink();

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("$count/$total"),
                                Text("${(progress * 100).toStringAsFixed(0)}%"),
                              ],
                            ),
                            SizedBox(height: 4),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: progress),
                              duration: const Duration(milliseconds: 250),
                              builder: (context, value, _) {
                                return LinearProgressIndicator(
                                  value: value,
                                  minHeight: 8,
                                  color: itemBorderColor,
                                  borderRadius: BorderRadius.circular(40),
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Consumer(
                              builder: (context, ref, _) {
                                final customer = ref.watch(currentDownloadingCustomerProvider);

                                if (customer == null) {
                                  return Text("Carregando clientes...");
                                }

                                late final String displayName;

                                if (customer is PersonCustomer) {
                                  displayName = customer.fullName ?? '--';
                                }
                                if (customer is CompanyCustomer) {
                                  displayName = customer.legalName ?? customer.tradeName ?? '--' ;
                                }

                                final icon = customer is PersonCustomer
                                  ? Icons.person
                                  : customer is CompanyCustomer
                                  ? Icons.apartment
                                  : Icons.help_outline;

                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  child: Container(
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
                                          child: Icon(
                                            icon,
                                            size: 36,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                displayName,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "CÓDIGO: ${customer.customerCode}",
                                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            ),
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
    );
  }

}