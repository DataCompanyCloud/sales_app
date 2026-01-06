import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/company/providers.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/error/presentation/views/error_screen.dart';
import 'package:sales_app/src/features/home/presentation/controllers/home_providers.dart';
import 'package:sales_app/src/features/home/presentation/widgets/draggable/draggable_company_selector.dart';
import 'package:sales_app/src/features/home/presentation/widgets/drawers/home_drawer.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/product/presentation/router/product_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/router/sales_order_router.dart';
import 'package:sales_app/src/features/stockTransaction/presentation/router/transaction_router.dart';
import 'package:sales_app/src/features/storage/presentation/router/storage_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends ConsumerWidget {
  final String title;

  const HomePage ({
    super.key,
    required this.title,
  });

  void _openCompanySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const DraggableCompanySelector();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(companyGroupControllerProvider);
    final currentIndex = ref.watch(homeIndexProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications)
          ),
        ],
      ),
      drawer: HomeDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              controller.when(
                error: (error, stack) => ErrorScreen(
                  exception: error is AppException
                    ? error
                    : AppException.errorUnexpected(error.toString())
                ),
                loading: _skeleton,
                data: (groups) {
                  if (groups.isEmpty) {
                    return SizedBox.shrink();
                  }

                  // Lógica para alterar entre as empresas
                  final company = ref.watch(activeCompanyProvider);
                  if (company == null) {
                    return const SizedBox();
                  }

                  return Card(
                    color: scheme.surface,
                    margin: EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      side: BorderSide(
                        color: scheme.outline,
                        width: 2
                      ),
                    ),
                    child: ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: scheme.onSurface,
                        child: Icon(Icons.factory, color: scheme.surface),
                      ),
                      title: Text(company.tradeName),
                      subtitle: Text(company.cnpj.formatted),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        _openCompanySelector(context);
                      },
                    ),
                  );
                }
              ),
              Padding(padding: EdgeInsets.only(top: 16)),
              Card(
                color: scheme.surface,
                margin: EdgeInsets.all(2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  side: BorderSide(
                    color: scheme.outline,
                    width: 2
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Pedido",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: scheme.onSurface,
                        child: Icon(Icons.format_list_bulleted, color: scheme.surface),
                      ),
                      title: Text("Lista de Pedidos"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        context.goNamed(SalesOrderRouter.list.name);
                      },
                    ),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: scheme.onSurface,
                        child: Icon(Icons.history, color: scheme.surface),
                      ),
                      title: Text("Histórico de Pedidos"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        context.goNamed(SalesOrderRouter.history.name);
                      },
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 12)),
              Card(
                color: scheme.surface,
                margin: EdgeInsets.all(2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  side: BorderSide(
                    color: scheme.outline,
                    width: 2
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Estoque",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: scheme.onSurface,
                        child: Icon(Icons.star_rounded, color: scheme.surface),
                      ),
                      title: Text("Meu Estoque"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: scheme.onSurface,
                        child: Icon(Icons.warehouse, color: scheme.surface),
                      ),
                      title: Text("Lista de Estoques"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        context.goNamed(StorageRouter.storage.name);
                      },
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 12)),
              Card(
                color: scheme.surface,
                margin: EdgeInsets.all(2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: scheme.outline,
                    width: 2
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Transação",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: scheme.onSurface,
                        child: Icon(Icons.monetization_on, color: scheme.surface),
                      ),
                      title: Text("Histórico de Transações"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        context.pushNamed(TransactionRouter.transaction.name);
                      },
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 12)),
              Card(
                color: scheme.surface,
                margin: EdgeInsets.all(2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: scheme.outline,
                    width: 2
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Produtos",
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: scheme.onSurface,
                        child: Icon(Icons.shopping_bag, color: scheme.surface),
                      ),
                      title: Text("Catálogo de Produtos"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        context.goNamed(ProductRouter.product.name);
                      },
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 12)),
              Card(
                color: scheme.surface,
                margin: EdgeInsets.all(2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: scheme.outline,
                    width: 2
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          "Clientes",
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: scheme.onSurface,
                        child: Icon(Icons.group, color: scheme.surface),
                      ),
                      title: Text("Lista de Clientes"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        context.goNamed(CustomerRouter.customer.name);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
    );
  }

  Widget _skeleton() {
    return Skeletonizer(
      enabled: true,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.person, size: 38),
            title: Bone.text(width: 300),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Bone.text(width: 300, fontSize: 15),
                SizedBox(height: 4),
                Bone.text(width: 80, fontSize: 15),
                SizedBox(height: 4),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward),
          ),
        ),
      )
    );
  }

}
