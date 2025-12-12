import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';

@Entity()
class ImageModel {
  @Id()
  int id;

  @Index()
  String code;
  String url;
  String? localUrl;

  ImageModel ({
    this.id = 0,
    required this.code,
    required this.url,
    required this.localUrl
  });
}

extension ImageModelMapper on ImageModel {
  /// De ImageModel → Image
  ImageEntity toEntity() => ImageEntity(code: code, url: url, localUrl: localUrl);
}

extension ImageMapper on ImageEntity {
  /// De Image → ImageModel
  ImageModel toModel() => ImageModel(code: code, url: url, localUrl: localUrl);
}