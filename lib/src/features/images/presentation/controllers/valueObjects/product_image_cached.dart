
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/images/domain/entities/image.dart';


part 'product_image_cached.freezed.dart';
part 'product_image_cached.g.dart';


/// rootDir: /products/[productId]
@freezed
abstract class ProductImageCached with _$ProductImageCached {
  const ProductImageCached._();

  const factory ProductImageCached({
    required int productId,
    required ImageEntity image
  }) = _ProductImageCached;

  factory ProductImageCached.fromJson(Map<String, dynamic> json) =>
      _$ProductImageCachedFromJson(json);

  String get rootDir => "products/$productId";
}