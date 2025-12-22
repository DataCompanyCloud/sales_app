import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sales_app/src/features/storage/presentation/views/storage_details_page.dart';
import 'package:sales_app/src/features/storage/presentation/views/storage_page.dart';

enum StorageRouter {
  storage,
  storage_details
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
        final idStr = state.uri.queryParameters['storageId'];
        final storageId = int.tryParse(idStr ?? '');

        if (storageId == null) {
          return Scaffold(
            body: Center(child: Text('Storage inválido')),
          );
        }

        final isMyStorage = state.extra is Map
          ? (state.extra as Map)['isMyStorage'] ?? false
          : false;

        return StorageDetailsPage(
          storageId: storageId,
          isMyStorage: isMyStorage,
        );
      }
    ),
  ]
);