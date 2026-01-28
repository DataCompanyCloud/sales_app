import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/widgets/fade_transition.dart';
import 'package:sales_app/src/features/customer/presentation/views/create_company_customer_page.dart';
import 'package:sales_app/src/features/customer/presentation/views/create_person_customer_page.dart';
import 'package:sales_app/src/features/customer/presentation/views/customer_details.dart';
import 'package:sales_app/src/features/customer/presentation/views/customer_page.dart';

enum CustomerRouter {
  customer,
  customerDetails,
  createPersonCustomer,
  createCompanyCustomer,
  editPersonCustomer,
  editCompanyCustomer,
}

final previousTabIndexProvider = StateProvider<int>((ref) => 3);
final customerRoutes = GoRoute(
  path: '/customer',
  name: CustomerRouter.customer.name,
  pageBuilder: (ctx, state) {
    return fadePage(child: CustomerPage(), key: state.pageKey);
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
      pageBuilder: (ctx, state) {
        final customerId = state.extra as int;
        return fadePage(child: CustomerDetails(customerId: customerId), key: state.pageKey);
      },
      routes: [
        // GoRoute(
        //   path: 'edit_person_customer',
        //   name: CustomerRouter.editPersonCustomer.name,
        //   builder: (context, state) {
        //     final customerId = state.extra as int;
        //     return EditPersonCustomer(customerId: customerId);
        //   },
        // ),
        // GoRoute(
        //   path: 'edit_company_customer',
        //   name: CustomerRouter.editCompanyCustomer.name,
        //   builder: (context, state) {
        //     final customerId = state.extra as int;
        //     return EditCompanyCustomer(customerId: customerId);
        //   },
        // ),
      ]
    ),
    GoRoute(
      path: 'create_person_customer',
      name: CustomerRouter.createPersonCustomer.name,
      pageBuilder: (ctx, state) {
        return fadePage(child: CreatePersonCustomerPage(), key: state.pageKey);
      },
    ),
    GoRoute(
      path: 'create_company_customer',
      name: CustomerRouter.createCompanyCustomer.name,
      pageBuilder: (ctx, state) {
        return fadePage(child: CreateCompanyCustomerPage(), key: state.pageKey);
      },
    )
  ]
);