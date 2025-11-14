import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/order_details_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/order_page.dart';
import 'package:sales_app/src/features/salesOrder/presentation/views/order_create_page.dart';

enum OrderRouter {
  list,
  details,
  create
}

final orderRoutes = GoRoute(
  path: '/orders',
  name: OrderRouter.list.name,
  builder: (context, state) {
    return OrderPage();

  },
  routes: [
    GoRoute(
      path: 'create', // /orders/create
      name: OrderRouter.create.name,
      builder: (context, state) {
        // ?showOrders=true ou ?showOrders=false
        final showOrdersStr = state.uri.queryParameters['showOrders'];
        final showOrders = showOrdersStr == 'true';

        // ?orderId=123
        final orderIdStr = state.uri.queryParameters['orderId'];
        final orderId = orderIdStr != null ? int.tryParse(orderIdStr) : null;

        return OrderCreatePage(
          orderId: orderId,
          showOrders: showOrders,
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

        return OrderDetailsPage(orderId: orderId);
      },
    ),
  ]
);