import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/home/presentation/views/home_page.dart';
import 'package:sales_app/src/features/product/presentation/views/product_stock_page.dart';

enum HomeRouter {
  home,
  productStock,
}

final homeRoutes = GoRoute(
  path: '/home',
  name: HomeRouter.home.name,
  builder: (context, state) {
    return HomePage(title: "Início");
  },
  routes: [
    GoRoute(
      path: 'product_stock_page',
      name: HomeRouter.productStock.name,
      builder: (context, state) {
        return ProductStockPage();
      }
    )
  ]
  /*
  pageBuilder: (context, state) {
    final ref = ProviderScope.containerOf(context);
    final currentIndex = 2;
    final previousIndex = ref.read(homeIndexProvider);

    final beginOffSet = previousIndex > currentIndex
      ? Offset(-1, 0)
      : Offset(1, 0);

    return CustomTransitionPage(
      key: state.pageKey,
      child: HomePage(title: "Início"),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        final tween = Tween(begin: beginOffSet, end: Offset.zero).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 600),
    );
  }
  */
);