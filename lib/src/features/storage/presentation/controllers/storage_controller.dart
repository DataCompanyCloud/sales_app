import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/valueObjects/storages_pagination.dart';
import 'package:sales_app/src/features/storage/providers.dart';

class StorageController extends AutoDisposeAsyncNotifier<StoragesPagination> {

  @override
  FutureOr<StoragesPagination> build() async {
    final filter = ref.watch(storageFilterProvider);
    final repository = await ref.read(storageRepositoryProvider.future);

    var total = await repository.count();

    final isConnected = ref.read(isConnectedProvider);
    if (isConnected) {
      try {
        final service = await ref.read(storageServiceProvider.future);
        final pagination = await service.getAll(filter);
        total = pagination.total;
        final storages = pagination.items;

        if (storages.isNotEmpty) {
          await repository.saveAll(storages);
        }
      } catch (e) {
        print(e);
      }
    }

    final items = await repository.fetchAll(filter);
    return StoragesPagination(
      total: total,
      items: items,
      isLoadingMore: false
    );
  }

  Future<void> leadMore() async {
    if (state.value!.isLoadingMore) return;
    state = AsyncData(state.value!.copyWith(isLoadingMore: true));
    final filter = ref.read(storageFilterProvider);
    final newFilter = filter.copyWith(
      start: state.value!.items.length,
    );

    final repository = await ref.watch(storageRepositoryProvider.future);
    final isConnected = ref.read(isConnectedProvider);

    var total = state.value?.total ?? 0;
    if (isConnected) {
      try {
        final service = await ref.read(storageServiceProvider.future);
        final pagination = await service.getAll(filter);
        total = pagination.total;
        final storages = pagination.items;

        if (storages.isNotEmpty) {
          await repository.saveAll(storages);
        }
      } catch (e) {
        print(e);
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

}