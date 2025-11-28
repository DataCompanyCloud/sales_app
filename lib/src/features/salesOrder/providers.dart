import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/api_client_provider.dart';
import 'package:sales_app/src/core/providers/datasource_provider.dart';
import 'package:sales_app/src/features/salesOrder/data/repositories/sales_order_repository_impl.dart';
import 'package:sales_app/src/features/salesOrder/data/repositories/tax_repository_impl.dart';
import 'package:sales_app/src/features/salesOrder/data/services/sales_order_service.dart';
import 'package:sales_app/src/features/salesOrder/data/services/sales_order_sync_service.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/domain/repositories/sales_order_repository.dart';
import 'package:sales_app/src/features/salesOrder/presentation/controllers/sales_order_controller.dart';
import 'package:sales_app/src/features/salesOrder/presentation/controllers/sales_order_create_controller.dart';
import 'package:sales_app/src/features/salesOrder/presentation/controllers/sales_order_details_controller.dart';

final salesOrderRepositoryProvider = FutureProvider.autoDispose<SalesOrderRepository>((ref) async {
  final store = await ref.watch(datasourceProvider.future);
  return SalesOrderRepositoryImpl(store);
});

final taxRepositoryImplProvider = Provider.autoDispose<TaxRepositoryImpl>((ref) {
  return TaxRepositoryImpl();
});

enum SalesOrderStatusFilter {
  all,
  finished,
  notFinished,
  cancelled,
  synced,
  notSynced,
}

final salesOrderStatusFilterProvider = StateProvider<SalesOrderStatusFilter>((ref) => SalesOrderStatusFilter.all);

final salesOrderFilterProvider = StateProvider.autoDispose<SalesOrderFilter>((ref) {
  return SalesOrderFilter(start: 0, limit: 20);
});

final salesOrderControllerProvider = AutoDisposeAsyncNotifierProvider<SalesOrderController, List<SalesOrder>> (() {
  return SalesOrderController();
});

final salesOrderCreateControllerProvider = AsyncNotifierProvider.autoDispose.family<SalesOrderCreateController, SalesOrder?, int?>(
  SalesOrderCreateController.new,
);

final salesOrderDetailsControllerProvider = AsyncNotifierProvider.autoDispose.family<SalesOrderDetailsController, SalesOrder, int>(
  SalesOrderDetailsController.new,
);

final salesOrderServiceProvider = FutureProvider.autoDispose<SalesOrderService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final repository = await ref.watch(salesOrderRepositoryProvider.future);
  return SalesOrderService(apiClient, repository);
});


final salesOrderSyncServiceProvider = FutureProvider.autoDispose<SalesOrderSyncService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final repository = await ref.watch(salesOrderRepositoryProvider.future);
  return SalesOrderSyncService(apiClient, repository);
});