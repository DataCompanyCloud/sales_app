import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/order/presentation/controllers/order_providers.dart';

class OrderPage extends ConsumerWidget {
  final String title;

  const OrderPage({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(orderIndexProvider);
    // final viewModelProvider = ref.watch(orderViewModelProvider);

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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn-go",
            backgroundColor: Color(0xFF0081F5),
            foregroundColor: Colors.white,
            onPressed: () {
              context.push('/order/create_order');
            },
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 48, left: 28, right: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF0081F5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            Icons.person_add, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 4,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            Icons.add_business, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 4,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            Icons.attach_money_sharp, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 4,
                          color: Colors.grey.shade500,
                        ),
                      )
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            Icons.check, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(left: 12, right: 12),
                    child: Divider(
                      color: Colors.grey.shade400,
                      height: 64,
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {

                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0081F5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3
                          ),
                          child: Icon(
                            Icons.add,
                            size: 28,
                            color: Colors.white,
                          )
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: (index) {
              ref.read(orderIndexProvider.notifier).state = 1;
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
                          Icons.add_circle,
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
                  icon: Icon(Icons.home_filled, size: 28),
                  label: "Home"
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