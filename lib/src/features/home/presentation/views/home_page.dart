import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/home/presentation/controllers/home_providers.dart';

class HomePage extends ConsumerWidget {
  final String title;

  const HomePage ({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeIndexProvider);
    // final viewModelProvider = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.notifications)
          ),
        ],
      ),
      drawer: Container(
          width: 322,
          height: double.infinity,
          color: Color(0xFF17203A),
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
                          Icons.home_filled,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        "Início",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {

                      },
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
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        "Pesquisa",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {

                      },
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
                      onTap: () {

                      },
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
                      onTap: () {

                      },
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
                      onTap: () {

                      },
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
                      title: Text(
                        "Sair",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        context.goNamed(AppRoutes.login.name);
                      },
                    ),
                  ]
              )
          )
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              color: Colors.white,
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
                        "Meu Aplicativo",
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

                    },
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
                      context.push('/home/order_details');
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
                    onTap: () {

                    },
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: 3),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      child: Icon(Icons.support_agent_outlined, color: Colors.black87),
                    ),
                    title: Text("Suporte"),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {

                    },
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 12)),
            Card(
              color: Colors.white,
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
                          "Informações",
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
                      child: Icon(Icons.search, color: Colors.black87),
                    ),
                    title: Text("Pesquisa"),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: 3),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      child: Icon(Icons.star_border_outlined, color: Colors.black87),
                    ),
                    title: Text("Favoritos"),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {

                    },
                  ),
                  ListTile(
                    visualDensity: VisualDensity(vertical: 3),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      child: Icon(Icons.cookie_outlined, color: Colors.black87),
                    ),
                    title: Text("Cookies"),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 10
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            selectedItemColor: Color(0xFF0081F5),
            backgroundColor: Colors.white,
            showUnselectedLabels: false,
            onTap: (index) {
              ref.read(homeIndexProvider.notifier).state = 2;
              switch(index) {
                case 0:
                  context.goNamed(AppRoutes.product.name);
                  break;
                case 1:
                  context.goNamed(AppRoutes.order.name);
                  break;
                case 2:
                  context.goNamed(AppRoutes.home.name);
                  break;
                case 3:
                  context.goNamed(AppRoutes.customer.name);
                  break;
                case 4:
                  context.goNamed(AppRoutes.schedule.name);
              }
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag, size: 28),
                  label: "Product List"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle, size: 28),
                  label: "Create Order"
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF0081F5),
                        child: Icon(
                          Icons.home_filled,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    ],
                  ),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: 28),
                  label: "Customers"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month, size: 28),
                  label: "Agenda"
              ),
            ],
          ),
        ),
      ),
    );
  }
}