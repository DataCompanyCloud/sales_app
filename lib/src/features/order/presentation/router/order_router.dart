import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/order/presentation/views/order_page.dart';

enum OrderRouter {
  order,
  create,
  invoicing,
  finish,
}

final orderRoutes = GoRoute(
  path: '/order',
  name: OrderRouter.order.name,
  builder: (context, state) {
    return OrderPage(title: "Pedidos");
  }
  /*
  pageBuilder: (context, state) {
    final ref = ProviderScope.containerOf(context);
    final currentIndex = 1;
    final previousIndex = ref.read(previousTabIndexProvider);

    final beginOffSet = previousIndex > currentIndex
      ? Offset(-1, 0)
      : Offset(-1, 0);

    return CustomTransitionPage(
      key: state.pageKey,
      child: OrderPage(title: "Pedidos"),
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
);