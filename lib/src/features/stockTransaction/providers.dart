// final transactionRepositoryProvider = FutureProvider.autoDispose<TransactionRepository>((ref) async {
//   final store = await ref.watch(datasourceProvider.future);
//   return TransactionRepositoryImpl(store);
// });
//
// final transactionControllerProvider = AutoDisposeAsyncNotifierProvider<TransactionController, List<StockTransaction>> (() {
//   return TransactionController();
// });
//
// final transactionServiceProvider = FutureProvider.autoDispose<TransactionService>((ref) async {
//   final apiClient = ref.watch(apiClientProvider);
//   final repository = await ref.watch(transactionRepositoryProvider.future);
//   return TransactionService(apiClient, repository);
// });
//
// final transactionControllerProvider = AutoDisposeAsyncNotifierProvider<TransactionController, List<StockTransaction>>(
//   TransactionController.new,
// );