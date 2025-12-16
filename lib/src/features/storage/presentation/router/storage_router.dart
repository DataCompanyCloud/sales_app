import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/storage/presentation/views/storage_details_page.dart';
import 'package:sales_app/src/features/storage/presentation/views/storage_page.dart';

enum StorageRouter {
  storage,
  storage_details,
  user_storage_details
}

final storageRoutes = GoRoute(
  path: '/storage',
  name: StorageRouter.storage.name,
  builder: (context, state) {
    return StoragePage();
  },
  routes: [
    GoRoute(
      path: 'storage_details',
      name: StorageRouter.storage_details.name,
      builder: (context, state) {
        final storage = state.extra as Storage;
        return StorageDetailsPage(storage: storage);
      }
    ),
  ]
);