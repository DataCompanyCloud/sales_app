import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/app_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/company_customer.dart';
import 'package:sales_app/src/features/customer/domain/entities/person_customer.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_controller.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_providers.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/company_customer_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/person_customer_card.dart';

class CustomerPage extends ConsumerWidget {
  final String title;

  const CustomerPage ({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(customerIndexProvider);
    final viewModelProvider = ref.watch(customerViewModelProvider);
    final customers = viewModelProvider.filteredCustomers;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      FilledButton(
                          onPressed: () {
                            viewModelProvider.changeFilter(CustomerFilter.all);
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300, width: 1),
                              backgroundColor: viewModelProvider.currentFilter == CustomerFilter.all
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)
                                ),
                              )
                          ),
                          child: Text(
                            "Todos",
                            style: TextStyle(
                                color: viewModelProvider.currentFilter == CustomerFilter.all
                                    ? Colors.black
                                    : Colors.black38
                            ),
                          )
                      ),
                      FilledButton(
                          onPressed: () {
                            viewModelProvider.changeFilter(CustomerFilter.active);
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300, width: 1),
                              backgroundColor: viewModelProvider.currentFilter == CustomerFilter.active
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)
                              )
                          ),
                          child: Text(
                            "Ativos",
                            style: TextStyle(
                              color: viewModelProvider.currentFilter == CustomerFilter.active
                                  ? Colors.black
                                  : Colors.black38,
                            ),
                          )
                      ),
                      FilledButton(
                          onPressed: () {
                            viewModelProvider.changeFilter(CustomerFilter.inactive);
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300, width: 1),
                              backgroundColor: viewModelProvider.currentFilter == CustomerFilter.inactive
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                  )
                              )
                          ),
                          child: Text(
                            "Inativos",
                            style: TextStyle(
                              color: viewModelProvider.currentFilter == CustomerFilter.inactive
                                  ? Colors.black
                                  : Colors.black38,
                            ),
                          )
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 16, left: 52, bottom: 16),
                            child: SizedBox(
                              width: 90,
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0081F5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Icon(Icons.filter_alt, color: Colors.white, size: 22)
                              ),
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    if (customer is PersonCustomer) return PersonCustomerCard(customer: customer);

                    if (customer is CompanyCustomer) return CompanyCustomerCard(customer: customer);

                    return SizedBox();
                  }
              )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        onPressed: () {
          context.push('/create_customer');
        },
        child: Icon(Icons.group_add),
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
              ref.read(customerIndexProvider.notifier).state = 3;
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
                          Icons.person,
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