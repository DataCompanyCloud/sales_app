import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/product/domain/valueObjects/image.dart';

@Entity()
class ImageModel {
  @Id()
  int id;

  @Index()
  int imageId;
  String url;
  String? localUrl;

  ImageModel ({
    this.id = 0,
    this.imageId = 0,
    required this.url,
    required this.localUrl
  });
}

extension ImageModelMapper on ImageModel {
  /// De ImageModel → Image
  ImageEntity toEntity() => ImageEntity(imageId: imageId, url: url, localUrl: localUrl);
}

extension ImageMapper on ImageEntity {
  /// De Image → ImageModel
  ImageModel toModel() => ImageModel(imageId: imageId, url: url, localUrl: localUrl);
}