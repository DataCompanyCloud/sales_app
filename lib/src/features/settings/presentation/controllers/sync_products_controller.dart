import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/notifications/notification_service.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';
import 'package:sales_app/src/features/product/providers.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_state.dart';
import 'package:sales_app/src/features/settings/presentation/controllers/valueObjects/sync_status.dart';
import 'package:sales_app/src/features/settings/providers.dart';
import 'dart:math';

class SyncProductsNotifier extends AsyncNotifier<SyncState> {
  static const channel = "sync_product";
  static const channelDescription = "Sincronizando produtos";

  @override
  SyncState build() {
    return SyncState();
  }

  Future<void> syncProducts({
    bool productWithImages = false,
  }) async {
    if (state.isLoading) return;
    state = AsyncData(SyncState(status: SyncStatus.preparing));
    state = const AsyncLoading();

    final service = await ref.read(productServiceProvider.future);
    final repository = await ref.read(productRepositoryProvider.future);
    try {
      // Preparação
      await NotificationService.initialSyncNotification(
        channel: channel,
        channelDescription: channelDescription,
        title: "Sincronização iniciada",
        body: "Preparando sincronização",
      );

      final imageService = ref.read(imageServiceProvider);
      final limit = 30;
      final totalLocal = await repository.count();
      final start = max(0, totalLocal);
      final total = await service.getCount(ProductFilter());

      if (total == totalLocal) {
        // Todos os produtos foram baixados,
        await NotificationService.completeSyncNotification(
          channel: channel,
          channelDescription: channelDescription,
          title: "Sincronização concluída",
          body: "Todos os produtos foram baixados com sucesso!"
        );

        // salva horário da última sync
        state = AsyncData(state.value!.copyWith( status: SyncStatus.complete));
        return;
      }

      // Inicia sincronização
      state = AsyncData(state.value!.copyWith(status: SyncStatus.syncing, total: total));

      int count = start;
      await NotificationService.showSyncNotification(
        channel: channel,
        channelDescription: channelDescription,
        title: "Sincronização iniciada",
        body: "Baixando produtos",
        progress: count,
        maxProgress: total,
      );

      for (int i = start; i < total; i += limit) {

        final cancelSync = ref.read(cancelSyncProvider);
        if (cancelSync) {
          NotificationService.completeSyncNotification(
            channel: channel,
            channelDescription: channelDescription,
            title: "Download cancelado",
            body: "O download foi interrompido pelo usuário.",
          );

          ref.read(cancelSyncProvider.notifier).state = false;
          state = AsyncData(state.value!.copyWith(status: SyncStatus.cancel, total: total));
          return;
        }

        final products = await service.getAll(
          ProductFilter(start: i, limit: limit),
        );

        for (var product in products) {
          state = AsyncData(state.value!.copyWith(itemsSyncAmount: count++ ));

          if (productWithImages && product.imagesAll.isEmpty) {
            continue;
          }

          final List<ImageEntity> imagesSaved = [];

          if (productWithImages) {
            for (var img in product.images) {
              final file = await imageService.downloadImage(img.url, "${img.imageId}.png");
              ref.read(currentDownloadingImageProvider.notifier).state = file;

              imagesSaved.add(img.copyWith(localUrl: file.path));
            }
          }

          var newProduct = product.copyWith(images: imagesSaved);
          ref.read(currentDownloadingProductProvider.notifier).state = newProduct;
          await repository.save(newProduct);

          await NotificationService.showSyncNotification(
            channel: channel,
            channelDescription: channelDescription,
            title: "Sincronizando produtos",
            body: "Baixando...",
            progress: count,
            maxProgress: total,
          );
        }
      }

      await NotificationService.completeSyncNotification(
        channel: channel,
        channelDescription: channelDescription,
        title: "Sincronização concluída",
        body: "Todos os produtos foram baixados com sucesso!",
      );

      // salva horário da última sync
      state = AsyncData(state.value!.copyWith( status: SyncStatus.complete ));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }


}
