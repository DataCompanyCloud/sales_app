import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/company/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_screen.dart';
import 'package:sales_app/src/features/home/presentation/controllers/home_providers.dart';
import 'package:sales_app/src/features/home/presentation/widgets/draggable/draggable_company_selector.dart';
import 'package:sales_app/src/features/home/presentation/widgets/drawers/home_drawer.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(companyGroupControllerProvider);
    final currentIndex = ref.watch(homeIndexProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
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


                  // TODO Rever isso aqui
                  final group = groups.first;
                  final company = group.primaryCompany ?? group.companies.first;

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
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.factory, color: Colors.black87),
                      ),
                      title: Text(company.tradeName),
                      subtitle: Text(company.cnpj.formatted),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => DraggableCompanySelector()
                        );
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
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.format_list_bulleted, color: Colors.black87),
                      ),
                      title: Text("Lista de Pedidos"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        context.goNamed(OrderRouter.list.name);
                      },
                    ),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.history, color: Colors.black87),
                      ),
                      title: Text("Histórico de Pedido"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.support_agent_outlined, color: Colors.black87),
                      ),
                      title: Text("Suporte"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)
                        ),
                      ),
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
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.star_rounded, color: Colors.black87),
                      ),
                      title: Text("Meu Estoque"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        context.pushNamed(StorageRouter.storage_details.name);
                      },
                    ),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.warehouse, color: Colors.black87),
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
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.monetization_on, color: Colors.black87),
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