import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction.dart';
import 'package:sales_app/src/features/stockTransaction/providers.dart';

class TransactionController extends AutoDisposeAsyncNotifier<List<StockTransaction>>{

  @override
  FutureOr<List<StockTransaction>> build() async {
    final repository = await ref.read(transactionRepositoryProvider.future);
    state = AsyncLoading();

    try {
      final service = await ref.watch(transactionServiceProvider.future);
      final newTransactions = await service.getAll();

      if (newTransactions.isNotEmpty) {
        await repository.saveAll(newTransactions);
      }
    } catch (e) {
      rethrow;
    }

    return await repository.fetchAll();
  }

}