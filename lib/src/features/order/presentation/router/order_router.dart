import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/order/presentation/views/order_details.dart';
import 'package:sales_app/src/features/order/presentation/views/order_page.dart';
import 'package:sales_app/src/features/order/presentation/views/create_order_page.dart';

enum OrderRouter {
  order,
  order_list,
  order_details
}

final orderRoutes = GoRoute(
  path: '/order',
  name: OrderRouter.order.name,
  builder: (context, state) {
    return CreateOrderPage();
  },
  routes: [
    GoRoute(
      path: 'order_list',
      name: OrderRouter.order_list.name,
      builder: (context, state) {
        return OrderPage(orders: []);
      }
    ),
    GoRoute(
      path: 'order_details',
      name: OrderRouter.order_details.name,
      builder: (context, state) {
        final orderId = state.extra as int;
        return OrderDetails(orderId: orderId);
      },
    ),
  ]
);