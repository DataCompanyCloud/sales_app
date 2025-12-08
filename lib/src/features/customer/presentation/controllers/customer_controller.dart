import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerController extends AutoDisposeAsyncNotifier<List<Customer>>{

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da API
  @override
  FutureOr<List<Customer>> build() async {
    final filter = ref.watch(customerFilterProvider);
    final repository = await ref.read(customerRepositoryProvider.future);
    state = AsyncLoading();

    final isConnected = ref.read(isConnectedProvider);
    print(isConnected);
    if (isConnected) {
      try {
        final service = await ref.read(customerServiceProvider.future);
        final newCustomers = await service.getAll(filter);

        if (newCustomers.isNotEmpty) {
          await repository.saveAll(newCustomers);
        }
      } catch (e) {
        print('Erro ao sincronizar clientes: $e');
      }
    }

    // Sempre retorna a lista do banco local (fonte da verdade)
    return await repository.fetchAll(filter);
  }


  Future<void> createCustomer(Customer customer) async {
    state = await AsyncValue.guard(() async {
      final filter = ref.watch(customerFilterProvider);
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
      return repository.fetchAll(filter);
    });
  }
}