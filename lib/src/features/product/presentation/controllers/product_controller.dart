import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/product/presentation/controllers/valueObjects/products_pagination.dart';
import 'package:sales_app/src/features/product/providers.dart';

class ProductController extends AutoDisposeAsyncNotifier<ProductsPagination> {

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da API
  @override
  FutureOr<ProductsPagination> build() async {
    final filter = ref.watch(productFilterProvider);
    final repository = await ref.watch(productRepositoryProvider.future);

    var total = await repository.count();

    final isConnected = ref.read(isConnectedProvider);
    if (isConnected) {
      try {
        final service = await ref.read(productServiceProvider.future);
        // Busca o ultimos que sofreram updates
        final pagination = await service.getAll(filter);
        total = pagination.total;
        final products = pagination.items;

        if (products.isNotEmpty) {
          await repository.saveAll(products); // Atualiza cache local
        }
      } catch (e) {
        // print(e);
      }
    }

    final items = await repository.fetchAll(filter);
    return ProductsPagination(
      total: total,
      items: items,
      isLoadingMore: false
    );
  }

  Future<void> loadMore() async {
    if (state.value!.isLoadingMore) return;
    state = AsyncData(state.value!.copyWith(isLoadingMore: true));
    final filter = ref.read(productFilterProvider);
    final newFilter = filter.copyWith(
      start: state.value!.items.length,
    );

    final repository = await ref.watch(productRepositoryProvider.future);
    final isConnected = ref.read(isConnectedProvider);

    var total = state.value?.total ?? 0;
    if (isConnected) {
      try {
        final service = await ref.read(productServiceProvider.future);
        // Busca o ultimos que sofreram updates
        final pagination = await service.getAll(filter);
        total = pagination.total;
        final products = pagination.items;

        if (products.isNotEmpty) {
          await repository.saveAll(products); // Atualiza cache local
        }
      } catch (e) {
        // print(e);
      }
    }

    final items = await repository.fetchAll(newFilter);
    state = AsyncData(
      state.value!.copyWith(
        total: total,
        items:[
          ...state.value?.items ?? [],
          ...items
        ],
        isLoadingMore: false
      )
    );
  }
}
