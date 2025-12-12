import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/features/images/data/repositories/file_system_local_image_repository_impl.dart';
import 'package:sales_app/src/features/images/data/services/image_cache_service.dart';
import 'package:sales_app/src/features/images/domain/repositories/local_image_repository.dart';
import 'package:sales_app/src/features/images/data/services/image_service.dart';
import 'package:sales_app/src/features/images/presentation/controllers/product_image_cached_controller.dart';
import 'package:sales_app/src/features/images/presentation/controllers/valueObjects/product_image_cached.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';

final localImageRepositoryProvider = Provider.family<LocalImageRepository, String>((ref, rootDir) {
  return FileSystemLocalImageRepository(rootDir: rootDir);
});

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

final imageCacheServiceProvider = Provider.family<ImageCacheService, String>((ref, rootDir) {
  final localRepo = ref.watch(localImageRepositoryProvider(rootDir));
  final imageService = ref.watch(imageServiceProvider);
  return ImageCacheService(localRepo: localRepo, imageService: imageService);
});

final productImageCachedProvider = AutoDisposeAsyncNotifierProviderFamily<ProductImageCachedController, ImageEntity, ProductImageCached>(
  ProductImageCachedController.new,
);