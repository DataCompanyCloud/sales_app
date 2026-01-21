import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/storage/domain/entities/storage_product.dart';

@Entity()
class StorageProductModel {
  @Id()
  int id;

  int productId;
  String productCode;
  int quantity;
  String productName;

  StorageProductModel ({
    this.id = 0,
    this.productId = 0,
    required this.productCode,
    required this.quantity,
    required this.productName
  });
}

extension StorageProductModelMapper on StorageProductModel {
  /// De StorageProductModel → StorageProduct
  StorageProduct toEntity() {

    return StorageProduct.raw(
      productId: productId,
      productCode: productCode,
      quantity: quantity,
      productName: productName
    );
  }
}

extension StorageProductMapper on StorageProduct {
  /// De StorageProduct → StorageProductModel
  StorageProductModel toModel() {
    final model = StorageProductModel(
      productId: productId,
      productCode: productCode,
      quantity: quantity,
      productName: productName
    );

    return model;
  }
}