import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/api_client_provider.dart';
import 'package:sales_app/src/core/providers/datasource_provider.dart';
import 'package:sales_app/src/features/customer/data/repositories/customer_repository_impl.dart';
import 'package:sales_app/src/features/customer/data/services/customer_service.dart';
import 'package:sales_app/src/features/customer/domain/entities/customer.dart';
import 'package:sales_app/src/features/customer/domain/repositories/customer_repository.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_controller.dart';
import 'package:sales_app/src/features/customer/presentation/controllers/customer_details_controller.dart';

final customerRepositoryProvider = FutureProvider.autoDispose<CustomerRepository>((ref) async {
  final store = await ref.watch(datasourceProvider.future);
  return CustomerRepositoryImpl(store);
});

final customerServiceProvider = FutureProvider.autoDispose<CustomerService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final repository = await ref.watch(customerRepositoryProvider.future);
  return CustomerService(apiClient, repository);
});

final customerControllerProvider = AutoDisposeAsyncNotifierProvider<CustomerController, List<Customer>> (() {
  return CustomerController();
});

final customerDetailsControllerProvider = AsyncNotifierProvider.autoDispose.family<CustomerDetailsController,Customer,int>(
  CustomerDetailsController.new,
);