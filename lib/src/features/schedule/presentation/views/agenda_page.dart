import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/schedule/presentation/controllers/agenda_providers.dart';

class AgendaPage extends ConsumerWidget {
  final String title;

  const AgendaPage ({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(agendaIndexProvider);
    // final viewModelProvider = ref.watch(agendaViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text(title),
        leading: IconButton(
            onPressed: () {
              context.go('/home');
            },
            icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.notifications)
          ),
        ],
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
            selectedItemColor: Color(0xFF003251),
            backgroundColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: (index) {
              ref.read(agendaIndexProvider.notifier).state = 4;
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
                  icon: Icon(Icons.home_filled, size: 28),
                  label: "Home"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person, size: 28),
                  label: "Customers"
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
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 32,
                        ),
                      )
                    ],
                  ),
                ),
                label: "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}