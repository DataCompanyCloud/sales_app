import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/home/orderList/presentation/views/order_list_page.dart';

enum OrderListRouter {
  order_list
}

final orderListRoutes = GoRoute(
  path: '/order_list',
  name: OrderListRouter.order_list.name,
  builder: (context, state) {
    return OrderListPage();
  },
);