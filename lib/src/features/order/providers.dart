import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/api_client_provider.dart';
import 'package:sales_app/src/core/providers/datasource_provider.dart';
import 'package:sales_app/src/features/order/data/repositories/order_repository_impl.dart';
import 'package:sales_app/src/features/order/data/services/order_service.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/domain/repositories/order_repository.dart';
import 'package:sales_app/src/features/order/presentation/controllers/order_controller.dart';
import 'package:sales_app/src/features/order/presentation/controllers/order_create_controller.dart';
import 'package:sales_app/src/features/order/presentation/controllers/order_details_controller.dart';

final orderRepositoryProvider = FutureProvider.autoDispose<OrderRepository>((ref) async {
  final store = await ref.watch(datasourceProvider.future);
  return OrderRepositoryImpl(store);
});

enum OrderStatusFilter {
  all,
  finished,
  notFinished,
  cancelled,
  synced,
  notSynced,
}

final orderStatusFilterProvider = StateProvider<OrderStatusFilter>((ref) => OrderStatusFilter.all);

final orderFilterProvider = StateProvider.autoDispose<OrderFilter>((ref) {
  return OrderFilter(start: 0, limit: 20);
});

final orderControllerProvider = AutoDisposeAsyncNotifierProvider<OrderController, List<Order>> (() {
  return OrderController();
});

final orderCreateControllerProvider = AutoDisposeAsyncNotifierProvider<OrderCreateController, List<Order>> (() {
  return OrderCreateController();
});


final orderDetailsControllerProvider = AsyncNotifierProvider.autoDispose.family<OrderDetailsController, Order, int>(
  OrderDetailsController.new,
);

final orderServiceProvider = FutureProvider.autoDispose<OrderService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final repository = await ref.watch(orderRepositoryProvider.future);
  return OrderService(apiClient, repository);
});