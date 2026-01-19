import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/salesOrder/presentation/controllers/valueObjects/sales_orders_pagination.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrderController extends AutoDisposeAsyncNotifier<SalesOrdersPagination>{

  @override
  FutureOr<SalesOrdersPagination> build() async {
    final filter = ref.watch(salesOrderFilterProvider);
    final repository = await ref.read(salesOrderRepositoryProvider.future);

    var total = await repository.count();

    final isConnected = ref.read(isConnectedProvider);
    if (isConnected) {
      try {
        final service = await ref.read(salesOrderServiceProvider.future);
        final pagination = await service.getAll(filter: filter);
        total = pagination.total;
        final orders = pagination.items;

        if (orders.isNotEmpty) {
          await repository.saveAll(orders);
        }
      } catch (e) {
        // print(e);
      }
    }

    final orders = await repository.fetchAll(filter);
    return SalesOrdersPagination(
      total: total,
      items: orders,
      isLoadingMore: false
    );
  }
  
}