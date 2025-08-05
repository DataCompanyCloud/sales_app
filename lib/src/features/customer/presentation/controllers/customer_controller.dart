import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerController extends AsyncNotifier<List<Customer>>{

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da API
  @override
  FutureOr<List<Customer>> build() async {
    final filter = ref.watch(customerFilterProvider);
    final repository = await ref.read(customerRepositoryProvider.future);
    state = AsyncLoading();
    // Tenta sincronizar com a API (se possível)
    try {
      final service = await ref.read(customerServiceProvider.future);
      final newCustomers = await service.getAll(filter);

      if (newCustomers.isNotEmpty) {
        await repository.saveAll(newCustomers); // Atualiza cache local
      }
    } catch (e) {
      print(e);
    }

    // Sempre retorna a lista do banco local (fonte da verdade)
    return await repository.fetchAll(filter);
  }
}