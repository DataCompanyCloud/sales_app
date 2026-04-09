import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';

@Entity()
class StorageProductModel {
  @Id()
  int id;

  String uuid;
  int quantity;
  String productName;
  String productCode;
  DateTime createdAt;
  DateTime? updatedAt;

  StorageProductModel ({
    this.id = 0,
    required this.uuid,
    required this.quantity,
    required this.productName,
    required this.productCode,
    required this.createdAt,
    this.updatedAt
  });
}

extension StorageProductModelMapper on StorageProductModel {
  /// De StorageProductModel → StorageProduct
  StorageProduct toEntity() {

    return StorageProduct.raw(
      id: id,
      uuid: uuid,
      quantity: quantity,
      productName: productName,
      productCode: productCode,
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }

  void deleteRecursively({
    required Box<StorageProductModel> storageProductBox,
  }) {
    storageProductBox.remove(id);
  }
}

extension StorageProductMapper on StorageProduct {
  /// De StorageProduct → StorageProductModel
  StorageProductModel toModel() {
    final model = StorageProductModel(
      id: id,
      uuid: uuid,
      quantity: quantity,
      productName: productName,
      productCode: productCode,
      createdAt: createdAt,
      updatedAt: updatedAt
    );

    return model;
  }
}