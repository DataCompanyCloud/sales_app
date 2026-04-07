import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/providers.dart';


// class ProductDetails {
//   final Product product;
//   final List<Storage> storage;
//
// }

class ProductDetailsController extends AutoDisposeFamilyAsyncNotifier<Product, String>{
  @override
  FutureOr<Product> build(String code) async {
    final service = await ref.watch(productServiceProvider.future);
    final repository = await ref.watch(productRepositoryProvider.future);

    try {
      final remote = await service.getById(code);
      await repository.save(remote);
      return remote;
    } catch (e) {
      // print(e);
    }

    return await repository.fetchByCode(code);
  }
}