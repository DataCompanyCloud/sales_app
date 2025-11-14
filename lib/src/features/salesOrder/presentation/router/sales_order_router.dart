import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/salesOrder/domain/repositories/sales_order_repository.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/sales_order_status.dart';
import 'package:sales_app/src/features/salesOrder/presentation/controllers/sales_order_controller.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_order_details_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_order_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_order_create_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_orders_draft_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/select_customer_page.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

enum OrderRouter {
  list,
  details,
  create,
  drafts,
  select_customer
}

final orderRoutes = GoRoute(
  path: '/sales-order',
  name: OrderRouter.list.name,
  builder: (context, state) {
    return SalesOrderPage();

  },
  routes: [
    GoRoute(
      path: 'create', // /orders/create
      name: OrderRouter.create.name,
      builder: (context, state) {
        // ?orderId=123
        final orderIdStr = state.uri.queryParameters['orderId'];
        final orderId = orderIdStr != null ? int.tryParse(orderIdStr) : null;

        return SalesOrderCreatePage(
          orderId: orderId,
        );
      },
      routes: [
        GoRoute(
          path: 'select-customer',
          name: OrderRouter.select_customer.name,
          builder: (context, state) {
            final customerIdStr = state.uri.queryParameters['customerId'];
            final customerId = customerIdStr != null ? int.tryParse(customerIdStr) : null;
            return  SelectCustomerPage(customerId: customerId);
          }
        ),
      ]
    ),
    GoRoute(
      path: 'drafts',
      name: OrderRouter.drafts.name,
        builder: (context, state) {

          const filter = SalesOrderFilter(
            start: 0,
            limit: 50,
            status: SalesOrderStatus.draft,
          );

          return ProviderScope(
            overrides: [
              salesOrderFilterProvider.overrideWith((ref) => filter),
              salesOrderControllerProvider.overrideWith(SalesOrderController.new),
            ],
            child: SalesOrdersDraftPage(),
          );
        }
    ),
    GoRoute(
      path: ':orderId', // /orders/:orderId
      name: OrderRouter.details.name,
      builder: (context, state) {
        final idStr = state.pathParameters['orderId'];
        final orderId = int.tryParse(idStr ?? '');

        if (orderId == null) {
          return  Scaffold(
            body: Center(child: Text('Order inválida')),
          );
        }

        return SalesOrderDetailsPage(orderId: orderId);
      },
    ),
  ]
);