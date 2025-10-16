import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/api_client_provider.dart';
import 'package:sales_app/src/core/providers/datasource_provider.dart';
import 'package:sales_app/src/features/storage/data/repositories/storage_repository_impl.dart';
import 'package:sales_app/src/features/storage/data/services/storage_service.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/storage/domain/repositories/storage_repository.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/storage_controller.dart';
import 'package:sales_app/src/features/storage/presentation/controllers/storage_details_controller.dart';

final storageRepositoryProvider = FutureProvider.autoDispose<StorageRepository>((ref) async {
  final store = await ref.watch(datasourceProvider.future);
  return StorageRepositoryImpl(store);
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

final storageControllerProvider = AutoDisposeAsyncNotifierProvider<StorageController, List<Storage>> (() {
  return StorageController();
});

final storageDetailsControllerProvider = AsyncNotifierProvider.autoDispose.family<StorageDetailsController, Storage, int>(
  StorageDetailsController.new,
);

final storageServiceProvider = FutureProvider.autoDispose<StorageService>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  final repository = await ref.watch(storageRepositoryProvider.future);
  return StorageService(apiClient, repository);
});