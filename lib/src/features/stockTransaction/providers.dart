import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/api_client_provider.dart';
import 'package:sales_app/src/core/providers/datasource_provider.dart';
import 'package:sales_app/src/features/stockTransaction/data/repositories/transaction_repository_impl.dart';
import 'package:sales_app/src/features/stockTransaction/data/services/transaction_service.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction.dart';
import 'package:sales_app/src/features/stockTransaction/domain/repositories/transaction_repository.dart';
import 'package:sales_app/src/features/stockTransaction/presentation/controllers/transaction_controller.dart';

final transactionRepositoryProvider = FutureProvider.autoDispose<TransactionRepository>((ref) async {
  final store = await ref.watch(datasourceProvider.future);
  return TransactionRepositoryImpl(store);
});

final transactionControllerProvider = AutoDisposeAsyncNotifierProvider<TransactionController, List<StockTransaction>> (() {
  return TransactionController();
});

final transactionServiceProvider = FutureProvider.autoDispose<TransactionService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final repository = await ref.watch(transactionRepositoryProvider.future);
  return TransactionService(apiClient, repository);
});

// final transactionControllerProvider = AutoDisposeAsyncNotifierProvider<TransactionController, List<StockTransaction>>(
//   TransactionController.new,
// );