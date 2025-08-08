import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerController extends AutoDisposeAsyncNotifier<List<Customer>>{

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da API
  @override
  FutureOr<List<Customer>> build() async {
    final search = ref.watch(customerSearchProvider);
    final repository = await ref.read(customerRepositoryProvider.future);
    state = AsyncLoading();
    // Tenta sincronizar com a API (se possível)
    try {
      final service = await ref.read(customerServiceProvider.future);
      final newCustomers = await service.getAll(search: search);

      if (newCustomers.isNotEmpty) {
        await repository.saveAll(newCustomers); // Atualiza cache local
      }
    } catch (e) {
      print(e);
    }

    // Sempre retorna a lista do banco local (fonte da verdade)
    return await repository.fetchAll(search: search);
  }


  Future<void> createCustomer(Customer customer) async {
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(customerRepositoryProvider.future);
      var newCustomer = customer;

      try {
        final service = await ref.read(customerServiceProvider.future);
        final serverId = await service.putCustomer(customer);
        newCustomer = customer.copyWith(serverId: serverId);
      } catch (e, st) {
        print(e);
      }

      await repository.save(newCustomer);
      return repository.fetchAll();
    });
  }
}