import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:sales_app/src/features/settings/providers.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';
import 'package:sales_app/src/widgets/image_widget.dart';

class MoreOptionsProductSection extends ConsumerStatefulWidget {
  const MoreOptionsProductSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MoreOptionsProductSectionState();

}

class MoreOptionsProductSectionState extends ConsumerState<MoreOptionsProductSection> {
  final productWithImagesProvider = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final productWithImages = ref.watch(productWithImagesProvider);
    final syncState = ref.watch(syncProductsProvider);
    final isSync = syncState.isLoading ; // || syncState.value?.isSyncing == true;
    final cancelSync = ref.read(cancelSyncProvider);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 12),
            child: Text(
              "PRODUTOS",
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
                title: Text(
                  cancelSync && isSync
                    ? "Cancelando processo..."
                    : isSync
                      ? "Sincronizando produtos"
                      : "Baixar produtos"
                ),
                leading: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => OptionsDescriptionDialog(
                        title: "Baixar produtos",
                        description: "Baixa os produtos salvos no banco.",
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
                                title: "Cancelar Donwload",
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
                  },
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

                    await ref.read(syncProductsProvider.notifier).syncProducts(
                      productWithImages: productWithImages
                    );
                },
              ),
              AbsorbPointer(
                absorbing: isSync,
                child: Opacity(
                  opacity: isSync ? 0.6 : 1.0, // visual quando desativado
                  child: Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
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
                              }
                          ),
                          Text(
                            "Baixar os produtos com imagem",
                            style: TextStyle(
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Consumer(
                  builder: (context, ref, _) {
                    final progress = syncState.value?.progress ?? 0;
                    print(progress);
                    final count = syncState.value?.itemsSyncAmount ?? 0;
                    final total = syncState.value?.total ?? 0;

                    if (progress == 0 || progress == 1.0) {
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
                                  final product = ref.watch(currentDownloadingProductProvider);

                                  if (product == null) {
                                    return Text("Carregando imagens...");
                                  }

                                  final image = product.images.isNotEmpty ? product.images.first : null;
                                  return Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ImageWidget(
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.fill,
                                          image: image
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "CÓDIGO: ${product.code}",
                                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
