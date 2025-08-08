import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/providers.dart';

final syncProgressCustomerProvider = StateProvider.autoDispose<double>((ref) => 0.0);
final syncCustomerProvider = FutureProvider.autoDispose<void>((ref) async {
  final repository = await ref.read(customerRepositoryProvider.future);
  final service = await ref.read(customerServiceProvider.future);

  ref.read(syncProgressCustomerProvider.notifier).state = 0.0;
  // 1) pega total real
  final total = 5000;
  const pageSize = 100;

  // 2) itera em páginas
  for (var offset = 0; offset < total; offset += pageSize) {
    try {
      final pageIndex = offset;
      final batch = await service.getAll(
        start: pageIndex,
        limit: pageSize,
      );
      print("$offset - ${offset + pageSize} = ${batch.length}");
      if (batch.isEmpty) {
        print("Cabou");
        break;
      }
      await repository.saveAll(batch);

      // opcional: atualiza progresso
      final pct = ((offset + batch.length) / total) * 100;
      ref.read(syncProgressCustomerProvider.notifier).state = pct;
    } catch (e) {
      print(e);
    }

  }
});

final syncProgressProductsProvider = StateProvider.autoDispose<double>((ref) => 0.0);
final syncProductsProvider = FutureProvider.autoDispose<void>((ref) async {
  ref.read(syncProgressProductsProvider.notifier).state = 0.0;
  await Future.delayed(Duration(seconds: 4));
  ref.read(syncProgressProductsProvider.notifier).state = 100;
});