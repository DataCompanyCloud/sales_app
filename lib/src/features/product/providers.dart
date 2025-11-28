import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/api_client_provider.dart';
import 'package:sales_app/src/core/providers/datasource_provider.dart';
import 'package:sales_app/src/features/product/data/repositories/product_repository_impl.dart';
import 'package:sales_app/src/features/product/data/services/product_service.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';
import 'package:sales_app/src/features/product/presentation/controllers/product_cart_controller.dart';
import 'package:sales_app/src/features/product/presentation/controllers/product_controller.dart';
import 'package:sales_app/src/features/product/presentation/controllers/product_details_controller.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order_product.dart';

final productRepositoryProvider = FutureProvider.autoDispose<ProductRepository>((ref) async {
  final store = await ref.watch(datasourceProvider.future);
  return ProductRepositoryImpl(store);
});

final productSearchProvider = StateProvider.autoDispose<ProductFilter>((ref) {
  return ProductFilter();
});

final productControllerProvider = AutoDisposeAsyncNotifierProvider<ProductController, List<Product>> (() {
  return ProductController();
});

final productDetailsControllerProvider = AsyncNotifierProvider.autoDispose.family<ProductDetailsController, Product, int>(
  ProductDetailsController.new,
);

final productServiceProvider = FutureProvider.autoDispose<ProductService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  return ProductService(apiClient);
});

final productCartControllerProvider = NotifierProvider<ProductCartController, Map<int, SalesOrderProduct>>(
  ProductCartController.new,
);