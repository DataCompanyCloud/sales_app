import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/settings/presentation/widgets/dialogs/settings_description_dialog.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Mais Opções"),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22),
        ),
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
                        showDialog(
                          context: context,
                          builder: (context) {
                            return OptionsDescriptionDialog();
                          }
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(Icons.question_mark),
                    ),
                    trailing: Switch(
                      value: requiredCnpj,
                      onChanged: (newValue) {
                        ref.read(isCnpjRequiredProvider.notifier).state = newValue;
                      }
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
                      onTap: () {},
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(Icons.question_mark),
                    ),
                    trailing: Switch(
                      value: blockSelling,
                      onChanged: (newValue) {
                        ref.read(isBlockSellingProvider.notifier).state = newValue;
                      }
                    ),
                  ),
                  ListTile(
                    title: Text("Ocultar itens sem estoque"),
                    leading: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(30),
                      child: Icon(Icons.question_mark),
                    ),
                    trailing: Switch(
                      value: hideItems,
                      onChanged: (newValue) {
                        ref.read(isHideItemProvider.notifier).state = newValue;
                      }
                    ),
                  ),
                  SwitchListTile(
                    title: Text("Bloquear venda sem estoque"),
                    // subtitle: Text("Bloqueia a venda do produto que esteja sem estoque"),
                    value: blockSelling,
                    onChanged: (newValue) {
                      ref.read(isBlockSellingProvider.notifier).state = newValue;
                    }
                  ),
                  SwitchListTile(
                    title: Text("Ocultar itens sem estoque"),
                    // subtitle: Text("Oculta todos os produtos que não estão em estoque"),
                    value: hideItems,
                    onChanged: (newValue) {
                      ref.read(isHideItemProvider.notifier).state = newValue;
                    }
                  )
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
                  ),
                  ListTile(
                    title: Text("Ajustar tabela de preço automaticamente"),
                  ),
                  ListTile(
                    title: Text("Fixar tabela na venda"),
                  ),
                  SwitchListTile(
                    title: Text("Tabela de Preço"),
                    // subtitle: Text("Sempre utilizar a Tabela de Preço"),
                    value: tablePrice,
                    onChanged: (newValue) {
                      ref.read(isTablePriceProvider.notifier).state = newValue;
                    }
                  ),
                  SwitchListTile(
                    title: Text("Ajustar tabela de preço automaticamente"),
                    // subtitle: Text("Altera automaticamente a tabela de preço ao modificar a quantidade vendida"),
                    value: adjustTablePrice,
                    onChanged: (newValue) {
                      ref.read(isTablePriceAdjustedProvider.notifier).state = newValue;
                    }
                  ),
                  SwitchListTile(
                    title: Text("Fixar tabela na venda"),
                    // subtitle: Text("Mantém a tabela vinculada à condição de pagamento e aplica automaticamente os descontos/acréscimos da subtabela nos produtos"),
                    value: sellingTable,
                    onChanged: (newValue) {
                      ref.read(isSellingTableFixedProvider.notifier).state = newValue;
                    }
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