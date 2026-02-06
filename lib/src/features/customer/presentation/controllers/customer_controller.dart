import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/valueObjects/customers_pagination.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerController extends AutoDisposeAsyncNotifier<CustomersPagination>{

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da API
  @override
  FutureOr<CustomersPagination> build() async {
    final filter = ref.watch(customerFilterProvider);
    final repository = await ref.read(customerRepositoryProvider.future);

    var total = await repository.count();

    final isConnected = ref.read(isConnectedProvider);
    if (isConnected) {
      try {
        final service = await ref.read(customerServiceProvider.future);
        final pagination = await service.getAll(filter);
        total = pagination.total;
        final customers = pagination.items;

        if (customers.isNotEmpty) {
          await repository.saveAll(customers);
        }
      } catch (e) {
        print('Erro ao sincronizar clientes: $e');
      }
    }

    final customer = await repository.fetchAll(filter);
    return CustomersPagination(
      total: total,
      items: customer,
      isLoadingMore: false
    );
  }

  Future<void> loadMore() async {
    if (state.value!.isLoadingMore) return;
    state = AsyncData(state.value!.copyWith(isLoadingMore: true));
    final filter = ref.read(customerFilterProvider);
    final newFilter = filter.copyWith(
      start: state.value!.items.length,
    );

    final repository = await ref.watch(customerRepositoryProvider.future);
    final isConnected = ref.read(isConnectedProvider);

    var total = state.value?.total ?? 0;
    if (isConnected) {
      try {
        final service = await ref.read(customerServiceProvider.future);
        final pagination = await service.getAll(newFilter);
        total = pagination.total;
        final customers = pagination.items;

        if (customers.isNotEmpty) {
          await repository.saveAll(customers);
        }
      } catch (e) {
        // print(e);
      }
    }

    final items = await repository.fetchAll(newFilter);
    state = AsyncData(
      state.value!.copyWith(
        total: total,
        items: [
          ...state.value?.items ?? [],
          ...items
        ],
        isLoadingMore: false
      )
    );
  }

  Future<void> createCustomer(Customer customer) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final filter = ref.read(customerFilterProvider);
      final repository = await ref.read(customerRepositoryProvider.future);
      var newCustomer = customer;

      final isConnected = ref.read(isConnectedProvider);
      if (isConnected) {
        try {
          final service = await ref.read(customerServiceProvider.future);
          final serverId = await service.putCustomer(customer);
          newCustomer = customer.copyWith(serverId: serverId);
        } catch (e) {
          // print(e);
        }
      }

      await repository.save(newCustomer);

      final total = await repository.count();
      final customers = await repository.fetchAll(filter);

      return CustomersPagination(
        total: total,
        items: customers,
        isLoadingMore: false
      );
    });
  }
}