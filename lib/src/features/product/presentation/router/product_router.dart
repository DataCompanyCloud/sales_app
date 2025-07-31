import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/presentation/views/product_details.dart';
import 'package:sales_app/src/features/product/presentation/views/product_page.dart';

enum ProductRouter {
  product,
  productDetails,
}

final previousTabIndexProvider = StateProvider<int>((ref) => 0);
final productRoutes =  GoRoute(
  path: '/product',
  name: ProductRouter.product.name,
  builder: (context, state) {
    return ProductPage(title: "Catálogo de Produtos");
  },
  /*
  pageBuilder: (context, state) {
    final ref = ProviderScope.containerOf(context);
    final currentIndex = 0;
    final previousIndex = ref.read(previousTabIndexProvider);

    final beginOffSet = previousIndex > currentIndex
      ? Offset(-1, 0)
      : Offset(1, 0);

    return CustomTransitionPage(
      key: state.pageKey,
      child: ProductPage(title: "Produtos"),
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
  routes: [
    GoRoute(
      path: 'product_details',
      name: ProductRouter.productDetails.name,
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetails(title: product.code, products: product);
      },
    ),
  ]
);