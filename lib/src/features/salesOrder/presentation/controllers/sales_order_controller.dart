import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrderController extends AutoDisposeAsyncNotifier<List<SalesOrder>>{

  @override
  FutureOr<List<SalesOrder>> build() async {
    final filter = ref.watch(salesOrderFilterProvider);
    final repository = await ref.read(salesOrderRepositoryProvider.future);
    state = AsyncLoading();

    try {
      final service = await ref.watch(salesOrderServiceProvider.future);
      final newOrders = await service.getAll(filter: filter);

      if (newOrders.isNotEmpty) {
        await repository.saveAll(newOrders);
      }
    } catch (e) {
      // print(e);
    }

    return await repository.fetchAll(filter);
  }

}