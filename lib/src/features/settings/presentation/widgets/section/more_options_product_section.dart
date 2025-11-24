import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/product/providers.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:sales_app/src/features/settings/providers.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MoreOptionsProductSection extends ConsumerWidget {
  const MoreOptionsProductSection ({
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDownloading = ref.watch(isDownloadingProductsProvider);
    final localPath = ref.watch(downloadedImagePathProvider);

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
                  onTap: () {
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
                trailing: Consumer(
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
                    ref.read(productDownloadProgressProvider.notifier).state = 0.0;

                    await downloadMockProducts(ref);

                    print("Download Finalizado!");
                  },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Consumer(
                  builder: (context, ref, _) {
                    final progress = ref.watch(productDownloadProgressProvider);
                    final processed = (progress * 15000).clamp(0, 15000).toInt();

                    if (progress == 0 || progress == 1.0) {
                      return SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "$processed/15000",
                                textAlign: TextAlign.start,
                              ),
                              Text("${(progress * 100).toStringAsFixed(0)}%"),
                            ],
                          ),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Baixar imagem de mock-products
              // ListTile(
              //   title: Text("Baixar imagens de produtos"),
              //   leading: InkWell(
              //     onTap: () {
              //       showInfoDialog(
              //         context,
              //         "Baixar imagens de produtos",
              //         "Adquire todas as imagens de produtos salvas no banco.\n\n"
              //           "ATENÇÃO: Esse é um processo lento e tende a demorar.",
              //         Icons.error_outline,
              //       );
              //     },
              //     borderRadius: BorderRadius.circular(30),
              //     child: Icon(Icons.error),
              //   ),
              //   trailing: Icon(Icons.download),
              //   onTap: () async {
              //     try {
              //       final file = await downloadImage(
              //         "http://192.168.254.31:3000/api/v1/images/img5.jpg",
              //         "produto5.jpg",
              //       );
              //
              //       ref.read(downloadedImagePathProvider.notifier).state = file.path;
              //
              //       print("Imagem salva em: ${file.path}");
              //     } catch (e) {
              //       print("Erro ao baixar imagem: $e");
              //     }
              //   }
              // ),
              // localPath != null
              //   ? Image.file(File(localPath))
              //   : SizedBox.shrink()
            ],
          ),
        ),
      ],
    );
  }
}

// Baixar produtos
Future<void> downloadMockProducts(WidgetRef ref) async {
  ref.read(isDownloadingProductsProvider.notifier).state = true;

  final progress = ref.read(productDownloadProgressProvider.notifier);
  final productList = ref.read(productListProvider.notifier);
  final services = await ref.read(productServiceProvider.future);

  productList.state = [];

  final total = 15000;
  final limit = 30;

  for (int i = 0; i < total; i += limit) {

    final products = await services.getAll(start: i, limit: limit);
    final next = [...productList.state, ...products];
    if (next.length > total) {
      productList.state = next.take(total).toList();
    } else {
      productList.state = next;
    }

    final current = (i + limit).clamp(0, total);
    progress.state = current / total;
  }

  progress.state = 1.0;

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