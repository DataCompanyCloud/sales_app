import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/domain/entities/company_customer.dart';
import 'package:sales_app/src/features/customer/domain/entities/person_customer.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_controller.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_providers.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/company_customer_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/person_customer_card.dart';
import 'package:sales_app/src/features/home/presentation/router/home_router.dart';
import 'package:sales_app/src/features/home/presentation/widgets/navigator/navigator_bar.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0081F5),
        foregroundColor: Colors.white,
        title: Text(title),
        leading: IconButton(
          onPressed: () {
            context.goNamed(HomeRouter.home.name);
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 22)
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.filter_alt)
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 2),
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
                          backgroundColor: viewModelProvider.currentFilter == CustomerFilter.all
                            ? colorScheme.onTertiary
                            : colorScheme.tertiary,
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
                                ? colorScheme.onSurface
                                : Colors.grey
                            ),
                          )
                      ),
                      FilledButton(
                        onPressed: () {
                          viewModelProvider.changeFilter(CustomerFilter.active);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: viewModelProvider.currentFilter == CustomerFilter.active
                            ? colorScheme.onTertiary
                            : colorScheme.tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)
                          )
                        ),
                        child: Text(
                          "Ativos",
                          style: TextStyle(
                            color: viewModelProvider.currentFilter == CustomerFilter.active
                              ? colorScheme.onSurface
                              : Colors.grey,
                          ),
                        )
                      ),
                      FilledButton(
                        onPressed: () {
                          viewModelProvider.changeFilter(CustomerFilter.inactive);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: viewModelProvider.currentFilter == CustomerFilter.inactive
                            ? colorScheme.onTertiary
                            : colorScheme.tertiary,
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
                              ? colorScheme.onSurface
                              : Colors.grey,
                          ),
                        )
                      ),
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
          context.pushNamed(CustomerRouter.createCustomer.name);
        },
        child: Icon(Icons.group_add),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: currentIndex),
    );
  }
}