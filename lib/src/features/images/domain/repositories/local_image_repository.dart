
import 'package:sales_app/src/features/images/domain/entities/image.dart';

abstract class LocalImageRepository {
  Future<List<ImageEntity>> fetchMany(List<ImageEntity> images);
  Future<ImageEntity> fetchOne(ImageEntity image);
  Future<ImageEntity> save(ImageEntity image);
  Future<void> delete(ImageEntity image);
}