import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/auth/presentation/controllers/sync_controller.dart';

final syncViewModelProvider = ChangeNotifierProvider((ref) {
  return SyncController();
});