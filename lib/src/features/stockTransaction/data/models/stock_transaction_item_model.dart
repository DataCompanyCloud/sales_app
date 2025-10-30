import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction_item.dart';

@Entity()
class StockTransactionItemModel {
  @Id()
  int id;

  int itemId;
  String code;
  int? serverId;
  int? movementId;
  int productId;
  String productCode;
  String productName;
  int quantity;

  StockTransactionItemModel ({
    this.id = 0,
    this.itemId = 0,
    required this.code,
    this.serverId,
    this.movementId,
    required this.productId,
    required this.productCode,
    required this.productName,
    required this.quantity
  });
}

extension StockTransactionItemModelMapper on StockTransactionItemModel {
  /// De StockTransactionItemModel → StockTransactionItem
  StockTransactionItem toEntity(){
    return StockTransactionItem(
      id: itemId,
      code: code,
      serverId: serverId,
      movementId: movementId,
      productId: productId,
      productCode: productCode,
      productName: productName,
      quantity: quantity
    );
  }
}

extension StockTransactionItemMapper on StockTransactionItem {
  /// De StockTransactionItem → StockTransactionItemModel
  StockTransactionItemModel toModel() {
    final model = StockTransactionItemModel(
      itemId: id,
      code: code,
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