import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/providers.dart';

class ProductController extends AutoDisposeAsyncNotifier<List<Product>>{

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da API
  @override
  FutureOr<List<Product>> build() async {
    final search = ref.watch(productSearchProvider);
    final repository = await ref.watch(productRepositoryProvider.future);
    state = AsyncLoading();
    // Tenta sincronizar com a API (se possível)
    try {
      final service = await ref.read(productServiceProvider.future);
      final newProducts = await service.getAll(search: search);

      if (newProducts.isNotEmpty) {
        await repository.saveAll(newProducts); // Atualiza cache local
      }
    } catch (e) {
      print(e);
    }

    // Sempre retorna a lista do banco local (fonte da verdade)
    return await repository.fetchAll(search: search);
  }
  
}
