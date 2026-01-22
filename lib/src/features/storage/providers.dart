import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/api_client_provider.dart';
import 'package:sales_app/src/core/providers/datasource_provider.dart';
import 'package:sales_app/src/features/storage/data/repositories/storage_products_repository_impl.dart';
import 'package:sales_app/src/features/storage/data/repositories/storage_repository_impl.dart';
import 'package:sales_app/src/features/storage/data/services/storage_products_service.dart';
import 'package:sales_app/src/features/storage/data/services/storage_service.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_products_repository.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_repository.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/storage_controller.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/storage_details_controller.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/storage_products_controller.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/valueObjects/storage_products_pagination.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/valueObjects/storages_pagination.dart';

final storageRepositoryProvider = FutureProvider.autoDispose<StorageRepository>((ref) async {
  final store = await ref.read(datasourceProvider.future);
  return StorageRepositoryImpl(store);
});

final storageProductRepositoryProvider = FutureProvider.autoDispose<StorageProductsRepository>((ref) async {
  final store = await ref.read(datasourceProvider.future);
  return StorageProductsRepositoryImpl(store);
});

final storageFilterProvider = StateProvider.autoDispose<StorageFilter>((ref) {
  return StorageFilter();
});

final storageProductsFilterProvider = StateProvider.autoDispose<StorageProductsFilter>((ref) {
  return StorageProductsFilter();
});

enum StorageMovementStatusFilter {
  all,
  entry,
  exit,
  transfer,
  synced,
  notSynced,
}

final storageMovementStatusFilterProvider = StateProvider<StorageMovementStatusFilter>((ref) => StorageMovementStatusFilter.all);
final storageSearchProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});

final storageControllerProvider = AutoDisposeAsyncNotifierProvider<StorageController, StoragesPagination> (() {
  return StorageController();
});

final storageProductsControllerProvider = AsyncNotifierProvider.autoDispose.family<StorageProductsController, StorageProductsPagination, int>(
  StorageProductsController.new,
);

final storageDetailsControllerProvider = AsyncNotifierProvider.autoDispose.family<StorageDetailsController, Storage, int?>(
  StorageDetailsController.new,
);

final storageServiceProvider = FutureProvider.autoDispose<StorageService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final repository = await ref.watch(storageRepositoryProvider.future);
  return StorageService(apiClient, repository);
});

final storageProductServiceProvider = FutureProvider.autoDispose<StorageProductsService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final repository = await ref.watch(storageProductRepositoryProvider.future);
  return StorageProductsService(apiClient, repository);
});