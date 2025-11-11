import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/order/domain/entities/order.dart';
import 'package:sales_app/src/features/order/providers.dart';

class OrderController extends AutoDisposeAsyncNotifier<List<Order>>{

  @override
  FutureOr<List<Order>> build() async {
    final filter = ref.watch(orderFilterProvider);
    final repository = await ref.read(orderRepositoryProvider.future);
    state = AsyncLoading();

    try {
      final service = await ref.watch(orderServiceProvider.future);
      final newOrders = await service.getAll(filter: filter);

      if (newOrders.isNotEmpty) {
        await repository.saveAll(newOrders);
      }
    } catch (e) {
      print(e);
    }

    return await repository.fetchAll(filter);
  }

}