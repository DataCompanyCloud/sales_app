import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/order/presentation/views/order_details_page.dart';
import 'package:sales_app/src/features/order/presentation/views/order_page.dart';
import 'package:sales_app/src/features/order/presentation/views/order_create_page.dart';

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
        final fromIdStr = state.uri.queryParameters['from'];
        final fromId = fromIdStr != null ? int.tryParse(fromIdStr) : null;
        return OrderCreatePage(orderId: fromId);
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