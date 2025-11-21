import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sales_app/src/widgets/dialogs/confirmation_dialog.dart';

//////
// Flag de permissão para editar a página
final isMoreOptionsEditableProvider = StateProvider<bool>((ref) => false);

// Switches
final isCnpjRequiredProvider = StateProvider<bool>((ref) => false);
final isBlockSellingProvider = StateProvider<bool>((ref) => false);
final isHideItemProvider = StateProvider<bool>((ref) => false);
final isTablePriceProvider = StateProvider<bool>((ref) => false);
final isTablePriceAdjustedProvider = StateProvider<bool>((ref) => false);
final isSellingTableFixedProvider = StateProvider<bool>((ref) => false);


// Salvar as imagens baixadas em uma lista
final downloadedImagePathProvider = StateProvider<String?>((ref) => '/data/user/0/com.datacompany.sales_app.sales_app/app_flutter/produto1.jpg');

// Download dos produtos
final productDownloadProgressProvider = StateProvider<double>((ref) => 0.0);
final productListProvider = StateProvider<List<Product>>((ref) => []);


class MoreOptionsPage extends ConsumerWidget {

  const MoreOptionsPage ({
    super.key
  });
//////
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requiredCnpj = ref.watch(isCnpjRequiredProvider);
    final blockSelling = ref.watch(isBlockSellingProvider);
    final hideItems = ref.watch(isHideItemProvider);
    final tablePrice = ref.watch(isTablePriceProvider);
    final adjustTablePrice = ref.watch(isTablePriceAdjustedProvider);
    final sellingTable = ref.watch(isSellingTableFixedProvider);

    final isEditable = ref.watch(isMoreOptionsEditableProvider);

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


    return Scaffold(
      appBar: AppBar(
        title: Text("Mais Opções"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                ref.read(isMoreOptionsEditableProvider.notifier).state = !isEditable;
              },
              icon: isEditable
                ? Icon(Icons.lock_outline)
                : Icon(Icons.lock_open_outlined)
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      "Cliente".toUpperCase(),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 12),
                    child: Text(
                      "Pedido".toUpperCase(),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 12),
                    child: Text(
                      "Carregando Produtos".toUpperCase(),
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
                        trailing: Icon(Icons.download),
                        onTap: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: "Atenção!".toUpperCase(),
                              description: "Este é um processo lento e recomendamos que você esteja conectado a uma rede Wi-Fi.\n\nDeseja continuar?",
                            )
                          ) ?? false;

                            if (!ok) return;
                            ref.read(productDownloadProgressProvider.notifier).state = 0.0;

                            // await downloadMockProducts(ref);

                            // Provider de baixar os produtos
                        },
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 12),
                    child: Text(
                      "Carregando Imagem de Produto".toUpperCase(),
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
                          title: Text("Baixar imagens de produtos"),
                          leading: InkWell(
                            onTap: () {
                              showInfoDialog(
                                context,
                                "Baixar imagens de produtos",
                                "Adquire todas as imagens de produtos salvas no banco.\n\n"
                                    "ATENÇÃO: Esse é um processo lento e tende a demorar.",
                                Icons.error_outline,
                              );
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: Icon(Icons.error),
                          ),
                          trailing: Icon(Icons.download),
                          onTap: () async {
                            try {
                              final file = await downloadImage(
                                "http://192.168.254.31:3000/api/v1/images/img5.jpg",
                                "produto5.jpg",
                              );

                              // Salva o caminho no provider
                              ref.read(downloadedImagePathProvider.notifier).state = file.path;

                              print("Imagem salva em: ${file.path}");
                            } catch (e) {
                              print("Erro ao baixar imagem: $e");
                            }
                          }
                      ),
                      localPath != null
                          ? Image.file(File(localPath))
                          : SizedBox.shrink()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Baixar produtos
// Future<void> downloadMockProducts(WidgetRef ref) async {
//   final progress = ref.read(productDownloadProgressProvider.notifier);
//   final productList = ref.read(productListProvider.notifier);
//
//   final mockProducts = mockProductList;
//
//   final total = mockProducts.length;
//
//   productList.state = [];
//
//   for (int i = 0; i < total; i++) {
//     await Future.delayed(const Duration(milliseconds: 150));
//
//     productList.state = [...productList.state, mockProducts[i]];
//     progress.state = (i + 1) / total;
//   }
//
//   progress.state = 1.0;
// }

// Baixar imagem local
Future<File> downloadImage(String url, String fileName) async {
  final response = await http.get(Uri.parse(url));

  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';

  final file = File(filePath);
  return file.writeAsBytes(response.bodyBytes);
}

