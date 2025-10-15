// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
//
// class StorageController extends AutoDisposeAsyncNotifier<List<Storage>>{
//
//   @override
//   FutureOr<List<Storage>> build() async {
//     final search = ref.watch(storageSearchProvider);
//     final repository = await ref.read(sotrageRepositoryProvider.future);
//     state = AsyncLoading();
//
//     try {
//       final service = await ref.watch(storageServiceProvider.future);
//       final newStorages = await service.getAll(search: search);
//
//       if (newStorages.isNotEmpty) {
//         await repository.saveAll(newStorages);
//       }
//     } catch (e) {
//       rethrow;
//     }
//
//     return await repository.fetchAll(search: search);
//   }
//
// }