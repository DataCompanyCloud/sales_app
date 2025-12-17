import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_product.freezed.dart';
part 'storage_product.g.dart';

@freezed
abstract class StorageProduct with _$StorageProduct {
  const StorageProduct._();

  const factory StorageProduct.raw({
    required int storageProductId,
    required String productName,
    required int quantity
  }) = _StorageProduct;

  factory StorageProduct ({
    required int storageProductId,
    required String productName,
    required int quantity
  }) {
    return StorageProduct(
      storageProductId: storageProductId,
      productName: productName,
      quantity: quantity
    );
  }

  factory StorageProduct.fromJson(Map<String, dynamic> json) =>
      _$StorageProductFromJson(json);
}