import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/valueObjects/storage_products_pagination.dart';
import 'package:sales_app/src/features/storage/providers.dart';

class StorageProductsController extends AutoDisposeFamilyAsyncNotifier<StorageProductsPagination, int>{

  @override
  FutureOr<StorageProductsPagination> build(int storageId) async {
    final filter = ref.watch(storageProductsFilterProvider(storageId));
    final repository = await ref.watch(storageProductRepositoryProvider.future);

    var total = await repository.count();

    final isConnected = ref.read(isConnectedProvider);
    if (isConnected) {
      try {
        final service = await ref.read(storageProductServiceProvider.future);
        final pagination = await service.getAll(filter, storageId);
        total = pagination.total;
        final storageProduct = pagination.items;

        if (storageProduct.isNotEmpty) {
          await repository.saveAll(storageProduct);
        }

      } catch (e) {
        // print(e);
      }
    }

    final items = await repository.fetchAll(filter);
    return StorageProductsPagination(
      total: total,
      items: items,
      isLoadingMore: false
    );
  }
}
