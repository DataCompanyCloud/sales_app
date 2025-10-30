import 'package:objectbox/objectbox.dart';
import 'package:sales_app/src/features/stockTransaction/data/models/stock_transaction_item_model.dart';
import 'package:sales_app/src/features/stockTransaction/domain/entities/stock_transaction.dart';
import 'package:sales_app/src/features/stockTransaction/domain/valueObjects/transaction_source.dart';
import 'package:sales_app/src/features/stockTransaction/domain/valueObjects/transaction_type.dart';

@Entity()
class StockTransactionModel {
  @Id()
  int id;

  int stockId;
  String code;
  int? serverId;
  int? userId;
  String? description;
  int? orderId;
  DateTime createAt;
  int? fromStorageId;
  int? toStorageId;
  int type;
  int source;

  final items = ToMany<StockTransactionItemModel>();

  StockTransactionModel ({
    this.id = 0,
    this.stockId = 0,
    required this.code,
    this.serverId,
    this.userId,
    this.description,
    this.orderId = 0,
    required this.createAt,
    this.fromStorageId,
    this.toStorageId,
    required this.type,
    required this.source
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
      userId: userId,
      description: description,
      orderId: orderId,
      createAt: createAt,
      fromStorageId: fromStorageId,
      toStorageId: toStorageId,
      type: TransactionType.values[type],
      source: TransactionSource.values[source],
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
      userId: userId,
      description: description,
      orderId: orderId,
      createAt: createAt,
      fromStorageId: fromStorageId,
      toStorageId: toStorageId,
      type: type.index,
      source: source.index
    );

    model.items.addAll(items.map((i) => i.toModel()));

    return model;
  }
}