import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/options_description_dialog.dart';

// Flag de permissão para editar a página
final isMoreOptionsEditableProvider = StateProvider<bool>((ref) => false);

// Switches
final isCnpjRequiredProvider = StateProvider<bool>((ref) => false);
final isBlockSellingProvider = StateProvider<bool>((ref) => false);
final isHideItemProvider = StateProvider<bool>((ref) => false);
final isTablePriceProvider = StateProvider<bool>((ref) => false);
final isTablePriceAdjustedProvider = StateProvider<bool>((ref) => false);
final isSellingTableFixedProvider = StateProvider<bool>((ref) => false);

class MoreOptionsPage extends ConsumerWidget {
  const MoreOptionsPage ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requiredCnpj = ref.watch(isCnpjRequiredProvider);
    final blockSelling = ref.watch(isBlockSellingProvider);
    final hideItems = ref.watch(isHideItemProvider);
    final tablePrice = ref.watch(isTablePriceProvider);
    final adjustTablePrice = ref.watch(isTablePriceAdjustedProvider);
    final sellingTable = ref.watch(isSellingTableFixedProvider);

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
      body: Padding(
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
                  "Produto".toUpperCase(),
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
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// // Baixar imagem local
// Future<File> downloadImage(String url, String fileName) async {
//   final response = await http.get(Uri.parse(url));
//
//   final directory = await getApplicationDocumentDirectory();
//   final filePath = '${directory.path}/$fileName';
//
//   final file = File(filePath);
//   return file.writeAsBytes(response.bodyBytes);
// }
//
// // Exibir imagem
// final file = await downloadImage(
//   url,
//   fileName
// );