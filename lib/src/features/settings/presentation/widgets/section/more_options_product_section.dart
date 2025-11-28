import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/notifications/notification_service.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';
import 'package:sales_app/src/features/product/providers.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:sales_app/src/features/settings/providers.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sales_app/src/widgets/image_widget.dart';

class MoreOptionsProductSection extends ConsumerWidget {
  const MoreOptionsProductSection ({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDownloading = ref.watch(isDownloadingProductsProvider);
    final isBoxSelected = ref.watch(checkBoxProvider);

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
              "Produtos".toUpperCase(),
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
                title: Text("Baixar todos os produtos"),
                leading: InkWell(
                  onTap: () async {
                    final onlyWithImages = ref.read(checkBoxProvider);

                    await downloadMockProducts(ref, onlyWithImages: onlyWithImages);
                    showInfoDialog(
                      context,
                      "Baixar todos os produtos",
                      "Baixa todos os produtos salvos no banco.",
                      Icons.error_outline,
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Icon(Icons.error),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Consumer(
                    builder: (context, ref, _) {

                      return isDownloading
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                        : Icon(Icons.download);
                    },
                  ),
                ),
                onTap: isDownloading
                  ? null
                  : () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmationDialog(
                        title: "Atenção!".toUpperCase(),
                        description: "Este é um processo lento e recomendamos que você esteja conectado a uma rede Wi-Fi.\n\nDeseja continuar?",
                      )
                    ) ?? false;

                    if (!ok) return;
                    ref.read(productDownloadProgressProvider.notifier).state = 0;

                    await downloadMockProducts(ref, onlyWithImages: ok);

                    print("Download Finalizado!");
                  },
              ),
              Container(
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
                        value: isBoxSelected,
                        onChanged: (onChanged) {
                          ref.read(checkBoxProvider.notifier).state = !isBoxSelected;
                        }
                      ),
                      Text(
                        "Baixar todos os produtos com imagem",
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Consumer(
                  builder: (context, ref, _) {
                    final downloaded = ref.watch(productDownloadProgressProvider);
                    final progress = downloaded / 15000;

                    if (downloaded == 0 || downloaded == 1.0) {
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
                                    "$downloaded/15000",
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
                                  final file = ref.watch(currentDownloadingImageProvider);
                                  final product = ref.watch(currentDownloadingProductProvider);

                                  if (file == null || product == null) {
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

// Baixar produtos
Future<void> downloadMockProducts(
    WidgetRef ref, {
      required bool onlyWithImages,
    }) async {
  ref.read(isDownloadingProductsProvider.notifier).state = true;

  final progress = ref.read(productDownloadProgressProvider.notifier);

  final services = await ref.read(productServiceProvider.future);
  final repository = await ref.read(productRepositoryProvider.future);

  final total = 15000;
  final limit = 30;
  final init = await repository.count();

  // progress.state = init;

  await NotificationService.showSyncNotification(
    title: "Baixando produtos",
    body: "Sincronização iniciada",
    progress: progress.state,
    maxProgress: total,
  );

  // await repository.deleteAll(); // Delete tudo local

  for (int i = init; i < total; i += limit) {

    final products = await services.getAll(
      ProductFilter(start: i, limit: limit),
    );

    for (var product in products) {
      progress.state++;

      if (onlyWithImages && product.imagesAll.isEmpty) {
        continue;
      }

      final List<ImageEntity> imagesSaved = [];

      /// TODO: Arrumar isso
      // if (onlyWithImages) {
      //   for (var img in product.images) {
      //     if (img.url.isEmpty) {
      //       imagesSaved.add(img);
      //       continue;
      //     }
      //
      //     final file = await downloadImage(img.url, "${img.imageId}.png");
      //     ref.read(currentDownloadingImageProvider.notifier).state = file;
      //
      //     imagesSaved.add(img.copyWith(localUrl: file.path));
      //   }
      // } else {
      //   imagesSaved.add(
      //     ImageEntity(
      //       imageId: -1,
      //       url: '',
      //       localUrl: 'asset:assets/images/not_found.png',
      //     ),
      //   );
      // }

      for(var img in product.images) {
        final file = await downloadImage(img.url, "${img.imageId}.png");
        ref.read(currentDownloadingImageProvider.notifier).state = file;

        imagesSaved.add(img.copyWith(localUrl: file.path));

      }

      var newProduct = product.copyWith(images: imagesSaved);
      ref.read(currentDownloadingProductProvider.notifier).state = newProduct;
      await repository.save(newProduct);
    }
    await NotificationService.showSyncNotification(
      title: "Baixando produtos",
      body: "Sincronizando imagens...",
      progress: progress.state,
      maxProgress: total,
    );

  }
  await NotificationService.completeSyncNotification(
      title: "Download concluído",
      body: "Todos os produtos foram baixados com sucesso!"
  );

  ref.read(isDownloadingProductsProvider.notifier).state = false;
}

// Baixar imagem local
Future<File> downloadImage(String url, String fileName) async {
  final response = await http.get(Uri.parse(url));

  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';

  final file = File(filePath);
  return file.writeAsBytes(response.bodyBytes);
}
