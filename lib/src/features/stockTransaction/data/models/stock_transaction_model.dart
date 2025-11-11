import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/stockTransaction/data/models/stock_transaction_item_model.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/owner_transaction.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/storage_endpoint.dart';
import 'package:sales_app/src/features/stockTransaction/domain/valueObjects/transaction_type.dart';

@Entity()
class StockTransactionModel {
  @Id()
  int id;

  int stockId;
  String code;
  int? serverId;
  OwnerTransaction? owner;
  String? description;
  int? orderId;
  DateTime createAt;
  StorageEndpoint? fromStorage;
  StorageEndpoint? toStorage;
  int type;

  final items = ToMany<StockTransactionItemModel>();

  StockTransactionModel ({
    this.id = 0,
    this.stockId = 0,
    required this.code,
    this.serverId,
    this.owner,
    this.description,
    this.orderId = 0,
    required this.createAt,
    this.fromStorage,
    this.toStorage,
    required this.type
  });
}

extension StockTransactionModelMapper on StockTransactionModel {
  /// De StockTransactionModel → StockTransaction
  StockTransaction toEntity() {
    final items = this.items.map((m) => m.toEntity()).toList();

    return StockTransaction(
      id: stockId,
      code: code,
      serverId: serverId,
      owner: owner,
      description: description,
      orderId: orderId,
      createAt: createAt,
      fromStorage: fromStorage,
      toStorage: toStorage,
      type: TransactionType.values[type],
      items: items
    );
  }
}

extension StockTransactionMapper on StockTransaction {
  /// De StockMovement → StockMovementModel
  StockTransactionModel toModel() {
    final model = StockTransactionModel(
      stockId: id,
      code: code,
      serverId: serverId,
      owner: owner,
      description: description,
      orderId: orderId,
      createAt: createAt,
      fromStorage: fromStorage,
      toStorage: toStorage,
      type: type.index
    );

    model.items.addAll(items.map((i) => i.toModel()));

    return model;
  }
}