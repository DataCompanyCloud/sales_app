import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_status.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:sales_app/src/features/settings/providers.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';
import 'package:sales_app/src/widgets/image_widget.dart';

class SyncProductsSection extends ConsumerStatefulWidget {
  const SyncProductsSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      SyncProductsSectionState();
}

class SyncProductsSectionState extends ConsumerState<SyncProductsSection> {
  final productWithImagesProvider = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final productWithImages = ref.watch(productWithImagesProvider);
    final syncState = ref.watch(syncProductsProvider);
    final cancelSync = ref.watch(cancelSyncProvider);

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

        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 2
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: backgroundColor,
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
                        ? "Sincronizando"
                        : isCancel
                        ? "Cancelado"
                        : isComplete
                        ? "Finalizado"
                        : "Baixar produtos"
                    ,
                  textAlign: TextAlign.start,
                  key: ValueKey(titleText),
                ),
              ),
              leading: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const OptionsDescriptionDialog(
                      title: "Baixar produtos",
                      description: "Baixa os produtos salvos no banco.",
                      icon: Icons.error_outline,
                    ),
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
                    child:
                    isCancel && isSync
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
                                  title: "Cancelar Donwload",
                                  description:
                                  "Tem certeza que deseja cancelar o download?\nTodo o progresso será perdido.",
                                ),
                              ) ??
                                  false;
                              if (!ok) return;
                              ref.read(cancelSyncProvider.notifier).state = true;
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
              onTap: isSync
                  ? null
                  : () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (context) => const ConfirmationDialog(
                      title: "ATENÇÃO!",
                      description:
                      "Este é um processo lento e recomendamos que você esteja conectado a uma rede Wi-Fi.\n\nDeseja continuar?",
                    ),
                  ) ??
                      false;

                  if (!ok) return;

                  await ref.read(syncProductsProvider.notifier).syncProducts(productWithImages: productWithImages,
                );
              },
            ),
            isSync
              ? SizedBox.shrink()
              : AbsorbPointer(
              absorbing: isSync,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSync ? 0.6 : 1.0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      children: [
                        Checkbox(
                          value: productWithImages,
                          onChanged: isSync
                            ? null
                            : (value) {
                              ref.read(productWithImagesProvider.notifier).state = value ?? false;
                            },
                        ),
                        const Text(
                          "Baixar os produtos com imagem",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Consumer(
                builder: (context, ref, _) {
                  final progress = syncState.value?.progress ?? 0;
                  final count = syncState.value?.itemsSyncAmount ?? 0;
                  final total = syncState.value?.total ?? 0;

                  final showProgress = progress > 0.0 && progress < 1.0 && total > 0;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) =>
                      SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1.0,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      ),
                    child: !showProgress
                      ? const SizedBox.shrink()
                      : Column(
                        key: const ValueKey('progress'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("$count/$total"),
                                    Text("${(progress * 100).toStringAsFixed(0)}%"),
                                  ],
                                ),
                                const SizedBox(height: 4),
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
                                const SizedBox(height: 8),
                                Consumer(
                                  builder: (context, ref, _) {
                                    final product = ref.watch(currentDownloadingProductProvider);

                                    if (product == null) {
                                      return const Text("Carregando imagens...");
                                    }

                                    final image = product.images.isNotEmpty
                                        ? product.images.first
                                        : null;

                                    return AnimatedSwitcher(
                                      duration: const Duration( milliseconds: 200),
                                      transitionBuilder: (child, animation) =>
                                        FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      child: Container(
                                        key: ValueKey(product.code),
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: itemBorderColor, width: 2
                                          ),
                                          // color: scheme.surfaceBright,
                                          borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: scheme.outline,
                                                borderRadius: BorderRadius.circular(8)
                                              ),
                                              child: ImageWidget(
                                                width: 64,
                                                height: 64,
                                                fit: BoxFit.contain,
                                                image: image,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:MainAxisAlignment.start,
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    "CÓDIGO: ${product.code}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: scheme.onSurface,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
