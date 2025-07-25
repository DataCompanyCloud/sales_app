import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/exceptions/app_exception.dart';
import 'package:sales_app/src/core/exceptions/app_exception_code.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/providers.dart';

class CustomerDetailsController extends AutoDisposeFamilyAsyncNotifier<Customer, int>{
  @override
  FutureOr<Customer> build(int arg) async {
    final service = await ref.watch(customerServiceProvider.future);
    final customer = await service.getById(arg);

    if (customer == null) {
      throw AppException(AppExceptionCode.CODE_002_CUSTOMER_SERVER_NOT_FOUND, "Cliente não encontrado");
    }

    return customer;
  }
}