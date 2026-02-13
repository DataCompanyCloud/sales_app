import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/notifications/notification_service.dart';
import 'package:sales_app/src/features/images/providers.dart';
import 'package:sales_app/src/features/product/data/models/product_model.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';
import 'package:sales_app/src/features/product/providers.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_state.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_status.dart';
import 'package:sales_app/src/features/settings/providers.dart';

class SyncProductsNotifier extends AsyncNotifier<SyncState> {
  static const channel = "sync_product";
  static const channelDescription = "Sincronizando produtos";

  @override
  SyncState build() {
    return SyncState();
  }

  Future<Product> _saveProductImages(Product product) async {
    final cacheService = ref.read(imageCacheServiceProvider("products/${product.id}"));

    final allImages = product.imagesAll;

    // Remover duplicadas por `code`
    final uniqueByCode = <String, ImageEntity>{};
    for (final image in allImages) {
      uniqueByCode[image.code] = image;
    }

    final uniqueImages = uniqueByCode.values.toList();

    // Garante que todas estejam cacheadas (baixa se precisar, seta localUrl)
    final cachedUniqueImages = await cacheService.ensureCachedAll(uniqueImages);

    // Map para lookup rápido: code -> imagem atualizada
    final cachedByCode = <String, ImageEntity>{
      for (final img in cachedUniqueImages) img.code: img,
    };

    // Aplica nas imagens do produto inteiro, recursivamente
    final updatedProduct = product.mapImages(
      (img) => cachedByCode[img.code] ?? img,
    );

    return updatedProduct;
  }


  Future<void> syncProducts({ bool productWithImages = false }) async {
    if (state.isLoading) return;
    state = AsyncData(SyncState(status: SyncStatus.preparing));
    state = const AsyncLoading();

    try {
      final service = await ref.read(productServiceProvider.future);
      final repository = await ref.read(productRepositoryProvider.future);

      await NotificationService.initialSyncNotification(
        channel: channel,
        channelDescription: channelDescription,
        title: "Sincronização iniciada",
        body: "Preparando sincronização",
      );

      final filter = ProductFilter();
      int count = await repository.count();
      while (true) {
        final pagination = await service.getAll(filter.copyWith(start: count));
        final total = pagination.total;
        final products = pagination.items;

        if (products.isEmpty) {
          // Nada mais para processar → encerra
          break;
        }

        state = AsyncData(state.value!.copyWith(status: SyncStatus.syncing, total: total));

        for (final product in products) {
          var toSave = product;

          if (productWithImages) {
            toSave = await _saveProductImages(product);
          }

          await repository.save(toSave);
          state = AsyncData(state.value!.copyWith(itemsSyncAmount: count++ ));
          ref.read(currentDownloadingProductProvider.notifier).state = toSave;

          await NotificationService.showSyncNotification(
            channel: channel,
            channelDescription: channelDescription,
            title: "Sincronização iniciada",
            body: "Baixando produtos",
            progress: count,
            maxProgress: total,
          );
        }

        if (count >= total) {
          // Já processou tudo → encerra
          break;
        }
      }

      await NotificationService.completeSyncNotification(
        channel: channel,
        channelDescription: channelDescription,
        title: "Sincronização concluída",
        body: "Todos os produtos foram baixados com sucesso!"
      );

      state = AsyncData(state.value!.copyWith( status: SyncStatus.complete ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  //
  // Future<void> syncProducts({
  //   bool productWithImages = false,
  // }) async {
  //   if (state.isLoading) return;
  //   state = AsyncData(SyncState(status: SyncStatus.preparing));
  //   state = const AsyncLoading();
  //
  //   final service = await ref.read(productServiceProvider.future);
  //   final repository = await ref.read(productRepositoryProvider.future);
  //   try {
  //     // Preparação
  //     await NotificationService.initialSyncNotification(
  //       channel: channel,
  //       channelDescription: channelDescription,
  //       title: "Sincronização iniciada",
  //       body: "Preparando sincronização",
  //     );
  //
  //     final imageService = ref.read(imageServiceProvider);
  //     final limit = 30;
  //     final totalLocal = await repository.count();
  //     final start = max(0, totalLocal);
  //     final total = await service.getCount(ProductFilter());
  //
  //     if (total == totalLocal) {
  //       // Todos os produtos foram baixados,
  //       await NotificationService.completeSyncNotification(
  //         channel: channel,
  //         channelDescription: channelDescription,
  //         title: "Sincronização concluída",
  //         body: "Todos os produtos foram baixados com sucesso!"
  //       );
  //
  //       // salva horário da última sync
  //       state = AsyncData(state.value!.copyWith(status: SyncStatus.complete));
  //       return;
  //     }
  //
  //     // Inicia sincronização
  //     state = AsyncData(state.value!.copyWith(status: SyncStatus.syncing, total: total));
  //
  //     int count = start;
  //     await NotificationService.showSyncNotification(
  //       channel: channel,
  //       channelDescription: channelDescription,
  //       title: "Sincronização iniciada",
  //       body: "Baixando produtos",
  //       progress: count,
  //       maxProgress: total,
  //     );
  //
  //     for (int i = start; i < total; i += limit) {
  //       final cancelSync = ref.read(cancelProductSyncProvider);
  //       if (cancelSync) {
  //         NotificationService.completeSyncNotification(
  //           channel: channel,
  //           channelDescription: channelDescription,
  //           title: "Download cancelado",
  //           body: "O download foi interrompido pelo usuário.",
  //         );
  //
  //         ref.read(cancelProductSyncProvider.notifier).state = false;
  //         state = AsyncData(state.value!.copyWith(status: SyncStatus.cancel, total: total));
  //         return;
  //       }
  //
  //       final pagination = await service.getAll(
  //         ProductFilter(start: i, limit: limit),
  //       );
  //
  //       final products = pagination.items;
  //
  //       for (var product in products) {
  //         state = AsyncData(state.value!.copyWith(itemsSyncAmount: count++ ));
  //
  //         if (productWithImages && product.imagesAll.isEmpty) {
  //           continue;
  //         }
  //
  //         final List<ImageEntity> imagesSaved = [];
  //
  //         if (productWithImages) {
  //           for (var img in product.images) {
  //             final file = await imageService.downloadImage(img.url, "${img.code}.png");
  //             ref.read(currentDownloadingImageProvider.notifier).state = file;
  //
  //             imagesSaved.add(img.copyWith(localUrl: file.path));
  //           }
  //         }
  //
  //         var newProduct = product.copyWith(images: imagesSaved);
  //         ref.read(currentDownloadingProductProvider.notifier).state = newProduct;
  //         await repository.save(newProduct);
  //
  //         await NotificationService.showSyncNotification(
  //           channel: channel,
  //           channelDescription: channelDescription,
  //           title: "Sincronizando produtos",
  //           body: "Baixando...",
  //           progress: count,
  //           maxProgress: total,
  //         );
  //       }
  //     }
  //
  //     await NotificationService.completeSyncNotification(
  //       channel: channel,
  //       channelDescription: channelDescription,
  //       title: "Sincronização concluída",
  //       body: "Todos os produtos foram baixados com sucesso!",
  //     );
  //
  //     // salva horário da última sync
  //     state = AsyncData(state.value!.copyWith( status: SyncStatus.complete ));
  //   } catch (e, st) {
  //     state = AsyncError(e, st);
  //   }
  // }
  //

}
