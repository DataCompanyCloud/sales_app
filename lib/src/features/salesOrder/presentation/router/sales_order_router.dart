import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/core/router/widgets/fade_transition.dart';
import 'package:sales_app/src/features/salesOrder/domain/repositories/sales_order_repository.dart';
import 'package:sales_app/src/features/salesOrder/domain/valueObjects/sales_order_status.dart';
import 'package:sales_app/src/features/salesOrder/presentation/controllers/sales_order_controller.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_order_details_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_order_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_order_create_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_order_products_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_orders_draft_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/sales_orders_history_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/select_customer_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/select_products_page.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

enum SalesOrderRouter {
  list,
  details,
  create,
  drafts,
  select_customer,
  select_products,
  products_details,
  history,
}

final orderRoutes = GoRoute(
  path: '/sales-order',
  name: SalesOrderRouter.list.name,
  pageBuilder: (ctx, state) {
    return fadePage(child: SalesOrderPage(), key: state.pageKey);
  },
  routes: [
    GoRoute(
      path: 'create', // /orders/create
      name: SalesOrderRouter.create.name,
      pageBuilder: (ctx, state) {
        // ?orderId=123
        final orderIdStr = state.uri.queryParameters['orderId'];
        final orderId = orderIdStr != null ? int.tryParse(orderIdStr) : null;

        return fadePage(child: SalesOrderCreatePage(orderId: orderId), key: state.pageKey);
      },
      routes: [
        GoRoute(
          path: 'select-customer',
          name: SalesOrderRouter.select_customer.name,
          pageBuilder: (ctx, state) {
            final customerIdStr = state.uri.queryParameters['customerId'];
            final customerId = customerIdStr != null ? int.tryParse(customerIdStr) : null;
            return fadePage(child: SelectCustomerPage(customerId: customerId), key: state.pageKey);
          }
        ),
        GoRoute(
          path: 'order-products-details',
          name: SalesOrderRouter.products_details.name,
          pageBuilder: (ctx, state) {
            // ?orderId=123
            final orderIdStr = state.uri.queryParameters['orderId'];
            final orderId = orderIdStr != null ? int.tryParse(orderIdStr) : null;

            return fadePage(child: SalesOrderProductsPage(orderId: orderId), key: state.pageKey);
          },
          routes: [
            GoRoute(
              path: 'select-products',
              name: SalesOrderRouter.select_products.name,
              pageBuilder: (ctx, state) {
                return fadePage(child: SelectProductsPage(), key: state.pageKey);
              }
            ),
          ]
        ),
      ]
    ),
    GoRoute(
      path: 'sales-orders-history',
      name: SalesOrderRouter.history.name,
      pageBuilder: (ctx, state) {
        return fadePage(child: SalesOrdersHistoryPage(), key: state.pageKey);
      }
    ),
    GoRoute(
      path: 'drafts',
      name: SalesOrderRouter.drafts.name,
        pageBuilder: (ctx, state) {
          const filter = SalesOrderFilter(
            start: 0,
            limit: 50,
            status: SalesOrderStatus.draft,
            onlyPendingSync: true,
            direction: SortDirection.desc,
            orderBy: SalesOrderSortField.createdAt
          );

          return fadePage(
            child: ProviderScope(
              overrides: [
                salesOrderFilterProvider.overrideWith((ref) => filter),
                salesOrderControllerProvider.overrideWith(SalesOrderController.new),
              ],
              child: SalesOrdersDraftPage(),
            ),
            key: state.pageKey
          );
        }
    ),
    GoRoute(
      path: ':orderId', // /orders/:orderId
      name: SalesOrderRouter.details.name,
      pageBuilder: (ctx, state) {
        final idStr = state.pathParameters['orderId'];
        final orderId = int.tryParse(idStr ?? '');

        if (orderId == null) {
           return fadePage(
             child: Scaffold(
               body: Center(child: Text('Order inválida')),
             ),
             key: state.pageKey
           );
        }

        return fadePage(child: SalesOrderDetailsPage(orderId: orderId), key: state.pageKey);
      },
    ),
  ]
);