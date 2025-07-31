import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/providers.dart';

class ProductController extends AutoDisposeAsyncNotifier<List<Product>>{

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da API
  @override
  FutureOr<List<Product>> build() async {
    await Future.delayed(Duration(seconds: 2));

    final repository = await ref.watch(productRepositoryProvider.future);
    await repository.deleteAll();
    final product = await repository.fetchAll();

    if (product.isNotEmpty) {
      return product;
    }

    final service = await ref.watch(productServiceProvider.future);

    return await service.getAll(start: 0, end: 30);
  }
}
