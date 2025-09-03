import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/orderList/presentation/views/order_details_page.dart';
import 'package:sales_app/src/features/orderList/presentation/views/order_list_page.dart';

enum OrderListRouter {
  order_list,
  order_details
}

final orderListRoutes = GoRoute(
  path: '/order_list',
  name: OrderListRouter.order_list.name,
  builder: (context, state) {
    return OrderListPage();
  },
  routes: [
    GoRoute(
      path: 'order_details',
      name: OrderListRouter.order_details.name,
      builder: (context, state) {
        return OrderDetailsPage();
      }
    )
  ]
);