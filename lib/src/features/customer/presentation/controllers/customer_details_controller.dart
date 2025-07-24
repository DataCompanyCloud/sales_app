import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerDetailsController extends AutoDisposeFamilyAsyncNotifier<Customer, int>{
  @override
  FutureOr<Customer> build(int arg) async {
    final repository = await ref.watch(customerRepositoryProvider.future);

    final customer = await repository.fetchById(arg);
    return customer;
  }
}