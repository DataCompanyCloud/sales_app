import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/customer/presentation/views/create_company_customer_page.dart';
import 'package:sales_app/src/features/customer/presentation/views/create_customer_page.dart';
import 'package:sales_app/src/features/customer/presentation/views/create_person_customer_page.dart';
import 'package:sales_app/src/features/customer/presentation/views/customer_details.dart';
import 'package:sales_app/src/features/customer/presentation/views/customer_page.dart';
import 'package:sales_app/src/features/customer/presentation/views/insert_customer_cnpj.dart';

enum CustomerRouter {
  customer,
  customerDetails,
  createCustomer,
  createPersonCustomer,
  createCompanyCustomer,
  insertCustomerCnpj
}

final previousTabIndexProvider = StateProvider<int>((ref) => 3);
final customerRoutes = GoRoute(
  path: '/customer',
  name: CustomerRouter.customer.name,
  builder: (context, state) {
    return CustomerPage();
  },
  /*
  pageBuilder: (context, state) {
    final ref = ProviderScope.containerOf(context);
    final currentIndex = 3;
    final previousIndex = ref.read(previousTabIndexProvider);

    final beginOffSet = previousIndex > currentIndex
      ? Offset(-1, 0)
      : Offset(1, 0);

    return CustomTransitionPage(
      key: state.pageKey,
      child: CustomerPage(title: "Clientes"),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        final tween = Tween(begin: beginOffSet, end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 600),
    );
  },
  */
  routes: [
    GoRoute(
      path: 'customer_details',
      name: CustomerRouter.customerDetails.name,
      builder: (context, state) {
        final customerId = state.extra as int;
        return CustomerDetails(customerId: customerId);
      }
    ),
    GoRoute(
      path: 'create_customer',
      name: CustomerRouter.createCustomer.name,
      builder: (context, state) {
        return CreateCustomer();
      },
      routes: [
        GoRoute(
          path: 'create_person_customer',
          name: CustomerRouter.createPersonCustomer.name,
          builder: (context, state) {
            return CreatePersonCustomerPage();
          },
        ),
        GoRoute(
          path: 'insert_customer_cnpj',
          name: CustomerRouter.insertCustomerCnpj.name,
          builder: (context, state) {
            return InsertCustomerCnpj();
          },
          routes: [
            GoRoute(
              path: 'create_company_customer',
              name: CustomerRouter.createCompanyCustomer.name,
              builder: (context, state) {
                return CreateCompanyCustomerPage();
              },
            )
          ]
        ),
      ]
    ),
  ]
);