import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_providers.dart';
import 'package:sales_app/src/features/customer/presentation/router/customer_router.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/company_customer_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/cards/person_customer_card.dart';
import 'package:sales_app/src/features/customer/presentation/widgets/skeleton/customer_page_skeleton.dart';
import 'package:sales_app/src/features/customer/providers.dart';
import 'package:sales_app/src/features/error_page/presentation/views/error_page.dart';
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
    // final viewModelProvider = ref.watch(customerViewModelProvider);
    final controller = ref.watch(customerControllerProvider);

    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return controller.when(
      error: (error, stack) => ErrorPage(
        exception: error is AppException
          ? error
          : AppException.errorUnexpected(error.toString()),
      ),
      loading: () =>  CustomerPageSkeleton(),
      data: (customers) {
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
              Row(
                children: [
                  IconButton(
                    onPressed: () {

                    },
                    icon: Icon(Icons.rss_feed)
                  ),
                  IconButton(
                    onPressed: () {

                    },
                    icon: Icon(Icons.filter_alt),
                  ),
                ],
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
                                // viewModelProvider.changeFilter(CustomerFilter.all);
                              },
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: viewModelProvider.currentFilter == CustomerFilter.all
                                //     ? colorScheme.onTertiary
                                //     : colorScheme.tertiary,
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
                                  // color: viewModelProvider.currentFilter == CustomerFilter.all
                                  //     ? colorScheme.onSurface
                                  //     : Colors.grey
                                ),
                              )
                          ),
                          FilledButton(
                              onPressed: () {
                                // viewModelProvider.changeFilter(CustomerFilter.active);
                              },
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: viewModelProvider.currentFilter == CustomerFilter.active
                                //     ? colorScheme.onTertiary
                                //     : colorScheme.tertiary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)
                                  )
                              ),
                              child: Text(
                                "Ativos",
                                style: TextStyle(
                                  // color: viewModelProvider.currentFilter == CustomerFilter.active
                                  //   ? colorScheme.onSurface
                                  //   : Colors.grey,
                                ),
                              )
                          ),
                          FilledButton(
                              onPressed: () {
                                // viewModelProvider.changeFilter(CustomerFilter.inactive);
                              },
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: viewModelProvider.currentFilter == CustomerFilter.inactive
                                //     ? colorScheme.onTertiary
                                //     : colorScheme.tertiary,
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
                                  // color: viewModelProvider.currentFilter == CustomerFilter.inactive
                                  //     ? colorScheme.onSurface
                                  //     : Colors.grey,
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
                    return customer.maybeMap(
                      person: (person) => InkWell(
                        onTap: () => context.pushNamed(CustomerRouter.customerDetails.name, extra: customer.customerId),
                        child: PersonCustomerCard(customer: person)
                      ),
                      company: (company) => InkWell(
                        onTap: () => context.pushNamed(CustomerRouter.customerDetails.name, extra: customer.customerId),
                        child: CompanyCustomerCard(customer: company)
                      ),
                      orElse: () => SizedBox()
                    );
                  }
                )
              )
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
    );
  }
}