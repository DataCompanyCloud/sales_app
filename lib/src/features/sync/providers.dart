import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/sync/data/repositories/sync_repository_impl.dart';
import 'package:sales_app/src/features/sync/domain/repositories/sync_repository.dart';
import 'package:sales_app/src/features/sync/presentation/controllers/sync_user_controller.dart';

final syncRepositoryProvider = Provider.autoDispose<SyncRepository>((ref) {
  return SyncRepositoryImpl();
});

final syncUserControllerProvider = AsyncNotifierProvider.autoDispose.family<SyncUserController,bool,int>(
  SyncUserController.new,
);