import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/sales_order.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class SalesOrderDetailsController extends AutoDisposeFamilyAsyncNotifier<SalesOrder, String>{
  @override
  FutureOr<SalesOrder> build(String uuid) async {
    state = AsyncLoading();
    final service = await ref.watch(salesOrderServiceProvider.future);
    final repository = await ref.watch(salesOrderRepositoryProvider.future);

    try {
      final remote = await service.getByUuId(uuid);
      await repository.save(remote);
      // return remote;
    } catch (e) {
      // print(e);
    }

    return await repository.fetchByUuId(uuid);
  }
}