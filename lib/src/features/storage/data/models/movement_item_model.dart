import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/storage/domain/entities/movement_item.dart';

@Entity()
class MovementItemModel {
  @Id()
  int id;

  int itemId;
  String movementItemUuId;
  int? serverId;
  int? movementId;
  int productId;
  String productCode;
  String productName;
  int quantity;

  MovementItemModel ({
    this.id = 0,
    this.itemId = 0,
    required this.movementItemUuId,
    this.serverId,
    this.movementId,
    required this.productId,
    required this.productCode,
    required this.productName,
    required this.quantity
  });
}

extension MovementItemModelMapper on MovementItemModel {
  /// De MovementItemModel → MovementItem
  MovementItem toEntity(){
    return MovementItem(
      itemId: itemId,
      movementItemUuId: movementItemUuId,
      serverId: serverId,
      movementId: movementId,
      productId: productId,
      productCode: productCode,
      productName: productName,
      quantity: quantity
    );
  }
}

extension MovementItemMapper on MovementItem {
  /// De MovementItem → MovementItemModel
  MovementItemModel toModel() {
    final model = MovementItemModel(
      itemId: itemId,
      movementItemUuId: movementItemUuId,
      serverId: serverId,
      movementId: movementId,
      productId: productId,
      productCode: productCode,
      productName: productName,
      quantity: quantity
    );

    return model;
  }
}