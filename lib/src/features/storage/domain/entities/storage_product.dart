import 'package:freezed_annotation/freezed_annotation.dart';

part 'storage_product.freezed.dart';
part 'storage_product.g.dart';

@freezed
abstract class StorageProduct with _$StorageProduct {
  const StorageProduct._();

  const factory StorageProduct.raw({
    required int storageId,
    required int productId,
    required String productCode,
    required int quantity,
    required String productName
  }) = _StorageProduct;

  factory StorageProduct ({
    required int storageId,
    required int productId,
    required String productCode,
    required int quantity,
    required String productName
  }) {
    return StorageProduct(
      storageId: storageId,
      productId: productId,
      productCode: productCode,
      quantity: quantity,
      productName: productName
    );
  }

  factory StorageProduct.fromJson(Map<String, dynamic> json) =>
      _$StorageProductFromJson(json);
}