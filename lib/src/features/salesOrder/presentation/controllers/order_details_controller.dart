import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/salesOrder/domain/entities/order.dart';
import 'package:sales_app/src/features/salesOrder/providers.dart';

class OrderDetailsController extends AutoDisposeFamilyAsyncNotifier<Order, int>{
  @override
  FutureOr<Order> build(int orderId) async {
    state = AsyncLoading();
    final service = await ref.watch(orderServiceProvider.future);
    final repository = await ref.watch(orderRepositoryProvider.future);

    try {
      final remote = await service.getById(orderId);
      await repository.save(remote);
      // return remote;
    } catch (e) {
      print(e);
    }

    return await repository.fetchById(orderId);
  }
}