import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/storage/providers.dart';

class StorageDetailsController extends AutoDisposeFamilyAsyncNotifier<Storage, int>{
  @override
  FutureOr<Storage> build(int storageId) async {
    state = AsyncLoading();
    final service = await ref.watch(storageServiceProvider.future);
    final repository = await ref.watch(storageRepositoryProvider.future);

    try {
      final remote = await service.getById(storageId);
      await repository.save(remote);
      return remote;
    } catch (e) {
      print(e);
    }

    return await repository.fetchById(storageId);
  }
}