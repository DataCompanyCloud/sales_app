import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sales_app/src/core/providers/connectivity_provider.dart';
import 'package:sales_app/src/features/images/presentation/controllers/valueObjects/product_image_cached.dart';
import 'package:sales_app/src/features/images/providers.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';

class ProductImageCachedController extends AutoDisposeFamilyAsyncNotifier<ImageEntity, ProductImageCached>{

  @override
  FutureOr<ImageEntity> build(ProductImageCached arg) async {
    final isConnected = ref.read(isConnectedProvider);
    final localRepo = ref.read(localImageRepositoryProvider(arg.rootDir));

    // 1) Se está offline → só tenta carregar do filesystem
    if (!isConnected) {
      return await localRepo.fetchOne(arg.image);
    }

    final cacheService = ref.read(imageCacheServiceProvider(arg.rootDir));
    // 2) Online → tenta garantir que está em cache (baixa se precisar)
    return await cacheService.ensureCached(arg.image);
  }
}
