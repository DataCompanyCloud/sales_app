import 'package:sales_app/src/features/images/domain/repositories/local_image_repository.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';
import 'package:sales_app/src/features/images/data/services/image_service.dart';

class ImageCacheService {
  final LocalImageRepository localRepo;
  final ImageService imageService;

  ImageCacheService({
    required this.localRepo,
    required this.imageService,
  });

  /// Garante que a imagem esteja em cache:
  /// - se já existe local → só retorna com localUrl
  /// - se não existe → baixa, salva no repo local, retorna
  Future<ImageEntity> ensureCached(ImageEntity image) async {
    // 1) tenta achar localmente
    final fetched = await localRepo.fetchOne(image);
    final withLocal = fetched;

    if (withLocal.localUrl != null) {
      return withLocal;
    }

    // 2) não existe → baixa
    final fileName = 'img_${image.code}.jpg';
    final file = await imageService.downloadImage(image.url, fileName);

    final updated = image.copyWith(localUrl: file.path);

    // 3) persiste no local
    await localRepo.save(updated);

    return updated;
  }

  Future<List<ImageEntity>> ensureCachedAll(List<ImageEntity> images) async {
    return Future.wait(images.map(ensureCached));
  }
}
