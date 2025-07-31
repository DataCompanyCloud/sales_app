import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerController extends AutoDisposeAsyncNotifier<List<Customer>>{

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da API
  @override
  FutureOr<List<Customer>> build() async {
    final filter = ref.watch(customerFilterProvider);
    final repository = await ref.watch(customerRepositoryProvider.future);

    // Tenta sincronizar com a API (se possível)
    try {
      final service = await ref.watch(customerServiceProvider.future);
      final newCustomers = await service.getAll(filter);

      if (newCustomers.isNotEmpty) {
        await repository.saveAll(newCustomers); // Atualiza cache local
      }
    } catch (e) {
      print("Falha ao sincronizar com API: $e");
    }

    // 🔹 Sempre retorna a lista do banco local (fonte da verdade)
    return await repository.fetchAll(filter);
  }
}