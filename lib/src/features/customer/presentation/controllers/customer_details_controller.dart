import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerDetailsController extends AutoDisposeFamilyAsyncNotifier<Customer, int>{
  @override
  FutureOr<Customer> build(int id) async {
    final service = await ref.watch(customerServiceProvider.future);
    final repository = await ref.watch(customerRepositoryProvider.future);

    // 1) Tenta servidor
    try {
      final remote = await service.getById(id);
      await repository.save(remote); // mantém cache atualizado
      return remote;
    } catch (e) {
      print(e);
    }

    // 2) Fallback: tenta local
    return await repository.fetchById(id);
  }
}