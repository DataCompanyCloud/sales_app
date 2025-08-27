import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/auth/providers.dart';
import 'package:sales_app/src/features/error/presentation/router/error_router.dart';
import 'package:sales_app/src/features/home/presentation/controllers/home_providers.dart';
import 'package:sales_app/src/features/home/presentation/widgets/dialogs/change_company_dialog.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';

class HomePage extends ConsumerWidget {
  final String title;

  const HomePage ({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            icon: Icon(Icons.crisis_alert)
          ),
        ],
      ),
      drawer: Container(
        width: 322,
        height: double.infinity,
        color: scheme.surface,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        )
                      )
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "nomeDeUsuário",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "emailDeUsuário",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Serviços".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white70
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(left: 24),
                    child: Divider(
                      color: Colors.white24,
                      height: 8,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: Icon(
                    Icons.chat,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                title: Text(
                  "FAQ",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(left: 24),
                    child: Divider(
                      color: Colors.white24,
                      height: 8,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                title: Text(
                  "Configurações",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Conta".toUpperCase(),
                  style: TextStyle(
                      color: Colors.white70
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(left: 24),
                    child: Divider(
                      color: Colors.white24,
                      height: 8,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: Icon(
                    Icons.account_circle_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                title: Text(
                  "Alterar conta",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {},
              ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(left: 24),
                    child: Divider(
                      color: Colors.white24,
                      height: 8,
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                onTap: () {
                  ref.read(authControllerProvider.notifier).logout();
                },
                title: Text(
                  "Sair",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ]
          )
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              /// TODO: Melhorar isso
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
                  title: Text("Empregador: Empresa A"),
                  subtitle: Text("CNPJ: 12.345.678/0000-01"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ChangeCompanyDialog()
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
                          "Informações de Pedido",
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
                      onTap: () {},
                    ),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.analytics_outlined, color: Colors.black87),
                      ),
                      title: Text("Detalhes de Pedido"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        context.pushNamed(
                          ErrorRouter.error.name,
                          extra: AppException.errorUnexpected("Algo deu errado"),
                        );
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
                elevation: 3,
                margin: EdgeInsets.all(2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          "Informações dos Clientes",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )
                    ),
                    Padding(padding: EdgeInsets.only(top: 12)),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.group_outlined, color: Colors.black87),
                      ),
                      title: Text("Qtd. Clientes"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.star_outline, color: Colors.black87),
                      ),
                      title: Text("Clientes Favoritos"),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    ListTile(
                      visualDensity: VisualDensity(vertical: 3),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: Icon(Icons.data_saver_on_outlined, color: Colors.black87),
                      ),
                      title: Text("Clientes DataCompany"),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
    );
  }
}