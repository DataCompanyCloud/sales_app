import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/storage/providers.dart';

class StorageDetailsController extends AutoDisposeFamilyAsyncNotifier<Storage, String>{

  @override
  FutureOr<Storage> build(String storageCode) async {
    final service = await ref.read(storageServiceProvider.future);
    final repository = await ref.read(storageRepositoryProvider.future);

    try {
      final remote = await service.getByCode(storageCode);
      await repository.save(remote);
      return remote;
    } catch (e) {
      // print(e);
    }

    return await repository.fetchByCode(storageCode);
  }
}