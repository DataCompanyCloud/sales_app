import 'package:freezed_annotation/freezed_annotation.dart';

part 'image.freezed.dart';
part 'image.g.dart';

@freezed
abstract class ImageEntity with _$ImageEntity{
  const factory ImageEntity({
    required int imageId,
    required String url,
    required String? localUrl
  }) = _ImageEntity;

  factory ImageEntity.fromJson(Map<String, dynamic> json) => _$ImageEntityFromJson(json);
}
