import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction.dart';

class StorageTransactionController extends AutoDisposeFamilyAsyncNotifier<List<StockTransaction>, int>{
  @override
  FutureOr<List<StockTransaction>> build(int storageId) async {
    state = AsyncLoading();
    // final service = await ref.watch(orderServiceProvider.future);
    // final repository = await ref.watch(orderRepositoryProvider.future);

    try {
      // final remote = await service.getById(orderId);
      // await repository.save(remote);
      // return remote;
    } catch (e) {
      // print(e);
    }

    // return await repository.fetchById(orderId);
    // /storage/1/stock-transaction
    return [];
  }
}