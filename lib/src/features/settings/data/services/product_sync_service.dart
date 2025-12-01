import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/notifications/notification_service.dart';
import 'package:sales_app/src/features/product/domain/repositories/product_repository.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';
import 'package:sales_app/src/features/product/providers.dart';
import 'package:sales_app/src/features/settings/data/services/image_service.dart';
import 'package:sales_app/src/features/settings/providers.dart';

class ProductSyncService {
  final ImageService images;

  ProductSyncService({
    required this.images
  });

  Future<void> downloadMockProducts(
      WidgetRef ref, {
        required bool productWithImages,
      }) async {
    ref.read(isDownloadingProductsProvider.notifier).state = true;

    final progress = ref.read(productDownloadProgressProvider.notifier);

    final services = await ref.read(productServiceProvider.future);
    final repository = await ref.read(productRepositoryProvider.future);

    final total = 15000;
    final limit = 30;
    final init = await repository.count();

    // progress.state = init; // Salva o progresso do download

    await NotificationService.showSyncNotification(
      title: "Baixando produtos",
      body: "Sincronização iniciada",
      progress: progress.state,
      maxProgress: total,
    );

    // await repository.deleteAll(); // Delete tudo local

    for (int i = init; i < total; i += limit) {

      final products = await services.getAll(
        ProductFilter(start: i, limit: limit),
      );

      for (var product in products) {
        progress.state++;

        if (productWithImages && product.imagesAll.isEmpty) {
          continue;
        }

        final List<ImageEntity> imagesSaved = [];

        if (productWithImages) {
          for (var img in product.images) {
            final imageService = ref.read(imageServiceProvider);
            final file = await imageService.downloadImage(img.url, "${img.imageId}.png");
            ref.read(currentDownloadingImageProvider.notifier).state = file;

            imagesSaved.add(img.copyWith(localUrl: file.path));
          }
        }

        var newProduct = product.copyWith(images: imagesSaved);
        ref.read(currentDownloadingProductProvider.notifier).state = newProduct;
        await repository.save(newProduct);
      }

      await NotificationService.showSyncNotification(
        title: "Baixando produtos",
        body: "Sincronizando imagens...",
        progress: progress.state,
        maxProgress: total,
      );
    }

    await NotificationService.completeSyncNotification(
        title: "Download concluído",
        body: "Todos os produtos foram baixados com sucesso!"
    );
    ref.read(isDownloadingProductsProvider.notifier).state = false;
  }
}