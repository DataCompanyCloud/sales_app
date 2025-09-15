import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/order/presentation/views/order_page.dart';

enum OrderRouter {
  order
}

final orderRoutes = GoRoute(
  path: '/order',
  name: OrderRouter.order.name,
  builder: (context, state) {
    return OrderPage();
  }
);