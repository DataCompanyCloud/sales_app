import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage.dart';
import 'package:sales_app/src/features/product/domain/entities/product.dart';

part 'storage_product.freezed.dart';
part 'storage_product.g.dart';

@freezed
abstract class StorageProduct with _$StorageProduct {
  const StorageProduct._();

  const factory StorageProduct.raw({
    required int id,
    required String uuid,
    Storage? storage,
    Product? product,
    required int quantity,
    required String productName,
    required String productCode,
    required DateTime createdAt,
    DateTime? updatedAt
  }) = _StorageProduct;

  factory StorageProduct ({
    required int id,
    required String uuid,
    Storage? storage,
    Product? product,
    required int quantity,
    required String productName,
    required String productCode,
    required DateTime createdAt,
    DateTime? updatedAt
  }) {
    return StorageProduct(
      id: id,
      uuid: uuid,
      storage: storage,
      product: product,
      quantity: quantity,
      productName: productName,
      productCode: productCode,
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }

  factory StorageProduct.fromJson(Map<String, dynamic> json) =>
      _$StorageProductFromJson(json);
}