import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerController extends AutoDisposeAsyncNotifier<List<Customer>>{

  /// Primeiro busca no banco local
  /// se não encontrar nada busca da api
  @override
  FutureOr<List<Customer>> build() async {
    await Future.delayed(Duration(seconds: 2));

    final repository = await ref.watch(customerRepositoryProvider.future);
    await repository.deleteAll();
    final customer = await repository.fetchAll();

    if (customer.isNotEmpty) {
      return customer;
    }

    final service = await ref.watch(customerServiceProvider.future);

    return await service.getAll(start: 0, end: 30);
  }
}