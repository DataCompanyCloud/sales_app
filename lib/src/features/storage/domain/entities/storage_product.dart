import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_product.freezed.dart';
part 'storage_product.g.dart';

@freezed
abstract class StorageProduct with _$StorageProduct {
  const StorageProduct._();

  const factory StorageProduct.raw({
    required int productId,
    required int quantity
  }) = _StorageProduct;

  factory StorageProduct ({
    required int productId,
    required int quantity
  }) {
    return StorageProduct(
        productId: productId,
      quantity: quantity
    );
  }

  factory StorageProduct.fromJson(Map<String, dynamic> json) =>
      _$StorageProductFromJson(json);
}