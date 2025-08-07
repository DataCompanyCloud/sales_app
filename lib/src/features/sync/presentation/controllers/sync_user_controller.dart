import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/sync/providers.dart';

class SyncUserController extends AutoDisposeFamilyAsyncNotifier<bool, int>{
  @override
  FutureOr<bool> build(int arg) async {
    try {
      final repo = ref.watch(syncRepositoryProvider);
      return await repo.get();
    } catch (e) {
      print(e.toString());
    }

    return false;
  }
}