import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrderDetailsController extends AutoDisposeFamilyAsyncNotifier<SalesOrder, int>{
  @override
  FutureOr<SalesOrder> build(int orderId) async {
    state = AsyncLoading();
    final service = await ref.watch(salesOrderServiceProvider.future);
    final repository = await ref.watch(salesOrderRepositoryProvider.future);

    try {
      final remote = await service.getById(orderId);
      await repository.save(remote);
      // return remote;
    } catch (e) {
      // print(e);
    }

    return await repository.fetchById(orderId);
  }
}