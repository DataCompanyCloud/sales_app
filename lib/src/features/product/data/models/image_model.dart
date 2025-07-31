import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/domain/entities/image.dart';

@Entity()
class ImageModel {
  @Id()
  int id;

  @Index()
  int imageId;
  String url;

  ImageModel ({
    this.id = 0,
    this.imageId = 0,
    required this.url
  });
}

extension ImageModelMapper on ImageModel {
  /// De ImageModel → Image
  ImageEntity toEntity() => ImageEntity(imageId: imageId, url: url);
}

extension ImageMapper on ImageEntity {
  /// De Image → ImageModel
  ImageModel toModel() => ImageModel(imageId: imageId, url: url);
}