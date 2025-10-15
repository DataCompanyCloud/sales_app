import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/error/presentation/views/error_page.dart';
import 'package:sales_app/src/features/home/presentation/controllers/home_providers.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/draggable/draggable_company_selector.dart';
import 'package:sales_app/src/features/home/presentation/widgets/drawers/home_drawer.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';
import 'package:sales_app/src/features/order/presentation/router/order_router.dart';

class HomePage extends ConsumerWidget {
  final String title;

  const HomePage ({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(authControllerProvider);
    final currentIndex = ref.watch(homeIndexProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
      ),
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(
              child: Text("Usuário nulo")
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            title: Text(title),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.crisis_alert)
              ),
            ],
          ),
          drawer: HomeDrawer(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      side: BorderSide(
                        color: scheme.secondary,
                        width: 1
                      )
                    ),
                    color: scheme.surface,
                    margin: EdgeInsets.all(2),
                    child: ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.factory, color: Colors.black87),
                      ),
                      title: Text("Empregador: ${user.company.first.tradeName}"),
                      subtitle: Text("CNPJ: ${user.company.first.cnpj.formatted}"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => DraggableCompanySelector()
                        );
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 16)),
                  Card(
                    color: scheme.surface,
                    elevation: 3,
                    margin: EdgeInsets.all(2),
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
                            context.goNamed(OrderRouter.order_list.name);
                          },
                        ),
                        ListTile(
                          visualDensity: VisualDensity(vertical: 3),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            child: Icon(Icons.history, color: Colors.black87),
                          ),
                          title: Text("Histórico de Cliente"),
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
                    elevation: 3,
                    margin: EdgeInsets.all(2),
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
                            child: Icon(Icons.archive_outlined, color: Colors.black87),
                          ),
                          title: Text("Produtos"),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            context.goNamed(HomeRouter.storagePage.name);
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
    );
  }
}